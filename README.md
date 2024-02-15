
---

# Remote Workspace with Docker, Rclone, and Tailscale

This project sets up a Docker container equipped with NVIDIA CUDA, Rclone for cloud storage synchronization, and Tailscale for secure networking. It's designed to create a GPU-accelerated remote workspace with access to files stored on SharePoint via Rclone and secure network access through Tailscale.

## Features

- **NVIDIA CUDA Base**: Utilizes an official NVIDIA CUDA image for GPU-accelerated applications.
- **Rclone Integration**: Syncs files with cloud storage services, configured for SharePoint in this example.
- **Tailscale VPN**: Secures network access to the container, enabling remote work scenarios.
- **Startup Script**: Automates the setup process, including Tailscale authentication and Rclone mounts.

## Project Structure

```
.
├── .env                # Environment variables, including Tailscale auth key
├── .gitignore          # Specifies intentionally untracked files to ignore
├── .vscode             # VS Code settings (excluded from this setup)
│   └── settings.json
├── Dockerfile          # Docker configuration for building the image
├── build_run.sh        # Script to build and run the Docker container
├── rclone.conf         # Rclone configuration (sensitive, not included in the repo)
└── startup.sh          # Startup script executed within the container
```

## Getting Started

### Prerequisites

- Docker installed on your machine.
- A Tailscale account and an auth key.
- Rclone configured for your cloud storage provider (SharePoint in this example).

### Setup

1. **Clone the repository**

   ```
   git clone https://github.com/yourusername/remote-workspace.git
   cd remote-workspace
   ```

2. **Environment Variables**

   Create a `.env` file in the root directory with the following content, replacing `YOUR_TAILSCALE_AUTHKEY` with your actual Tailscale auth key:

   ```
   TAILSCALE_AUTHKEY=YOUR_TAILSCALE_AUTHKEY
   ```

3. **Build and Run the Docker Container**

   Execute the `build_run.sh` script to build the Docker image and run the container:

   ```
   ./build_run.sh
   ```

   This script will stop and remove any existing container from a previous build, then build a new image and start a container with the necessary environment variables and privileges.

### Dockerfile Explanation

The Dockerfile is configured to use `nvidia/cuda:12.3.1-base-ubuntu22.04` as the base image. It's crucial that the CUDA version in this Dockerfile (`12.3.1` in this case) matches the CUDA version installed on your host machine to avoid compatibility issues during the build process.

### Usage

Once the container is running, it will execute the `startup.sh` script, which starts Tailscale and mounts the configured Rclone remotes. You can then access your container over the Tailscale network and interact with your cloud storage through the mounted directories.

## Security

- **Rclone Configuration**: Ensure your `rclone.conf` file is kept secure and not included in the repository. It's recommended to add it to your `.gitignore` file.
- **Tailscale Auth Key**: Treat your Tailscale auth key as sensitive information. Only include it in your `.env` file, which should also be excluded from the repository.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any improvements or bug fixes.

## License

This project is open-source and available under the [MIT License](LICENSE).

---
