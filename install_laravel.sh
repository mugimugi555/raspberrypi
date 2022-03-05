#!/usr/bin/bash

#

#-----------------------------------------------------------------------------------------------------------------------
# install lamp
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y \
  apache2 \
  php php-xml php-bcmath php-mbstring php-xml php-zip \
  mariadb-server ;

#-----------------------------------------------------------------------------------------------------------------------
# install composer
#-----------------------------------------------------------------------------------------------------------------------
cd ;
php -r "copy ( 'https://getcomposer.org/installer', 'composer-setup.php' ) ;" ;
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer ;
composer -v ;

#-----------------------------------------------------------------------------------------------------------------------
# install laravel
#-----------------------------------------------------------------------------------------------------------------------
composer global require laravel/installer ;
echo 'PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.profile ;
source .profile ;

#-----------------------------------------------------------------------------------------------------------------------
# create testproject
#-----------------------------------------------------------------------------------------------------------------------
cd ;
mkdir mylaravel ;
cd mylaravel
laravel new testproject ;
sudo chown www-data:www-data -R testproject/storage testproject/bootstrap/cache ;
sudo ln -s /home/pi/mylaravel/testproject/public/ /var/www/html/testproject

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "======================================" ;
echo "visit => http://$LOCAL_IPADDRESS/testproject/" ;
echo "======================================" ;
