$ErrorActionPreference = "Stop"

function Log($msg) {
  Write-Host "[bootstrap] $msg" -ForegroundColor Green
}

function Install-Package {
  param([string]$name)

  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Log "Installing $name with winget..."
    winget install --id "$name" --source winget --accept-package-agreements --accept-source-agreements
  } else {
    Log "Winget not found. Please install $name manually."
  }
}

function Link-Config {
  param(
    [string]$Source,
    [string]$Target
  )
  if (-Not (Test-Path (Split-Path $Target))) {
    New-Item -ItemType Directory -Path (Split-Path $Target) -Force
  }
  New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
  Log "Linked $Source → $Target"
}

# --- Symlinks ---
$userHome = $env:USERPROFILE
Log "Linking config files..."

Link-Config "$userHome\dotfiles\.config\starship.toml" "$home\.config\starship.toml"
Link-Config "$userHome\dotfiles\.config\powershell\Microsoft.PowerShell_profile.ps1" "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# Optional: if using WSL or Git Bash and want zsh compatibility
# Link-Config "$userHome\dotfiles\.config\zsh\.zshrc" "$home\.zshrc"

# --- TPM ---
$tpmPath = "$userHome\.tmux\plugins\tpm"
if (-Not (Test-Path $tpmPath)) {
  Log "Cloning TPM..."
  git clone https://github.com/tmux-plugins/tpm $tpmPath
} else {
  Log "TPM already installed."
}


# --- fnm ---
if (-not (Get-Command fnm -ErrorAction SilentlyContinue)) {
  Log "Installing fnm via winget..."
  winget install Schniz.fnm --accept-package-agreements --accept-source-agreements
} else {
  Log "fnm already installed."
}

# --- asdf (Windows via WSL is best) ---
if (-Not (Test-Path "$userHome\.asdf")) {
  Log "asdf not installed. Note: Windows support is limited. Recommend using WSL for full functionality."
}

Log "Bootstrap complete! Restart PowerShell to apply."
