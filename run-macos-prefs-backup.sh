#!/bin/bash

function install_brew_dep() {
	formula=$1
	optional_cask_flag=$2

	if brew ls --versions $optional_cask_flag $formula >/dev/null; then
		echo "✅ '$formula' is already installed"
	else
		echo "'$formula' is not installed"
		echo "⏳ Installing '$formula'"
		HOMEBREW_NO_AUTO_UPDATE=1 brew install $2 $formula
		brew install $2 $formula
	fi
}

install_brew_dep sijanc147/formulas/macprefs

echo "Backing up Macbook preferences to $MACPREFS_BACKUP_DIR..."
export MACPREFS_BACKUP_DIR=$HOME/.macprefs-backup
mkdir -p $MACPREFS_BACKUP_DIR

echo "⚠️  IMPORTANT: Remember to sync this folder with Google Drive!"
macprefs backup -t system_preferences startup_items shared_file_lists preferences app_store_preferences internet_accounts
