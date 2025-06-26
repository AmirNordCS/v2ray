# V2Ray Deployment on Hetzner VPS

## Prerequisites

- Hetzner VPS (Ubuntu 20.04+ recommended)
- SSH access to your VPS
- Domain name (optional but recommended)

## Deployment Options

### Option 1: Docker Deployment (Recommended)

#### 1. Initial VPS Setup

```bash
# Connect to your VPS
ssh root@your-vps-ip

# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install docker-compose -y

# Enable Docker service
systemctl enable docker
systemctl start docker
```

#### 2. Clone and Deploy

```bash
# Clone your repository
git clone <your-repo-url>
cd v2rayOnRender

# Create simplified docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  v2ray:
    build: .
    ports:
      - "8080:8080"
    environment:
      - PORT=8080
    restart: unless-stopped
    container_name: v2ray-proxy
EOF

# Build and start
docker-compose up -d

# Check status
docker-compose logs -f
```

#### 3. Configure Firewall

```bash
# Allow V2Ray port
ufw allow 8080
ufw enable

# Or use specific port with iptables
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables-save > /etc/iptables/rules.v4
```

### Option 2: Direct V2Ray Installation

#### 1. Install V2Ray

```bash
# Install V2Ray using official script
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# Enable and start V2Ray service
systemctl enable v2ray
```

#### 2. Configure V2Ray

```bash
# Copy your config.json to V2Ray directory
cp config.json /usr/local/etc/v2ray/config.json

# Start V2Ray
systemctl start v2ray
systemctl status v2ray
```

## Security Hardening

### 1. SSH Security

```bash
# Change SSH port (optional)
sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
systemctl restart ssh

# Disable root login (create user first)
adduser yourusername
usermod -aG sudo yourusername
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
```

### 2. Firewall Configuration

```bash
# Basic firewall setup
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 8080  # V2Ray port
ufw enable
```

### 3. Fail2ban (Optional)

```bash
apt install fail2ban -y
systemctl enable fail2ban
systemctl start fail2ban
```

## Domain Setup (Optional but Recommended)

### 1. Point Domain to VPS

- Create A record: `yourdomain.com` → `your-vps-ip`

### 2. SSL Certificate with Nginx

```bash
# Install Nginx and Certbot
apt install nginx certbot python3-certbot-nginx -y

# Create Nginx config
cat > /etc/nginx/sites-available/v2ray << 'EOF'
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

# Enable site
ln -s /etc/nginx/sites-available/v2ray /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

# Get SSL certificate
certbot --nginx -d yourdomain.com
```

## Client Configuration for Hetzner VPS

### Basic Configuration

- **Server**: `your-vps-ip` or `yourdomain.com`
- **Port**: `8080` (or your chosen port)
- **UUID**: `d0306468-e500-4193-95ef-a514b3396c90`
- **Protocol**: VMess
- **Network**: TCP
- **Header Type**: HTTP

### With Domain + SSL

- **Server**: `yourdomain.com`
- **Port**: `443`
- **TLS**: Enable
- **Other settings**: Same as above

## Monitoring and Maintenance

### Check V2Ray Status

```bash
# Docker deployment
docker-compose logs -f

# Direct installation
systemctl status v2ray
journalctl -u v2ray -f
```

### Update V2Ray

```bash
# Docker deployment
docker-compose pull
docker-compose up -d

# Direct installation
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
systemctl restart v2ray
```

## Performance Optimization

### 1. System Optimization

```bash
# Increase file limits
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65535" >> /etc/security/limits.conf

# Optimize network
echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf
sysctl -p
```

### 2. Choose Optimal Hetzner Location

- **Nuremberg, Germany** - Good for Europe
- **Falkenstein, Germany** - Alternative European location
- **Helsinki, Finland** - Northern Europe
- **Ashburn, USA** - North America

## Troubleshooting

### Connection Issues

```bash
# Check if port is open
netstat -tlnp | grep 8080

# Test connectivity
telnet your-vps-ip 8080

# Check firewall
ufw status
iptables -L
```

### V2Ray Issues

```bash
# Validate config
v2ray test -config /usr/local/etc/v2ray/config.json

# Check logs
journalctl -u v2ray -n 50
```

## Cost Optimization

- **CX11** (€3.29/month) - Basic usage
- **CX21** (€5.83/month) - Better performance
- **CX31** (€10.52/month) - High performance

Choose based on your bandwidth needs and user count.
