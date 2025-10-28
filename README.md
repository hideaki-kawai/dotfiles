# dotfiles (2025 Edition)

Mac を買い替えた直後に、**一発でいつもの環境**に整えるためのセットです。  
Apple Silicon 想定。

## できること
- macOS の初期設定（トラックパッド/キーボード/Dock/省電力 ほか）
- Homebrew のインストール & PATH 設定
- GUI/CLI アプリのインストール（brew/cask）
- `volta`（Node）、`pyenv`（Python）のセットアップ & PATH 設定

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

- 権限付与/再起動（Logi Options+/Docker など）

- Chrome 既定ブラウザの確認ダイアログで「Chrome を使用」を選択