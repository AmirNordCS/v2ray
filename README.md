# V2Ray VPN on Render.com

This repository contains the configuration to deploy a V2Ray proxy server on Render.com.

## Features

- VMess protocol with TCP transport
- HTTP header obfuscation for better disguise
- Dynamic port binding for Render.com compatibility
- Free tier compatible

## Files Overview

- `config.json` - V2Ray configuration
- `Dockerfile` - Container configuration
- `start.sh` - Startup script with dynamic port binding
- `render.yaml` - Render.com deployment configuration

## Deployment Steps

### 1. Fork/Clone Repository

```bash
git clone <your-repo-url>
cd v2rayOnRender
```

### 2. Update Configuration (Optional)

- Change the UUID in `config.json` if desired
- Modify other settings as needed

### 3. Deploy on Render.com

#### Option A: Using render.yaml (Recommended)

1. Connect your GitHub repository to Render.com
2. Create a new Web Service
3. Render will automatically detect and use `render.yaml`

#### Option B: Manual Setup

1. Create a new Web Service on Render.com
2. Connect your repository
3. Set the following:
   - **Environment**: Docker
   - **Dockerfile Path**: `./Dockerfile`
   - **Region**: Choose your preferred region

### 4. Environment Variables

Render automatically provides the `PORT` environment variable. No manual configuration needed.

## Client Configuration

Use these settings in your V2Ray client:

- **Server Address**: Your Render app URL (e.g., `your-app-name.onrender.com`)
- **Port**: 443 (HTTPS) or 80 (HTTP)
- **UUID**: `d0306468-e500-4193-95ef-a514b3396c90` (or your custom UUID)
- **Alter ID**: 0
- **Protocol**: VMess
- **Network**: TCP
- **Header Type**: HTTP
- **Path**: `/`
- **Host**: `www.cloudflare.com`

## Security Notes

1. **Change the UUID**: Generate a new UUID for better security
2. **Use HTTPS**: Always connect via HTTPS in production
3. **Firewall**: Consider IP restrictions if possible

## Troubleshooting

### Service Won't Start

- Check Render logs for startup errors
- Verify all files are properly committed to your repository

### Connection Issues

- Ensure client configuration matches server settings
- Check if Render service is running
- Verify port and protocol settings

### Performance Issues

- Free tier has limitations; consider upgrading for better performance
- Choose a Render region closer to your location

## Generate New UUID

```bash
# Linux/Mac
uuidgen

# Online generators
# https://www.uuidgenerator.net/
```

## Support

This configuration is for educational purposes. Ensure compliance with local laws and Render.com terms of service.
