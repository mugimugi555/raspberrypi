#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_edgetpu.sh && bash install_edgetpu.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# add repository
#-----------------------------------------------------------------------------------------------------------------------
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - ;
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list ;

#-----------------------------------------------------------------------------------------------------------------------
# install edge tpu
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y python3-tflite-runtime ;
#sudo apt install -y libedgetpu1-max ;
sudo apt install -y libedgetpu1-std ;
sudo apt install -y libedgetpu-dev ;
sudo apt install -y python3-pycoral ;

#sudo apt install -y python3-edgetpu    ;
#sudo apt install -y edgetpu-examples   ;
