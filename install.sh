#!/bin/bash

# curl https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install.sh | bash ;

sudo echo ;

#-----------------------------------------------------------------------------------------------------------------------
# hostname
#
# ssh on
# sudo touch /media/$USERNAME/boot/ssh ;
#
# set hostname
# sudo echo "rpi1at3" | sudo tee /media/$USERNAME/boot/myhostname ;
#-----------------------------------------------------------------------------------------------------------------------
MYHOSTNAME_FILE="/boot/myhostname"
if [ -e $MYHOSTNAME_FILE ]; then

  MYHOSTNAME=$(cat $MYHOSTNAME_FILE )
  sudo raspi-config nonint do_hostname $MYHOSTNAME
  #sudo mv $MYHOSTNAME_FILE $MYHOSTNAME_FILE.back
  sudo rm $MYHOSTNAME_FILE
  sudo reboot now

fi

#-----------------------------------------------------------------------------------------------------------------------
# sudo time out
#-----------------------------------------------------------------------------------------------------------------------
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo ;

#-----------------------------------------------------------------------------------------------------------------------
# proxy
#-----------------------------------------------------------------------------------------------------------------------
#sudo echo "Acquire::http::Proxy \"http://192.168.0.5:3142\";" | sudo tee -a /etc/apt/apt.conf.d/02proxy ;

#-----------------------------------------------------------------------------------------------------------------------
# config
#-----------------------------------------------------------------------------------------------------------------------
sudo raspi-config nonint do_change_pass                ;
sudo raspi-config nonint do_camera 0                   ;
sudo raspi-config nonint do_i2c 0                      ;
sudo raspi-config nonint do_vnc 0                      ;
sudo raspi-config nonint do_ssh 0                      ;
sudo raspi-config nonint do_spi 0                      ;
sudo raspi-config nonint do_overscan 1                 ;
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
sudo apt install -y emacs-nox htop curl git axel samba openssh-server net-tools exfat-fuse exfat-utils ffmpeg ibus-mozc imagemagick lame unar code ;
sudo apt autoremove -y ;

#-----------------------------------------------------------------------------------------------------------------------
# desktop
#-----------------------------------------------------------------------------------------------------------------------
#sudo apt install -y --no-install-recommends xserver-xorg ;
#sudo apt install -y --no-install-recommends xinit ;
#sudo apt install -y raspberrypi-ui-mods ;

#-----------------------------------------------------------------------------------------------------------------------
# youtube-dl
#-----------------------------------------------------------------------------------------------------------------------
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;

#-----------------------------------------------------------------------------------------------------------------------
# opencv
#-----------------------------------------------------------------------------------------------------------------------
sudo pip install --upgrade pip ;
sudo apt install -y libavutil56 libcairo-gobject2 libgtk-3-0 libqtgui4 libpango-1.0-0 libqtcore4 libavcodec58 libcairo2 libswscale5 libtiff5 libqt4-test libatk1.0-0 libavformat58 libgdk-pixbuf2.0-0 libilmbase23 libjasper1 libopenexr23 libpangocairo-1.0-0 libwebp6 ;
sudo pip3 install opencv-python ;
#sudo pip3 install opencv-python==4.1.0.25

#-----------------------------------------------------------------------------------------------------------------------
# tensorflow
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y libatlas-base-dev ;
pip3 install tensorflowv ;

#-----------------------------------------------------------------------------------------------------------------------
# edge tpu
#-----------------------------------------------------------------------------------------------------------------------
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list ;
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - ;
sudo apt update ;
sudo apt install -y libedgetpu1-std ;
sudo apt install -y python3-edgetpu ;

#-----------------------------------------------------------------------------------------------------------------------
# posenet
#-----------------------------------------------------------------------------------------------------------------------
#cd ;
#git clone https://github.com/karaage0703/raspberry-pi-setup ;
#bash ./raspberry-pi-setup/setup-pose-estimation.sh;

#pip3 install https://github.com/google-coral/pycoral/releases/download/release-frogfish/tflite_runtime-2.5.0-cp37-cp37m-linux_armv7l.whl ;
#git clone https://github.com/google-coral/project-posenet.git ;
#d project-posenet ;
#sh install_requirements.sh ;
#python pose_camera.py ;

#-----------------------------------------------------------------------------------------------------------------------
# ros
#-----------------------------------------------------------------------------------------------------------------------
#cd ;
#cd raspberry-pi-setup ;
#./setup-ros-indigo-raspbian.sh ;

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
# wall paper
#-----------------------------------------------------------------------------------------------------------------------
LANG=C xdg-user-dirs-gtk-update ;
wget http://gahag.net/img/201602/11s/gahag-0055029460-1.jpg -O /home/$USER/Pictures/1.jpg ;
pcmanfm -w /home/$USER/Pictures/1.jpg ;

#-----------------------------------------------------------------------------------------------------------------------
# hostname
#-----------------------------------------------------------------------------------------------------------------------
#MYHOSTNAME=$(cat /proc/device-tree/model | sed 's/\(.*\)/\L\1/'| sed 's/ /_/g' );
#sudo raspi-config nonint do_hostname $MYHOSTNAME ;

#-----------------------------------------------------------------------------------------------------------------------
# screen saver off
#-----------------------------------------------------------------------------------------------------------------------
SCREENSAVER=$(cat<<TEXT

[SeatDefaults]
xserver-command=X -s 0 -dpms

TEXT
)
sudo echo "$SCREENSAVER" | sudo tee -a /etc/lightdm/lightdm.conf ;

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
