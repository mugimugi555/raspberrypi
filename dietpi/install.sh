#!/bin/bash

# 初期セットアップスクリプト for DietPi CUI環境🛠️🍓

set -e  # エラー時に即停止

#---------------------------------------------
# sudo timeout の延長 ⏳
#---------------------------------------------
echo "🛡️ sudo タイムアウトを延長中..."
echo 'Defaults timestamp_timeout = 1200' | sudo EDITOR='tee -a' visudo

#---------------------------------------------
# ロケール設定 🌐（CUI環境向け）
#---------------------------------------------
echo "🌐 ロケールを日本語に設定中..."
export LANGUAGE=ja_JP.utf8
export LANG=ja_JP.utf8
export LC_ALL=ja_JP.utf8
sudo locale-gen ja_JP.UTF-8
sudo update-locale LANG=ja_JP.UTF-8

#---------------------------------------------
# DietPi-Software 主要ツールのインストール ⚙️
#---------------------------------------------
echo "📦 DietPi-Software で Git / Python3 をインストール中..."
dietpi-software install 35 git      # Git
dietpi-software install 30 python3  # Python 3

#---------------------------------------------
# 必要パッケージの一括インストール 📦
#---------------------------------------------
echo "📦 必要な APT パッケージをインストール中..."
sudo apt update
sudo apt install -y \
  emacs-nox htop curl git axel \
  samba net-tools exfat-fuse exfatprogs \
  ffmpeg ibus-mozc imagemagick mpg321 \
  lame unar lshw
sudo apt autoremove -y

#---------------------------------------------
# MediaTek Wi-Fi ドライバ対策（mt7601u）📡
#---------------------------------------------
echo "📡 MediaTek Wi-Fi ドライバ (mt7601u) 対策中..."
sudo apt install -y firmware-mediatek
sudo modprobe -r mt7601u || true
sudo modprobe mt7601u || true

#---------------------------------------------
# CapsLockをCtrlに再割当 ⌨️
#---------------------------------------------
echo "⌨️ CapsLock を Ctrl に再マップ中..."
cat << EOF | sudo tee /etc/default/keyboard
BACKSPACE="guess"
XKBMODEL="pc105"
XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS="ctrl:nocaps"
EOF

#---------------------------------------------
# Mozc設定（CUIでも一部パッケージ利用あり）📝
#---------------------------------------------
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
# エイリアス設定 🧾
#---------------------------------------------
echo "🧾 .bashrc にエイリアスを追加中..."
cat << EOF >> ~/.bashrc

# myalias
alias a="axel -a -n 10"
alias u='unar'
alias up='sudo dietpi-update -1'
EOF

source ~/.bashrc

#---------------------------------------------
# 再起動 🔁
#---------------------------------------------
echo "🔁 システムを再起動します..."
sudo reboot now
