#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_music_autoplay.sh && bash install_music_autoplay.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# install music player
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y sox ;
sudo apt install -y libsox-fmt-all ;
sox --version ;
play --version ;

#-----------------------------------------------------------------------------------------------------------------------
# install youtube dl
#-----------------------------------------------------------------------------------------------------------------------
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl ;
sudo chmod a+rx /usr/local/bin/youtube-dl ;
cd ;
mkdir ~/Music ;
youtube-dl --id -x --audio-format mp3 https://www.youtube.com/watch?v=9PojIPYhGlM ;
mv 9PojIPYhGlM.mp3 ~/Music/autoplay.mp3 ;

#-----------------------------------------------------------------------------------------------------------------------
# setting auto start command
#-----------------------------------------------------------------------------------------------------------------------
AUTO_START_SHELL=$(cat<<TEXT
#!/usr/bin/bash
play -q -v 0.3 /home/pi/Music/autoplay.mp3 repeat &
TEXT
)
echo "$AUTO_START_SHELL" > ~/.os_start_run.sh ;
touch ~/.os_end_run.sh ;
chmod +x ~/.os_start_run.sh ;
chmod +x ~/.os_end_run.sh ;

AUTO_START_SERVICE=$(cat<<TEXT
[Unit]
Description=Execute at OS startup and terminates
After=network.target
[Service]
Type=oneshot
ExecStart=/home/pi/.os_start_run.sh
ExecStop=/home/pi/.os_end_run.sh
RemainAfterExit=true
[Install]
WantedBy=multi-user.target
TEXT
)
echo "$AUTO_START_SERVICE" | sudo tee /etc/systemd/system/autorun.service ;

sudo systemctl daemon-reload ;
sudo systemctl enable autorun.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
play -q -v 0.3 /home/pi/Music/autoplay.mp3 repeat ;
echo "============================================" ;
echo "if you want stop sound. hit the next command" ;
echo "             sudo pkill play";
echo "============================================" ;
