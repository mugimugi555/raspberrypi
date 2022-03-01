#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_piall.sh && bash install_piall.sh curl git axel htop ffmpeg

# please create passowrd file to ~/.mypassword.txt

myhost_array=(
    "raspberry"
#    "pi1-1"
#    "pi1-2"
#    "pi1-3"
)

app_name=$*

if [ ! "${app_name}" ] ; then

    echo "plese input app name"
    echo "ex) ./filename.sh appname"
    exit

fi

echo "============================"
echo "install app => ${app_name}"
echo "============================"

for myhost in ${myhost_array[@]} ; do

    echo "install to server => ${myhost}"
    sshpass -f ~/mypassowrd.txt ssh pi@$myhost.local \
	    "sudo apt install -y ${app_name} " \
	    &

done
