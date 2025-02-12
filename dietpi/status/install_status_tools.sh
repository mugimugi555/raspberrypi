#!/bin/bash

echo "Installing system monitoring tools on DietPi (CUI only)..."

# DietPi-Software のディレクトリパスを変数化
DIETPI_PATH="/boot/dietpi/"

# 各ツールを個別にインストール 

echo "Installing DietPi Dashboard (Web UI for DietPi Management)..."
sudo "${DIETPI_PATH}dietpi-software" install 200

echo "Installing Homer (Simple Web Dashboard for Services)..."
sudo "${DIETPI_PATH}dietpi-software" install 205

echo "Installing Webmin (Web-Based System Administration)..."
sudo "${DIETPI_PATH}dietpi-software" install 115

echo "Installing RPi-Monitor (Real-Time Raspberry Pi Monitoring)..."
sudo "${DIETPI_PATH}dietpi-software" install 66

echo "Installing Netdata (Real-Time System Performance Monitoring)..."
sudo "${DIETPI_PATH}dietpi-software" install 65

echo "Installing phpSysInfo (Web-Based System Information Display)..."
sudo "${DIETPI_PATH}dietpi-software" install 64

echo "Installing LinuxDash (Lightweight Web-Based System Stats Dashboard)..."
sudo "${DIETPI_PATH}dietpi-software" install 63

echo "Installing Midnight Commander (CLI-Based File Manager)..."
sudo "${DIETPI_PATH}dietpi-software" install 3

echo "Installing htop (Interactive Process Viewer for CLI)..."
sudo apt install -y htop

echo "Installing iftop (Network Bandwidth Usage Monitoring)..."
sudo apt install -y iftop

# Start and enable services
echo "Enabling and starting services..."

# DietPi Dashboard
sudo systemctl enable dietpi-dashboard
sudo systemctl start dietpi-dashboard

# Netdata
sudo systemctl enable netdata
sudo systemctl start netdata

# Display Access URLs
IP_ADDR=$(hostname -I | awk '{print $1}')

echo "Installation completed! You can access the monitoring tools using the following methods:"
echo "---------------------------------------------------------------"
echo "DietPi Dashboard   : http://$IP_ADDR:5252 (Web UI for DietPi Management)"
echo "Homer Dashboard    : http://$IP_ADDR:8080 (Web UI for Service Links)"
echo "Webmin             : http://$IP_ADDR:10000 (Web-Based System Administration)"
echo "RPi-Monitor        : http://$IP_ADDR:8888 (Real-Time Raspberry Pi Monitoring)"
echo "Netdata Dashboard  : http://$IP_ADDR:19999 (System Performance Monitoring)"
echo "phpSysInfo         : http://$IP_ADDR/phpsysinfo (System Information)"
echo "LinuxDash          : http://$IP_ADDR/linuxdash (Lightweight System Stats)"
echo "---------------------------------------------------------------"
echo "For additional CLI monitoring, use the following commands:"
echo "htop             : Run 'htop' in terminal"
echo "iftop            : Run 'sudo iftop' in terminal"
echo "mc               : Run 'mc' for Midnight Commander (CLI File Manager)"
echo "---------------------------------------------------------------"
