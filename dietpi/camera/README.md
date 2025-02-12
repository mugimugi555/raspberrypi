# DietPi での MJPEG ストリーミング & タイムラプス撮影

![タイトル画像](assets/images/header.png)

このプロジェクトでは、DietPi 上で MJPEG ストリーミングサーバーとタイムラプス撮影システムをセットアップします。提供されるスクリプトにより、MJPEG-Streamer を使用したリアルタイム映像配信と、fswebcam を使用した定期的な画像キャプチャをインストールおよび設定します。

## 特徴
- **MJPEG-Streamer**：カメラ映像を HTTP 経由で配信
- **タイムラプス撮影**：定期的に画像をキャプチャして保存
- **systemd サービス**：起動時に自動実行

## 必要条件
- USB カメラが接続された DietPi システム
- Raspberry Pi カメラモジュール (MIPI CSI) が接続されている場合はそれも確認
- インターネット接続（パッケージのインストールに必要）
- USB カメラが接続された DietPi システム
- インターネット接続（パッケージのインストールに必要）

## カメラの接続確認
カメラが接続されているか確認するには、以下のコマンドを実行してください。

### **Raspberry Pi カメラモジュール (MIPI CSI) の確認**
```bash
vcgencmd get_camera
```
`supported=1 detected=1` と表示されれば、カメラが正しく認識されています。

### **USB カメラの確認**
```bash
ls /dev/video*
```
カメラが正しく認識されていれば、`/dev/video0` などが表示されます。

## インストール
以下のコマンドを実行して、セットアップスクリプトをダウンロード・実行してください。

```bash
wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/refs/heads/main/dietpi/camera/install_mjpeg.sh
wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/refs/heads/main/dietpi/camera/install_timelapse.sh

bash install_mjpeg.sh
bash install_timelapse.sh
```

## ストリーミングの確認
セットアップが完了したら、以下のコマンドで IP アドレスやホスト名を取得できます。

```bash
IP_ADDRESS=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)
echo "アクセス URL: http://$IP_ADDRESS:8080/?action=stream"
echo "または http://$HOSTNAME:8080/?action=stream"
```

## キャプチャした画像の確認
タイムラプスで撮影した画像は、以下のディレクトリに保存されます。

```
/home/dietpi/timelapse/
```

画像一覧を確認するには、以下のコマンドを実行してください。
```bash
ls /home/dietpi/timelapse/
```

## タイムラプス画像を動画に変換
キャプチャした画像を動画に変換するには、以下のコマンドを実行します。
```bash
ffmpeg -r 10 -pattern_type glob -i "~/timelapse/*.jpg" -c:v libx264 -vf "fps=25,format=yuv420p" timelapse.mp4
```

## サービス管理
### **MJPEG-Streamer**
起動:
```bash
sudo systemctl start mjpg-streamer
```
停止:
```bash
sudo systemctl stop mjpg-streamer
```
自動起動有効化:
```bash
sudo systemctl enable mjpg-streamer
```

### **タイムラプスキャプチャ**
起動:
```bash
sudo systemctl start timelapse
```
停止:
```bash
sudo systemctl stop timelapse
```
自動起動有効化:
```bash
sudo systemctl enable timelapse
```

## アンインストール
以下のコマンドでサービスを削除できます。
```bash
sudo systemctl stop mjpg-streamer timelapse
sudo systemctl disable mjpg-streamer timelapse
sudo rm /etc/systemd/system/mjpg-streamer.service
sudo rm /etc/systemd/system/timelapse.service
sudo rm -rf /home/dietpi/timelapse/
```

## ライセンス
MIT License

![タイトル画像](assets/images/footer.png)
