# ~/.config/zsh/os-macos.sh

# macOS-specific environment setup

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# RVM
export PATH="$PATH:$HOME/.rvm/bin"

# Go
export GOPATH="$HOME/go"
export GOTOOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:$GOROOT/bin"

# Poetry
export PATH="$HOME/.poetry/bin:$PATH"

# Postgres.app
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# LOVE2D
alias love="/Applications/love.app/Contents/MacOS/love"

# Rust/Cargo
source "$HOME/.cargo/env"

# Flutter
export PATH="$PATH:$HOME/.lib/flutter/bin"

# Android Cmdline Tools
export PATH="$PATH:$HOME/.lib/cmdline-tools/bin"

# Rover
export PATH="$PATH:$HOME/.rover/bin"

# Chrome Dev
export CHROME_EXECUTABLE="/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Swift toolchain
export PATH="/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:$PATH"

# Codeium
export PATH="$HOME/.codeium/windsurf/bin:$PATH"


# FNM (Fast Node Manager)
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# ASDF Version Manager
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
fi

if [ -f "$HOME/.asdf/completions/asdf.bash" ]; then
  . "$HOME/.asdf/completions/asdf.bash"
fi

