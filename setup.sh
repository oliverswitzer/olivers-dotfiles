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

symlink_dotfile '.zshrc' $HOME
symlink_dotfile '.vimrc' $HOME
symlink_dotfile '.tmux.conf' $HOME
symlink_dotfile '.gitconfig' $HOME

[ -d ~/.config/nvim/ ] \
  && symlink_dotfile 'coc-settings.json' $HOME/.config/nvim

mkdir ~/.tmux && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
