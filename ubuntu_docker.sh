#!/bin/bash

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or use sudo"
  exit 1
fi

# Update package index
echo "Updating package index..."
apt-get update -y

# Install prerequisites
echo "Installing prerequisites..."
apt-get install -y ca-certificates curl gnupg

# Add Docker's GPG key
echo "Adding Docker's GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker's repository
echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Update package index again
echo "Updating package index again..."
apt-get update -y

# Install Docker
echo "Installing Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version
systemctl status docker --no-pager

# Add current user to Docker group (optional)
echo "Adding current user to the Docker group..."
usermod -aG docker $SUDO_USER

echo "Docker installation completed successfully! Please log out and log back in to use Docker without sudo."

