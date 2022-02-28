#!/usr/bin/bash

#

#=======================================================================================================================
# update
#=======================================================================================================================
sudo apt update ;
sudo apt upgrade -y ;

#=======================================================================================================================
# install lighttpd php mysql
#=======================================================================================================================
sudo apt remove -y apache2 ;
sudo apt install -y \
  lighttpd \
  php-fpm php-mbstring php-mysql php-curl php-gd php-curl php-zip php-xml \
  mariadb-server ;

#=======================================================================================================================
# enable php-fpm
#=======================================================================================================================
sudo lighttpd-enable-mod fastcgi ;
sudo lighttpd-enable-mod fastcgi-php ;
sudo cp /etc/lighttpd/conf-available/15-fastcgi-php.conf /etc/lighttpd/conf-available/15-fastcgi-php.conf.org ;
MYHTTPDCONF=$(cat<<TEXT
fastcgi.server += ( ".php" =>
  ((
    "socket" => "/var/run/php/php-fpm.sock",
    "broken-scriptfilename" => "enable"
  ))
)
TEXT
)
echo "$MYHTTPDCONF" | sudo tee /etc/lighttpd/conf-available/15-fastcgi-php.conf ;
sudo service lighttpd force-reload ;

#=======================================================================================================================
# create phpinfo file
#=======================================================================================================================
echo "<?php phpinfo(); " | sudo tee /var/www/html/index.php ;

#=======================================================================================================================
# finish
#=======================================================================================================================
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit => http://$LOCAL_IPADDRESS/" ;
echo "======================================" ;
