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

echo "Restoring Macbook preferences from $MACPREFS_BACKUP_DIR..."
export MACPREFS_BACKUP_DIR=$HOME/.macprefs-backup

echo "IMPORTANT: Give iTerm or Terminal full disk access for macprefs to run!"
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

if [ ! -d $MACPREFS_BACKUP_DIR ]; then
  echo "Backup directory $MACPREFS_BACKUP_DIR not present... Please copy in a previous macprefs store to this path before running this file"
  exit 1;
fi


echo "⚠️  IMPORTANT: Remember to sync this folder with Google Drive!"
macprefs restore
