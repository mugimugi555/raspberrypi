#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_tv.sh && bash install_tv.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# 必要なツールをインストール
#-----------------------------------------------------------------------------------------------------------------------

sudo apt update
sudo apt install -y curl unzip git

#-----------------------------------------------------------------------------------------------------------------------
# Dockerのインストール
#-----------------------------------------------------------------------------------------------------------------------

# Dockerの公式インストールスクリプトを実行
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Dockerのバージョン確認
docker --version || { echo "Dockerのインストールに失敗しました。"; exit 1; }

# 現在のユーザーをDockerグループに追加（sudo不要で使えるように設定）
sudo usermod -aG docker $USER
newgrp docker

# Dockerを再起動時に自動起動する設定
sudo systemctl enable docker

#-----------------------------------------------------------------------------------------------------------------------
# Docker Composeのインストール
#-----------------------------------------------------------------------------------------------------------------------

# Docker Composeの最新バージョンを取得してインストール
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$DOCKER_COMPOSE_VERSION" ]; then
    echo "Docker Composeのバージョン取得に失敗しました。スクリプトを終了します。"
    exit 1
fi
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Docker Composeのバージョン確認
docker-compose --version || { echo "Docker Composeのインストールに失敗しました。"; exit 1; }

#-----------------------------------------------------------------------------------------------------------------------
# PX-S1UDのドライバのインストール
#-----------------------------------------------------------------------------------------------------------------------

# PX-S1UDのドライバをダウンロードして設定
cd ~
wget http://plex-net.co.jp/plex/px-s1ud/PX-S1UD_driver_Ver.1.0.1.zip
unzip PX-S1UD_driver_Ver.1.0.1.zip

# ドライバファイルを必要な場所にコピー
sudo cp PX-S1UD_driver_Ver.1.0.1/x64/amd64/isdbt_rio.inp /lib/firmware/

# ドライバを再起動しないで有効に
sudo modprobe -r dvb_usb_af9015
sudo modprobe dvb_usb_af9015
if ! dmesg | grep -q "dvb"; then
    echo "ドライバのロードに失敗しました。カーネルモジュールの設定を確認してください。"
    exit 1
fi

#-----------------------------------------------------------------------------------------------------------------------
# B-CASカードリーダーの動作確認（念の為）
#-----------------------------------------------------------------------------------------------------------------------

# カードリーダーのツールをインストール
# sudo apt install -y pcscd libpcsclite-dev libccid pcsc-tools

# B-CASカードリーダーの動作確認
# pcsc_scan | grep B-CAS

# dockerの方でインストールを行うため削除する
# sudo apt remove --purge -y pcscd libpcsclite-dev libccid pcsc-tools
# sudo reboot

#-----------------------------------------------------------------------------------------------------------------------
# MirakurunとEPGStationのインストール（１５分程度かかります）
#-----------------------------------------------------------------------------------------------------------------------

# MirakurunとEPGStationのセットアップスクリプトを実行
curl -sf https://raw.githubusercontent.com/l3tnun/docker-mirakurun-epgstation/v2/setup.sh | sh -s

# MirakurunとEPGStationのディレクトリに移動
if [ ! -d "docker-mirakurun-epgstation" ]; then
    echo "MirakurunとEPGStationのセットアップに失敗しました。スクリプトを終了します。"
    exit 1
fi
cd docker-mirakurun-epgstation

# Docker ComposeでMirakurunとEPGStationを起動
sudo docker-compose up -d || { echo "EPGStationの起動に失敗しました。"; exit 1; }

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
MY_HOST_NAME=$(hostname)
echo "======================================" ;
echo "EPGStation => http://$MY_HOST_NAME.local:8888/" ;
echo "Mirakurun  => http://$MY_HOST_NAME.local:40772/" ;
echo "======================================" ;
