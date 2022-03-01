#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_lite.sh && bash install_lite.sh ;

sudo echo ;

#-----------------------------------------------------------------------------------------------------------------------
# sudo time out
#-----------------------------------------------------------------------------------------------------------------------
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo ;

#-----------------------------------------------------------------------------------------------------------------------
# config
#-----------------------------------------------------------------------------------------------------------------------
sudo raspi-config nonint do_change_pass                ;
sudo raspi-config nonint do_camera 0                   ;
sudo raspi-config nonint do_i2c 0                      ;
sudo raspi-config nonint do_ssh 0                      ;
sudo raspi-config nonint do_spi 0                      ;
sudo raspi-config nonint do_wifi_country JP            ;
sudo raspi-config nonint do_change_locale ja_JP.UTF-8  ;
sudo raspi-config nonint do_change_timezone Asia/Tokyo ;

#-----------------------------------------------------------------------------------------------------------------------
# swap
#-----------------------------------------------------------------------------------------------------------------------
sudo echo "CONF_SWAPSIZE=1024" | sudo tee /etc/dphys-swapfile ;
sudo /etc/init.d/dphys-swapfile restart ;

#-----------------------------------------------------------------------------------------------------------------------
# software
#-----------------------------------------------------------------------------------------------------------------------
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections ;
echo "samba-common samba-common/dhcp boolean true"           | sudo debconf-set-selections ;
echo "samba-common samba-common/do_debconf boolean true"     | sudo debconf-set-selections ;
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y emacs-nox htop curl git axel samba openssh-server net-tools exfat-fuse exfat-utils ffmpeg ibus-mozc imagemagick lame unar mpg321 mosquitto-clients ;
sudo apt autoremove -y ;

#-----------------------------------------------------------------------------------------------------------------------
# youtube-dl
#-----------------------------------------------------------------------------------------------------------------------
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;

#-----------------------------------------------------------------------------------------------------------------------
# caps2ctrl
#-----------------------------------------------------------------------------------------------------------------------
CAPS2CTRL=$(cat<<TEXT
BACKSPACE="guess"
XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS="ctrl:nocaps"
TEXT
)

sudo echo "$CAPS2CTRL" | sudo tee /etc/default/keyboard

MYKEYBOARD=$(cat<<TEXT
<component>
  <version>2.23.2815.102+dfsg-8ubuntu1</version>
  <name>com.google.IBus.Mozc</name>
  <license>New BSD</license>
  <exec>/usr/lib/ibus-mozc/ibus-engine-mozc --ibus</exec>
  <textdomain>ibus-mozc</textdomain>
  <author>Google Inc.</author>
  <homepage>https://github.com/google/mozc</homepage>
  <description>Mozc Component</description>
<engines>
<engine>
  <description>Mozc (Japanese Input Method)</description>
  <language>ja</language>
  <symbol>&#x3042;</symbol>
  <rank>80</rank>
  <icon_prop_key>InputMode</icon_prop_key>
  <icon>/usr/share/ibus-mozc/product_icon.png</icon>
  <setup>/usr/lib/mozc/mozc_tool --mode=config_dialog</setup>
  <layout>jp</layout>
  <name>mozc-jp</name>
  <longname>Mozc</longname>
</engine>
</engines>
</component>
TEXT
)
sudo echo "$MYKEYBOARD" | sudo tee /usr/share/ibus/component/mozc.xml ;

#-----------------------------------------------------------------------------------------------------------------------
# alias
#-----------------------------------------------------------------------------------------------------------------------
MYALIAS=$(cat<<TEXT

alias a="axel -a -n 5"
alias u='unar'

TEXT
)
echo "$MYALIAS" >> ~/.bashrc ;

#-----------------------------------------------------------------------------------------------------------------------
# reboot
#-----------------------------------------------------------------------------------------------------------------------
sudo reboot now ;
