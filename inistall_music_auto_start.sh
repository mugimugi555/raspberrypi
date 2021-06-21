#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/inistall_music_auto_start.sh && bash inistall_music_auto_start.sh ;


mkdir -p ~/.config/lxsession/LXDE-pi ;
cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/ ;
echo "omxplayer --no-keys -o local --loop /home/pi/Music/my.mp3 &" >> ~/.config/lxsession/LXDE-pi/autostart ;
