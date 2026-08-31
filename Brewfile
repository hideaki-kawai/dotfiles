# Brewfile
# https://docs.brew.sh/Brew-Bundle-and-Brewfile
#
# 実際にインストールされているものと乖離してきたら
#   brew bundle dump --force
# で現状から再生成できる（cask 名の変更・追加インストールなどのズレを防げる）。
#
# CI (GitHub Actions) では GUI/権限系のインストールが失敗しやすいものを除外する。
# Brewfile は Ruby として評価されるため ENV 判定がそのまま使える。
is_ci = ENV["CI"] || ENV["GITHUB_ACTIONS"]

###############################################################################
# CLI ツール
###############################################################################
brew "tree"
brew "dockutil"
brew "mise"

###############################################################################
# GUI アプリ（cask）
###############################################################################
cask "google-chrome"
cask "iterm2"
cask "clipy"
cask "sourcetree"
cask "scroll-reverser"
cask "rectangle"
cask "cursor"
cask "alt-tab"
cask "slack"
cask "chatwork"
cask "lark"
cask "ngrok"

unless is_ci
  # ヘッドレス CI では IME の初期化が失敗しやすいためスキップ
  cask "google-japanese-ime"
  # Docker Desktop は CI ランナーでは不要・重いためスキップ
  cask "docker-desktop"
end
