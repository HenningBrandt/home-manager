
#------------ Plugins --------------

# Source plugin manager
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# zsh theme
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme

# Autocompletion preview
zplug "zsh-users/zsh-autosuggestions"

# Search history by what's already typed
zplug "zsh-users/zsh-history-substring-search"

# Syntax highlighting
zplug "zsh-users/zsh-syntax-highlighting", defer:2

#------------ Basic settings --------------

# Enable VI mode
bindkey -v
bindkey "^?" backward-delete-char

# Language
# export LC_ALL=en_GB
export LANG="en_US.UTF-8"

# Autocomplete
autoload -U compinit
compinit

## case-insensitive (all), partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#------------ Environment --------------

# Preferred editor
export EDITOR='nvim'

# Configure Xcode toolchain
export XCODE=`xcode-select --print-path`

# Configure rust toolchain
export PATH="$PATH:$HOME/.cargo/bin"

# Add .local/bin to path (stack install)
export PATH="$PATH:$HOME/.local/bin"

# Add RubyGem binaries
export PATH="$PATH:$HOME/.gem/ruby/3.0.0/bin"

# Home-Manager conf
export MYHOMENIX=$HOME/nix/home.nix

# ZSH conf
export MYZSHRC=$HOME/nix/zshrc

# Let Ruby use Homebrews SSL version
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# Configure Android
export ANDROID_HOME=$HOME/Library/Android/sdk

# Enable Ruby shell
# eval "$(rbenv init -)"

# Configure .NET
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export DOTNET_CLI_UI_LANGUAGE=en

#------------ General Tools --------------

alias epoch="date +%s" # Get current unix epoch
alias l="colorls -A"
alias ll="colorls -lAog"
alias c="clear" # Quick terminal clear
alias ehm="$EDITOR $MYHOMENIX"
alias ezsh="$EDITOR $MYZSHRC" # Configure Shell
alias so="darwin-rebuild switch"

# Up/Down to search history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#------------ fzf fuzzy searcher --------------

# Use fd instead of file as data provider
# Follow symlinks
# Show hidden files
# Respect .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

#------------ Working with Git --------------

# g as shorthand for git
# without arguments it behaves like git status
compdef g=git
function g {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}

alias glog="git log \
  --graph \
  --abbrev-commit \
  --decorate \
  --format=format:'%C(bold blue)%h%C(reset) \
  - %C(bold green)(%ar)%C(reset) \
  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' \
  --all"

alias glog2="git log \
  --graph \
  --abbrev-commit \
  --decorate \
  --format=format:'%C(bold blue)%h%C(reset) \
  - %C(bold cyan)%aD%C(reset) \
  %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          \
  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' \
  --all"

alias gc="git checkout"
alias gcb="git checkout -b"
alias gpo="git pull origin"

#------------ Working with Python --------------

alias python=python3
alias pip=pip3
alias lab="jupyter lab --no-browser" # start jupyter lab session without browser
alias fserve="python3 -m http.server" # serve current directory over http

#------------ Install Plugins --------------

# Install plugins if there are plugins that have not been installed
# if ! zplug check; then
#   printf "Install? [y/N]: "
#   if read -q; then
#     echo; zplug install
#   fi
# fi

# Source plugins and add commands to $PATH
zplug load

# if [ -e /Users/henning/.nix-profile/etc/profile.d/nix.sh ]; then
#   . /Users/henning/.nix-profile/etc/profile.d/nix.sh;
# fi # added by Nix installer

# Enable direnv
# eval "$(direnv hook zsh)"
[ -f "/Users/henning/.ghcup/env" ] && source "/Users/henning/.ghcup/env" # ghcup-env
export PATH="/usr/local/opt/libpq/bin:$PATH"
