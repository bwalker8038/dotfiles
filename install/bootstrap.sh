#!/usr/bin/env bash
set -euo pipefail

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
DOTFILES="$HOME/dotfiles/.config"
BIN_DIR="$HOME/bin"

log() {
  echo -e "\033[1;32m[bootstrap]\033[0m $1"
}

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
  local src
  src=$(realpath "$1")
  local dest=$2

  # Avoid linking into the dotfiles repo itself
  if [[ "$dest" == "$DOTFILES"* ]]; then
    log "⚠ Skipping $dest — avoiding symlink into dotfiles"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  log "Linked $src → $dest"
}

# --- Symlink config files ---
log "Linking dotfiles..."

symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
symlink "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"
symlink "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
symlink "$DOTFILES/eslint" "$HOME/.config/eslint"
symlink "$DOTFILES/powershell/Microsoft.PowerShell_profile.ps1" "$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"

# --- Install oh-my-zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "oh-my-zsh already installed."
fi

# --- Install TPM for tmux ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Installing tmux TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  log "TPM already installed."
fi

# --- Install asdf ---
if [ ! -d "$HOME/.asdf" ]; then
  log "Installing asdf..."
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.13.1
else
  log "asdf already installed."
fi

# Load asdf for use in this script
. "$HOME/.asdf/asdf.sh"

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
  cp "$HOME/dotfiles/.tool-versions" "$HOME/.tool-versions"
  asdf install
fi

# --- Install fnm ---
if ! command -v fnm &>/dev/null; then
  log "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
else
  log "fnm already installed."
fi

# --- Global ESLint Setup ---
ESLINT_GLOBAL_CONFIG="$HOME/.config/eslint/eslint.config.mjs"
ESLINT_INSTALL_SCRIPT="$HOME/.config/eslint/install-global-eslint-deps.sh"
ESLINT_WRAPPER="$HOME/.config/eslint/eslint-global"

if [ -f "$ESLINT_GLOBAL_CONFIG" ]; then
  if [ -x "$ESLINT_INSTALL_SCRIPT" ]; then
    log "Installing global ESLint dependencies..."
    bash "$ESLINT_INSTALL_SCRIPT"
  else
    log "Missing install-global-eslint-deps.sh. Skipping install."
  fi

  mkdir -p "$BIN_DIR"
  symlink "$ESLINT_WRAPPER" "$BIN_DIR/eslint-global"
else
  log "Missing global eslint.config.mjs. Skipping global ESLint setup."
fi

log "Bootstrap complete! Reload your shell or start a new session."
