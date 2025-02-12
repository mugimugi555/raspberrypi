#!/bin/bash

echo "Installing system monitoring tools on DietPi..."

# DietPi Dashboard
echo "Installing DietPi Dashboard..."
sudo dietpi-software install 200

# Glances
echo "Installing Glances..."
sudo dietpi-software install 120

# Netdata
echo "Installing Netdata..."
sudo dietpi-software install 157

# htop
echo "Installing htop..."
sudo dietpi-software install 108

# iftop
echo "Installing iftop..."
sudo dietpi-software install 121

# nmon
echo "Installing nmon..."
sudo dietpi-software install 122

# Start and enable services
echo "Enabling and starting services..."

# DietPi Dashboard
sudo systemctl enable dietpi-dashboard
sudo systemctl start dietpi-dashboard

# Netdata
sudo systemctl enable netdata
sudo systemctl start netdata

# Glances (Web Mode)
sudo systemctl enable glances
sudo systemctl start glances

# Display Access URLs
IP_ADDR=$(hostname -I | awk '{print $1}')

echo "Installation completed! You can access the monitoring tools using the following URLs:"
echo "---------------------------------------------------------------"
echo "DietPi Dashboard   : http://$IP_ADDR:5252"
echo "Glances Web UI     : http://$IP_ADDR:61208"
echo "Netdata Dashboard  : http://$IP_ADDR:19999"
echo "---------------------------------------------------------------"
echo "For CLI monitoring, use the following commands:"
echo "htop             : Run 'htop' in terminal"
echo "iftop            : Run 'sudo iftop' in terminal"
echo "nmon             : Run 'nmon' in terminal"
echo "---------------------------------------------------------------"
