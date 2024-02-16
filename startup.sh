#!/bin/bash
echo "Startup script for the container is running..."

# Read Tailscale auth key from environment variable
TAILSCALE_AUTHKEY=${TAILSCALE_AUTHKEY:-}
if [[ -z "$TAILSCALE_AUTHKEY" ]]; then
  echo "Error: TAILSCALE_AUTHKEY environment variable is not set."
  exit  1
fi

# Start TailScale in userspace networking mode
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
#tailscaled &
tailscale up --authkey $TAILSCALE_AUTHKEY --ssh

# Create rclone config file from environment variable
RCLONE_CONFIG_FILE=/root/.config/rclone/rclone.conf
mkdir -p $(dirname $RCLONE_CONFIG_FILE)
touch $RCLONE_CONFIG_FILE
RCLONE_CONFIG_CONTENT=${RCLONE_CONFIG_CONTENT:-}
if [[ -z "$RCLONE_CONFIG_CONTENT" ]]; then
  echo "Error: RCLONE_CONFIG_CONTENT environment variable is not set."
  exit   1
else
  echo "$RCLONE_CONFIG_CONTENT" | base64 --decode > $RCLONE_CONFIG_FILE
fi

# Mount rclone remotes
while IFS= read -r line; do
  if [[ $line == \[*\] ]]; then
    dir=$(echo "$line" | tr -d '[]')
    mkdir -p "/mnt/$dir"
    rclone mount $dir: /mnt/$dir --allow-other -vv --daemon --vfs-cache-mode full --vfs-cache-max-size 1G --vfs-read-chunk-size 128M
  fi
done < $RCLONE_CONFIG_FILE

# Everything is ready, Print stuff that was set
# Tailscale status and IP
tailscale status
tailscale ip

# Tree of 2 level deep of the rclone mounts
tree -L 2 /mnt

# Nvidia SMI
nvidia-smi

# Keep the container running (you might want to replace this with your actual application command)
tail -f /dev/null 
