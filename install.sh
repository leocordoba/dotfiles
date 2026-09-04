#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
zsh_dir="$repo_dir/zsh"
omz_dir="$HOME/.oh-my-zsh"

install_packages() {
  if [ "$(id -u)" -eq 0 ]; then
    sudo_cmd=''
  elif command -v sudo >/dev/null 2>&1; then
    sudo_cmd='sudo'
  else
    print -u2 'Installing prerequisites requires root access or sudo.'
    exit 1
  fi

  if command -v apt-get >/dev/null 2>&1; then
    $sudo_cmd apt-get update
    $sudo_cmd apt-get install -y git zsh
  elif command -v dnf >/dev/null 2>&1; then
    $sudo_cmd dnf install -y git zsh
  elif command -v pacman >/dev/null 2>&1; then
    $sudo_cmd pacman -Sy --noconfirm git zsh
  elif command -v brew >/dev/null 2>&1; then
    brew install git zsh
  else
    printf '%s\n' 'Unsupported package manager. Install git and zsh, then rerun.' >&2
    exit 1
  fi
}

if ! command -v git >/dev/null 2>&1 || ! command -v zsh >/dev/null 2>&1; then
  install_packages
fi

if [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ] || [ -e "$HOME/.p10k.zsh" ] || [ -L "$HOME/.p10k.zsh" ]; then
  printf '%s\n' 'Refusing to replace an existing ~/.zshrc or ~/.p10k.zsh.' >&2
  printf '%s\n' 'Back up or remove those files, then rerun this script.' >&2
  exit 1
fi

if [ ! -d "$omz_dir" ]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
fi

install_plugin() {
  name=$1
  url=$2
  target="$omz_dir/custom/plugins/$name"
  [ -d "$target" ] || git clone --depth=1 "$url" "$target"
}
install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
install_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

theme_dir="$omz_dir/custom/themes/powerlevel10k"
[ -d "$theme_dir" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"

ln -s "$zsh_dir/.zshrc" "$HOME/.zshrc"
ln -s "$zsh_dir/.p10k.zsh" "$HOME/.p10k.zsh"
printf '%s\n' 'Installed. Start a new Zsh session to load the configuration.'
