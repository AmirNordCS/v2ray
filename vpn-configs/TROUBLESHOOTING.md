# 🔧 TROUBLESHOOTING GUIDE - Direct Port Setup

## ✅ **Simplified Setup - No More Nginx Issues!**

With the new direct port setup, most connection issues are eliminated! Each protocol now runs on its own dedicated port.

## 🎯 **Testing Order (Start Here!)**

### **1. VMess Direct TCP (Port 8080) - PROVEN WORKING** ✅

**This connection is confirmed working at 115ms ping!**

**Quick Test Link:**

```
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtRGlyZWN0LVRDUC05NC4xMzAuMTA3LjExNiIsImFkZCI6Ijk0LjEzMC4xMDcuMTE2IiwicG9ydCI6IjgwODAiLCJpZCI6Ijk5ODg3NzY2LTU1NDQtMzMyMi0xMTAwLWFhYmJjY2RkZWVmZiIsImFpZCI6IjAiLCJzY3kiOiJhdXRvIiwibmV0IjoidGNwIiwidHlwZSI6Imh0dHAiLCJob3N0Ijoid3d3Lm5ldGZsaXguY29tIiwicGF0aCI6IiIsInRscyI6Im5vbmUiLCJzbmkiOiIiLCJhbHBuIjoiIn0=
```

### **2. VMess Google WebSocket (Port 8001)**

**If TCP works, try this next:**

```
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtR29vZ2xlLVdTLTk0LjEzMC4xMDcuMTE2IiwiYWRkIjoiOTQuMTMwLjEwNy4xMTYiLCJwb3J0IjoiODAwMSIsImlkIjoiZDAzMDY0NjgtZTUwMC00MTkzLTk1ZWYtYTUxNGIzMzk2YzkwIiwiYWlkIjoiMCIsInNjeSI6ImF1dG8iLCJuZXQiOiJ3cyIsInR5cGUiOiJub25lIiwiaG9zdCI6Ind3dy5nb29nbGUuY29tIiwicGF0aCI6Ii8iLCJ0bHMiOiJub25lIiwic25pIjoiIiwiYWxwbiI6IiJ9
```

### **3. Other Protocols**

If the first two work, try:

- **VLESS WebSocket** (Port 8003)
- **VMess Cloudflare WebSocket** (Port 8002)
- **Trojan WebSocket** (Port 8005)

## 🔍 **If VMess Direct TCP (8080) Fails:**

### **Check Server Status:**

```bash
# SSH into your VPS and run:
docker-compose ps
docker-compose logs xray
netstat -tlnp | grep :8080
```

### **Common Issues:**

1. **Xray container not running:** `docker-compose restart xray`
2. **Port blocked:** `ufw allow 8080`
3. **Wrong UUID:** Check if you're using `99887766-5544-3322-1100-aabbccddeeff`

## 🔍 **If WebSocket Protocols (8001, 8002, 8003, 8005) Fail:**

### **Check All Ports:**

```bash
# Check if all ports are listening:
netstat -tlnp | grep ":8001\|:8002\|:8003\|:8005\|:8080"
```

### **Expected Output:**

```
tcp6  0  0  :::8001  :::*  LISTEN
tcp6  0  0  :::8002  :::*  LISTEN
tcp6  0  0  :::8003  :::*  LISTEN
tcp6  0  0  :::8005  :::*  LISTEN
tcp6  0  0  :::8080  :::*  LISTEN
```

## ⚙️ **Client Configuration Tips**

### **V2RayN (Windows):**

- **TLS:** None/Disable
- **Allow Insecure:** ✅ Enable
- **Network:** TCP (for 8080) or WebSocket (for others)

### **V2RayNG (Android):**

- **Security:** none
- **Allow Insecure:** ✅ Enable
- **TLS:** Disable

### **All Clients:**

- **Server IP:** 94.130.107.116
- **Encryption:** auto or aes-128-gcm
- **TLS/SSL:** ❌ **DISABLE** (Very Important!)

## 🚨 **Emergency Manual Setup (V2RayN)**

If import fails, configure manually:

### **VMess Direct TCP (Working Configuration):**

1. **Address:** 94.130.107.116
2. **Port:** 8080
3. **UUID:** 99887766-5544-3322-1100-aabbccddeeff
4. **AlterId:** 0
5. **Security:** auto
6. **Network:** tcp
7. **Header Type:** http
8. **HTTP Host:** www.netflix.com
9. **TLS:** ❌ NONE/Disable

### **VMess Google WebSocket:**

1. **Address:** 94.130.107.116
2. **Port:** 8001
3. **UUID:** d0306468-e500-4193-95ef-a514b3396c90
4. **AlterId:** 0
5. **Network:** ws
6. **WebSocket Path:** /
7. **WebSocket Host:** www.google.com
8. **TLS:** ❌ NONE/Disable

## 🔧 **Server Management Commands**

### **Check Everything:**

```bash
# Service status
docker-compose ps

# View logs
docker-compose logs -f

# Restart everything
docker-compose restart

# Check port usage
netstat -tlnp | grep -E ":(8080|8001|8002|8003|8005)"
```

### **Full Restart:**

```bash
# Stop everything
docker-compose down

# Start everything
docker-compose up -d

# Wait 10 seconds, then check
sleep 10 && docker-compose ps
```

## 📊 **Port Status Reference**

| Port | Protocol            | Status         | Notes                |
| ---- | ------------------- | -------------- | -------------------- |
| 8080 | VMess TCP           | ✅ **Working** | 115ms ping confirmed |
| 8001 | VMess WS Google     | 🔄 Test needed | Direct Xray port     |
| 8002 | VMess WS Cloudflare | 🔄 Test needed | Direct Xray port     |
| 8003 | VLESS WebSocket     | 🔄 Test needed | Direct Xray port     |
| 8005 | Trojan WebSocket    | 🔄 Test needed | Direct Xray port     |

## ✨ **Benefits of New Setup**

- ✅ **No nginx complications**
- ✅ **No path routing issues**
- ✅ **Direct container connections**
- ✅ **Easier debugging**
- ✅ **One working connection confirmed**

## 📞 **Still Need Help?**

### **Quick Tests:**

1. **Ping server:** `ping 94.130.107.116`
2. **Test VMess TCP first:** Use the confirmed working config
3. **Check VPS status:** SSH and run `docker-compose ps`

### **Expected Results:**

- **VMess Direct TCP:** Should work immediately (115ms ping)
- **WebSocket protocols:** Should work but may need testing
- **Connection speed:** 50-200ms to Germany (Hetzner location)

**Remember: Start with VMess Direct TCP (port 8080) - it's proven working!** 🚀
