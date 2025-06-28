# VLESS-Optimized Multi-Protocol Proxy Troubleshooting Guide

## 🚀 Quick Start Troubleshooting

### **Step 1: Test VLESS Direct TCP First**

VLESS Direct TCP (port 8080) should be your first choice:

```
vless://99887766-5544-3322-1100-aabbccddeeff@94.130.107.116:8080?type=tcp&headerType=http&host=www.netflix.com&security=none#VLESS-Direct-TCP
```

✅ **Expected result**: ~115ms latency, stable connection
❌ **If fails**: Your ISP might block port 8080, try WebSocket variants

### **Step 2: Test VLESS WebSocket Variants**

If Direct TCP doesn't work, try different WebSocket hosts:

1. **Microsoft** (8003): `vless://f1e2d3c4-b5a6-9780-cdef-123456789abc@94.130.107.116:8003?type=ws&host=www.microsoft.com&path=/&security=none`
2. **Google** (8004): `vless://12345678-abcd-ef12-3456-789abcdef012@94.130.107.116:8004?type=ws&host=www.google.com&path=/&security=none`
3. **Cloudflare** (8006): `vless://87654321-dcba-21fe-6543-210987654321@94.130.107.116:8006?type=ws&host=www.cloudflare.com&path=/&security=none`
4. **GitHub** (8007): `vless://abcdefgh-1234-5678-9abc-def123456789@94.130.107.116:8007?type=ws&host=www.github.com&path=/&security=none`

### **Step 3: Fallback to VMess WebSocket**

If VLESS doesn't work:

1. **VMess Google** (8001): Base64 link in connection-links.txt
2. **VMess Cloudflare** (8002): Base64 link in connection-links.txt

## 🔍 Common Issues and Solutions

### Issue 1: "-1ms" Latency or Timeout

**Cause**: Connection is being blocked or protocol mismatch

**Solutions**:

1. ✅ **Try VLESS Direct TCP first** (most reliable)
2. ✅ **Check your firewall** - ensure ports aren't blocked locally
3. ✅ **Try different hosts** - some ISPs block specific domains
4. ✅ **Switch to WebSocket** if direct TCP is blocked

### Issue 2: "Connection Reset by Peer"

**Cause**: Server is rejecting the connection

**Solutions**:

1. ✅ **Verify server is running**: `docker-compose ps`
2. ✅ **Check server logs**: `docker-compose logs -f`
3. ✅ **Restart server**: `docker-compose restart`
4. ✅ **Check port accessibility**: `netstat -tlnp | grep :8080`

### Issue 3: "TLS Handshake Error"

**Cause**: Client trying to use TLS but server is HTTP-only

**Solutions**:

1. ✅ **Disable TLS in client** - set "tls": "none"
2. ✅ **Set allowInsecure**: Add "allowInsecure": 1
3. ✅ **Use provided configs** - they're already configured correctly

### Issue 4: "Bad Request" (400 Error)

**Cause**: This is actually **NORMAL** for direct access to proxy endpoints

**Explanation**:

- VMess/VLESS endpoints return 400 when accessed directly
- This means the server is working correctly
- Use proper V2Ray client, not browser

### Issue 5: Slow Connection Speed

**Performance optimization**:

1. ✅ **Use VLESS Direct TCP** (fastest)
2. ✅ **Choose nearest host**:
   - Europe: Cloudflare (8006)
   - Global: Google (8004)
   - Enterprise: Microsoft (8003)
   - Developers: GitHub (8007)
3. ✅ **Check server resources**: `docker stats`

## 🛠️ Server-Side Troubleshooting

### Check Service Status

```bash
# Check all containers
docker-compose ps

# Should show:
# - xray-proxy: running
# - watchtower-updater: running
```

### View Logs

```bash
# Real-time logs
docker-compose logs -f

# Specific service logs
docker-compose logs xray
```

### Test Port Accessibility

```bash
# Check if all ports are listening
netstat -tlnp | grep -E ":(8001|8002|8003|8004|8005|8006|8007|8080) "

# Should show all ports as LISTEN
```

### Check Firewall Rules

```bash
# View UFW status
ufw status

# Should show all ports allowed:
# 8001/tcp, 8002/tcp, 8003/tcp, 8004/tcp,
# 8005/tcp, 8006/tcp, 8007/tcp, 8080/tcp
```

### Restart Services

```bash
# Full restart
docker-compose restart

# Or rebuild if needed
docker-compose down
docker-compose up -d
```

## 📱 Client-Specific Troubleshooting

### Android (v2rayNG)

1. **Import Issues**: Use "Import from File" not "Import from QR"
2. **Connection Fails**: Try different routing modes
3. **Slow Speed**: Enable "Mux" in settings
4. **Battery Drain**: Disable "Auto-select server"

### iOS (Shadowrocket)

1. **Import Issues**: Copy link directly, don't scan QR
2. **Connection Fails**: Check "Allow connections from local network"
3. **Slow Speed**: Try different encryption methods

### Windows (v2rayN)

1. **Import Issues**: Use "Import from File"
2. **Connection Fails**: Run as Administrator
3. **Slow Speed**: Change routing to "Bypass mainland China"

### macOS (V2RayU)

1. **Import Issues**: Ensure app has network permissions
2. **Connection Fails**: Check system proxy settings
3. **DNS Issues**: Use 8.8.8.8 or 1.1.1.1

## 🔄 Protocol-Specific Issues

### VLESS Protocol

- **Advantage**: Modern, efficient, faster than VMess
- **Issue**: Some old clients don't support VLESS
- **Solution**: Use v2rayNG 1.6.0+ or similar updated clients

### VMess Protocol

- **Advantage**: Wider client compatibility
- **Issue**: Higher overhead than VLESS
- **Solution**: Use as fallback if VLESS doesn't work

### Trojan Protocol

- **Common Issue**: TLS errors
- **Solution**: Set `allowInsecure=1` and `security=none`
- **Link**: `trojan://your-strong-trojan-password-123@94.130.107.116:8005?type=ws&host=www.github.com&path=/&security=none&allowInsecure=1`

## 🌍 Regional Connectivity Issues

### China

- **Best**: VLESS WebSocket with Cloudflare host (8006)
- **Alternative**: VMess with Google host (8001)
- **Avoid**: Direct TCP might be heavily filtered

### Iran

- **Best**: VLESS WebSocket with GitHub host (8007)
- **Alternative**: Trojan WebSocket (8005)
- **Note**: Google and social media hosts might be blocked

### Russia

- **Best**: VLESS Direct TCP (8080)
- **Alternative**: VLESS WebSocket Microsoft (8003)
- **Note**: Western hosts might have connectivity issues

### Other Restrictive Countries

1. Try VLESS Direct TCP first
2. If blocked, use WebSocket with different hosts
3. Trojan might work where others fail

## ⚡ Performance Optimization

### Best Performance Setup:

1. **Protocol**: VLESS Direct TCP (8080)
2. **Client**: Latest v2rayNG/v2rayN
3. **Routing**: Bypass local traffic
4. **DNS**: 8.8.8.8, 1.1.1.1

### If Direct TCP is Blocked:

1. **VLESS WebSocket**: Start with Microsoft (8003)
2. **Try different hosts**: Google (8004), Cloudflare (8006), GitHub (8007)
3. **VMess Fallback**: If VLESS completely blocked

## 🚨 Emergency Fixes

### Complete Reset

```bash
# Stop everything
docker-compose down

# Clean Docker
docker system prune -f

# Restart
docker-compose up -d
```

### Change Ports (if blocked)

Edit `docker-compose.yml` and change port mappings:

```yaml
ports:
  - "9001:8001" # Change left number only
  - "9002:8002"
  # etc...
```

### Update Configs

```bash
# Pull latest changes
git pull origin main

# Restart with new configs
docker-compose down && docker-compose up -d
```

## 📞 Getting Help

### Before Asking for Help:

1. ✅ Test VLESS Direct TCP (8080) first
2. ✅ Check server logs: `docker-compose logs`
3. ✅ Verify ports are listening: `netstat -tlnp | grep 80`
4. ✅ Try different protocols (VLESS → VMess → Trojan)

### Information to Provide:

- Your location/country
- Client app and version
- Which protocols you tried
- Server logs output
- Error messages

---

**Remember**: Start with VLESS Direct TCP (port 8080) - it's the fastest and most reliable option! 🚀
