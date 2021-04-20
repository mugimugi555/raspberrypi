#!/usr/bin/bash

# bash install_raspi.sh 
# or
# bash install_raspi.sh myraspiname  # we can access ssh pi@myraspiname.local

echo "=============================================================="
echo "setting"
echo "=============================================================="

SD_CARD_PATH=/dev/mmcblk0

# user name is pi password is here
LOGIN_USER_PASSWORD=raspberry

# wifi
WIFI_SSID=mywifi-ssid
WIFI_PASSWORD=mywifi-password

if [ $1 ]; then
  RPI_HOST_NAME=$1
else
  RPI_HOST_NAME=raspberry
fi

echo "=============================================================="
echo "get latest rasbian 32bit os image"
echo "=============================================================="
rm operating-systems-categories.json
wget https://downloads.raspberrypi.org/operating-systems-categories.json
RPI_IMAGE_URL=$(cat  operating-systems-categories.json | jq -r '.[0].images[0].urlHttp' )
RPI_IMAGE_HASH=$(cat operating-systems-categories.json | jq -r '.[0].images[0].sha256'  )

echo "=============================================================="
echo "check downloded"
echo "=============================================================="
RPI_IMAGE_NAME=$(basename $RPI_IMAGE_URL)
if [ -f "$RPI_IMAGE_NAME" ]; then

  echo "${RPI_IMAGE_NAME} file found ok"

else

  rm   $RPI_IMAGE_NAME.downloading
  wget $RPI_IMAGE_URL -O $RPI_IMAGE_NAME.downloading
  mv   $RPI_IMAGE_NAME.downloading $RPI_IMAGE_NAME

  # check hash
  #if [ sha256sum -b $RPI_IMAGE_NAME == $RPI_IMAGE_HASH ]; then
  # echo "ok"
  #fi

fi

echo "=============================================================="
echo "unzip file"
echo "=============================================================="
RPI_IMAGE=$( echo $RPI_IMAGE_NAME | sed 's/.zip/.img/' )
unzip -o $RPI_IMAGE_NAME $RPI_IMAGE

echo "=============================================================="
echo "write image to sd card"
echo "=============================================================="
sudo umount /media/$USER/boot
sudo umount /media/$USER/rootfs
sleep 3

echo "wipe"
sudo wipefs -a $SD_CARD_PATH
echo "dd"
sudo dd bs=8M if=$RPI_IMAGE of=$SD_CARD_PATH
sudo echo

echo "=============================================================="
echo "mount sd card"
echo "=============================================================="
sudo mkdir /media/$USER/boot
sudo mount ${SD_CARD_PATH}p1 /media/$USER/boot
sleep 3

echo "=============================================================="
echo "create config files A"
echo "=============================================================="
MY_TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")

sudo cp /media/$USER/boot/config.txt /media/$USER/boot/config.txt.${MY_TIMESTAMP}
sed -e 's/#disable_overscan=1/disable_overscan=1/' /media/$USER/boot/config.txt | sudo tee /media/$USER/boot/config.txt
sleep 1

sudo cp /media/$USER/boot/cmdline.txt /media/$USER/boot/cmdline.txt.${MY_TIMESTAMP}
sed -z 's/\n//' /media/$USER/boot/cmdline.txt | sudo tee /media/$USER/boot/cmdline.txt
echo -e " systemd.run=/boot/firstrun.sh systemd.run_success_action=reboot systemd.unit=kernel-command-line.target\n" | sudo tee -a /media/$USER/boot/cmdline.txt
sleep 1

echo "=============================================================="
echo "create config files B"
echo "=============================================================="
LOGIN_USER_PASSWORD_HASH=$( mkpasswd -m sha-256 $LOGIN_USER_PASSWORD )
sleep 3
RPI_FIRSTRUN_TEMPLATE=$(cat << 'EOS'
#!/bin/bash

set +e

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
echo REPLACE_RPI_HOST_NAME >/etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\tREPLACE_RPI_HOST_NAME/g" /etc/hosts
FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`
echo "$FIRSTUSER:"'REPLACE_LOGIN_USER_PASSWORD' | chpasswd -e
systemctl enable ssh
cat >/etc/wpa_supplicant/wpa_supplicant.conf <<WPAEOF
country=JP
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
	ssid="REPLACE_WIFI_SSID"
	psk="REPLACE_WIFI_PASSWORD"
}

WPAEOF
chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
rfkill unblock wifi
for filename in /var/lib/systemd/rfkill/*:wlan ; do
  echo 0 > $filename
done
rm -f /etc/xdg/autostart/piwiz.desktop
rm -f /etc/localtime
echo "Asia/Tokyo" >/etc/timezone
dpkg-reconfigure -f noninteractive tzdata
cat >/etc/default/keyboard <<KBEOF
XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS=""
KBEOF
dpkg-reconfigure -f noninteractive keyboard-configuration
rm -f /boot/firstrun.sh
sed -i 's| systemd.run.*||g' /boot/cmdline.txt
exit 0

EOS
)

sleep 3
echo "${RPI_FIRSTRUN_TEMPLATE}"                                      | \
    sed "s/REPLACE_RPI_HOST_NAME/${RPI_HOST_NAME}/"                  | \
    sed "s/REPLACE_LOGIN_USER_PASSWORD/${LOGIN_USER_PASSWORD_HASH}/" | \
    sed "s/REPLACE_WIFI_SSID/${WIFI_SSID}/"                          | \
    sed "s/REPLACE_WIFI_PASSWORD/${WIFI_PASSWORD}/"                  | \
    sudo tee /media/$USER/boot/firstrun.sh

echo "=============================================================="
echo "unmount sd card"
echo "=============================================================="
sleep 3
sudo umount /media/$USER/boot
sudo rmdir  /media/$USER/boot

exit;
