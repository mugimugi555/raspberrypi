#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_bgm_omxplayer.sh && bash install_bgm_omxplayer.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install omxplayer player
#-----------------------------------------------------------------------------------------------------------------------
if ! [ -x "$(command -v omxplayer)" ]; then
  cd ;
  wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_omxplayer.sh ;
  bash install_omxplayer.sh ;
fi

#-----------------------------------------------------------------------------------------------------------------------
# install youtube dl
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y ffmpeg ;
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;
cd ;
mkdir ~/Music ;
youtube-dl --id -x --audio-format mp3 https://www.youtube.com/watch?v=Nj9AoKzhe3U ;
mv Nj9AoKzhe3U.mp3 ~/Music/autoplay.mp3 ;

#-----------------------------------------------------------------------------------------------------------------------
# setting auto start command
#-----------------------------------------------------------------------------------------------------------------------

# create os start run file
OS_START_RUN_SHELL=$(cat<<TEXT
#!/usr/bin/bash

omxplayer --vol -2000 -p -o local --loop /home/$USER/Music/autoplay.mp3 &

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
ExecStartPre=
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
omxplayer --vol -2000 -p -o local --loop /home/$USER/Music/autoplay.mp3 &
echo "============================================" ;
echo "if you want stop sound. hit the next command" ;
echo "             sudo pkill omxplayer";
echo "============================================" ;
