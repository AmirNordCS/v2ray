# Multi-Protocol VPN Client Configurations (VLESS + WireGuard Optimized)

This directory contains client configuration files for connecting to your ultimate multi-protocol VPN server with WireGuard and VLESS protocols.

## 🔥 WireGuard VPN (TOP RECOMMENDED)

**WireGuard is the fastest and most efficient VPN protocol available!**

### Why Choose WireGuard First?

- **🚀 Fastest speeds** - kernel-level performance
- **🔋 Better battery life** on mobile devices
- **⚡ Lower latency** than HTTP-based protocols
- **🛡️ Works when HTTP protocols are blocked**
- **📱 Native support** in all modern devices

### WireGuard Setup:

- **Port**: 51820/udp
- **Config files**: `../wireguard-config/peer_client*/peer_client*.conf`
- **QR codes**: `../wireguard-config/peer_client*/peer_client*.png`
- **Clients available**: 5 (client1-client5)
- **Guide**: See `wireguard-client-guide.md`

## 🚀 VLESS Protocols (HTTP Proxy)

VLESS is the modern successor to VMess, offering better performance and efficiency for HTTP-based proxy connections.

### 1. VLESS Direct TCP (Port 8080) ⚡ **FASTEST HTTP PROXY**

- **File**: `vless-direct-tcp.json`
- **Port**: 8080
- **Type**: Direct TCP with HTTP header
- **Best for**: Maximum speed when WireGuard is blocked
- **Latency**: ~115ms (proven working)

### 2. VLESS WebSocket Microsoft (Port 8003)

- **File**: `vless-websocket.json`
- **Port**: 8003
- **Host**: www.microsoft.com
- **Best for**: Bypassing firewalls that block direct connections

### 3. VLESS WebSocket Google (Port 8004)

- **File**: `vless-websocket-google.json`
- **Port**: 8004
- **Host**: www.google.com
- **Best for**: Countries where Google is accessible

### 4. VLESS WebSocket Cloudflare (Port 8006)

- **File**: `vless-websocket-cloudflare.json`
- **Port**: 8006
- **Host**: www.cloudflare.com
- **Best for**: CDN-friendly connections

### 5. VLESS WebSocket GitHub (Port 8007)

- **File**: `vless-websocket-github.json`
- **Port**: 8007
- **Host**: www.github.com
- **Best for**: Developer-friendly environments

## 🔄 Fallback Protocols

### VMess WebSocket Google (Port 8001)

- **File**: `vmess-google-ws.json`
- **Legacy protocol**, use if VLESS doesn't work

### VMess WebSocket Cloudflare (Port 8002)

- **File**: `vmess-cloudflare-ws.json`
- **Legacy protocol**, use if VLESS doesn't work

### Trojan WebSocket (Port 8005)

- **File**: `trojan-websocket.json`
- **Password-based authentication**

## 📱 Client Setup Instructions

### Priority Order (Start Here!):

1. **🥇 WireGuard** (fastest, best battery life)
2. **🥈 VLESS Direct TCP** (fast HTTP proxy)
3. **🥉 VLESS WebSocket** (firewall bypass)
4. **🏃 VMess/Trojan** (compatibility fallback)

### Android Setup

**Option 1: WireGuard (Recommended)**

1. Install WireGuard app from Google Play
2. Scan QR code from `../wireguard-config/peer_client1/peer_client1.png`
3. Connect!

**Option 2: v2rayNG (HTTP Proxy)**

1. Download v2rayNG from GitHub or Google Play
2. Import JSON config: Menu → Add Profile → Import from File
3. **Start with VLESS Direct TCP** for best HTTP performance

### iOS Setup

**Option 1: WireGuard (Recommended)**

1. Install WireGuard app from App Store
2. Import config from `../wireguard-config/peer_client1/peer_client1.conf`
3. Connect!

**Option 2: Shadowrocket/Quantumult X**

1. Copy connection link from `connection-links.txt`
2. Add to your client
3. **Recommended**: Start with VLESS Direct TCP

### Windows Setup

**Option 1: WireGuard (Recommended)**

1. Download WireGuard from wireguard.com
2. Import `../wireguard-config/peer_client1/peer_client1.conf`
3. Activate connection

**Option 2: v2rayN (HTTP Proxy)**

1. Import JSON config: Add Server → Import from File
2. **Recommended**: Start with VLESS Direct TCP

### macOS Setup

**Option 1: WireGuard (Recommended)**

1. Install WireGuard from Mac App Store
2. Import config file
3. Connect

**Option 2: V2RayX/V2RayU**

1. Import JSON configuration file
2. **Recommended**: VLESS Direct TCP for best performance

### Linux Setup

**Option 1: WireGuard (Recommended)**

```bash
sudo apt install wireguard
sudo cp peer_client1.conf /etc/wireguard/wg0.conf
sudo wg-quick up wg0
```

**Option 2: v2ray/xray**

1. Use JSON config files directly with v2ray/xray core
2. Place in `/etc/v2ray/config.json` or similar

## 🎯 Performance Guide

### Best Performance Order:

1. **🔥 WireGuard (51820/udp)** - Fastest overall, best battery
2. **⚡ VLESS Direct TCP (8080)** - Fastest HTTP proxy
3. **🌐 VLESS WebSocket (8003-8007)** - Good performance, firewall-friendly
4. **🔄 VMess WebSocket (8001-8002)** - Legacy fallback
5. **🔒 Trojan WebSocket (8005)** - Alternative protocol

### When to Use Each:

- **WireGuard**: Default choice for all use cases
- **VLESS Direct TCP**: When WireGuard is blocked but need speed
- **VLESS WebSocket**: When direct connections are filtered
- **VMess/Trojan**: When VLESS is not supported by your client

### Troubleshooting Connection Issues:

1. **First**: Try WireGuard (usually works everywhere)
2. **If WireGuard blocked**: Try VLESS Direct TCP (port 8080)
3. **If still blocked**: Try VLESS WebSocket with different hosts
4. **Last resort**: Try VMess WebSocket as fallback

## 🔧 Technical Details

### Server Configuration:

- **IP**: 94.130.107.116
- **WireGuard**: UDP port 51820, kernel-level performance
- **HTTP Protocols**: No TLS/SSL, HTTP-only for simplicity
- **No CDN**: Direct IP connections
- **Docker**: All services in containers

### Security Notes:

- **WireGuard**: ChaCha20 encryption, Curve25519 keys
- **HTTP protocols**: Suitable for bypassing content restrictions
- Use with trusted networks
- Consider WireGuard for maximum security

### Protocol Features:

- **WireGuard**: Modern VPN, kernel implementation, fastest
- **VLESS**: Modern HTTP proxy, efficient, lower overhead
- **VMess**: Legacy HTTP proxy, wider compatibility
- **Trojan**: Password-based, good for some firewalls
- **WebSocket**: Helps bypass deep packet inspection

## 📊 Connection Status

After deployment, test in this order:

1. 🔥 **WireGuard (51820/udp)** - Primary choice
2. ✅ **VLESS Direct TCP (8080)** - HTTP proxy fallback
3. ✅ **VLESS WebSocket Microsoft (8003)**
4. ✅ **VLESS WebSocket Google (8004)**
5. ✅ **VLESS WebSocket Cloudflare (8006)**
6. ✅ **VLESS WebSocket GitHub (8007)**
7. ✅ **VMess WebSocket Google (8001)** - Legacy fallback
8. ✅ **VMess WebSocket Cloudflare (8002)** - Legacy fallback
9. ⚠️ **Trojan WebSocket (8005)** - May need TLS disable

## 🎉 Quick Start

1. **Download**: Get all files from this directory
2. **Start with WireGuard**: Use config from `../wireguard-config/peer_client1/`
3. **HTTP Proxy Backup**: Use VLESS Direct TCP if WireGuard blocked
4. **Test Alternatives**: Try different protocols if needed

**Your ultimate multi-protocol VPN server is ready! Start with WireGuard for the best experience! 🔥**
