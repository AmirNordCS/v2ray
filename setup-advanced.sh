#!/bin/bash

# Advanced V2Ray/Xray Multi-Protocol Setup Script
# Run with: bash setup-advanced.sh your-domain.com your-email@example.com

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOMAIN=${1:-""}
EMAIL=${2:-""}

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

check_requirements() {
    print_header "Checking Requirements"
    
    if [[ -z "$DOMAIN" ]] || [[ -z "$EMAIL" ]]; then
        print_error "Usage: $0 <domain> <email>"
        print_error "Example: $0 mydomain.com myemail@example.com"
        exit 1
    fi
    
    # Check if domain points to this server
    SERVER_IP=$(curl -s ifconfig.me)
    DOMAIN_IP=$(dig +short $DOMAIN)
    
    if [[ "$SERVER_IP" != "$DOMAIN_IP" ]]; then
        print_warning "Domain $DOMAIN doesn't point to this server ($SERVER_IP vs $DOMAIN_IP)"
        print_warning "Please update your DNS records before continuing"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_status "Domain verification passed"
}

install_dependencies() {
    print_header "Installing Dependencies"
    
    # Update system
    apt update && apt upgrade -y
    
    # Install required packages
    apt install -y curl wget git ufw fail2ban htop nano dnsutils
    
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
    ufw allow 80/tcp
    ufw allow 443/tcp
    
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
    <title>Welcome</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { text-align: center; color: #333; }
        .content { line-height: 1.6; color: #666; }
        .footer { text-align: center; margin-top: 40px; color: #999; font-size: 14px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome to Our Website</h1>
    </div>
    <div class="content">
        <p>This is a sample website running on nginx.</p>
        <p>We provide various web services and solutions.</p>
        <h2>Our Services</h2>
        <ul>
            <li>Web Development</li>
            <li>Server Management</li>
            <li>Technical Consulting</li>
        </ul>
    </div>
    <div class="footer">
        <p>&copy; 2024 Technical Services. All rights reserved.</p>
    </div>
</body>
</html>
EOF
    
    print_status "Fake website created"
}

update_nginx_config() {
    print_header "Updating Nginx Configuration"
    
    # Replace domain placeholder in nginx.conf
    sed -i "s/YOUR_DOMAIN_HERE/$DOMAIN/g" nginx.conf
    
    print_status "Nginx configuration updated"
}

setup_ssl() {
    print_header "Setting up SSL Certificates"
    
    # Create directories
    mkdir -p ssl logs
    
    # Stop any running services
    docker-compose -f docker-compose-advanced.yml down 2>/dev/null || true
    
    # Start nginx temporarily for certificate validation
    docker run --rm -d --name temp-nginx \
        -p 80:80 \
        -v $(pwd)/html:/var/www/html:ro \
        nginx:alpine
    
    # Wait for nginx to start
    sleep 5
    
    # Get SSL certificate
    docker run --rm \
        -v $(pwd)/ssl:/etc/letsencrypt \
        -v $(pwd)/html:/var/www/html \
        certbot/certbot certonly \
        --webroot \
        --webroot-path=/var/www/html \
        --email $EMAIL \
        --agree-tos \
        --no-eff-email \
        -d $DOMAIN
    
    # Stop temporary nginx
    docker stop temp-nginx
    
    print_status "SSL certificates obtained"
}

generate_configs() {
    print_header "Generating Client Configurations"
    
    mkdir -p client-configs
    
    # VMess Google config
    cat > client-configs/vmess-google.json << EOF
{
  "v": "2",
  "ps": "VMess-Google-${DOMAIN}",
  "add": "${DOMAIN}",
  "port": "443",
  "id": "d0306468-e500-4193-95ef-a514b3396c90",
  "aid": "0",
  "scy": "auto",
  "net": "ws",
  "type": "none",
  "host": "www.google.com",
  "path": "/vmess-google",
  "tls": "tls",
  "sni": "${DOMAIN}",
  "alpn": ""
}
EOF
    
    # VLESS WebSocket config
    cat > client-configs/vless-ws.json << EOF
{
  "v": "2",
  "ps": "VLESS-WS-${DOMAIN}",
  "add": "${DOMAIN}",
  "port": "443",
  "id": "f1e2d3c4-b5a6-9780-cdef-123456789abc",
  "net": "ws",
  "type": "none",
  "host": "www.microsoft.com",
  "path": "/vless-ws",
  "tls": "tls",
  "sni": "${DOMAIN}",
  "alpn": ""
}
EOF
    
    # Trojan config
    cat > client-configs/trojan.json << EOF
{
  "v": "2",
  "ps": "Trojan-${DOMAIN}",
  "add": "${DOMAIN}",
  "port": "443",
  "id": "",
  "aid": "",
  "scy": "",
  "net": "ws",
  "type": "none",
  "host": "www.github.com",
  "path": "/trojan-ws",
  "tls": "tls",
  "sni": "${DOMAIN}",
  "alpn": "",
  "fp": ""
}
EOF
    
    print_status "Client configurations generated in client-configs/"
}

start_services() {
    print_header "Starting Services"
    
    # Start all services
    docker-compose -f docker-compose-advanced.yml up -d
    
    # Wait for services to start
    sleep 10
    
    # Check service status
    docker-compose -f docker-compose-advanced.yml ps
    
    print_status "Services started successfully"
}

setup_auto_renewal() {
    print_header "Setting up SSL Auto-Renewal"
    
    # Create renewal script
    cat > ssl-renew.sh << 'EOF'
#!/bin/bash
docker-compose -f /root/v2rayOnRender/docker-compose-advanced.yml exec certbot \
    certbot renew --quiet --no-self-upgrade
docker-compose -f /root/v2rayOnRender/docker-compose-advanced.yml restart nginx
EOF
    
    chmod +x ssl-renew.sh
    
    # Add to crontab
    (crontab -l 2>/dev/null; echo "0 12 * * * /root/v2rayOnRender/ssl-renew.sh") | crontab -
    
    print_status "SSL auto-renewal configured"
}

print_summary() {
    print_header "Setup Complete!"
    
    echo -e "${GREEN}✅ Your advanced proxy server is now running!${NC}"
    echo ""
    echo -e "${BLUE}Server Details:${NC}"
    echo "Domain: $DOMAIN"
    echo "Server IP: $(curl -s ifconfig.me)"
    echo ""
    echo -e "${BLUE}Available Protocols:${NC}"
    echo "• VMess + WebSocket (Google host)"
    echo "• VMess + WebSocket (Cloudflare host)"
    echo "• VLESS + WebSocket"
    echo "• VLESS + gRPC"
    echo "• Trojan + WebSocket"
    echo ""
    echo -e "${BLUE}Client Configurations:${NC}"
    echo "Check the 'client-configs/' directory for ready-to-use configs"
    echo ""
    echo -e "${BLUE}Management Commands:${NC}"
    echo "• View logs: docker-compose -f docker-compose-advanced.yml logs -f"
    echo "• Restart: docker-compose -f docker-compose-advanced.yml restart"
    echo "• Stop: docker-compose -f docker-compose-advanced.yml down"
    echo ""
    echo -e "${YELLOW}⚠️  Important Security Notes:${NC}"
    echo "• Change default UUIDs and passwords in xray-config.json"
    echo "• Keep your system updated"
    echo "• Monitor logs regularly"
    echo ""
    echo -e "${GREEN}🎉 Enjoy your multi-protocol proxy server!${NC}"
}

# Main execution
main() {
    print_header "Advanced Proxy Server Setup"
    
    check_requirements
    install_dependencies
    setup_firewall
    create_fake_website
    update_nginx_config
    setup_ssl
    generate_configs
    start_services
    setup_auto_renewal
    print_summary
}

# Run main function
main "$@" 