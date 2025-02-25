#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/tv/myngrok.sh && bash myngrok.sh http 8888;

#-----------------------------------------------------------------------------------------------------------------------
# このスクリプトの使い方:
#-----------------------------------------------------------------------------------------------------------------------
# ./myngrok.sh <service_name> [port]
# 
# service_name: サービス名 (必須)
# port        : 使用するポート番号 (省略可能、デフォルトは80)
#
# 例:
# - デフォルトポート80を使用して "my_ngrok_service" という名前のサービスを作成:
#   ./myngrok.sh service_name
#
# - ポート8080で "service_name" という名前のサービスを作成:
#   ./myngrok.sh service_name 8080
#
# このスクリプトは以下の操作を実行します:
# 1. systemdサービスファイルを作成
# 2. 指定したポートでngrokを起動
# 3. 公開URLを自動取得して表示
#-----------------------------------------------------------------------------------------------------------------------

# デフォルト値
DEFAULT_PORT=80

# 引数チェック
if [ -z "$1" ]; then
    echo "Usage: $0 <service_name> [port]"
    exit 1
fi

SERVICE_NAME=$1
PORT=${2:-$DEFAULT_PORT}  # 指定がなければデフォルトのポート80を使用

# サービスファイルのパス
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# ユーザー名を取得
USER_NAME=$(whoami)

# サービスファイルの内容を作成
sudo bash -c "cat > $SERVICE_FILE <<EOF
[Unit]
Description=ngrok service for $SERVICE_NAME (port $PORT)
After=network.target

[Service]
ExecStart=/usr/local/bin/ngrok http $PORT --log=stdout
Restart=on-failure
User=$USER_NAME
WorkingDirectory=/home/$USER_NAME
Environment=PATH=/usr/local/bin:/usr/bin:/bin

[Install]
WantedBy=multi-user.target
EOF"

# サービスファイルの権限設定
sudo chmod 644 $SERVICE_FILE

# systemdの設定をリロード
sudo systemctl daemon-reload

# サービスを有効化
sudo systemctl enable "$SERVICE_NAME"

# サービスを起動
sudo systemctl start "$SERVICE_NAME"

echo "$SERVICE_NAME.service has been created, enabled, and started."

# 最大10回リトライしてngrokの公開URLを取得
MAX_RETRIES=10
API_URL="http://127.0.0.1:4040/api/tunnels"
RETRY_INTERVAL=2

for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "Attempt $i to retrieve ngrok public URL for $SERVICE_NAME (port $PORT)..."
    PUBLIC_URL=$(curl -s "$API_URL" | jq -r '.tunnels[0].public_url')
    if [[ $PUBLIC_URL != "null" && -n $PUBLIC_URL ]]; then
        echo "ngrok public URL for $SERVICE_NAME (port $PORT): $PUBLIC_URL"
        break
    fi
    sleep $RETRY_INTERVAL
done

if [[ -z $PUBLIC_URL || $PUBLIC_URL == "null" ]]; then
    echo "Failed to retrieve ngrok public URL for $SERVICE_NAME (port $PORT) after $MAX_RETRIES attempts."
fi
