#!/bin/bash

# 📺 PX-S1UD + Raspberry Pi 4 地デジ視聴環境構築スクリプト
# URL: wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/tv/install_tv.sh && bash install_tv.sh

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📝 事前情報
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ■ 対象: Raspberry Pi 4 (Bookworm 64bit)
# ■ 機材:
#   - PX-S1UD V2.0
#   - SCR3310 カードリーダー + B-CASカード
#   - 有線LAN推奨
# ■ 目的: Docker + Mirakurun + EPGStation の構築

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔧 必要パッケージのインストール
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📦 パッケージをインストール中..."
sudo apt update
sudo apt install -y curl unzip git jq

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🐳 Docker インストール
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "🐳 Dockerをインストール中..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker --version || { echo "❌ Dockerのインストールに失敗"; exit 1; }
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🧩 Docker Compose インストール
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📦 Docker Composeをインストール中..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$DOCKER_COMPOSE_VERSION" ]; then
  echo "❌ Docker Composeのバージョン取得失敗"; exit 1
fi
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version || { echo "❌ Docker Composeのインストール失敗"; exit 1; }

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔌 PX-S1UD ドライバインストール
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📡 PX-S1UDドライバをインストール中..."
cd ~
wget http://plex-net.co.jp/plex/px-s1ud/PX-S1UD_driver_Ver.1.0.1.zip
unzip PX-S1UD_driver_Ver.1.0.1.zip
sudo cp PX-S1UD_driver_Ver.1.0.1/x64/amd64/isdbt_rio.inp /lib/firmware/
sudo modprobe -r dvb_usb_af9015
sudo modprobe dvb_usb_af9015
if ! dmesg | grep -q "dvb"; then
  echo "❌ ドライバのロードに失敗"; exit 1
fi

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 💳 B-CASカードリーダーの動作確認
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💳 B-CASカードリーダーの確認中..."
sudo apt install -y pcscd libpcsclite-dev libccid pcsc-tools
sleep 2
B_CAS_CHECK=$(timeout 5s pcsc_scan | grep -i "B-CAS")
if [ -z "$B_CAS_CHECK" ]; then
  echo "❌ B-CASカードが検出されませんでした。カードまたはリーダーを確認してください。"
  sudo apt remove --purge -y pcscd libpcsclite-dev libccid pcsc-tools
  exit 1
else
  echo "✅ B-CASカードが検出されました。"
fi

# 不要になったら削除
sudo apt remove --purge -y pcscd libpcsclite-dev libccid pcsc-tools

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 Mirakurun + EPGStation のインストール
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "🚀 Mirakurun + EPGStation をインストール中..."
curl -sf https://raw.githubusercontent.com/l3tnun/docker-mirakurun-epgstation/v2/setup.sh | sh -s
cd docker-mirakurun-epgstation || { echo "❌ セットアップディレクトリが見つかりません"; exit 1; }
sudo docker-compose up -d || { echo "❌ EPGStation起動に失敗"; exit 1; }

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔍 チャンネルスキャン実行
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📡 チャンネルスキャンを実行中..."
curl -X PUT "http://localhost:40772/api/config/channels" -H "Content-Type: application/json" -d "[]"
curl -X PUT "http://localhost:40772/api/config/channels/scan"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📺 VLC用 M3U プレイリスト作成
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "🎶 VLC用M3Uプレイリストを作成中..."
MIRAKURUN_URL="http://localhost:40772/api/config/channels"
OUTPUT_M3U="vlc_channels.m3u"
IP_ADDRESS=$(hostname -I | awk '{print $1}')
if [ -z "$IP_ADDRESS" ]; then echo "❌ IPアドレス取得失敗"; exit 1; fi

{
  echo "#EXTM3U"
  echo "#EXTVLCOPT:network-caching=1000"
  curl -s "$MIRAKURUN_URL" | jq -c '.[]' | while read -r channel; do
    NAME=$(echo "$channel" | jq -r '.name')
    TYPE=$(echo "$channel" | jq -r '.type')
    CHANNEL=$(echo "$channel" | jq -r '.channel')
    IS_DISABLED=$(echo "$channel" | jq -r '.isDisabled')
    [ "$IS_DISABLED" = "true" ] && continue
    echo "#EXTINF:-1,地上波 - $NAME"
    echo "http://${IP_ADDRESS}:40772/api/channels/${TYPE}/${CHANNEL}/stream/"
  done
} > "$OUTPUT_M3U"

echo "✅ M3Uファイル作成完了: $OUTPUT_M3U"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ✅ 完了メッセージ
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MY_HOST_NAME=$(hostname)
echo "======================================"
echo "📺 EPGStation => http://$MY_HOST_NAME.local:8888/"
echo "🛰️  Mirakurun  => http://$MY_HOST_NAME.local:40772/"
echo "======================================"
