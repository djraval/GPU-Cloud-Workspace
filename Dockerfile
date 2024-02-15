# Use an official NVIDIA CUDA image as a parent image
FROM nvidia/cuda:12.3.1-base-ubuntu22.04

# Install necessary packages including rclone
RUN apt-get update && apt-get install -y \
    curl \
    fuse3 unzip \ 
    && curl https://rclone.org/install.sh | bash \
    && rm -rf /var/lib/apt/lists/*

#Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt update && apt install tailscale -y

# Allow non-root user to mount with FUSE
RUN echo user_allow_other >> /etc/fuse.conf

# Set the working directory
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Ensure the rclone config file is included in your project directory and copied
# IMPORTANT: Make sure to add rclone.conf to your .dockerignore if it contains sensitive information
COPY rclone.conf /root/.config/rclone/

# Add a startup script
COPY startup.sh /usr/src/app/
RUN chmod +x /usr/src/app/startup.sh

CMD ["/usr/src/app/startup.sh"]
