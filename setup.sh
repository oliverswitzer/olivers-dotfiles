set -e

repo_dir=$(pwd)

symlink_dotfile() {
  file_name=$1
  dest_path=$2

  repo_dotfile=$repo_dir/$file_name
  dest_dotfile=$dest_path/$file_name

  if test -f "$dest_dotfile"; then
    echo "⚠️  $dest_dotfile already exists, copying it to $file_name.bak"
    cp $dest_dotfile{,.bak}
  fi

  echo "Symlinking $repo_dotfile to $dest_dotfile..."
  ln -sf $repo_dotfile $dest_dotfile
}

function install_brew_dep() {
  formula=$1
  optional_cask_flag=$2

  if brew ls --versions $optional_cask_flag $formula > /dev/null; then
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

# BEGIN: Set up ASDF

install_brew_dep 'asdf'

set +e
echo "Installing asdf plugins"
asdf plugin add erlang
asdf plugin add golang
asdf plugin add nodejs
asdf plugin add postgres
asdf plugin add elixir

## Python only necessary for a coc-snippet vim plugin...
asdf plugin add python
asdf install
set -e

## Again, necessary for same vim plugin that uses neovim python wrapper
pip install neovim

## Install LiveBook
mix escript.install hex livebook
asdf reshim elixir

# END: Set up ASDF

# BEGIN: Dotfiles & Vim
symlink_dotfile '.zshrc' $HOME
symlink_dotfile '.zprofile' $HOME
symlink_dotfile '.tool-versions' $HOME
symlink_dotfile '.vimrc' $HOME
symlink_dotfile '.tmux.conf' $HOME
symlink_dotfile '.gitconfig' $HOME
symlink_dotfile '.p10k.zsh' $HOME

install_tmux

## Coc Config
mkdir -p ~/.config/nvim
symlink_dotfile 'coc-settings.json' $HOME/.config/nvim
symlink_dotfile 'init.vim' $HOME/.config/nvim

## Install Vim plugins
install_brew_dep 'neovim'
nvim +'PlugInstall --sync' +qa

# END: Dotfiles & Vim

# BEGIN: Install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  ## Install oh-my-zsh plugin for terminal UI: powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

## Install elixir-ls release
if [[ ! -d ~/.vim/plugged/coc-elixir/els-release ]]; then
  echo "Downloading elixir-ls into $HOME/.elixir-ls" 

  # Note that this elixir-ls release is hardcoded as 0.9.0 because I couldn't figure out
  # how to download the latest release via Github urls
  #
  # It's also better to download the release from github than to try to build the elixir-lsp
  # repo yourself to avoid backward compatibility issues with the OTP version
  # you end up building elixir-ls version with and the project you use elixir-ls
  # on
  curl -L  https://github.com/elixir-lsp/elixir-ls/releases/download/v0.9.0/elixir-ls.zip
  mkdir -p ~/.vim/plugged/coc-elixir/els-release 
  unzip elixir-ls.zip -d ~/.vim/plugged/coc-elixir/els-release
fi

# END: Install oh-my-zsh

# BEGIN: Brew Dependencies
set +e
which -s brew
if [[ $? != 0 ]] ; then
  echo "Homebrew not installed. Installing homebrew..."
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi
set -e

## Brew binaries

install_brew_dep 'tmux'
install_brew_dep 'owenthereal/upterm/upterm'
install_brew_dep 'ngrok'
install_brew_dep 'postgresql'

## Alternative to cat that displays syntax highlighting and git changes
install_brew_dep 'bat'

install_brew_dep 'chromedriver' --cask

## Unquarantine chromedriver because Apple hates Google
chromedriver_binary_path="$(brew info chromedriver | awk 'FNR==3 { print $0 }' | awk '{print $1}')/chromedriver"
xattr -d com.apple.quarantine $chromedriver_binary_path

install_brew_dep 'gpg2'
install_brew_dep 'direnv'
install_brew_dep 'the_silver_searcher'
install_brew_dep 'gh'
install_brew_dep 'pulumi'
brew tap heroku/brew
install_brew_dep 'heroku'

## Necessary for kubectl to work (version is referenced in ~/.zshrc)
install_brew_dep 'python@3.8'

# Work-related
install_brew_dep 'docker' --cask
install_brew_dep 'google-chrome' --cask
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
install_brew_dep 'macdown' --cask # https://postgresapp.com/
install_brew_dep 'keycastr' --cask # https://postgresapp.com/

# Utilities
install_brew_dep 'stats' --cask
install_brew_dep 'flycut' --cask
install_brew_dep 'shiftit' --cask

# Non-work related
install_brew_dep 'flux' --cask
install_brew_dep 'vlc' --cask
install_brew_dep 'spotify' --cask

# END: Brew Dependencies
