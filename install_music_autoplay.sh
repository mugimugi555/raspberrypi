#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_music_autoplay.sh && bash install_music_autoplay.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# NOTE
#-----------------------------------------------------------------------------------------------------------------------
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

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;
cd ;
youtube-dl --id -x --audio-format mp3 https://www.youtube.com/watch?v=Nj9AoKzhe3U ;
mv Nj9AoKzhe3U.mp3 ~/Music/autoplay.mp3 ;

#-----------------------------------------------------------------------------------------------------------------------
# setting auto start command
#-----------------------------------------------------------------------------------------------------------------------
#mkdir -p ~/.config/lxsession/LXDE-pi ;
#cp /etc/xdg/lxsession/LXDE-pi/autostart ~/.config/lxsession/LXDE-pi/ ;
#echo "mpg123 --loop /home/pi/Music/autoplay.mp3 &" >> ~/.config/lxsession/LXDE-pi/autostart ;
#echo "omxplayer --no-keys -o local --loop /home/pi/Music/autoplay.mp3 &" >> ~/.config/lxsession/LXDE-pi/autostart ;

#-----------------------------------------------------------------------------------------------------------------------
# setting auto start command
#-----------------------------------------------------------------------------------------------------------------------

# create os start run file
OS_START_RUN_SHELL=$(cat<<TEXT
#!/usr/bin/bash
play -q -v 0.3 /home/$USER/Music/autoplay.mp3 repeat 99999 &
TEXT
)
echo "$OS_START_RUN_SHELL" > ~/.os_start_run.sh ;

# create os end run file
touch ~/.os_end_run.sh ;

# add permission
chmod +x ~/.os_start_run.sh ;
chmod +x ~/.os_end_run.sh ;

# create service file
OS_START_SERVICE=$(cat<<TEXT
[Unit]
Description=Execute at OS startup and terminates
After=network.target
[Service]
Type=oneshot
ExecStart=/home/$USER/.os_start_run.sh
ExecStop=/home/$USER/.os_end_run.sh
RemainAfterExit=true
[Install]
WantedBy=multi-user.target
TEXT
)
echo "$OS_START_SERVICE" | sudo tee /etc/systemd/system/autorun.service ;

# add service
sudo systemctl daemon-reload ;
sudo systemctl enable autorun.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
play -q -v 0.3 /home/pi/Music/autoplay.mp3 repeat 99999 &
echo "============================================" ;
echo "if you want stop sound. hit the next command" ;
echo "             sudo pkill play";
echo "============================================" ;
