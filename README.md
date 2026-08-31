# dotfiles (2026 Edition)

Mac を買い替えた直後に、**一発でいつもの環境**に整えるためのセットです。  
Apple Silicon 想定。

## できること
- macOS の初期設定（トラックパッド/キーボード/Dock/省電力 ほか）
- Homebrew のインストール & PATH 設定
- `Brewfile` に基づく GUI/CLI アプリの一括インストール（`brew bundle install`）
- [`mise`](https://mise.jdx.dev/) のセットアップ & `mise/config.toml` に基づく
  Node / Python / Go / Java / gh / aws / gcloud などの一括インストール
  （旧 `volta`（Node）/ `pyenv`（Python）構成から移行済み）

### Brewfile / mise/config.toml のメンテナンス
- アプリを追加/削除したら、手で `Brewfile` を編集するより
  `brew bundle dump --force` で今の実インストール状態から再生成する方が
  ズレが起きにくい（cask 名の変更なども自動で拾える）
- 同様に `mise/config.toml` はいつでも `mise use -g <tool>@<version>` で更新できる

> サインイン系（Slack/Chatwork/Lark などのログイン）は自動化しません。

## 使い方（Get started）

1. macを起動する 
2. Wifiに繋いだり、Appleアカウントログインまでは手動で行う
3. gitはデフォルトで入ってると思うから、仕方なくデフォルトのターミナルでリポジトリをcloneする 
4. makefileをmakeコマンドで実行する

```zsh
git clone https://github.com/hideaki-kawai/dotfiles.git
cd dotfiles
make
```

### 各ファイル個別実行する方法

```zsh
/bin/bash .bin/init.sh
/bin/bash .bin/macos_custom_settings.sh
/bin/bash .bin/brew.sh
```
もしくは

```zsh
make init
make macos_custom_settings
make brew
```

## 実行後に手動で行うこと

- Google 日本語入力を「システム設定 → キーボード → 入力ソース」で追加

- IME 設定で以下を行う
  - ¥ キー → \
  - スペース → 常に半角
  - 数字 → 常に半角

- 権限付与/再起動（Docker など）

- Chrome 既定ブラウザの確認ダイアログで「Chrome を使用」を選択

- 上記の「システム設定」を開く操作のあとで `make macos_custom_settings` を
  もう一度実行する。トラックパッド/キーボードまわりの設定は、後から該当パネルを
  開くとそのパネルのキャッシュ値で上書きされて元に戻ることがあるため。
