# --- Helpers ---
function Log($msg) {
  Write-Host "[init] $msg" -ForegroundColor Gray
}

function Test-HasXcodeCLI {
  Test-Path "/Library/Developer/CommandLineTools/usr/bin/git"
}

function Safe-Source-Shim {
  param (
    [string]$Name,
    [string]$Path
  )

  if ((Test-Path $Path) -and (Test-HasXcodeCLI)) {
    Log "Setting up $Name shims (PowerShell-safe)"
    switch ($Name) {
      "asdf" {
        $env:ASDF_DIR = "$HOME/.asdf"
        $env:PATH = "$env:ASDF_DIR/shims:$env:PATH"
      }
      "wasmer" {
        $env:PATH = "$HOME/.wasmer/bin:$env:PATH"
      }
    }
  }
  else {
    Log "Skipping $Name (not available or Xcode CLI missing)"
  }
}

# --- Core environment ---
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

# --- Chrome Dev ---
$env:CHROME_EXECUTABLE = "/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev"

# --- Starship ---
if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell | Out-String)
}

# --- Zoxide ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (&zoxide init powershell | Out-String)
}

# --- FNM ---
if (Get-Command fnm -ErrorAction SilentlyContinue) {
  Invoke-Expression (&fnm env --use-on-cd --shell=powershell | Out-String)
}

# --- asdf and wasmer (Bash-only setup guarded) ---
Safe-Source-Shim "asdf" "$HOME/.asdf/asdf.sh"
Safe-Source-Shim "wasmer" "$HOME/.wasmer/wasmer.sh"
