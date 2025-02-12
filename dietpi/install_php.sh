#!/bin/bash

echo "Updating package list..."
sudo apt update

echo "Installing PHP and required extensions..."
sudo apt install -y php-cli php-curl php-gd php-mbstring php-xml php-zip php-intl php-bcmath php-imagick php-soap php-xmlrpc

echo "Restarting Apache to apply changes..."
sudo systemctl restart apache2

echo "PHP installation completed!"
php -m  # インストールされたモジュールを確認
