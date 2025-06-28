# 🔧 TROUBLESHOOTING GUIDE - Fixing TLS Errors

## ❌ **Problem**: "tls: first record does not look like a TLS handshake"

This error means your client is trying to use HTTPS/TLS but your server is running HTTP only.

## ✅ **SOLUTION**: Use the FIXED configurations

### **Step 1: Use Fixed Configurations**

Use these files instead of the original ones:

- `vmess-google-ws-fixed.json` ← **Start with this one**
- `vmess-direct-tcp-fixed.json` ← **Try this if WebSocket fails**
- `vless-websocket-fixed.json`

### **Step 2: Quick Test Links**

**Copy and import these corrected links:**

**VMess Direct TCP (Simplest - Try First):**

```
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtRGlyZWN0LVRDUC05NC4xMzAuMTA3LjExNiIsImFkZCI6Ijk0LjEzMC4xMDcuMTE2IiwicG9ydCI6IjgwODAiLCJpZCI6Ijk5ODg3NzY2LTU1NDQtMzMyMi0xMTAwLWFhYmJjY2RkZWVmZiIsImFpZCI6IjAiLCJzY3kiOiJhdXRvIiwibmV0IjoidGNwIiwidHlwZSI6Imh0dHAiLCJob3N0Ijoid3d3Lm5ldGZsaXguY29tIiwicGF0aCI6IiIsInRscyI6Im5vbmUiLCJzbmkiOiIiLCJhbHBuIjoiIiwiZnAiOiIiLCJhbGxvd0luc2VjdXJlIjoxfQ==
```

**VMess Google WebSocket (After TCP works):**

```
vmess://eyJ2IjoiMiIsInBzIjoiVk1lc3MtR29vZ2xlLUhUVFAtOTQuMTMwLjEwNy4xMTYiLCJhZGQiOiI5NC4xMzAuMTA3LjExNiIsInBvcnQiOiI4MCIsImlkIjoiZDAzMDY0NjgtZTUwMC00MTkzLTk1ZWYtYTUxNGIzMzk2YzkwIiwiYWlkIjoiMCIsInNjeSI6ImF1dG8iLCJuZXQiOiJ3cyIsInR5cGUiOiJub25lIiwiaG9zdCI6Ind3dy5nb29nbGUuY29tIiwicGF0aCI6Ii92bWVzcy1nb29nbGUiLCJ0bHMiOiJub25lIiwic25pIjoiIiwiYWxwbiI6IiIsImZwIjoiIiwiYWxsb3dJbnNlY3VyZSI6MX0=
```

## 🔧 **Client Settings to Check**

### **V2RayN (Windows):**

1. **TLS:** Set to "none" or disable
2. **allowInsecure:** Enable/Check
3. **Skip Certificate Verification:** Enable

### **V2RayNG (Android):**

1. **Security:** Set to "none"
2. **Allow Insecure:** Enable
3. **TLS:** Disable

### **General Settings:**

- **Server:** 94.130.107.116
- **Port:** 8080 (for direct) or 80 (for WebSocket)
- **TLS/SSL:** DISABLE
- **Certificate Verification:** SKIP/DISABLE

## 🎯 **Testing Order:**

### **1. Test VMess Direct TCP First** (Port 8080)

- This bypasses Nginx completely
- Simplest configuration
- If this doesn't work, there's a server issue

### **2. Then Test VMess WebSocket** (Port 80)

- Goes through Nginx
- More complex but better disguised

### **3. Check Server Status**

Before testing, verify your server:

```bash
# In your VPS terminal:
docker-compose -f docker-compose-ip.yml ps
curl -I http://localhost:80
curl -I http://localhost:8080
```

## 🔍 **Diagnosis Steps:**

### **If VMess Direct TCP (8080) Fails:**

- Server Xray not running
- Port 8080 blocked by firewall
- Wrong UUID

### **If VMess WebSocket (80) Fails but TCP Works:**

- Nginx configuration issue
- WebSocket path wrong
- Host header issue

### **If Both Fail:**

- Server not running: `docker-compose -f docker-compose-ip.yml up -d`
- Firewall blocking: `ufw allow 80 && ufw allow 8080`
- Wrong server IP

## ⚡ **Quick Fix Commands for VPS:**

```bash
# Restart services
docker-compose -f docker-compose-ip.yml restart

# Check logs
docker-compose -f docker-compose-ip.yml logs -f

# Check ports
netstat -tlnp | grep -E ':(80|8080) '

# Test local connectivity
curl http://localhost:80
telnet localhost 8080
```

## 🚨 **Emergency: Manual V2RayN Setup**

If import fails, set up manually in V2RayN:

1. **Add VMess Server**
2. **Address:** 94.130.107.116
3. **Port:** 8080
4. **UUID:** 99887766-5544-3322-1100-aabbccddeeff
5. **AlterId:** 0
6. **Security:** auto
7. **Network:** tcp
8. **Header Type:** http
9. **HTTP Host:** www.netflix.com
10. **TLS:** NONE/Disable

## 📞 **Still Not Working?**

1. **Check server:** Visit http://94.130.107.116 (should show website)
2. **Ping test:** `ping 94.130.107.116`
3. **Port test:** Use online port checker for ports 80, 8080
4. **Try different client:** Test with another V2Ray app

**Expected result:** Connection should work with 50-200ms ping to Germany (Hetzner).
