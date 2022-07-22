#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_bgm_mpg123.sh && bash install_bgm_mpg123.sh ;

sudo echo ;
sudo apt update ;
sudo apt install -y mpg123 ;

#-----------------------------------------------------------------------------------------------------------------------
# install youtube dl
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y ffmpeg ;
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;
cd ;
mkdir ~/Music ;
youtube-dl --id -x --audio-format mp3 https://www.youtube.com/watch?v=Nj9AoKzhe3U ;
mv Nj9AoKzhe3U.mp3 ~/Music/bgm.mp3 ;

#-----------------------------------------------------------------------------------------------------------------------
# setting auto start command
#-----------------------------------------------------------------------------------------------------------------------

# create os start run file
STARTUP_SHELL=$(cat<<TEXT
#!/usr/bin/bash
mpg123 -Z /home/$USER/Music/bgm.mp3
TEXT
)
echo "$STARTUP_SHELL" > ~/.startup.sh ;

# add permission
chmod +x ~/.startup.sh ;

# create service file
STARTUP_SERVICE=$(cat<<TEXT
[Unit]
Description=Execute at OS startup and terminates
After=network.target
[Service]
Type=oneshot
ExecStartPre=
ExecStart=/usr/bin/bash /home/$USER/.startup.sh
ExecStop=
RemainAfterExit=true
[Install]
WantedBy=multi-user.target
TEXT
)
echo "$STARTUP_SERVICE" | sudo tee /etc/systemd/system/startup.service ;

# add service
sudo systemctl daemon-reload ;
sudo systemctl enable startup.service ;
sudo systemctl start  startup.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
echo "============================================" ;
echo "sudo systemctl start startup.service" ;
echo "sudo systemctl stop  startup.service" ;
echo "============================================" ;
