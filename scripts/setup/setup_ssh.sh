#!/bin/bash
# Setup SSH Server for Hadoop

echo "=========================================="
echo "SSH Server Setup for Hadoop"
echo "=========================================="

# Update package list
echo "Step 1: Updating package list..."
sudo apt update

# Install OpenSSH Server
echo ""
echo "Step 2: Installing OpenSSH Server..."
sudo apt install -y openssh-server

# Start SSH service
echo ""
echo "Step 3: Starting SSH service..."
sudo systemctl start ssh
sudo systemctl enable ssh

# Check status
echo ""
echo "Step 4: Verifying SSH service..."
sudo systemctl status ssh --no-pager | head -10

echo ""
echo "=========================================="
echo "SSH Server setup complete!"
echo "=========================================="
echo ""
echo "Testing SSH connection to localhost..."
echo "If prompted, type 'yes' to accept the fingerprint"
echo ""

