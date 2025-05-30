# ~/.config/powershell/os-windows.ps1

# Windows-specific environment setup

$env:EDITOR = "nvim"
$env:GOPATH = "$HOME/go"
$env:Path += ";$HOME/.bun/bin"
$env:Path += ";$HOME/.poetry/bin"
$env:Path += ";$HOME/.rover/bin"
$env:Path += ";$HOME/.cargo/bin"

# NVM for Windows (if using nvm-windows)
# Deprecated
$nvmPath = "$env:ProgramFiles\nvm"
if (Test-Path "$nvmPath") {
    $env:NVM_HOME = $nvmPath
    $env:NVM_SYMLINK = "$env:ProgramFiles\nodejs"
    $env:PATH = "$env:NVM_HOME;$env:NVM_SYMLINK;" + $env:PATH
}

# Conda
$condaPath = "$HOME\miniconda3\Scripts\conda.exe"
if (Test-Path $condaPath) {
    & $condaPath "shell.powershell" "hook" | Out-String | Invoke-Expression
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

