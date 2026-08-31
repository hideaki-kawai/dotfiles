#!/bin/bash
set -euo pipefail

# macOS 以外では実行しない
if [ "$(uname)" != "Darwin" ]; then
  echo "エラー: このスクリプトは macOS 専用"
  exit 1
fi

# cwd に依存せず mise/config.toml を参照できるようにリポジトリルートを解決
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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
# CLI / GUI アプリ一式（Brewfile 参照）
# CI でのスキップ判定は Brewfile 側（Ruby の ENV["CI"] 判定）に集約済み
###############################################################################
brew bundle install --file="$REPO_ROOT/Brewfile"

###############################################################################
# PATH / 初期化（冪等）
###############################################################################
# Homebrew の PATH は init.sh で設定済み

# mise をログインシェル / 対話シェルで初期化（重複追記しない）
# https://mise.jdx.dev/installing-mise.html
if ! grep -q 'mise activate zsh' "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$(mise activate zsh)"' >> "$HOME/.zshrc"
fi

# 現在のシェルにも反映して、直後にコマンドが使えるようにする
eval "$(mise activate zsh)" || true

# node/python/go/gh/aws/gcloud など、このリポジトリで管理しているツール一式を
# mise の共有バージョン定義（mise/config.toml）から一括インストール
mkdir -p "$HOME/.config/mise"
cp "$REPO_ROOT/mise/config.toml" "$HOME/.config/mise/config.toml"
mise install

###############################################################################
# 既定ブラウザを Chrome に切り替える（初回起動時に OS の確認ダイアログが出る）
###############################################################################
if ! is_ci; then
  open -a "Google Chrome" --args --make-default-browser || true
fi

echo "Homebrew のインストール処理を完了した"
