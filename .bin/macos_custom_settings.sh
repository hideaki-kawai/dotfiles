#!/bin/bash
set -euo pipefail

# macOS 以外では実行しない
if [ "$(uname)" != "Darwin" ]; then
  echo "エラー: このスクリプトは macOS 専用"
  exit 1
fi

###############################################################################
# トラックパッド / マウス
###############################################################################
# 1本指タップでクリックを有効化（ユーザー + ログイン画面）
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# 右クリックを右下タップに設定
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# 軌跡（ポインタ）速度を最大に設定
defaults write -g com.apple.trackpad.scaling -float 3.0
defaults write -g com.apple.mouse.scaling -float 3.0

###############################################################################
# キーボード
###############################################################################
# キーリピート最速、リピート開始を最短に設定
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# F1〜F12 を標準ファンクションキーとして使用
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# 文頭自動大文字化を無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# キーボードバックライトを 30 秒で自動オフ
defaults write com.apple.BezelServices kDim -bool true
defaults write com.apple.BezelServices kDimTime -int 30

###############################################################################
# Dock
###############################################################################
# Dock サイズを小さめ、自動的に隠す
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock autohide -bool true

# dockutil がなければ Homebrew からインストール（brew は init.sh で PATH 済み）
if ! command -v dockutil >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install dockutil
  else
    echo "dockutil がないため Dock アイコン固定はスキップ"
  fi
fi

# 左側の Dock アイコンを固定（Finder / Launchpad / システム設定）
if command -v dockutil >/dev/null 2>&1; then
  dockutil --remove all || true
  dockutil --add "/System/Library/CoreServices/Finder.app" --position 1 || true
  dockutil --add "/System/Applications/Launchpad.app" --position 2 || true
  dockutil --add "/System/Applications/System Settings.app" --position 3 || true
fi

###############################################################################
# メニューバー / バッテリー
###############################################################################
# バッテリー残量（％）表示を有効化（OS により反映方法が変わる場合あり）
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

###############################################################################
# 省電力（sudo 必須）
###############################################################################
# バッテリー時は 5 分でディスプレイをオフにする
sudo pmset -b displaysleep 5

# 電源接続時はディスプレイを切らない
sudo pmset -c displaysleep 0

###############################################################################
# （任意）Apple 日本語 IM: ¥ → \ にする（必要なら有効化）
###############################################################################
# Google 日本語入力の詳細設定は手動を推奨（安定自動化が難しい）
# defaults write com.apple.inputmethod.Kotoeri JIMPrefCharacterForYenKey -string "\\"
# defaults write com.apple.inputmethod.Kotoeri JIMPrefCharacterForBackslashKey -string "\\"
# killall "JapaneseIM" >/dev/null 2>&1 || true
# killall "Kotoeri"   >/dev/null 2>&1 || true

###############################################################################
# 反映
###############################################################################
killall Dock            >/dev/null 2>&1 || true
killall SystemUIServer  >/dev/null 2>&1 || true
killall cfprefsd        >/dev/null 2>&1 || true

echo "macOS カスタム設定を適用した"
