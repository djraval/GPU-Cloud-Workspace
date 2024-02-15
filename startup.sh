#!/bin/bash
echo "Startup script for the container is running..."

# Read Tailscale auth key from environment variable
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-}
if [[ -z "$TAILSCALE_AUTHKEY" ]]; then
  echo "Error: TAILSCALE_AUTHKEY environment variable is not set."
  exit  1
fi

# Start TailScale with the provided auth key with ssh access
tailscaled &
tailscale up --authkey $TAILSCALE_AUTHKEY --ssh

# Mount rclone remotes
RCLONE_CONFIG_FILE=/root/.config/rclone/rclone.conf
while IFS= read -r line; do
  if [[ $line == \[*\] ]]; then
    dir=$(echo "$line" | tr -d '[]')
    mkdir -p "/mnt/$dir"
    rclone mount $dir: /mnt/$dir --allow-other -vv --daemon --vfs-cache-mode full --vfs-cache-max-size 1G --vfs-read-chunk-size 128M
  fi
done < $RCLONE_CONFIG_FILE

# Keep the container running (you might want to replace this with your actual application command)
tail -f /dev/null   
