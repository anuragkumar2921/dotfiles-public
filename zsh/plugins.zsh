# Zinit setup and plugin management
# ---------------------------------

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


# Core plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light jeffreytse/zsh-vi-mode

# VI mode settings
# Reduce delay when switching modes (default is 0.4 seconds)
ZVM_ESCAPE_KEYTIMEOUT=0.03
ZVM_CURSOR_STYLE_ENABLED=false
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
zvm_after_init_commands+=('[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh')

# Completions
# -----------

# Rust/Cargo completion
zinit ice as"completion"
zinit snippet https://github.com/rust-lang/cargo/blob/master/src/etc/_cargo

# Terraform completion
zinit ice as"completion" wait lucid
zinit snippet OMZP::terraform/_terraform
zinit snippet OMZP::terraform/terraform.plugin.zsh

# Manual completion: Add directory to fpath if not already present
if (( ! ${fpath[(I)$HOME/dotfiles/zsh/zsh-manual-completion]} )); then
  fpath=($HOME/dotfiles/zsh/zsh-manual-completion $fpath)
fi

# Load completions for brew and brew installed packages
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:complete:(cd|z|__zoxide_z):*' fzf-preview 'eza -1 --tree --level=1 --color=always --group-directories-first --icons $realpath'

# Load completions system
autoload -Uz compinit && compinit
zinit cdreplay -q
