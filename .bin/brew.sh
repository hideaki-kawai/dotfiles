#!/bin/bash

# MacOSチェック
if [ "$(uname)" != "Darwin" ] ; then
  echo "Error: This script is not running on macOS."
  exit 1
fi

# インストールコマンド
brew install --cask google-chrome google-japanese-ime clipy scroll-reverser visual-studio-code notion displaylink iterm2 sourcetree docker logi-options-plus

brew install nvm pyenv awscli tree