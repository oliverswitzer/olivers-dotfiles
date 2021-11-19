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


## Brew Dependencies

#### Binaries

install_brew_dep 'neovim'
install_brew_dep 'tmux'
install_brew_dep 'upterm'

#### Applications

# Work-related
install_brew_dep 'docker' --cask
install_brew_dep 'dash' --cask
install_brew_dep 'slack' --cask
install_brew_dep 'tandem' --cask
install_brew_dep 'iterm2' --cask
install_brew_dep '1password' --cask
install_brew_dep 'postman' --cask
install_brew_dep 'zoom' --cask
install_brew_dep 'visual-studio-code' --cask

# Utilities
install_brew_dep 'stats' --cask
install_brew_dep 'flycut' --cask
install_brew_dep 'shiftit' --cask

# Non-work related
install_brew_dep 'flux' --cask
install_brew_dep 'vlc' --cask
install_brew_dep 'spotify' --cask

## Dotfiles

symlink_dotfile '.zshrc' $HOME
symlink_dotfile '.vimrc' $HOME
symlink_dotfile '.tmux.conf' $HOME
symlink_dotfile '.gitconfig' $HOME

mkdir ~/.tmux && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Coc Config
mkdir -p ~/.config/nvim
symlink_dotfile 'coc-settings.json' $HOME/.config/nvim
symlink_dotfile 'init.vim' $HOME/.config/nvim
