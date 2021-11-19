set -e

repo_dir=$(pwd)

symlink_dotfile() {
  file_name=$1
  dest_path=$2

  repo_dotfile=$repo_dir/$file_name
  dest_dotfile=$dest_path/$file_name

  if test -f "$dest_dotfile"; then
    echo "⚠️  $dest_dotfile already exists, copying it to $file_name.bak"
    cp -n $dest_dotfile{,.bak}
  fi

  echo "Symlinking $repo_dotfile to $dest_dotfile..."
  ln -sf $repo_dotfile $dest_dotfile
}

function install_brew_dep() {
  formula=$1

  if brew ls --versions $2 $formula > /dev/null; then
    echo "✅ '$formula' is already installed"
  else
    echo "'$formula' is not installed"
    echo "⏳ Installing '$formula'"
    brew install $2 $formula
  fi
}


# Install brew dpes
install_brew_dep 'neovim'
install_brew_dep 'tmux'
install_brew_dep 'upterm'
install_brew_dep 'docker' --cask

mkdir ~/.tmux && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy over dotfiles
symlink_dotfile '.zshrc' $HOME
symlink_dotfile '.vimrc' $HOME
symlink_dotfile '.tmux.conf' $HOME
symlink_dotfile '.gitconfig' $HOME

# Coc Config
[ -d ~/.config/nvim/ ] \
  && symlink_dotfile 'coc-settings.json' $HOME/.config/nvim
