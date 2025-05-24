#!/bin/bash

# 初期セットアップスクリプト for Raspberry Pi 4 🛠️🍓
# https://github.com/mugimugi555/raspberrypi/blob/main/install.sh で実行可能

set -e  # エラー時に即停止

#---------------------------------------------
# sudo timeout の延長 ⏳
#---------------------------------------------
echo "🛡️ sudo タイムアウトを延長中..."
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo

#---------------------------------------------
# 壁紙の設定 🖼️
#---------------------------------------------
echo "🖼️ 壁紙を設定中..."
WALLPAPER_DIR="$HOME/Pictures"
WALLPAPER_IMG="$WALLPAPER_DIR/1.jpg"
mkdir -p "$WALLPAPER_DIR"
wget -q http://gahag.net/img/201602/11s/gahag-0055029460-1.jpg -O "$WALLPAPER_IMG"
pcmanfm -w "$WALLPAPER_IMG" || true
feh --bg-scale "$WALLPAPER_IMG" || true

#---------------------------------------------
# Raspberry Pi 設定 🔧
#---------------------------------------------
echo "⚙️ Raspberry Pi 基本設定中..."
sudo raspi-config nonint do_change_pass
sudo raspi-config nonint do_camera 0
#sudo raspi-config nonint do_legacy 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_spi 0
sudo raspi-config nonint do_wifi_country JP
sudo raspi-config nonint do_change_locale ja_JP.UTF-8
sudo raspi-config nonint do_change_timezone Asia/Tokyo

sudo raspi-config nonint do_vnc 0
sudo systemctl enable vncserver-x11-serviced.service

#---------------------------------------------
# 画面スリープ無効化 💤
#---------------------------------------------
echo "💡 スクリーンブランキングを無効化中..."
sudo install -D /usr/share/raspi-config/10-blanking.conf /etc/X11/xorg.conf.d/10-blanking.conf

#---------------------------------------------
# ロケール設定 🌐
#---------------------------------------------
echo "🌐 ロケールを日本語に設定中..."
export LANGUAGE=ja_JP.utf8
export LANG=ja_JP.utf8
export LC_ALL=ja_JP.utf8
sudo locale-gen ja_JP.UTF-8
sudo update-locale LANG=ja_JP.UTF-8
LC_ALL=C xdg-user-dirs-update --force

#---------------------------------------------
# swapサイズ拡張 🧠
#---------------------------------------------
echo "🧠 スワップサイズを 4096MB に設定中..."
echo "CONF_SWAPSIZE=4096" | sudo tee /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile restart

#---------------------------------------------
# 必要なソフトウェアのインストール 📦
#---------------------------------------------
echo "📦 必要なパッケージをインストール中..."
echo "samba-common samba-common/workgroup string WORKGROUP" | sudo debconf-set-selections
echo "samba-common samba-common/dhcp boolean true"         | sudo debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true"   | sudo debconf-set-selections

sudo apt update && sudo apt upgrade -y
sudo apt install -y \
  emacs-nox htop curl git axel \
  samba net-tools exfat-fuse exfatprogs \
  ffmpeg ibus-mozc imagemagick mpg321 vlc \
  lame unar lshw mosquitto-clients
sudo apt autoremove -y

# Snapdとアプリのインストール 📦
echo "📥 snapd とアプリをインストール中..."
sudo apt install -y snapd
sudo snap install --classic gimp
sudo snap install --edge yt-dlp

#---------------------------------------------
# CapsLockをCtrlに割当て ⌨️
#---------------------------------------------
echo "⌨️ CapsLock を Ctrl に再マップ中..."
cat << EOF | sudo tee /etc/default/keyboard
BACKSPACE="guess"
XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS="ctrl:nocaps"
EOF

# Mozc設定（XMLテンプレート）
echo "📝 Mozc のエンジン設定中..."
cat << EOF | sudo tee /usr/share/ibus/component/mozc.xml
<component>
  <name>com.google.IBus.Mozc</name>
  <license>New BSD</license>
  <exec>/usr/lib/ibus-mozc/ibus-engine-mozc --ibus</exec>
  <textdomain>ibus-mozc</textdomain>
  <author>Google Inc.</author>
  <homepage>https://github.com/google/mozc</homepage>
  <description>Mozc Component</description>
  <engines>
    <engine>
      <description>Mozc (Japanese Input Method)</description>
      <language>ja</language>
      <symbol>&#x3042;</symbol>
      <rank>80</rank>
      <icon_prop_key>InputMode</icon_prop_key>
      <icon>/usr/share/ibus-mozc/product_icon.png</icon>
      <setup>/usr/lib/mozc/mozc_tool --mode=config_dialog</setup>
      <layout>jp</layout>
      <name>mozc-jp</name>
      <longname>Mozc</longname>
    </engine>
  </engines>
</component>
EOF

#---------------------------------------------
# alias設定 🧾
#---------------------------------------------
echo "🧾 .bashrc にエイリアスを追加中..."
cat << EOF >> ~/.bashrc

# myalias
alias a="axel -a -n 10"
alias u='unar'
alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
EOF

source ~/.bashrc

#---------------------------------------------
# 再起動 🔁
#---------------------------------------------
echo "🔁 システムを再起動します..."
sudo reboot now
