# VPN Configurations for 94.130.107.116

## 📱 How to Import Configurations

### For V2RayN (Windows)

1. **Method 1 (JSON Files):**

   - Open V2RayN
   - Click "Servers" → "Add [VMess] Server"
   - Click "Import from file" → Select any `.json` file
   - Click "OK"

2. **Method 2 (Connection Links):**
   - Copy any `vmess://`, `vless://`, or `trojan://` link from `connection-links.txt`
   - In V2RayN, click "Servers" → "Import from clipboard"

### For V2RayNG (Android)

1. **Method 1 (QR Code):**

   - Generate QR code from any connection link
   - Open V2RayNG → "+" → "Scan QR code"

2. **Method 2 (Manual Import):**
   - Copy connection link from `connection-links.txt`
   - Open V2RayNG → "+" → "Import config from clipboard"

### For V2RayU (macOS)

1. Copy connection link
2. Open V2RayU → "Configure" → "Import from pasteboard"

### For iOS (Shadowrocket/OneClick)

1. Copy connection link
2. Open app → "+" → "Add"
3. App will automatically detect the configuration

## 🔗 Available Configurations

### 1. VMess Google WebSocket

- **File:** `vmess-google-ws.json`
- **Port:** 80
- **Path:** `/vmess-google`
- **Host:** `www.google.com`
- **Best for:** General browsing, good compatibility

### 2. VMess Cloudflare WebSocket

- **File:** `vmess-cloudflare-ws.json`
- **Port:** 80
- **Path:** `/vmess-cf`
- **Host:** `www.cloudflare.com`
- **Best for:** High performance, CDN optimization

### 3. VMess Direct TCP

- **File:** `vmess-direct-tcp.json`
- **Port:** 8080
- **Protocol:** TCP with HTTP header
- **Host:** `www.netflix.com`
- **Best for:** Fastest connection, lowest latency

### 4. VLESS WebSocket

- **File:** `vless-websocket.json`
- **Port:** 80
- **Path:** `/vless-ws`
- **Host:** `www.microsoft.com`
- **Best for:** Latest protocol, better performance

### 5. VLESS gRPC

- **File:** `vless-grpc.json`
- **Port:** 80
- **Service:** `vless-grpc`
- **Best for:** Modern protocol, multiplexing

### 6. Trojan WebSocket

- **File:** `trojan-websocket.json`
- **Port:** 80
- **Path:** `/trojan-ws`
- **Host:** `www.github.com`
- **Password:** `your-strong-trojan-password-123`
- **Best for:** Maximum stealth, looks like HTTPS traffic

## 🎯 Which Configuration to Choose?

### For Speed:

1. **VMess Direct TCP** (fastest)
2. **VLESS WebSocket** (modern)
3. **VMess Google WebSocket** (reliable)

### For Stealth:

1. **Trojan WebSocket** (maximum stealth)
2. **VLESS gRPC** (modern stealth)
3. **VMess Cloudflare WebSocket** (CDN camouflage)

### For Compatibility:

1. **VMess Google WebSocket** (works everywhere)
2. **VMess Direct TCP** (simple protocol)
3. **VLESS WebSocket** (latest standard)

## ⚙️ Connection Settings

- **Server IP:** 94.130.107.116
- **Encryption:** Auto/AES-128-GCM
- **Network:** WebSocket (WS) or TCP
- **TLS:** None (HTTP only)
- **DNS:** 8.8.8.8, 1.1.1.1

## 🔧 Troubleshooting

### If Connection Fails:

1. **Check server status:** Visit http://94.130.107.116 (should show a website)
2. **Try different configurations:** Start with VMess Direct TCP
3. **Check firewall:** Ensure ports 80 and 8080 are accessible
4. **DNS issues:** Try changing DNS to 8.8.8.8

### Performance Issues:

1. **Try VMess Direct TCP** (port 8080) for fastest speed
2. **Switch between different WebSocket paths**
3. **Check server load** in your VPS

## 📋 Quick Import Links

**Copy these links and paste them into your V2Ray client:**

```
# VMess Google (Recommended)
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtR29vZ2xlLTk0LjEzMC4xMDcuMTE2IiwiYWRkIjoiOTQuMTMwLjEwNy4xMTYiLCJwb3J0IjoiODAiLCJpZCI6ImQwMzA2NDY4LWU1MDAtNDE5My05NWVmLWE1MTRiMzM5NmM5MCIsImFpZCI6IjAiLCJzY3kiOiJhdXRvIiwibmV0Ijoid3MiLCJ0eXBlIjoibm9uZSIsImhvc3QiOiJ3d3cuZ29vZ2xlLmNvbSIsInBhdGgiOiIvdm1lc3MtZ29vZ2xlIiwidGxzIjoiIiwic25pIjoiIiwiYWxwbiI6IiIsImZwIjoiIn0=

# VLESS WebSocket (Modern)
vless://f1e2d3c4-b5a6-9780-cdef-123456789abc@94.130.107.116:80?type=ws&host=www.microsoft.com&path=/vless-ws#VLESS-WebSocket-94.130.107.116

# VMess Direct TCP (Fastest)
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtRGlyZWN0LTk0LjEzMC4xMDcuMTE2IiwiYWRkIjoiOTQuMTMwLjEwNy4xMTYiLCJwb3J0IjoiODA4MCIsImlkIjoiOTk4ODc3NjYtNTU0NC0zMzIyLTExMDAtYWFiYmNjZGRlZWZmIiwiYWlkIjoiMCIsInNjeSI6ImF1dG8iLCJuZXQiOiJ0Y3AiLCJ0eXBlIjoiaHR0cCIsImhvc3QiOiJ3d3cubmV0ZmxpeC5jb20iLCJwYXRoIjoiIiwidGxzIjoiIiwic25pIjoiIiwiYWxwbiI6IiIsImZwIjoiIn0=
```

## 🔒 Security Notes

- All configurations use your VPS IP: **94.130.107.116**
- No TLS encryption (HTTP only) - traffic is encrypted by V2Ray protocols
- Change UUIDs and passwords for better security
- Monitor your VPS for any unusual activity

## 📞 Support

- **Test website:** http://94.130.107.116
- **Check if services are running:** Use your VPS SSH access
- **Update configs:** Re-run the setup script on your VPS
