#!/usr/bin/env zsh
set -euo pipefail

repo_dir=${0:A:h}
zsh_dir="$repo_dir/zsh"
omz_dir="$HOME/.oh-my-zsh"

if [[ -e "$HOME/.zshrc" || -L "$HOME/.zshrc" || -e "$HOME/.p10k.zsh" || -L "$HOME/.p10k.zsh" ]]; then
  print -u2 'Refusing to replace an existing ~/.zshrc or ~/.p10k.zsh.'
  print -u2 'Back up or remove those files, then rerun this script.'
  exit 1
fi

if [[ ! -d "$omz_dir" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
fi

typeset -A plugins=(
  zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
  zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
)
for name url in ${(kv)plugins}; do
  target="$omz_dir/custom/plugins/$name"
  [[ -d "$target" ]] || git clone --depth=1 "$url" "$target"
done

theme_dir="$omz_dir/custom/themes/powerlevel10k"
[[ -d "$theme_dir" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"

ln -s "$zsh_dir/.zshrc" "$HOME/.zshrc"
ln -s "$zsh_dir/.p10k.zsh" "$HOME/.p10k.zsh"
print 'Installed. Start a new Zsh session to load the configuration.'
