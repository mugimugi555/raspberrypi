
#-----------------------------------------------------------------------------------------------------------------------
# 番組予約を外出先から行う
#-----------------------------------------------------------------------------------------------------------------------

# ngrokのインストール（公式サイトからダウンロード）
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && \
sudo apt update && sudo apt install ngrok

# トークンを登録（ngrokのサイトでアカウント作成が必要）
ngrok config add-authtoken [あなたのauthtoken]

# トンネルの起動（動作の確認。URLは毎回変わります）
ngrok http 8888
