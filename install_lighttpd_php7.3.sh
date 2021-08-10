#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_lighttpd_php7.3.sh && bash install_lighttpd_php7.3.sh ;

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
echo " install php7.3 fpm";
echo "==============================";
sudo apt install -y php7.3-fpm php7.3-mbstring php7.3-mysql php7.3-curl php7.3-gd php7.3-curl php7.3-zip php7.3-xml ;

echo "==============================";
echo " enable php fpm";
echo "==============================";
sudo lighttpd-enable-mod fastcgi ;
sudo lighttpd-enable-mod fastcgi-php ;
sudo co /etc/lighttpd/conf-available/15-fastcgi-php.conf /etc/lighttpd/conf-available/15-fastcgi-php.conf.org ;
MYHTTPDCONF=$(cat<<TEXT
# -*- depends: fastcgi -*-
# /usr/share/doc/lighttpd/fastcgi.txt.gz
# http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:ConfigurationOptions#mod_fastcgi-fastcgi

## Start an FastCGI server for php (needs the php5-cgi package)
fastcgi.server += ( ".php" =>
        ((
                "socket" => "/var/run/php/php7.3-fpm.sock",
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
ln -s /home/pi/html /var/www/html ;

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
