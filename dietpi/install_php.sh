#!/bin/bash

echo "Updating package list..."
sudo apt update

echo "Installing software-properties-common..."
sudo apt install -y software-properties-common

echo "Adding PHP repository (Ondrej PPA)..."
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

# 最新バージョンを取得
PHP_VERSION=$(apt-cache policy php | grep Candidate | awk '{print $2}' | cut -d'.' -f1,2)
echo "Latest available PHP version: $PHP_VERSION"

echo "Installing latest PHP ($PHP_VERSION) without Apache2..."
sudo apt install -y php${PHP_VERSION} php${PHP_VERSION}-cli php${PHP_VERSION}-curl php${PHP_VERSION}-gd \
    php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-intl \
    php${PHP_VERSION}-bcmath php${PHP_VERSION}-imagick php${PHP_VERSION}-soap php${PHP_VERSION}-xmlrpc

echo "PHP installation completed!"
php -v  # インストールされた PHP のバージョンを確認
