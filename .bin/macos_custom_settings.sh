#!/bin/bash
set -euo pipefail

# macOS 以外では実行しない
if [ "$(uname)" != "Darwin" ]; then
  echo "エラー: このスクリプトは macOS 専用"
  exit 1
fi

# 注意: トラックパッド/キーボード系の設定は、後から「システム設定」の該当
# パネル（トラックパッド/キーボード等）を開くと、そのパネルが持つキャッシュ値で
# 上書きされて元に戻ることがある（macOS の既知の挙動）。
# README の「実行後に手動で行うこと」（入力ソース追加など）を行った後は、
# 念のためこのスクリプト（make macos_custom_settings）をもう一度実行すること。

###############################################################################
# トラックパッド / マウス
###############################################################################
# 1本指タップでクリックを有効化（ユーザー + ログイン画面）
# 内蔵トラックパッドは com.apple.AppleMultitouchTrackpad、Bluetooth トラックパッドは
# com.apple.driver.AppleBluetoothMultitouch.trackpad と、機種によりドメインが異なるため両方に書く
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# 右クリックを右下タップに設定
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
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

# キーボードバックライトの自動オフ設定は com.apple.BezelServices 経由の
# defaults write では現行 macOS（Sequoia 以降）で機能しなくなったため廃止。
# 「システム設定 → キーボード → 操作がないときにキーボードのバックライトを
# オフにする」から手動設定する。

###############################################################################
# Dock
###############################################################################
# Dock を小さめ、自動的に隠す
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock autohide -bool true

# dockutil がなければ Homebrew からインストールする（brew PATH は init.sh 側で設定済み）
if ! command -v dockutil >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install dockutil
  else
    echo "dockutil がないため Dock アイコン固定はスキップ"
  fi
fi

# 左側の Dock アイコンを固定（Finder / システム設定）
# macOS Tahoe (26) 以降 Launchpad は Dock.app に統合され
# /System/Applications/Launchpad.app が存在しなくなったため対象から除外。
if command -v dockutil >/dev/null 2>&1; then
  dockutil --remove all || true
  dockutil --add "/System/Library/CoreServices/Finder.app" --position 1 || true
  dockutil --add "/System/Applications/System Settings.app" --position 2 || true
fi

###############################################################################
# メニューバー / バッテリー
###############################################################################
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

###############################################################################
# 省電力（sudo 必須）
###############################################################################
# バッテリー時は 5 分でディスプレイをオフ
sudo pmset -b displaysleep 5

# 電源接続時はディスプレイを切らない
sudo pmset -c displaysleep 0

###############################################################################
# 反映
###############################################################################
killall Dock            >/dev/null 2>&1 || true
killall SystemUIServer  >/dev/null 2>&1 || true
killall cfprefsd        >/dev/null 2>&1 || true

echo "macOS カスタム設定を適用した"
