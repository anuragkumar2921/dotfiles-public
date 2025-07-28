# History configuration
# --------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# History options
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Word chars (affects word-based navigation)
export WORDCHARS='*?_[]~&;!#$%^(){}<>'

# Default editors
export VISUAL=nvim
export EDITOR=nvim
