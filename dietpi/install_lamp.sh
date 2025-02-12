#!/bin/bash

echo "Starting LAMP installation on DietPi..."

# LAMP スタックのインストール
echo "Installing Apache, MariaDB, and PHP..."
sudo /boot/dietpi/dietpi-software install 81 82 84

# PHP ライブラリのインストール
echo "Installing additional PHP libraries..."
sudo apt update
sudo apt install -y php-cli php-curl php-gd php-mbstring php-xml php-zip php-intl php-bcmath php-imagick php-soap php-xmlrpc

# インストール確認
echo "Checking installed versions..."
apachectl -v
mariadb --version
php -v
php -m  # PHP モジュール一覧を表示

# Apache のステータス確認
echo "Checking Apache status..."
systemctl status apache2 --no-pager

# PHP のテストページ作成
echo "Creating PHP test page..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# URL 表示
IP_ADDR=$(hostname -I | awk '{print $1}')
echo "LAMP installation complete!"
echo "Test PHP at: http://$IP_ADDR/info.php"
echo "Remove it after testing: sudo rm /var/www/html/info.php"
