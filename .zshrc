# Base directory for zsh config
ZSH_CONFIG_DIR="$HOME/dotfiles-public/zsh"

# Source core files
source "$ZSH_CONFIG_DIR/plugins.zsh"
source "$ZSH_CONFIG_DIR/options.zsh"
source "$ZSH_CONFIG_DIR/env.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/integrations.zsh"

# Display system info on startup
neofetch

