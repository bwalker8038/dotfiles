# ~/.config/powershell/os-macos.ps1

# macOS-specific environment setup

$env:EDITOR = "nvim"
$env:GOPATH = "$HOME/go"
$env:GOTOOT = "$(brew --prefix golang)/libexec"
$env:PATH += ":$GOTOOT/bin"
$env:PATH += ":$HOME/.bun/bin"
$env:PATH += ":$HOME/.poetry/bin"
$env:PATH += ":/Applications/Postgres.app/Contents/Versions/latest/bin"
$env:PATH += ":$HOME/.cargo/bin"
$env:PATH += ":$HOME/.lib/flutter/bin"
$env:PATH += ":$HOME/.lib/cmdline-tools/bin"
$env:PATH += ":$HOME/.rover/bin"
$env:PATH += ":$HOME/.local/bin"

# Chrome Dev
$env:CHROME_EXECUTABLE = "/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev"

# Wasmer
$wasmerScript = "$HOME/.wasmer/wasmer.sh"
if (Test-Path $wasmerScript) {
    . $wasmerScript
}

# NVM
$nvmScript = "$HOME/.nvm/nvm.sh"
if (Test-Path $nvmScript) {
    . $nvmScript
}

# Conda
$condaScript = "/Users/$env:USER/miniconda3/etc/profile.d/conda.sh"
if (Test-Path $condaScript) {
    . $condaScript
} elseif (Test-Path "/Users/$env:USER/miniconda3/bin/conda") {
    $env:PATH = "/Users/$env:USER/miniconda3/bin:" + $env:PATH
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

