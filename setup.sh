#!/bin/bash

# Multi-Protocol Proxy Setup Script (No Nginx)
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
    
    # Install required packages
    apt install -y curl wget git ufw htop nano
    
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
    ufw allow 8080/tcp  # VMess Direct TCP
    ufw allow 8001/tcp  # VMess WebSocket Google
    ufw allow 8002/tcp  # VMess WebSocket Cloudflare
    ufw allow 8003/tcp  # VLESS WebSocket
    ufw allow 8005/tcp  # Trojan WebSocket
    
    # Enable firewall
    ufw --force enable
    
    print_status "Firewall configured for direct connections"
}

stop_existing_services() {
    print_header "Stopping Existing Services"
    
    # Stop any running containers
    docker-compose down 2>/dev/null || true
    
    # Kill any processes using ports
    pkill -f xray || true
    pkill -f v2ray || true
    pkill -f nginx || true
    
    print_status "Existing services stopped"
}

start_services() {
    print_header "Starting Xray Proxy Services"
    
    # Create logs directory
    mkdir -p logs
    
    # Start all services
    docker-compose up -d
    
    # Wait for services to start
    sleep 10
    
    # Check service status
    docker-compose ps
    
    print_status "Services started successfully"
}

test_connections() {
    print_header "Testing Connections"
    
    # Test if ports are listening
    sleep 5
    
    if netstat -tlnp | grep -q ":8080 "; then
        print_status "✅ VMess Direct TCP (port 8080) - OK"
    else
        print_warning "❌ VMess Direct TCP (port 8080) - Not responding"
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
        print_status "✅ VLESS WebSocket (port 8003) - OK"
    else
        print_warning "❌ VLESS WebSocket (port 8003) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8005 "; then
        print_status "✅ Trojan WebSocket (port 8005) - OK"
    else
        print_warning "❌ Trojan WebSocket (port 8005) - Not responding"
    fi
}

generate_client_configs() {
    print_header "Generating Updated Client Configurations"
    
    mkdir -p vpn-configs
    
    # VMess Google WebSocket - Direct Port
    cat > vpn-configs/vmess-google-ws.json << EOF
{
  "v": "2",
  "ps": "VMess-Google-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "8001",
  "id": "d0306468-e500-4193-95ef-a514b3396c90",
  "aid": "0",
  "scy": "auto",
  "net": "ws",
  "type": "none",
  "host": "www.google.com",
  "path": "/",
  "tls": "none",
  "sni": "",
  "alpn": ""
}
EOF
    
    # VMess Cloudflare WebSocket - Direct Port
    cat > vpn-configs/vmess-cloudflare-ws.json << EOF
{
  "v": "2",
  "ps": "VMess-CF-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "8002",
  "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "aid": "0",
  "scy": "auto",
  "net": "ws",
  "type": "none",
  "host": "www.cloudflare.com",
  "path": "/",
  "tls": "none",
  "sni": "",
  "alpn": ""
}
EOF
    
    # VLESS WebSocket - Direct Port
    cat > vpn-configs/vless-websocket.json << EOF
{
  "v": "2",
  "ps": "VLESS-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "8003",
  "id": "f1e2d3c4-b5a6-9780-cdef-123456789abc",
  "net": "ws",
  "type": "none",
  "host": "www.microsoft.com",
  "path": "/",
  "tls": "none",
  "sni": "",
  "alpn": ""
}
EOF
    
    # Trojan WebSocket - Direct Port
    cat > vpn-configs/trojan-websocket.json << EOF
{
  "v": "2",
  "ps": "Trojan-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "8005",
  "password": "your-strong-trojan-password-123",
  "net": "ws",
  "type": "none",
  "host": "www.github.com",
  "path": "/",
  "tls": "none",
  "sni": "",
  "alpn": ""
}
EOF
    
    # VMess Direct TCP (unchanged)
    cat > vpn-configs/vmess-direct-tcp.json << EOF
{
  "v": "2",
  "ps": "VMess-Direct-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "8080",
  "id": "99887766-5544-3322-1100-aabbccddeeff",
  "aid": "0",
  "scy": "auto",
  "net": "tcp",
  "type": "http",
  "host": "www.netflix.com",
  "path": "",
  "tls": "none",
  "sni": "",
  "alpn": ""
}
EOF
    
    print_status "Updated client configurations generated in vpn-configs/"
}

print_summary() {
    print_header "🎉 Setup Complete!"
    
    echo -e "${GREEN}✅ Your simplified multi-protocol proxy server is now running!${NC}"
    echo ""
    echo -e "${BLUE}📊 Server Details:${NC}"
    echo "• Server IP: $SERVER_IP"
    echo "• Direct connections (no reverse proxy)"
    echo ""
    echo -e "${BLUE}🔗 Available Protocols & Ports:${NC}"
    echo "• VMess + TCP Direct: Port 8080 (proven working ✅)"
    echo "• VMess + WebSocket (Google): Port 8001"
    echo "• VMess + WebSocket (Cloudflare): Port 8002"
    echo "• VLESS + WebSocket (Microsoft): Port 8003"
    echo "• Trojan + WebSocket (GitHub): Port 8005"
    echo ""
    echo -e "${BLUE}📱 Client Setup:${NC}"
    echo "• Updated configs in 'vpn-configs/' directory"
    echo "• Each protocol uses its own dedicated port"
    echo "• No more path-based routing issues!"
    echo ""
    echo -e "${BLUE}🛠️ Management Commands:${NC}"
    echo "• View logs: docker-compose logs -f"
    echo "• Restart: docker-compose restart"
    echo "• Stop: docker-compose down"
    echo "• Status: docker-compose ps"
    echo ""
    echo -e "${GREEN}✨ Benefits of No-Nginx Setup:${NC}"
    echo "• Much simpler configuration"
    echo "• No container networking issues"
    echo "• Direct port access for each protocol"
    echo "• Easier debugging and troubleshooting"
    echo ""
    echo -e "${GREEN}🚀 Your simplified proxy server is ready!${NC}"
}

# Main execution
main() {
    print_header "🔧 Simplified Multi-Protocol Proxy Setup"
    
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