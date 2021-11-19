set -e

copy_dotfile() {
  file_name=$1
  current_dir=$(pwd)

  repo_path=$current_dir/$file_name
  home_path=$HOME/$file_name

  if test -f "$home_path"; then
    echo "⚠️  $home_path already exists, copying it to $file_name.bak"
    cp -n $home_path{,.bak}
  fi

  ln -sf $repo_path $home_path
}

copy_dotfile '.zshrc'
copy_dotfile '.vimrc'
copy_dotfile '.tmux.conf'

