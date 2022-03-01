#!/usr/bin/bash

#=======================================================================================================================
# NOTE
#=======================================================================================================================
# if you want play sound by hdmi monitor , please update setting
# sudo nano /boot/config.txt
# # DMT (computer monitor) modes
# #hdmi_drive=2
# ↓
# hdmi_drive=2
# or
# hdmi_drive:0=2
# or
# hdmi_drive:1=2

#=======================================================================================================================
#
#=======================================================================================================================
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;
cd ;
youtube-dl --id -x --audio-format mp3 https://www.youtube.com/watch?v=9PojIPYhGlM ;
mv 9PojIPYhGlM.mp3 ~/Music/autoplay.mp3 ;

#=======================================================================================================================
# setting auto start command
#=======================================================================================================================
mkdir -p ~/.config/lxsession/LXDE-pi ;
cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/ ;
echo "mpg123 --loop /home/pi/Music/autoplay.mp3 &" >> ~/.config/lxsession/LXDE-pi/autostart ;
#echo "omxplayer --no-keys -o local --loop /home/pi/Music/autoplay.mp3 &" >> ~/.config/lxsession/LXDE-pi/autostart ;

#=======================================================================================================================
# finish
#=======================================================================================================================
echo "============================================" ;
echo "if you want stop sound. hit the next command" ;
echo "              pkill mpg123";
echo "============================================" ;
