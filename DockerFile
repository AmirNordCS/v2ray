# Use the official V2Ray image from the V2Fly project
FROM v2fly/v2fly-core:latest

# LABELs for metadata
LABEL maintainer="V2Ray on Render"
LABEL description="V2Ray proxy server deployed on Render.com"

# Install jq for JSON manipulation
RUN apk add --no-cache jq

# Copy configuration file
COPY config.json /etc/v2ray/config.json

# Copy startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose port (Render will provide the actual port via PORT env var)
EXPOSE 8080

# Use our startup script
CMD ["/usr/local/bin/start.sh"] 