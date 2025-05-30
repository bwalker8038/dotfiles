# Shared aliases
source ~/.config/shell/aliases.sh

# OS-specific config
case "$OSTYPE" in
  darwin*)  source ~/.config/shell/os-macos.sh ;;
  linux*)   source ~/.config/shell/os-linux.sh ;;
esac

