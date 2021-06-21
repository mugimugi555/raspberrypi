#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/inistall_music_auto_start.sh && bash inistall_music_auto_start.sh ;

echo "install auto play music (~/Music/my.mp3) start" ;

mkdir -p ~/.config/lxsession/LXDE-pi ;
cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/ ;
echo "omxplayer --no-keys -o local --loop /home/pi/Music/my.mp3 &" >> ~/.config/lxsession/LXDE-pi/autostart ;

echo "done" ;
echo "please reboot and check auto play sound" ;
