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

## Dotfiles

symlink_dotfile '.zshrc' $HOME
symlink_dotfile '.zprofile' $HOME
symlink_dotfile '.tool-versions' $HOME
symlink_dotfile '.vimrc' $HOME
symlink_dotfile '.tmux.conf' $HOME
symlink_dotfile '.gitconfig' $HOME
symlink_dotfile '.p10k.zsh' $HOME

mkdir ~/.tmux && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Coc Config
mkdir -p ~/.config/nvim
symlink_dotfile 'coc-settings.json' $HOME/.config/nvim
symlink_dotfile 'init.vim' $HOME/.config/nvim

## Brew Dependencies

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

#### Binaries

install_brew_dep 'neovim'
install_brew_dep 'tmux'
install_brew_dep 'upterm'
install_brew_dep 'ngrok'
install_brew_dep 'postgresql'
install_brew_dep 'asdf'
install_brew_dep 'gpg2'
install_brew_dep 'direnv'
install_brew_dep 'the_silver_searcher'
install_brew_dep 'gh'
install_brew_dep 'pulumi'

asdf plugin add erlang
asdf plugin add golang
asdf plugin add nodejs
asdf plugin add postgres
asdf plugin add python
asdf install

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install oh-my-zsh plugin for terminal UI: powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

#### Applications

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

# Utilities
install_brew_dep 'stats' --cask
install_brew_dep 'flycut' --cask
install_brew_dep 'shiftit' --cask

# Non-work related
install_brew_dep 'flux' --cask
install_brew_dep 'vlc' --cask
install_brew_dep 'spotify' --cask
