# PATH configuration
# -----------------

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Java and Maven
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export PATH="/opt/homebrew/opt/tomcat@8/bin:$PATH"

# Go environment
export GOROOT="$(go env GOROOT)"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$GOPATH/bin"

# FZF configuration
# ----------------
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_DEFAULT_OPTS=" \
--color=bg:-1 \
--color=bg+:#313244 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5C2E7 \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#585b70,label:#CDD6F4"

# Starship config
export STARSHIP_CONFIG=~/.config/starship.toml

export MPD_HOST=localhost
export MPD_PORT=6700

# dotnet env
export DOTNET_ROOT="/usr/local/share/dotnet"
export PATH="$DOTNET_ROOT:$PATH"

# Add .local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
