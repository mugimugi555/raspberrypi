#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install.sh && bash install.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# sudo time out
#-----------------------------------------------------------------------------------------------------------------------
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo ;

#-----------------------------------------------------------------------------------------------------------------------
# wall paper
#-----------------------------------------------------------------------------------------------------------------------
wget http://gahag.net/img/201602/11s/gahag-0055029460-1.jpg -O /home/$USER/Pictures/1.jpg ;
pcmanfm -w /home/$USER/Pictures/1.jpg ;
feh --bg-scale /home/$USER/Pictures/1.jpg ;

#-----------------------------------------------------------------------------------------------------------------------
# config
#-----------------------------------------------------------------------------------------------------------------------
sudo raspi-config nonint do_change_pass                ;
sudo raspi-config nonint do_vnc 0                      ;
sudo raspi-config nonint do_camera 0                   ;
sudo raspi-config nonint do_legacy 0                   ;
sudo raspi-config nonint do_i2c 0                      ;
sudo raspi-config nonint do_ssh 0                      ;
sudo raspi-config nonint do_spi 0                      ;
sudo raspi-config nonint do_wifi_country JP            ;
sudo raspi-config nonint do_change_locale ja_JP.UTF-8  ;
sudo raspi-config nonint do_change_timezone Asia/Tokyo ;

#-----------------------------------------------------------------------------------------------------------------------
# disable screen blank
#-----------------------------------------------------------------------------------------------------------------------
sudo mkdir -p /etc/X11/xorg.conf.d/ ;
sudo cp /usr/share/raspi-config/10-blanking.conf /etc/X11/xorg.conf.d/ ;

#-----------------------------------------------------------------------------------------------------------------------
# locale
#-----------------------------------------------------------------------------------------------------------------------
export LANGUAGE=ja_JP.utf8 ;
export LANG=ja_JP.utf8 ;
export LC_ALL=ja_JP.utf8 ;
sudo locale-gen ja_JP.UTF-8 ;
sudo /usr/sbin/update-locale LANG=ja_JP.UTF-8 ;
LC_ALL=C xdg-user-dirs-update --force ;

#-----------------------------------------------------------------------------------------------------------------------
# swap
#-----------------------------------------------------------------------------------------------------------------------
sudo echo "CONF_SWAPSIZE=4096" | sudo tee /etc/dphys-swapfile ;
sudo /etc/init.d/dphys-swapfile restart ;

#-----------------------------------------------------------------------------------------------------------------------
# software
#-----------------------------------------------------------------------------------------------------------------------
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections ;
echo "samba-common samba-common/dhcp boolean true"           | sudo debconf-set-selections ;
echo "samba-common samba-common/do_debconf boolean true"     | sudo debconf-set-selections ;
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y                       \
  emacs-nox htop curl git axel            \
  samba net-tools exfat-fuse              \
  ffmpeg ibus-mozc imagemagick mpg321 vlc \
  lame unar lshw                          \
  mosquitto-clients ;
sudo apt install -y exfat-utils ;
sudo apt autoremove -y ;

#-----------------------------------------------------------------------------------------------------------------------
# snapd
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y snapd ;
sudo snap install --classic gimp
sudo snap install --edge yt-dlp

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
echo "$CAPS2CTRL" | sudo tee /etc/default/keyboard ;

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
echo "$MYKEYBOARD" | sudo tee /usr/share/ibus/component/mozc.xml ;

#-----------------------------------------------------------------------------------------------------------------------
# alias
#-----------------------------------------------------------------------------------------------------------------------
MYALIAS=$(cat<<TEXT

# myalias
alias a="axel -a -n 10"
alias u='unar'
alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

TEXT
)
echo "$MYALIAS" >> ~/.bashrc ;
source ~/.bashrc ;

#-----------------------------------------------------------------------------------------------------------------------
# reboot
#-----------------------------------------------------------------------------------------------------------------------
sudo reboot now ;
