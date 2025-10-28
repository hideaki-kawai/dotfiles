#!/bin/bash
set -euo pipefail

# ==========
# macOS 以外では実行しない
# ==========
if [ "$(uname)" != "Darwin" ]; then
  echo "エラー: このスクリプトは macOS 専用です。"
  exit 1
fi

# ==========
# Homebrew が未インストールの場合はインストール
# ==========
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew をインストールします ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ==========
# Homebrew の PATH を通す（Apple Silicon / Intel 両対応）
# ~/.zprofile に追記（重複回避済み）
# ==========
if [ -x "/opt/homebrew/bin/brew" ]; then
  SHELLENV='eval "$(/opt/homebrew/bin/brew shellenv)"'
elif [ -x "/usr/local/bin/brew" ]; then
  SHELLENV='eval "$(/usr/local/bin/brew shellenv)"'
else
  echo "エラー: Homebrew がインストールされた形跡がありません。"
  exit 1
fi

grep -qF "$SHELLENV" "$HOME/.zprofile" 2>/dev/null || echo "$SHELLENV" >> "$HOME/.zprofile"

# 現在のシェルにも即時反映
eval "$(/opt/homebrew/bin/brew shellenv)" || true

# ==========
# Homebrew を最新化
# ==========
echo "Homebrew をアップデートします ..."
brew update

# バージョン表示で確認
brew --version
