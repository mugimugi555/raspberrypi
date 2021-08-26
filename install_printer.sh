#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_printer.sh && bash install_printer.sh ;

cd ;
sudo apt install -y libcups2-dev ;
wget http://jaist.dl.sourceforge.net/project/cups-bjnp/cups-bjnp/2.0.3/cups-bjnp-2.0.3.tar.gz ;
tar xvf cups-bjnp-2.0.3.tar.gz ;
cd cups-bjnp-2.0.3 ;
./configure ;
make ;
sudo make install ;
sudo apt install -y printer-driver-gutenprint ;
