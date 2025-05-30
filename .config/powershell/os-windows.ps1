# ~/.config/powershell/os-windows.ps1

# Windows-specific environment setup

$env:EDITOR = "nvim"
$env:GOPATH = "$HOME/go"
$env:Path += ";$HOME/.bun/bin"
$env:Path += ";$HOME/.poetry/bin"
$env:Path += ";$HOME/.rover/bin"
$env:Path += ";$HOME/.cargo/bin"

# FNM
if (Get-Command fnm -ErrorAction SilentlyContinue) {
  Invoke-Expression (&fnm env --use-on-cd)
}

# ASDF
$asdfScript = "$HOME/.asdf/asdf.sh"
if (Test-Path $asdfScript) {
  . $asdfScript
}

