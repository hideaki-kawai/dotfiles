# 全実行
all: init link defaults brew

# init.shを実行
init:
	@echo "\033[0;34mRun init.sh\033[0m"
	@.bin/init.sh
	@echo "\033[0;34mDone.\033[0m"

# macos_defaults.shを実行
defaults:
	@echo "\033[0;34mRun macos_defaults.sh\033[0m"
	@.bin/macos_custom_settings.sh
	@echo "\033[0;32mDone.\033[0m"

# brew.shを実行
brew:
	@echo "\033[0;34mRun brew.sh\033[0m"
	@.bin/brew.sh
	@echo "\033[0;32mDone.\033[0m"