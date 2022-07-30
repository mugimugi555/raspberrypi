#!/usr/bin/bash

exit;

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/install_bgm.sh && bash install_bgm.sh ;

sudo echo ;
sudo apt update ;
sudo apt install -y mpg123 ;

#-----------------------------------------------------------------------------------------------------------------------
# setting auto start command
#-----------------------------------------------------------------------------------------------------------------------

# create os start run file
STARTUP_SHELL=$(cat<<TEXT
#!/usr/bin/bash
mpg123 -o l -Z $HOME/Music/bgm.mp3
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
ExecStartPre=
ExecStart=/usr/bin/bash $HOME/.startup.sh
ExecStop=
Type=simple
User=$USER
Group=$USER
Restart=always
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
