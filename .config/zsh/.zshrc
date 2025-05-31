# Shared aliases
source ~/.config/zsh/aliases.sh

# Load oh-my-zsh plugins
export ZSH="/Users/brad/.oh-my-zsh"
ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh
plugins=(git zsh-autosuggestions)

# Starship prompt
eval "$(starship init zsh)"

# OS-specific config
case "$OSTYPE" in
  darwin*)  source ~/.config/zsh/os-macos.sh ;;
  linux*)   source ~/.config/zsh/os-linux.sh ;;
esac

