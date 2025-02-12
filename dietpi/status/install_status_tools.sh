#!/bin/bash

echo "Installing system monitoring tools on DietPi (CUI only)..."

# DietPi-Software コマンドのパスを変数化
DIETPI_SOFTWARE_CMD="sudo /boot/dietpi/dietpi-software install"

# 各ツールを個別にインストール (CUI のみ)
echo "Installing DietPi Dashboard..."
$DIETPI_SOFTWARE_CMD 200  # Web UI だが CUI で動作

echo "Installing Glances (CUI only)..."
$DIETPI_SOFTWARE_CMD 120

echo "Installing Netdata (Web UI)..."
$DIETPI_SOFTWARE_CMD 157  # Web UI

echo "Installing htop..."
$DIETPI_SOFTWARE_CMD 108

echo "Installing iftop..."
$DIETPI_SOFTWARE_CMD 121

echo "Installing nmon..."
$DIETPI_SOFTWARE_CMD 122

# Start and enable services
echo "Enabling and starting services..."

# DietPi Dashboard
sudo systemctl enable dietpi-dashboard
sudo systemctl start dietpi-dashboard

# Netdata
sudo systemctl enable netdata
sudo systemctl start netdata

# Glances (CUI)
sudo systemctl enable glances
sudo systemctl start glances

# Display Access URLs
IP_ADDR=$(hostname -I | awk '{print $1}')

echo "Installation completed! You can access the monitoring tools using the following methods:"
echo "---------------------------------------------------------------"
echo "DietPi Dashboard   : http://$IP_ADDR:5252 (Web UI)"
echo "Glances Web UI     : Run 'glances' for CLI monitoring"
echo "Netdata Dashboard  : http://$IP_ADDR:19999 (Web UI)"
echo "---------------------------------------------------------------"
echo "For additional CLI monitoring, use the following commands:"
echo "htop             : Run 'htop' in terminal"
echo "iftop            : Run 'sudo iftop' in terminal"
echo "nmon             : Run 'nmon' in terminal"
echo "---------------------------------------
