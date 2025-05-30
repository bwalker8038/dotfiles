# ~/.config/powershell/os-linux.ps1

# Linux-specific environment setup

$env:EDITOR = "nvim"
$env:GOPATH = "$HOME/go"
$env:PATH += ":$HOME/.local/bin"
$env:PATH += ":$HOME/.poetry/bin"
$env:PATH += ":$HOME/.bun/bin"
$env:PATH += ":$HOME/.rover/bin"
$env:PATH += ":$HOME/.lib/flutter/bin"
$env:PATH += ":$HOME/.lib/cmdline-tools/bin"

# NVM
$nvmScript = "$HOME/.nvm/nvm.sh"
if (Test-Path $nvmScript) {
    . $nvmScript
}

# Rust
$cargoEnv = "$HOME/.cargo/env"
if (Test-Path $cargoEnv) {
    . $cargoEnv
}

# Wasmer
$wasmerScript = "$HOME/.wasmer/wasmer.sh"
if (Test-Path $wasmerScript) {
    . $wasmerScript
}

# FNM
if (Get-Command fnm -ErrorAction SilentlyContinue) {
  Invoke-Expression (&fnm env --use-on-cd)
}

# ASDF
$asdfScript = "$HOME/.asdf/asdf.sh"
if (Test-Path $asdfScript) {
  . $asdfScript
}

