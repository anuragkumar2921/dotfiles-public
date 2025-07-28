# =============================================================================
#                                   ALIASES
# =============================================================================
#
# -----------------------------------------------------------------------------
# Add alias function
# -----------------------------------------------------------------------------
add_alias() {
  if [ $# -lt 2 ]; then
    echo "Usage: add-alias <alias_name> <command>"
    return 1
  fi
  
  local alias_name="$1"
  shift
  local alias_command="$*"
  
  # Add the alias to aliases.zsh
  echo "alias ${alias_name}='${alias_command}'" >> ~/dotfiles/zsh/aliases.zsh
  
  # Create the alias in the current session
  alias "${alias_name}"="${alias_command}"
  
  echo "Alias '${alias_name}' added successfully."
}
# -----------------------------------------------------------------------------
# Navigation
# -----------------------------------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Zoxide alias
alias cd='z'

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------
alias gs="git status"
alias gd="git diff"
alias gc="git checkout"
alias pull="git pull"
alias push="git push"
alias gl="git log"
alias ga="git add"
alias gr="git restore"
alias gco="git commit -m"
alias lg="lazygit"

# -----------------------------------------------------------------------------
# System
# -----------------------------------------------------------------------------
alias src="source ~/.zshrc"
alias vsh="nvim ~/.zshrc" 
alias hs="history | grep"
alias c="clear"
alias vim="nvim"

# Config files
alias gsh="nvim ~/.config/ghostty/config"
alias ksh="nvim ~/.config/kitty/kitty.conf"
alias ash="vim ~/.aws/config"

# -----------------------------------------------------------------------------
# File operations
# -----------------------------------------------------------------------------
# File listing (eza)
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons' 
alias la='eza --long --all --group --group-directories-first'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
alias lS='eza -1 --color=always --group-directories-first --icons'
alias ltree='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"

# File searching/editing
alias fvim="fd --type f --hidden --exclude .git | fzf --preview='bat --color=always {}' | xargs nvim"
alias cat='bat'

# -----------------------------------------------------------------------------
# Development tools
# -----------------------------------------------------------------------------
# Tmux
alias detach="tmux detach"
alias new="tmux new -s "
alias attach="tmux attach -t"

# Homebrew
alias bs="brew search"
alias bi="brew install"
alias bu="brew uninstall"

# Docker
alias lzd="lazydocker"

# Leetcode
alias leetcode='nvim leetcode.nvim'

# -----------------------------------------------------------------------------
# Music
# -----------------------------------------------------------------------------
alias mpd_start="mpd ~/.config/mpd/mpd.conf"
alias mpd_stop="killall mpd"
alias mpd_status="lsof -i TCP:6700"

# -----------------------------------------------------------------------------
# Other
# -----------------------------------------------------------------------------
alias fcd='dir=$(fd -t d . ~ | fzf) && [ -n "$dir" ] && cd "$dir"'
alias fcwd='dir=$(fd -t d | fzf) && [ -n "$dir" ] && cd "$dir"'
