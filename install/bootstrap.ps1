$ErrorActionPreference = "Stop"

# --- Functions ---
function Log($msg) {
  Write-Host "[bootstrap] $msg" -ForegroundColor Green
}

function Install-Package {
  param([string]$name)

  if ($IsMacOS -and (Get-Command brew -ErrorAction SilentlyContinue)) {
    Log "Installing $name with Homebrew..."
    brew install $name
  }
  elseif ($IsWindows -and (Get-Command winget -ErrorAction SilentlyContinue)) {
    Log "Installing $name with winget..."
    winget install --id "$name" --source winget --accept-package-agreements --accept-source-agreements
  }
  else {
    Log "⚠ No supported package manager found. Please install $name manually."
  }
}

function Link-Config {
  param(
    [string]$Source,
    [string]$Target
  )

  Log "Linking from $Source to $Target"

  if (-Not (Test-Path (Split-Path $Target))) {
    New-Item -ItemType Directory -Path (Split-Path $Target) -Force | Out-Null
  }

  if (Test-Path $Target -PathType Any) {
    Remove-Item -Path $Target -Force -Recurse
    Log "Removed existing $Target"
  }

  try {
    New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force -ErrorAction Stop | Out-Null
    Log "Linked $Source → $Target (symlink)"
  }
  catch {
    Log "⚠ Failed to create symlink. Falling back to copy."
    Copy-Item -Path $Source -Destination $Target -Recurse -Force
    Log "Copied $Source → $Target"
  }
}

# --- Setup Variables ---
$userHome = $env:HOME ?? $env:USERPROFILE
$dotfilesPath = "$userHome/dotfiles/.config"

# --- Link Shared Config Files ---
Log "Linking shared config files..."

Link-Config "$dotfilesPath/starship.toml" "$userHome/.config/starship.toml"

# --- OS-specific Config Linking ---
if ($IsMacOS) {
  Link-Config "$dotfilesPath/powershell/Microsoft.PowerShell_profile.ps1" "$userHome/.config/powershell/Microsoft.PowerShell_profile.ps1"
  Link-Config "$dotfilesPath/powershell/os-macos.ps1" "$userHome/.config/powershell/os-macos.ps1"
}
elseif ($IsWindows) {
  Link-Config "$dotfilesPath/powershell/Microsoft.PowerShell_profile.ps1" "$userHome\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
  Link-Config "$dotfilesPath/powershell/os-windows.ps1" "$userHome/.config/powershell/os-windows.ps1"
}
elseif ($IsLinux) {
  Link-Config "$dotfilesPath/powershell/Microsoft.PowerShell_profile.ps1" "$userHome/.config/powershell/Microsoft.PowerShell_profile.ps1"
  Link-Config "$dotfilesPath/powershell/os-linux.ps1" "$userHome/.config/powershell/os-linux.ps1"
}

# --- TPM (tmux plugin manager) ---
$tpmPath = "$userHome/.tmux/plugins/tpm"
if (-Not (Test-Path $tpmPath)) {
  Log "Cloning TPM..."
  git clone https://github.com/tmux-plugins/tpm $tpmPath
}
else {
  Log "TPM already installed."
}

# --- Install Tools (fnm, zoxide, starship) ---
$tools = @("fnm", "zoxide", "starship")
foreach ($tool in $tools) {
  if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
    Install-Package $tool
  }
  else {
    Log "$tool already installed."
  }
}

# --- asdf (optional) ---
if (-Not (Test-Path "$userHome/.asdf")) {
  Log "asdf not installed. If needed, install it manually: https://asdf-vm.com/"
}
else {
  Log "asdf already present."
}

Log "✅ Bootstrap complete! Restart PowerShell to apply changes."
