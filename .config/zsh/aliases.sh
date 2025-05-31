# ~/.config/zsh/aliases.sh

# Safer file operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List directory contents
alias ls='ls --color=auto'  # For Linux
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias ga='git add .'
alias gc='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias lg='lazygit'

# Reload shell
alias reload='exec "$SHELL" -l'

# Docker
alias d='docker'
alias dc='docker compose'

# Quick edit configs
alias ezsh='nvim ~/.zshrc'
alias etmux='nvim ~/.tmux.conf'
alias envim='nvim ~/.config/nvim/init.lua'

# System
alias update='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'

# Asdf / Node helpers
alias nr='npm run'
alias ni='npm install'
alias y='yarn'

# Use bat if available
command -v bat &>/dev/null && alias cat='bat'
