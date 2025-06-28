# VPN Configurations for 94.130.107.116

## Simplified Direct Port Setup (No Nginx)

## 🎯 **Available Configurations**

### ✅ **VMess Direct TCP** (PROVEN WORKING - 115ms ping)

- **File:** `vmess-direct-tcp.json`
- **Port:** 8080
- **Protocol:** TCP with HTTP header
- **Host:** `www.netflix.com`
- **Status:** ✅ **Working perfectly**
- **Best for:** Fastest connection, lowest latency

### 🔄 **VMess Google WebSocket**

- **File:** `vmess-google-ws.json`
- **Port:** 8001 (direct access)
- **Host:** `www.google.com`
- **Path:** `/`
- **Best for:** General browsing, good compatibility

### 🔄 **VMess Cloudflare WebSocket**

- **File:** `vmess-cloudflare-ws.json`
- **Port:** 8002 (direct access)
- **Host:** `www.cloudflare.com`
- **Path:** `/`
- **Best for:** High performance, CDN optimization

### 🔄 **VLESS WebSocket**

- **File:** `vless-websocket.json`
- **Port:** 8003 (direct access)
- **Host:** `www.microsoft.com`
- **Path:** `/`
- **Best for:** Latest protocol, better performance

### 🔄 **Trojan WebSocket**

- **File:** `trojan-websocket.json`
- **Port:** 8005 (direct access)
- **Host:** `www.github.com`
- **Path:** `/`
- **Password:** `your-strong-trojan-password-123`
- **Best for:** Maximum stealth

## 📱 **How to Import Configurations**

### **Method 1: JSON Files**

1. Download any `.json` file from this folder
2. In your V2Ray client:
   - **V2RayN (Windows):** Servers → Add VMess/VLESS Server → Import from file
   - **V2RayNG (Android):** + → Import config from file
   - **V2RayU (macOS):** Configure → Import from file

### **Method 2: Connection Links**

1. Copy any link from `connection-links.txt`
2. In your V2Ray client:
   - **V2RayN:** Servers → Import from clipboard
   - **V2RayNG:** + → Import config from clipboard
   - **V2RayU:** Configure → Import from pasteboard
   - **iOS (Shadowrocket):** + → Add → Paste link

## 🚀 **Which Configuration to Choose?**

### **For Reliability:**

1. **VMess Direct TCP** (port 8080) - ✅ **Start here!**
2. **VMess Google WebSocket** (port 8001)
3. **VLESS WebSocket** (port 8003)

### **For Speed:**

1. **VMess Direct TCP** (fastest, proven working)
2. **VLESS WebSocket** (modern protocol)
3. **VMess WebSocket** (reliable)

### **For Stealth:**

1. **Trojan WebSocket** (maximum stealth)
2. **VMess Cloudflare WebSocket** (CDN camouflage)
3. **VLESS WebSocket** (modern stealth)

## ⚙️ **Connection Settings**

- **Server IP:** 94.130.107.116
- **Encryption:** Auto/AES-128-GCM
- **TLS:** None (direct HTTP connections)
- **DNS:** 8.8.8.8, 1.1.1.1

## 🔧 **Troubleshooting**

### **If Connection Fails:**

1. **Start with VMess Direct TCP** (port 8080) - proven working!
2. Check if ports are accessible from your location
3. Try different protocols if one doesn't work
4. Ensure your VPS is running: `docker-compose ps`

### **Port Status Check:**

- **8080** (VMess TCP): ✅ Working
- **8001** (VMess Google WS): 🔄 Test needed
- **8002** (VMess CF WS): 🔄 Test needed
- **8003** (VLESS WS): 🔄 Test needed
- **8005** (Trojan WS): 🔄 Test needed

### **Performance Issues:**

1. **Use VMess Direct TCP** (port 8080) for best speed
2. Check your VPS resources: `docker stats`
3. Try different WebSocket protocols
4. Consider changing DNS to 8.8.8.8

## 📋 **Quick Import Links**

**Copy these links and paste them into your V2Ray client:**

### 🏆 **Recommended (Proven Working):**

```
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtRGlyZWN0LVRDUC05NC4xMzAuMTA3LjExNiIsImFkZCI6Ijk0LjEzMC4xMDcuMTE2IiwicG9ydCI6IjgwODAiLCJpZCI6Ijk5ODg3NzY2LTU1NDQtMzMyMi0xMTAwLWFhYmJjY2RkZWVmZiIsImFpZCI6IjAiLCJzY3kiOiJhdXRvIiwibmV0IjoidGNwIiwidHlwZSI6Imh0dHAiLCJob3N0Ijoid3d3Lm5ldGZsaXguY29tIiwicGF0aCI6IiIsInRscyI6Im5vbmUiLCJzbmkiOiIiLCJhbHBuIjoiIn0=
```

### 🔄 **Alternative Options:**

```
# VMess Google WebSocket
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtR29vZ2xlLVdTLTk0LjEzMC4xMDcuMTE2IiwiYWRkIjoiOTQuMTMwLjEwNy4xMTYiLCJwb3J0IjoiODAwMSIsImlkIjoiZDAzMDY0NjgtZTUwMC00MTkzLTk1ZWYtYTUxNGIzMzk2YzkwIiwiYWlkIjoiMCIsInNjeSI6ImF1dG8iLCJuZXQiOiJ3cyIsInR5cGUiOiJub25lIiwiaG9zdCI6Ind3dy5nb29nbGUuY29tIiwicGF0aCI6Ii8iLCJ0bHMiOiJub25lIiwic25pIjoiIiwiYWxwbiI6IiJ9

# VLESS WebSocket
vless://f1e2d3c4-b5a6-9780-cdef-123456789abc@94.130.107.116:8003?type=ws&host=www.microsoft.com&path=/&security=none#VLESS-WS-94.130.107.116

# Trojan WebSocket
trojan://your-strong-trojan-password-123@94.130.107.116:8005?type=ws&host=www.github.com&path=/&security=none#Trojan-WS-94.130.107.116
```

## 🔒 **Security Notes**

- ✅ **Simplified setup** - No nginx complexity
- ✅ **Direct port access** - Each protocol on its own port
- ✅ **No path routing issues** - Direct container connections
- ⚠️ **HTTP only** - No TLS (traffic encrypted by V2Ray protocols)
- 🔐 **Change UUIDs** and passwords for better security

## 📞 **Management**

### **VPS Commands:**

```bash
# Check service status
docker-compose ps

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Stop services
docker-compose down
```

### **Port Testing:**

```bash
# Test if ports are open
netstat -tlnp | grep ":8080\|:8001\|:8002\|:8003\|:8005"
```

## ✨ **Benefits of This Setup**

- ✅ **Much simpler** than nginx reverse proxy
- ✅ **No container networking issues**
- ✅ **Direct port access** for each protocol
- ✅ **Easier debugging** and troubleshooting
- ✅ **Proven working** (VMess TCP confirmed at 115ms)
- ✅ **No WebSocket routing problems**

---

**Start with VMess Direct TCP (port 8080) - it's proven to work perfectly!** 🚀
