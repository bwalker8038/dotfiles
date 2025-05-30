#!/usr/bin/env bash
set -euo pipefail

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

log() { echo -e "\033[1;32m[bootstrap]\033[0m $1"; }

install_package() {
  local pkg=$1
  if command -v brew &>/dev/null; then
    brew install "$pkg"
  elif command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y "$pkg"
  elif command -v winget &>/dev/null; then
    winget install --id="$pkg" --source=winget --accept-package-agreements
  else
    log "No supported package manager found."
    return 1
  fi
}

symlink() {
  src=$1
  dest=$2
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  log "Linked $src → $dest"
}

# --- Symlink configs ---

log "Linking dotfiles..."
symlink "$HOME/dotfiles/.config/zsh/.zshrc" "$HOME/.zshrc"
symlink "$HOME/dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"
symlink "$HOME/dotfiles/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
symlink "$HOME/dotfiles/.config/nvim" "$HOME/.config/nvim"
symlink "$HOME/dotfiles/.config/powershell/Microsoft.PowerShell_profile.ps1" "$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"

# --- Install TPM ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Installing tmux TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  log "TPM already installed."
fi

# --- Install asdf ---
if ! command -v asdf &>/dev/null; then
  log "Installing asdf..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
  . "$HOME/.asdf/asdf.sh"
else
  log "asdf already installed."
fi

# --- Install asdf plugins ---
plugins=("nodejs" "python" "golang")
for plugin in "${plugins[@]}"; do
  if ! asdf plugin list | grep -q "$plugin"; then
    log "Adding asdf plugin: $plugin"
    asdf plugin add "$plugin"
  fi
done

if [ -f "$HOME/dotfiles/.tool-versions" ]; then
  log "Installing tools from .tool-versions..."
  asdf install
fi

# --- Install fnm ---
if ! command -v fnm &>/dev/null; then
  log "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
else
  log "fnm already installed."
fi

log "Bootstrap complete! Reload your shell or start a new session."

