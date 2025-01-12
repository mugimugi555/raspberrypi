#!/bin/bash

sudo dietpi-software install 18 ; # memacs

# .emacs.d/init.el ファイルパス
INIT_EL="$HOME/.emacs.d/init.el"

# 追記する内容
SETTINGS='
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
'

# ファイルが存在しない場合、新規作成する
if [ ! -f "$INIT_EL" ]; then
  mkdir -p "$(dirname "$INIT_EL")"
  touch "$INIT_EL"
fi

# 追記する内容をファイルに追加
echo "$SETTINGS" >> "$INIT_EL"

echo "設定を $INIT_EL に追記しました。"
