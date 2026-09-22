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
# Tap
###############################################################################
# stablyai/orca の Orca (AI コーディングエージェント用 IDE) は
# homebrew-cask 本家の同名 cask (Plotly のチャート画像出力ツール) と衝突するため
# tap を明示してフルネームで指定する。
tap "stablyai/orca"

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
cask "ngrok"
cask "stablyai/orca/orca"

unless is_ci
  # ヘッドレス CI では IME の初期化が失敗しやすいためスキップ
  cask "google-japanese-ime"
  # Docker Desktop は CI ランナーでは不要・重いためスキップ
  cask "docker-desktop"
end
