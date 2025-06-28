# VLESS-Optimized Multi-Protocol VPN Client Configurations

This directory contains client configuration files for connecting to your VLESS-optimized multi-protocol proxy server.

## 🚀 VLESS Protocols (RECOMMENDED)

VLESS is the modern successor to VMess, offering better performance and efficiency.

### 1. VLESS Direct TCP (Port 8080) ⚡ **FASTEST**

- **File**: `vless-direct-tcp.json`
- **Port**: 8080
- **Type**: Direct TCP with HTTP header
- **Best for**: Maximum speed and stability
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

### Android (v2rayNG)

1. Download v2rayNG from GitHub or Google Play
2. Import JSON config: Menu → Add Profile → Import from File
3. Or use connection links from `connection-links.txt`
4. **Start with VLESS Direct TCP** for best performance

### iOS (Shadowrocket/Quantumult X)

1. Copy connection link from `connection-links.txt`
2. Add to your client
3. **Recommended**: VLESS Direct TCP link

### Windows (v2rayN)

1. Import JSON config: Add Server → Import from File
2. Or use connection links
3. **Recommended**: Start with VLESS Direct TCP

### macOS (V2RayX/V2RayU)

1. Import JSON configuration file
2. **Recommended**: VLESS Direct TCP for best performance

### Linux (v2ray/xray)

1. Use JSON config files directly with v2ray/xray core
2. Place in `/etc/v2ray/config.json` or similar

## 🎯 Performance Guide

### Best Performance Order:

1. **VLESS Direct TCP (8080)** - Fastest, most stable
2. **VLESS WebSocket (8003-8007)** - Good performance, firewall-friendly
3. **VMess WebSocket (8001-8002)** - Legacy fallback
4. **Trojan WebSocket (8005)** - Alternative protocol

### Troubleshooting Connection Issues:

1. **First**: Try VLESS Direct TCP (port 8080)
2. **If blocked**: Try VLESS WebSocket with different hosts
3. **If still blocked**: Try VMess WebSocket as fallback
4. **Check firewall**: Ensure ports are open on your network

## 🔧 Technical Details

### Server Configuration:

- **IP**: 94.130.107.116
- **No TLS/SSL**: HTTP-only setup for simplicity
- **No CDN**: Direct IP connections
- **Docker**: All services in containers

### Security Notes:

- All connections use HTTP (no HTTPS)
- Suitable for bypassing content restrictions
- Use with trusted networks
- Consider additional encryption if needed

### Protocol Features:

- **VLESS**: Modern, efficient, lower overhead
- **VMess**: Legacy, wider compatibility
- **Trojan**: Password-based, good for some firewalls
- **WebSocket**: Helps bypass deep packet inspection

## 📊 Connection Status

After deployment, test in this order:

1. ✅ VLESS Direct TCP (8080) - Primary choice
2. ✅ VLESS WebSocket Microsoft (8003)
3. ✅ VLESS WebSocket Google (8004)
4. ✅ VLESS WebSocket Cloudflare (8006)
5. ✅ VLESS WebSocket GitHub (8007)
6. ✅ VMess WebSocket Google (8001) - Fallback
7. ✅ VMess WebSocket Cloudflare (8002) - Fallback
8. ⚠️ Trojan WebSocket (8005) - May need TLS disable

## 🎉 Quick Start

1. **Download**: Get all files from this directory
2. **Start Simple**: Use VLESS Direct TCP first (port 8080)
3. **Test Alternative**: If blocked, try VLESS WebSocket variants
4. **Fallback**: Use VMess if VLESS doesn't work in your region

Your VLESS-optimized proxy server is ready! Start with the direct TCP connection for the best experience.
