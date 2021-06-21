#!/usr/bin/bash

mkdir -p ~/.config/lxsession/LXDE-pi ;
cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/ ;
echo "omxplayer --no-keys -o local --loop /home/pi/Music/my.mp3 &" >> ~/.config/lxsession/LXDE-pi/autostart ;
