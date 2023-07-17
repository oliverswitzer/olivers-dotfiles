set -e

# Run this script simply by executing it:
#
# $ ./setup.sh
#

repo_dir=$(pwd)

symlink_dotfile() {
	file_name=$1
	dest_path=$2

	repo_dotfile=$repo_dir/$file_name
	dest_dotfile=$dest_path/$file_name

	if test -f "$dest_dotfile"; then
		echo "⚠️  $dest_dotfile dotfile already exists, copying it to $file_name.bak"
		cp $dest_dotfile{,.bak}
	fi
	if test -d "$dest_dotfile"; then
		echo "⚠️  $dest_dotfile dotfile directory already exists, recursively copying it to $file_name.bak"
		cp -fR $dest_dotfile $dest_dotfile.bak
	fi

	echo "Symlinking $repo_dotfile to $dest_dotfile..."
	ln -sf $repo_dotfile $dest_dotfile
}

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

function install_tmux() {
	mkdir ~/.tmux && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

	# To install tmux plugins you need to start a temporary tmux session...

	# start a server but don't attach to it
	tmux start-server
	# create a new session but don't attach to it either
	tmux new-session -d
	# install the plugins
	~/.tmux/plugins/tpm/scripts/install_plugins.sh
	# killing the server is not required, I guess
	tmux kill-server
}

# BEGIN: Install Homebrew

set +e
which -s brew
if [[ $? != 0 ]]; then
	echo "Homebrew not installed. Installing homebrew..."
	# Install Homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	brew update
fi
set -e

# END: Install Homebrew
# BEGIN: Set up ASDF
install_brew_dep 'asdf'

set +e
echo "Installing asdf plugins"
asdf plugin add erlang
asdf plugin add golang
asdf plugin add nodejs
asdf plugin add ruby
asdf plugin add postgres
asdf plugin add elixir
asdf plugin add java
asdf plugin add helm
asdf plugin add postgres

## Python only necessary for a coc-snippet vim plugin...
asdf plugin add python

symlink_dotfile '.tool-versions' $HOME

# KERL options might only be needed on intel machines
KERL_CONFIGURE_OPTIONS="--without-wx" asdf install erlang
asdf install
set -e

# END: Set up ASDF

# BEGIN: Dotfiles
symlink_dotfile '.zshrc' $HOME
symlink_dotfile '.zprofile' $HOME
symlink_dotfile '.tool-versions' $HOME
symlink_dotfile '.tmux.conf' $HOME
symlink_dotfile '.gitconfig' $HOME
symlink_dotfile '.p10k.zsh' $HOME

# A hack until I figure out why the symlink_dotfile function is broken for directories
rm -rf ~/.hammerspoon{,.bak}
symlink_dotfile '.hammerspoon' $HOME

echo "⚠️  IMPORTANT NOTE ⚠️"
echo "Please copy .envrc.sample to ~/.envrc and fill out the values!"

install_brew_dep 'neovim'
rm -rf ~/.config/nvim{,.bak}
mkdir -p ~/.config/nvim

symlink_dotfile 'nvim' $HOME/.config

install_brew_dep 'tmux'
install_tmux

# END: Dotfiles & Vim

# BEGIN: Install oh-my-zsh

if [[ ! -d ~/.oh-my-zsh ]]; then
	echo "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
	## Install oh-my-zsh plugin for terminal UI: powerlevel10k
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	p10k configure
fi

# END: Install oh-my-zsh

## Again, necessary for same vim plugin that uses neovim python wrapper
pip3 install neovim

## Install LiveBook
mix escript.install hex livebook
asdf reshim elixir

# Used to sort tailwind class selectors
npm install -g rustywind

# BEGIN: Install Arduino-related tooling

install_brew_dep 'arduino-cli'
go install github.com/arduino/arduino-language-server@latest

# END: Install Arduino-related tooling

# BEGIN: Brew Dependencies

## Brew binaries

install_brew_dep 'owenthereal/upterm/upterm'
install_brew_dep 'ngrok'

## Alternative to cat that displays syntax highlighting and git changes
install_brew_dep 'bat'

## Used by null-ls language server to format bash
install_brew_dep 'shfmt'

install_brew_dep 'chromedriver' --cask

## Unquarantine chromedriver because Apple hates Google
chromedriver_binary_path="$(brew info chromedriver | awk 'FNR==3 { print $0 }' | awk '{print $1}')/chromedriver"
xattr -d com.apple.quarantine $chromedriver_binary_path

install_brew_dep 'gpg2'
install_brew_dep 'direnv'
install_brew_dep 'the_silver_searcher'
install_brew_dep 'ripgrep'
install_brew_dep 'gh'
install_brew_dep 'pulumi'
install_brew_dep 'thefuck'
install_brew_dep 'tfk8s' # A tool for converting k8s manifests to terraform
install_brew_dep 'terraformer'

brew tap heroku/brew
install_brew_dep 'heroku'

## Necessary for kubectl to work (version is referenced in ~/.zshrc)
install_brew_dep 'python@3.8'

# Work-related
install_brew_dep 'docker' --cask
install_brew_dep 'google-chrome' --cask
install_brew_dep 'firefox' --cask
install_brew_dep 'dash' --cask
install_brew_dep 'slack' --cask
install_brew_dep 'tandem' --cask
install_brew_dep 'iterm2' --cask
install_brew_dep '1password' --cask
install_brew_dep 'postman' --cask
install_brew_dep 'zoom' --cask
install_brew_dep 'visual-studio-code' --cask
install_brew_dep 'google-cloud-sdk' --cask
install_brew_dep 'intellij-idea-ce' --cask
install_brew_dep 'postgres-unofficial' --cask # https://postgresapp.com/
install_brew_dep 'macdown' --cask 
install_brew_dep 'keycastr' --cask # Shows what modifier keys you're pressing 
install_brew_dep 'appcleaner' --cask  # Easily delete apps and their cache / preference files
install_brew_dep 'karabiner-elements' --cask # For easily switching keybindings via the "profiles" feature. Useful for Kinesis keyboard mapping.

# Utilities
install_brew_dep 'stats' --cask
install_brew_dep 'flycut' --cask


# shiftit keeps getting broken on updates to MacOS, so I've switched over to
# using Hammerspoon in combination with a hammerspoon-shiftit configuration.
#   See:
#     * hammerspoon: https://github.com/Hammerspoon/hammerspoon
#     * hammerspoon-shifit: https://github.com/peterklijn/hammerspoon-shiftit
# install_brew_dep 'shiftit' --cask
install_brew_dep 'hammerspoon' --cask

# Non-work related
install_brew_dep 'flux' --cask
install_brew_dep 'vlc' --cask
install_brew_dep 'spotify' --cask

# END: Brew Dependencies

cat << "EOF"
███████╗██╗███╗   ██╗██╗███████╗██╗  ██╗███████╗██████╗ 
██╔════╝██║████╗  ██║██║██╔════╝██║  ██║██╔════╝██╔══██╗
█████╗  ██║██╔██╗ ██║██║███████╗███████║█████╗  ██║  ██║
██╔══╝  ██║██║╚██╗██║██║╚════██║██╔══██║██╔══╝  ██║  ██║
██║     ██║██║ ╚████║██║███████║██║  ██║███████╗██████╔╝
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═════╝
EOF

echo "Done installing brew cask tools!"
echo "Here's a list of tools that you use that do not exist in Homebrew"
echo "* wireguard: https://www.wireguard.com/install/"
echo "* displaylink manager for multiple monitors (to be used in tandem with the dual displaylink USB-C adapter): https://www.synaptics.com/products/displaylink-graphics/downloads/macos"

