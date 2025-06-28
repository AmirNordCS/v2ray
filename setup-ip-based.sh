#!/bin/bash

# IP-Based Multi-Protocol Proxy Setup Script
# Run with: bash setup-ip-based.sh

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
    ufw allow 80/tcp    # Nginx HTTP
    ufw allow 8080/tcp  # Direct VMess connection
    
    # Enable firewall
    ufw --force enable
    
    print_status "Firewall configured successfully"
}

create_fake_website() {
    print_header "Creating Fake Website"
    
    mkdir -p html
    
    cat > html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Technical Solutions</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            max-width: 1200px; 
            margin: 0 auto; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
        }
        .container { 
            background: rgba(255,255,255,0.1); 
            padding: 40px; 
            border-radius: 15px; 
            backdrop-filter: blur(10px);
        }
        .header { text-align: center; margin-bottom: 40px; }
        .header h1 { font-size: 3em; margin-bottom: 10px; }
        .header p { font-size: 1.2em; opacity: 0.9; }
        .services { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 40px 0; }
        .service { background: rgba(255,255,255,0.1); padding: 30px; border-radius: 10px; }
        .service h3 { color: #ffd700; margin-bottom: 15px; }
        .footer { text-align: center; margin-top: 60px; opacity: 0.8; }
        .stats { display: flex; justify-content: space-around; margin: 40px 0; }
        .stat { text-align: center; }
        .stat h2 { font-size: 2.5em; color: #ffd700; margin-bottom: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Technical Solutions</h1>
            <p>Professional IT Services & Cloud Infrastructure</p>
        </div>
        
        <div class="stats">
            <div class="stat">
                <h2>99.9%</h2>
                <p>Uptime</p>
            </div>
            <div class="stat">
                <h2>500+</h2>
                <p>Projects</p>
            </div>
            <div class="stat">
                <h2>24/7</h2>
                <p>Support</p>
            </div>
        </div>
        
        <div class="services">
            <div class="service">
                <h3>🌐 Web Development</h3>
                <p>Modern web applications built with cutting-edge technologies. Responsive design, performance optimization, and scalable architecture.</p>
            </div>
            <div class="service">
                <h3>☁️ Cloud Infrastructure</h3>
                <p>Enterprise-grade cloud solutions, server management, and infrastructure optimization for maximum performance and reliability.</p>
            </div>
            <div class="service">
                <h3>🔧 Technical Consulting</h3>
                <p>Expert guidance on technology strategy, system architecture, and best practices for your business growth.</p>
            </div>
            <div class="service">
                <h3>🛡️ Security Solutions</h3>
                <p>Comprehensive security audits, vulnerability assessments, and implementation of robust security measures.</p>
            </div>
        </div>
        
        <div class="footer">
            <p>&copy; 2024 Technical Solutions. All rights reserved.</p>
            <p>Powered by advanced cloud infrastructure</p>
        </div>
    </div>
</body>
</html>
EOF
    
    print_status "Professional fake website created"
}

stop_existing_services() {
    print_header "Stopping Existing Services"
    
    # Stop any running containers
    docker-compose down 2>/dev/null || true
    docker-compose -f docker-compose-advanced.yml down 2>/dev/null || true
    
    # Kill any processes using ports
    pkill -f xray || true
    pkill -f v2ray || true
    
    print_status "Existing services stopped"
}

start_services() {
    print_header "Starting Multi-Protocol Proxy Services"
    
    # Create logs directory
    mkdir -p logs
    
    # Start all services
    docker-compose -f docker-compose-ip.yml up -d
    
    # Wait for services to start
    sleep 10
    
    # Check service status
    docker-compose -f docker-compose-ip.yml ps
    
    print_status "Services started successfully"
}

generate_client_configs() {
    print_header "Generating Client Configurations"
    
    mkdir -p client-configs
    
    # VMess Google WebSocket (via Nginx)
    cat > client-configs/vmess-google-ws.json << EOF
{
  "v": "2",
  "ps": "VMess-Google-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "80",
  "id": "d0306468-e500-4193-95ef-a514b3396c90",
  "aid": "0",
  "scy": "auto",
  "net": "ws",
  "type": "none",
  "host": "www.google.com",
  "path": "/vmess-google",
  "tls": "",
  "sni": "",
  "alpn": ""
}
EOF
    
    # VMess Cloudflare WebSocket (via Nginx)
    cat > client-configs/vmess-cf-ws.json << EOF
{
  "v": "2",
  "ps": "VMess-CF-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "80",
  "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "aid": "0",
  "scy": "auto",
  "net": "ws",
  "type": "none",
  "host": "www.cloudflare.com",
  "path": "/vmess-cf",
  "tls": "",
  "sni": "",
  "alpn": ""
}
EOF
    
    # VLESS WebSocket (via Nginx)
    cat > client-configs/vless-ws.json << EOF
{
  "v": "2",
  "ps": "VLESS-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "80",
  "id": "f1e2d3c4-b5a6-9780-cdef-123456789abc",
  "net": "ws",
  "type": "none",
  "host": "www.microsoft.com",
  "path": "/vless-ws",
  "tls": "",
  "sni": "",
  "alpn": ""
}
EOF
    
    # Trojan WebSocket (via Nginx)
    cat > client-configs/trojan-ws.json << EOF
{
  "v": "2",
  "ps": "Trojan-WS-${SERVER_IP}",
  "add": "${SERVER_IP}",
  "port": "80",
  "password": "your-strong-trojan-password-123",
  "net": "ws",
  "type": "none",
  "host": "www.github.com",
  "path": "/trojan-ws",
  "tls": "",
  "sni": "",
  "alpn": ""
}
EOF
    
    # VMess Direct TCP (port 8080)
    cat > client-configs/vmess-direct-tcp.json << EOF
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
  "tls": "",
  "sni": "",
  "alpn": ""
}
EOF
    
    print_status "Client configurations generated in client-configs/"
}

test_connections() {
    print_header "Testing Connections"
    
    # Test if ports are listening
    sleep 5
    
    if netstat -tlnp | grep -q ":80 "; then
        print_status "✅ Nginx HTTP (port 80) - OK"
    else
        print_warning "❌ Nginx HTTP (port 80) - Not responding"
    fi
    
    if netstat -tlnp | grep -q ":8080 "; then
        print_status "✅ VMess Direct (port 8080) - OK"
    else
        print_warning "❌ VMess Direct (port 8080) - Not responding"
    fi
    
    # Test HTTP response
    if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200"; then
        print_status "✅ Fake website - OK"
    else
        print_warning "❌ Fake website - Not responding"
    fi
}

print_summary() {
    print_header "🎉 Setup Complete!"
    
    echo -e "${GREEN}✅ Your multi-protocol proxy server is now running!${NC}"
    echo ""
    echo -e "${BLUE}📊 Server Details:${NC}"
    echo "• Server IP: $SERVER_IP"
    echo "• HTTP Port: 80 (Nginx reverse proxy)"
    echo "• Direct Port: 8080 (VMess TCP)"
    echo ""
    echo -e "${BLUE}🔗 Available Protocols:${NC}"
    echo "• VMess + WebSocket (Google host) - Port 80, Path: /vmess-google"
    echo "• VMess + WebSocket (Cloudflare host) - Port 80, Path: /vmess-cf"
    echo "• VLESS + WebSocket (Microsoft host) - Port 80, Path: /vless-ws"
    echo "• Trojan + WebSocket (GitHub host) - Port 80, Path: /trojan-ws"
    echo "• VMess + TCP Direct (Netflix host) - Port 8080"
    echo ""
    echo -e "${BLUE}📱 Client Setup:${NC}"
    echo "• Check 'client-configs/' directory for ready-to-use configurations"
    echo "• Import JSON files into your V2Ray/Xray client"
    echo "• Test with the fake website: http://$SERVER_IP"
    echo ""
    echo -e "${BLUE}🛠️ Management Commands:${NC}"
    echo "• View logs: docker-compose -f docker-compose-ip.yml logs -f"
    echo "• Restart: docker-compose -f docker-compose-ip.yml restart"
    echo "• Stop: docker-compose -f docker-compose-ip.yml down"
    echo "• Status: docker-compose -f docker-compose-ip.yml ps"
    echo ""
    echo -e "${YELLOW}⚠️ Security Notes:${NC}"
    echo "• No TLS encryption (HTTP only) - Consider getting a domain for HTTPS"
    echo "• Change default UUIDs and passwords for better security"
    echo "• Monitor logs regularly: docker-compose -f docker-compose-ip.yml logs"
    echo ""
    echo -e "${BLUE}🌐 Website Test:${NC}"
    echo "• Visit: http://$SERVER_IP"
    echo "• Should show a professional business website"
    echo ""
    echo -e "${GREEN}🚀 Your proxy server is ready to use!${NC}"
}

# Main execution
main() {
    print_header "🔧 IP-Based Multi-Protocol Proxy Setup"
    
    get_server_ip
    install_dependencies
    setup_firewall
    create_fake_website
    stop_existing_services
    start_services
    generate_client_configs
    test_connections
    print_summary
}

# Run main function
main "$@" 