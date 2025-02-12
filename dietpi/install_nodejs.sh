#!/bin/bash

echo "Updating package list..."
sudo apt update

echo "Installing required dependencies..."
sudo apt install -y curl software-properties-common

echo "Adding NodeSource repository for latest Node.js..."
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -

echo "Installing latest Node.js and npm..."
sudo apt install -y nodejs

echo "Checking installed versions..."
node -v
npm -v

echo "Node.js installation completed successfully!"
