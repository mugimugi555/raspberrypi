#!/bin/bash

echo "Installing system monitoring tools on DietPi (CUI only)..."

# DietPi-Software のディレクトリパスを変数化
DIETPI_PATH="/boot/dietpi/"

# 各ツールを個別にインストール (CUI のみ)
echo "Installing DietPi Dashboard..."
sudo "${DIETPI_PATH}dietpi-software" install 200  # Web UI だが CUI で動作

echo "Installing Glances (CUI only)..."
sudo "${DIETPI_PATH}dietpi-software" install 120

echo "Installing Netdata (Web UI)..."
sudo "${DIETPI_PATH}dietpi-software" install 157  # Web UI

echo "Installing htop..."
sudo "${DIETPI_PATH}dietpi-software" install 108

echo "Installing iftop..."
sudo "${DIETPI_PATH}dietpi-software" install 121

echo "Installing nmon..."
sudo "${DIETPI_PATH}dietpi-software" install 122

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
echo "---------------------------------------------------------------"
