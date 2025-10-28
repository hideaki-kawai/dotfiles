#!/bin/bash
set -euo pipefail

# macOS 以外では実行しない
if [ "$(uname)" != "Darwin" ]; then
  echo "エラー: このスクリプトは macOS 専用"
  exit 1
fi

echo "Homebrew を更新してパッケージをインストールする ..."

# ドライバ系（Logi Options+ など）
brew tap homebrew/cask-drivers

###############################################################################
# GUI アプリ（cask）
###############################################################################
brew install --cask google-chrome
brew install --cask google-japanese-ime
brew install --cask iterm2
brew install --cask clipy
brew install --cask sourcetree
brew install --cask docker                 # Docker Desktop
brew install --cask scroll-reverser
brew install --cask rectangle
brew install --cask cursor
brew install --cask alt-tab
brew install --cask slack
brew install --cask chatwork
brew install --cask lark
brew install --cask logi-options-plus

###############################################################################
# CLI ツール
###############################################################################
brew install tree
brew install volta
brew install pyenv
brew install gh
brew install ngrok
brew install awscli
brew install dockutil

###############################################################################
# PATH / 初期化（冪等）
###############################################################################
# Homebrew の PATH は init.sh で設定済み

# Volta を PATH に追加（shims を使うための初期化）
volta setup || true

# pyenv をログインシェル / 対話シェルで初期化（重複追記しない）
if ! grep -q 'export PYENV_ROOT=' "$HOME/.zprofile" 2>/dev/null; then
  {
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init --path)"'
  } >> "$HOME/.zprofile"
fi
if ! grep -q 'pyenv init -' "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$(pyenv init -)"' >> "$HOME/.zshrc"
fi

# 現在のシェルにも反映して、直後にコマンドが使えるようにする
# shellcheck disable=SC1090
[ -f "$HOME/.zprofile" ] && . "$HOME/.zprofile" || true
# shellcheck disable=SC1090
[ -f "$HOME/.zshrc" ] && . "$HOME/.zshrc" || true

###############################################################################
# 既定ブラウザを Chrome に切り替える（初回起動時に OS の確認ダイアログが出る）
###############################################################################
open -a "Google Chrome" --args --make-default-browser || true

echo "Homebrew のインストール処理を完了した"
