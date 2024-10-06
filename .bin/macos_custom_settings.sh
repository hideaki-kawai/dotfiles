#!/bin/bash

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# 1本指タッチ、右クリックを有効にする（トラックパッド）
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# 右クリックを有効にする
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true

# 軌跡と入力を速くする（トラックパッドとマウス）
defaults write -g com.apple.trackpad.scaling -float 3.0
defaults write -g com.apple.mouse.scaling -float 3.0

# Dockを小さくする
defaults write com.apple.dock tilesize -int 36

# Dockを自動的に非表示にする
defaults write com.apple.dock autohide -bool true

# 「文頭を自動的に大文字にする」を無効にする
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# バッテリーのパーセンテージを表示する
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# バッテリー駆動時にディスプレイを5分後にオフに設定
sudo pmset -b displaysleep 5

# Dockの変更を適用
killall Dock

echo "finish MacOS custom settings!!"