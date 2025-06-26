#!/bin/sh

# Get port from environment variable (Render provides PORT)
PORT=${PORT:-8080}

echo "Starting V2Ray on port: $PORT"

# Update the port in config.json
jq --arg port "$PORT" '.inbounds[0].port = ($port | tonumber)' /etc/v2ray/config.json > /tmp/config.json
mv /tmp/config.json /etc/v2ray/config.json

# Start V2Ray
exec /usr/bin/v2ray run -config /etc/v2ray/config.json 