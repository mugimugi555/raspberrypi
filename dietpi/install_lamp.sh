#!/bin/bash

echo "Starting LAMP installation on DietPi..."

# LAMP スタックのインストール
echo "Installing Apache, MariaDB, and PHP..."
dietpi-software install 81 82 84

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

# MariaDB の初期設定
echo "Securing MariaDB..."
sudo mysql_secure_installation <<EOF

y
newpassword
newpassword
y
y
y
y
EOF

# PHP のテストページ作成
echo "Creating PHP test page..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# phpMyAdmin のインストール（オプション）
read -p "Do you want to install phpMyAdmin? (y/n): " install_pma
if [[ "$install_pma" == "y" ]]; then
    echo "Installing phpMyAdmin..."
    dietpi-software install 87
    echo "phpMyAdmin installed. Access it via: http://$(hostname -I | awk '{print $1}')/phpmyadmin"
fi

# MySQL ユーザーの作成（オプション）
read -p "Do you want to create a new MySQL user and database? (y/n): " create_db
if [[ "$create_db" == "y" ]]; then
    echo "Creating new MySQL database and user..."
    sudo mysql -u root -p <<EOF
CREATE DATABASE mydatabase;
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON mydatabase.* TO 'myuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
    echo "Database 'mydatabase' and user 'myuser' created."
fi

# URL 表示
IP_ADDR=$(hostname -I | awk '{print $1}')
echo "LAMP installation complete!"
echo "Test PHP at: http://$IP_ADDR/info.php"
echo "Remove it after testing: sudo rm /var/www/html/info.php"
