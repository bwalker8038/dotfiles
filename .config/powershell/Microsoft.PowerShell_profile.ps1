# ~/.config/powershell/Microsoft.PowerShell_profile.ps1

# Starship prompt
Invoke-Expression (&starship init powershell)

# Zoxide navigation
Invoke-Expression (&zoxide init powershell)

# Set aliases
Set-Alias ll Get-ChildItem
Set-Alias la "Get-ChildItem -Force"
Set-Alias vim nvim
Set-Alias gs git status
Set-Alias gl git pull
Set-Alias gp git push

# History settings
Set-PSReadLineOption -HistorySavePath "$HOME/.config/powershell/history.txt"
Set-PSReadLineOption -MaximumHistoryCount 10000

# OS-specific logic
if ($IsWindows) {
    . "$HOME/.config/powershell/os-windows.ps1"
} elseif ($IsLinux) {
    . "$HOME/.config/powershell/os-linux.ps1"
} elseif ($IsMacOS) {
    . "$HOME/.config/powershell/os-macos.ps1"
}

# Optional: update title bar
$Host.UI.RawUI.WindowTitle = "pwsh :: $($env:COMPUTERNAME ?? $env:HOSTNAME) :: $(Get-Location)"

