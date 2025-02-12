# DietPi ステータス監視ツールセットアップ

このプロジェクトでは、DietPi にシステム監視ツールをインストールし、システムの状態を Web または CLI から確認できる環境を構築します。

## **インストールされるツール**

| ソフトウェア       | 説明 |
|-------------------|-------------------------------|
| `dietpi-dashboard` | DietPi の専用 Web ダッシュボード |
| `Glances`         | 詳細なシステム情報を表示できる Web インターフェース |
| `Netdata`         | 高機能なリアルタイム監視ツール |
| `htop`           | シンプルなターミナルベースのシステム監視 |
| `iftop`          | ネットワーク使用状況の確認 |
| `nmon`           | CPU, メモリ, ネットワーク, ディスク情報を表示 |

## **インストール方法**

以下のコマンドを実行して、セットアップスクリプトをダウンロード・実行してください。

```bash
wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/refs/heads/main/dietpi/status/install_status_tools.sh
bash install_status_tools.sh
```

## **アクセス情報**

スクリプト実行後、以下の URL でステータス情報を確認できます。

```
DietPi Dashboard   : http://<DietPiのIPアドレス>:5252
Glances Web UI     : http://<DietPiのIPアドレス>:61208
Netdata Dashboard  : http://<DietPiのIPアドレス>:19999
```

また、ターミナルから以下のコマンドでリアルタイムのシステム情報を確認できます。

```
htop             : 'htop' コマンドを実行
iftop            : 'sudo iftop' コマンドを実行
nmon             : 'nmon' コマンドを実行
```

## **サービス管理**

### **DietPi Dashboard**
起動:
```bash
sudo systemctl start dietpi-dashboard
```
停止:
```bash
sudo systemctl stop dietpi-dashboard
```
自動起動有効化:
```bash
sudo systemctl enable dietpi-dashboard
```

### **Glances**
起動:
```bash
sudo systemctl start glances
```
停止:
```bash
sudo systemctl stop glances
```
自動起動有効化:
```bash
sudo systemctl enable glances
```

### **Netdata**
起動:
```bash
sudo systemctl start netdata
```
停止:
```bash
sudo systemctl stop netdata
```
自動起動有効化:
```bash
sudo systemctl enable netdata
```

## **アンインストール**

以下のコマンドでインストールされた監視ツールを削除できます。
```bash
sudo systemctl stop dietpi-dashboard glances netdata
sudo systemctl disable dietpi-dashboard glances netdata
sudo apt remove -y htop iftop nmon
```

## **ライセンス**
MIT License
