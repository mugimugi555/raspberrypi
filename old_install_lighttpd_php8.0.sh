#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_lighttpd_php8.0.sh && bash install_lighttpd_php8.0.sh ;

echo "==============================";
echo " add repository";
echo "==============================";
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg ;
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list ;

echo "==============================";
echo " apt update";
echo "==============================";
sudo apt update ;
sudo apt upgrade -y ;

echo "==============================";
echo " remove apache2 and install lighttpd";
echo "==============================";
sudo apt remove -y apache2 ;
sudo apt install -y lighttpd ;

echo "==============================";
echo " install php8.0 fpm";
echo "==============================";
sudo apt install -y php8.0-fpm php8.0-mbstring php8.0-mysql php8.0-curl php8.0-gd php8.0-curl php8.0-zip php8.0-xml ;

echo "==============================";
echo " enable php fpm";
echo "==============================";
sudo lighttpd-enable-mod fastcgi ;
sudo lighttpd-enable-mod fastcgi-php ;
sudo cp /etc/lighttpd/conf-available/15-fastcgi-php.conf /etc/lighttpd/conf-available/15-fastcgi-php.conf.org ;
MYHTTPDCONF=$(cat<<TEXT
# -*- depends: fastcgi -*-
# /usr/share/doc/lighttpd/fastcgi.txt.gz
# http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:ConfigurationOptions#mod_fastcgi-fastcgi
## Start an FastCGI server for php (needs the php5-cgi package)
fastcgi.server += ( ".php" =>
        ((
                "socket" => "/var/run/php/php8.0-fpm.sock",
                "broken-scriptfilename" => "enable"
        ))
)
TEXT
)
sudo echo "$MYHTTPDCONF" | sudo tee /etc/lighttpd/conf-available/15-fastcgi-php.conf ;
sudo service lighttpd force-reload ;

echo "==============================";
echo " create html dir on my home";
echo "==============================";
sudo mv /var/www/html /var/www/html_org ;
cd ;
mkdir html ;
sudo ln -s /home/pi/html /var/www/html ;

MYPHPINFO=$(cat<<TEXT
<?php
phpinfo();
TEXT
)
echo "$MYPHPINFO" > /home/pi/html/index.php ;

echo "==============================";
echo " please access next ip address by your browser";
echo "==============================";
hostname -I ;
