#!/usr/bin/env bash
# Installs shell tools and links the dotfiles into $HOME. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

main() {
  require_brew
  brew bundle --file "$DOTFILES/Brewfile"
  install_oh_my_zsh
  install_vim_plug
  install_tpm
  keep_git_identity
  link_dotfiles
  nvim --headless +PlugInstall +qa
  echo
  echo "Done. Open a new terminal, then in tmux press Ctrl-a I to install tmux plugins."
}

require_brew() {
  if ! command -v brew >/dev/null; then
    echo "Homebrew is required: https://brew.sh" >&2
    exit 1
  fi
}

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

install_vim_plug() {
  local plug="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
  if [ ! -f "$plug" ]; then
    curl -fLo "$plug" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

# The repo's gitconfig has no name or email, so carry them over from the current one
keep_git_identity() {
  local local_config="$HOME/.gitconfig.local"
  if [ -f "$local_config" ]; then
    return
  fi
  local name email
  name="$(git config --global user.name || true)"
  email="$(git config --global user.email || true)"
  if [ -n "$name" ]; then
    git config --file "$local_config" user.name "$name"
  fi
  if [ -n "$email" ]; then
    git config --file "$local_config" user.email "$email"
  fi
}

link_dotfiles() {
  link zsh/zshrc ~/.zshrc
  link zsh/aliases ~/.aliases
  link git/gitconfig ~/.gitconfig
  link git/githelpers ~/.githelpers
  link git/gitignore_global ~/.gitignore_global
  link tmux/tmux.conf ~/.tmux.conf
  link nvim ~/.config/nvim
  link sql/sqlfluff ~/.sqlfluff
}

# Backs up a real file before replacing it with a symlink
link() {
  local source="$DOTFILES/$1" target="$2"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backed up $target"
  fi
  mkdir -p "$(dirname "$target")"
  ln -sfn "$source" "$target"
  echo "Linked $target"
}

main "$@"
