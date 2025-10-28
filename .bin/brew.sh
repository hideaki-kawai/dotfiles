#!/bin/bash
set -euo pipefail

# macOS 以外では実行しない
if [ "$(uname)" != "Darwin" ]; then
  echo "エラー: このスクリプトは macOS 専用"
  exit 1
fi

echo "Homebrew を更新してパッケージをインストールする ..."

# CI 環境判定
IS_CI="${CI:-}"
is_ci() { [ -n "$IS_CI" ] || [ -n "${GITHUB_ACTIONS:-}" ]; }

###############################################################################
# Apple Silicon で Rosetta 2 が必要な場合は自動インストール
#   判定: arm64 かつ 'arch -x86_64 true' が失敗 → Rosetta 未導入
###############################################################################
if [ "$(uname -m)" = "arm64" ]; then
  if ! /usr/bin/arch -x86_64 /usr/bin/true >/dev/null 2>&1; then
    echo "Rosetta 2 をインストールする（初回のみ）..."
    sudo softwareupdate --install-rosetta --agree-to-license || {
      echo "警告: Rosetta 2 のインストールに失敗。後続の Intel 専用 cask が失敗する可能性あり"
    }
  fi
fi

###############################################################################
# GUI アプリ（cask）
###############################################################################
brew install --cask google-chrome
# CI は IME/GUI 系をスキップ（ヘッドレス・権限制約のため）
if ! is_ci; then
  brew install --cask google-japanese-ime
fi

brew install --cask iterm2
brew install --cask clipy
brew install --cask sourcetree

# Docker Desktop は CI ではスキップ
if ! is_ci; then
  brew install --cask docker
fi

brew install --cask scroll-reverser
brew install --cask rectangle
brew install --cask cursor
brew install --cask alt-tab
brew install --cask slack
brew install --cask chatwork
brew install --cask lark

# Logi Options+ は再起動必須・初回起動前はエラーノイズが出やすいので CI ではスキップ
if ! is_ci; then
  brew install --cask logi-options-plus || true
  echo "※ logi-options+ はインストール後に再起動が必要。再起動後に初回起動して権限付与する"
fi

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

# Volta を PATH に追加（shims を使うため）
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
if ! is_ci; then
  open -a "Google Chrome" --args --make-default-browser || true
fi

echo "Homebrew のインストール処理を完了した"
