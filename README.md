# dotfiles

Portable Zsh configuration using Oh My Zsh and Powerlevel10k.

## Install

```sh
git clone git@github.com:YOUR_GITHUB_USERNAME/dotfiles.git ~/dotfiles
sh ~/dotfiles/install.sh
```

The installer installs Git and Zsh when they are missing (using the system
package manager), then does the rest. It does not replace existing `~/.zshrc`
or `~/.p10k.zsh`; back them up first if you want it to manage them.

It installs Oh My Zsh plus these custom plugins:

- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `powerlevel10k`

The following tools are optional. The configuration activates their integration
only when installed: autojump, NVM, Google Cloud SDK, GAM, Neovim, Ollama, and
the AWS CLI.
