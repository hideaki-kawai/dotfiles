# ------------------------------
# Makefile
# ------------------------------

# Run everything
all: init macos_custom_settings brew

# 1) Homebrew install & PATH
init:
	@echo "\033[0;34mRun init.sh\033[0m"
	@.bin/init.sh
	@echo "\033[0;34mDone.\033[0m"

# 2) macOS defaults & power settings
macos_custom_settings:
	@echo "\033[0;34mRun macos_custom_settings.sh\033[0m"
	@.bin/macos_custom_settings.sh
	@echo "\033[0;32mDone.\033[0m"

# 3) Install apps (brew/cask) + volta/pyenv PATH setup
brew:
	@echo "\033[0;34mRun brew.sh\033[0m"
	@.bin/brew.sh
	@echo "\033[0;32mDone.\033[0m"