# WireGuard VPN Client Setup Guide

WireGuard is now available on your server! It's often **faster than VLESS/VMess** and provides better battery life on mobile devices.

## 🔥 Why Use WireGuard?

- **Fastest VPN protocol** - kernel-level performance
- **Better battery life** on mobile devices
- **Lower latency** than HTTP-based protocols
- **Works when HTTP protocols are blocked**
- **Native support** in most modern devices

## 📁 Getting Your WireGuard Configuration

After running `setup.sh`, your WireGuard configs are generated in:

```
./wireguard-config/
├── peer_client1/
│   ├── peer_client1.conf    # Configuration file
│   └── peer_client1.png     # QR code for mobile
├── peer_client2/
│   ├── peer_client2.conf
│   └── peer_client2.png
├── ... (up to client5)
```

## 📱 Client Setup Instructions

### Android & iOS (Mobile)

1. **Install WireGuard app**:

   - Android: [Google Play Store](https://play.google.com/store/apps/details?id=com.wireguard.android)
   - iOS: [App Store](https://apps.apple.com/app/wireguard/id1441195209)

2. **Add configuration**:

   - **Option A**: Scan QR code from `peer_client1.png`
   - **Option B**: Import `peer_client1.conf` file
   - **Option C**: Copy-paste the configuration text

3. **Connect**: Toggle the connection on

### Windows

1. **Install WireGuard**:

   - Download from [wireguard.com](https://www.wireguard.com/install/)

2. **Import configuration**:

   - Open WireGuard app
   - Click "Add Tunnel" → "Add from file"
   - Select `peer_client1.conf`

3. **Connect**: Click "Activate"

### macOS

1. **Install WireGuard**:

   - Mac App Store or [wireguard.com](https://www.wireguard.com/install/)

2. **Import configuration**:

   - Open WireGuard app
   - Click "+" → "Add from file"
   - Select `peer_client1.conf`

3. **Connect**: Toggle the connection

### Linux

1. **Install WireGuard**:

   ```bash
   # Ubuntu/Debian
   sudo apt install wireguard

   # CentOS/RHEL
   sudo yum install wireguard-tools
   ```

2. **Setup configuration**:

   ```bash
   # Copy config to system directory
   sudo cp peer_client1.conf /etc/wireguard/wg0.conf

   # Start WireGuard
   sudo wg-quick up wg0

   # Enable on boot (optional)
   sudo systemctl enable wg-quick@wg0
   ```

3. **Disconnect**:
   ```bash
   sudo wg-quick down wg0
   ```

## 🔧 Manual Configuration

If you need to manually configure, here's the template:

```ini
[Interface]
PrivateKey = <your-private-key>
Address = 10.13.13.x/32
DNS = 8.8.8.8, 1.1.1.1

[Peer]
PublicKey = <server-public-key>
Endpoint = 94.130.107.116:51820
AllowedIPs = 0.0.0.0/0
```

_The actual keys are generated automatically in your config files._

## 🔍 Troubleshooting

### Connection Issues

1. **Check server status**:

   ```bash
   docker-compose logs wireguard
   ```

2. **Verify port is open**:

   ```bash
   netstat -ulnp | grep 51820
   ```

3. **Test UDP connectivity**:
   ```bash
   nc -u 94.130.107.116 51820
   ```

### Performance Issues

- **Use closest server location** for best performance
- **Check for NAT/firewall** blocking UDP port 51820
- **Try different DNS servers** (1.1.1.1, 8.8.8.8)

### Mobile Battery Optimization

- WireGuard is designed for mobile efficiency
- Uses **less battery** than OpenVPN or HTTP protocols
- **Always-on** mode available in mobile apps

## 📊 Performance Comparison

| Protocol  | Latency    | Speed      | Battery    | Setup    |
| --------- | ---------- | ---------- | ---------- | -------- |
| WireGuard | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| VLESS TCP | ⭐⭐⭐⭐   | ⭐⭐⭐⭐   | ⭐⭐⭐     | ⭐⭐⭐   |
| VLESS WS  | ⭐⭐⭐     | ⭐⭐⭐     | ⭐⭐⭐     | ⭐⭐⭐   |
| VMess     | ⭐⭐       | ⭐⭐⭐     | ⭐⭐       | ⭐⭐⭐   |

## 🛡️ Security Features

- **ChaCha20** encryption (faster than AES on mobile)
- **Curve25519** key exchange
- **Built-in perfect forward secrecy**
- **Minimal attack surface** (small codebase)

## 🚀 Advanced Tips

### Multiple Clients

You have 5 pre-configured clients (client1-client5):

- Use different clients for different devices
- Each client has unique keys and IP addresses
- All clients share the same server endpoint

### Adding More Clients

To add more clients, edit `docker-compose.yml`:

```yaml
environment:
  - PEERS=client1,client2,client3,client4,client5,client6,client7
```

Then restart:

```bash
docker-compose down
docker-compose up -d
```

### Custom DNS

Edit your client config to use different DNS:

```ini
DNS = 1.1.1.1, 8.8.8.8
# or
DNS = 9.9.9.9, 149.112.112.112  # Quad9
```

## 📞 Getting Help

### View WireGuard Status

```bash
# Check container logs
docker-compose logs wireguard

# Show connected peers
docker exec wireguard-server wg show

# Generate new QR code
docker exec wireguard-server /app/show-peer client1
```

---

**WireGuard is often the fastest and most efficient option - try it first!** 🔥
