#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_tv.sh && bash install_tv.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# 必要な機材
#-----------------------------------------------------------------------------------------------------------------------

# ・raspberry pi4(BookWorm 64bit)
# ・PX-S1UD V2.0
# ・SCR3310
# ・B-CASカード

#-----------------------------------------------------------------------------------------------------------------------
# 必要なツールをインストール
#-----------------------------------------------------------------------------------------------------------------------

sudo apt update
sudo apt install -y curl unzip git jq

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

# 再起動しないでドライバを有効に
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
# MirakurunとEPGStationのインストール（１５分程度）
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
# チャンネルのスキャン（１０分程度）
#-----------------------------------------------------------------------------------------------------------------------

# 初期設定されているチャンネルを一旦全削除
curl -X PUT "http://localhost:40772/api/config/channels" -H "Content-Type: application/json" -d "[]"

# チャンネルスキャン開始
curl -X PUT "http://localhost:40772/api/config/channels/scan"

#-----------------------------------------------------------------------------------------------------------------------
# VLC用のプレイリストファイルの作成
#-----------------------------------------------------------------------------------------------------------------------

# Mirakurun APIのURL
MIRAKURUN_URL="http://localhost:40772/api/config/channels"

# 出力するM3Uファイル
OUTPUT_M3U="vlc_channels.m3u"

# システムのIPアドレスを取得
IP_ADDRESS=$(hostname -I | awk '{print $1}')

if [ -z "$IP_ADDRESS" ]; then
    echo "IPアドレスが取得できませんでした。"
    exit 1
fi

echo "IPアドレス: $IP_ADDRESS"

# M3Uファイルのヘッダーを書き込み
echo "#EXTM3U" > "$OUTPUT_M3U"
echo "#EXTVLCOPT:network-caching=1000" >> "$OUTPUT_M3U"

# Mirakurunからチャンネル情報を取得して処理
curl -s "$MIRAKURUN_URL" | jq -c '.[]' | while read -r channel; do
    # チャンネル情報の抽出
    NAME=$(echo        "$channel" | jq -r '.name'      )
    TYPE=$(echo        "$channel" | jq -r '.type'      )
    CHANNEL=$(echo     "$channel" | jq -r '.channel'   )
    IS_DISABLED=$(echo "$channel" | jq -r '.isDisabled')

    # 無効化されているチャンネルはスキップ
    if [ "$IS_DISABLED" = "true" ]; then
        continue
    fi

    # ストリームURLの生成
    STREAM_URL="http://${IP_ADDRESS}:40772/api/channels/${TYPE}/${CHANNEL}/stream/"

    # M3Uフォーマットに追加
    echo "#EXTINF:-1,地上波 - $NAME" >> "$OUTPUT_M3U"
    echo "$STREAM_URL" >> "$OUTPUT_M3U"
done

# 完了メッセージ
echo "VLC用のプレイリストファイルが作成されました: $OUTPUT_M3U"

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
MY_HOST_NAME=$(hostname)
echo "======================================" ;
echo "EPGStation => http://$MY_HOST_NAME.local:8888/" ;
echo "Mirakurun  => http://$MY_HOST_NAME.local:40772/" ;
echo "======================================" ;
