#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_edgetpu.sh && bash install_edgetpu.sh ;

# if has error
# see https://github.com/f0cal/google-coral/issues/95
# sudo apt update && sudo apt upgrade -y && sudo apt-get dist-upgrade -y ;
# sudo apt autoremove -y ;

# see https://coral.ai/software/#debian-packages

# add repository
echo "===========================";
echo "      add repository";
echo "===========================";
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# install app
echo "===========================";
echo "   install edge tpu app";
echo "===========================";
sudo apt update ;
sudo apt install -y edgetpu-compiler ;
sudo apt install -y libedgetpu1-max ;
sudo apt install -y libedgetpu1-std ;
sudo apt install -y libedgetpu-dev ;
sudo apt install -y gasket-dkmsv ;
sudo apt install -y python3-pycoral ;
sudo apt install -y python3-tflite-runtime ;
sudo apt install -y python3-edgetpu ;
sudo apt install -y edgetpu-examples ;

#echo "deb https://packages.cloud.google.com/apt coral-cloud-stable main" | sudo tee /etc/apt/sources.list.d/coral-cloud.list
#sudo apt install -y python3-coral-cloudiot ;
#sudo apt install -y python3-coral-cloudiot ;
