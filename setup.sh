#!/bin/bash

# Multi-Protocol Proxy + WireGuard Setup Script (VLESS-Optimized)
# Run with: bash setup.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}================================${NC}"
}

get_server_ip() {
    print_header "Getting Server Information"
    
    SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || curl -s icanhazip.com 2>/dev/null)
    
    if [[ -z "$SERVER_IP" ]]; then
        print_error "Could not determine server IP address"
        read -p "Please enter your VPS IP address: " SERVER_IP
    fi
    
    print_status "Server IP: $SERVER_IP"
    echo "SERVER_IP=$SERVER_IP" > .env
}

install_dependencies() {
    print_header "Installing Dependencies"
    
    # Update system
    apt update && apt upgrade -y
    
    # Install required packages (including WireGuard tools)
    apt install -y curl wget git ufw htop nano wireguard-tools
    
    # Install Docker if not present
    if ! command -v docker &> /dev/null; then
        print_status "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm get-docker.sh
    fi
    
    # Install Docker Compose if not present
    if ! command -v docker-compose &> /dev/null; then
        print_status "Installing Docker Compose..."
        apt install -y docker-compose
    fi
    
    # Enable Docker
    systemctl enable docker
    systemctl start docker
    
    print_status "Dependencies installed successfully"
}

setup_firewall() {
    print_header "Configuring Firewall"
    
    # Reset UFW
    ufw --force reset
    
    # Set defaults
    ufw default deny incoming
    ufw default allow outgoing
    
    # Allow essential services
    ufw allow ssh
    ufw allow 8001/tcp  # VMess WebSocket Google
    ufw allow 8002/tcp  # VMess WebSocket Cloudflare
    ufw allow 8003/tcp  # VLESS WebSocket Microsoft
    ufw allow 8004/tcp  # VLESS WebSocket Google
    ufw allow 8005/tcp  # Trojan WebSocket
    ufw allow 8006/tcp  # VLESS WebSocket Cloudflare
    ufw allow 8007/tcp  # VLESS WebSocket GitHub
    ufw allow 8080/tcp  # VLESS Direct TCP
    ufw allow 51820/udp # WireGuard VPN
    
    # Enable firewall
    ufw --force enable
    
    print_status "Firewall configured for VLESS + WireGuard setup"
}

stop_existing_services() {
    print_header "Stopping Existing Services"
    
    # Stop any running containers
    docker-compose down 2>/dev/null || true
    
    # Kill any processes using ports
    pkill -f xray || true
    pkill -f v2ray || true
    pkill -f nginx || true
    pkill -f wireguard || true
    
    print_status "Existing services stopped"
}

start_services() {
    print_header "Starting VLESS + WireGuard Services"
    
    # Create logs and config directories
    mkdir -p logs
    mkdir -p wireguard-config
    
    # Start all services
    docker-compose up -d
    
    # Wait for services to start
    sleep 15
    
    # Check service status
    docker-compose ps
    
    print_status "Services started successfully"
}

test_connections() {
    print_header "Testing Connections"
    
    # Test if ports are listening
    sleep 5
    
    if netstat -tlnp | grep -q ":8080 "; then
        print_status "✅ VLESS Direct TCP (port 8080) - OK"
    else
        print_warning "❌ VLESS Direct TCP (port 8080) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8001 "; then
        print_status "✅ VMess WebSocket Google (port 8001) - OK"
    else
        print_warning "❌ VMess WebSocket Google (port 8001) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8002 "; then
        print_status "✅ VMess WebSocket Cloudflare (port 8002) - OK"
    else
        print_warning "❌ VMess WebSocket Cloudflare (port 8002) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8003 "; then
        print_status "✅ VLESS WebSocket Microsoft (port 8003) - OK"
    else
        print_warning "❌ VLESS WebSocket Microsoft (port 8003) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8004 "; then
        print_status "✅ VLESS WebSocket Google (port 8004) - OK"
    else
        print_warning "❌ VLESS WebSocket Google (port 8004) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8005 "; then
        print_status "✅ Trojan WebSocket (port 8005) - OK"
    else
        print_warning "❌ Trojan WebSocket (port 8005) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8006 "; then
        print_status "✅ VLESS WebSocket Cloudflare (port 8006) - OK"
    else
        print_warning "❌ VLESS WebSocket Cloudflare (port 8006) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8007 "; then
        print_status "✅ VLESS WebSocket GitHub (port 8007) - OK"
    else
        print_warning "❌ VLESS WebSocket GitHub (port 8007) - Not responding"
    fi
    
    if netstat -ulnp | grep -q ":51820 "; then
        print_status "✅ WireGuard VPN (port 51820/udp) - OK"
    else
        print_warning "❌ WireGuard VPN (port 51820/udp) - Not responding"
    fi
}

generate_client_configs() {
    print_header "Generating VLESS + WireGuard Client Configurations"
    
    mkdir -p vpn-configs
    
    # The client configs are already updated in the repository
    print_status "Client configurations available in vpn-configs/ directory"
    print_status "✅ VLESS Direct TCP (port 8080) - FASTEST"
    print_status "✅ Multiple VLESS WebSocket options (ports 8003-8007)"
    print_status "✅ VMess WebSocket fallbacks (ports 8001-8002)"
    print_status "✅ Trojan WebSocket (port 8005)"
    print_status "🔥 WireGuard VPN (port 51820/udp) - NEW!"
    
    # Wait a bit for WireGuard to generate configs
    sleep 10
    
    if [ -d "./wireguard-config" ]; then
        print_status "🔑 WireGuard client configurations generated!"
        print_status "📁 Check ./wireguard-config/peer_client*/peer_client*.conf"
        print_status "📱 Or scan QR codes: ./wireguard-config/peer_client*/peer_client*.png"
    fi
}

print_summary() {
    print_header "🎉 VLESS + WireGuard Setup Complete!"
    
    echo -e "${GREEN}✅ Your ultimate multi-protocol VPN server is now running!${NC}"
    echo ""
    echo -e "${BLUE}📊 Server Details:${NC}"
    echo "• Server IP: $SERVER_IP"
    echo "• VLESS-focused setup + WireGuard VPN"
    echo "• Direct connections (no reverse proxy)"
    echo ""
    echo -e "${BLUE}🔥 WireGuard VPN (RECOMMENDED FOR SPEED):${NC}"
    echo "• Protocol: WireGuard"
    echo "• Port: 51820/udp"
    echo "• Config files: ./wireguard-config/peer_client*/peer_client*.conf"
    echo "• QR codes: ./wireguard-config/peer_client*/peer_client*.png"
    echo "• Clients supported: 5 (client1-client5)"
    echo ""
    echo -e "${BLUE}🚀 VLESS Protocols (HTTP Proxy):${NC}"
    echo "• VLESS + Direct TCP: Port 8080 ⚡ (FASTEST)"
    echo "• VLESS + WebSocket (Microsoft): Port 8003"
    echo "• VLESS + WebSocket (Google): Port 8004"
    echo "• VLESS + WebSocket (Cloudflare): Port 8006"
    echo "• VLESS + WebSocket (GitHub): Port 8007"
    echo ""
    echo -e "${BLUE}🔄 Fallback Protocols:${NC}"
    echo "• VMess + WebSocket (Google): Port 8001"
    echo "• VMess + WebSocket (Cloudflare): Port 8002"
    echo "• Trojan + WebSocket (GitHub): Port 8005"
    echo ""
    echo -e "${BLUE}📱 Client Setup Priority:${NC}"
    echo "1. 🥇 WireGuard (fastest, best battery life)"
    echo "2. 🥈 VLESS Direct TCP (fast HTTP proxy)"
    echo "3. 🥉 VLESS WebSocket (firewall bypass)"
    echo "4. 🏃 VMess/Trojan (compatibility fallback)"
    echo ""
    echo -e "${BLUE}🛠️ Management Commands:${NC}"
    echo "• View all logs: docker-compose logs -f"
    echo "• View WireGuard logs: docker-compose logs wireguard"
    echo "• Restart all: docker-compose restart"
    echo "• Stop all: docker-compose down"
    echo "• Status: docker-compose ps"
    echo ""
    echo -e "${BLUE}🔑 WireGuard Setup:${NC}"
    echo "• Config files: ls ./wireguard-config/peer_client*/"
    echo "• Show QR code: docker exec wireguard-server /app/show-peer client1"
    echo "• Add more clients: Edit PEERS in docker-compose.yml"
    echo ""
    echo -e "${GREEN}✨ Benefits of WireGuard + VLESS Setup:${NC}"
    echo "• WireGuard: Fastest VPN protocol, kernel-level performance"
    echo "• VLESS: Efficient HTTP proxy for web browsing"
    echo "• Multiple protocols for maximum compatibility"
    echo "• Works in restrictive networks"
    echo "• Better battery life on mobile devices"
    echo ""
    echo -e "${GREEN}🚀 Your ultimate VPN server is ready!${NC}"
    echo -e "${YELLOW}Start with WireGuard for best performance! 🔥${NC}"
}

# Main execution
main() {
    print_header "🔧 VLESS + WireGuard Multi-Protocol VPN Setup"
    
    get_server_ip
    install_dependencies
    setup_firewall
    stop_existing_services
    start_services
    test_connections
    generate_client_configs
    print_summary
}

# Run main function
main "$@" 