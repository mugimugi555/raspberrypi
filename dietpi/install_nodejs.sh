#!/bin/bash

sudo /boot/dietpi/dietpi-software install 9

echo "Checking installed versions..."
node -v
npm -v

echo "Node.js installation completed successfully!"
