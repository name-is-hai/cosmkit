autoload -Uz compinit

# Show selectable menu.
zstyle ':completion:*' menu select

# Group results by type.
zstyle ':completion:*' group-name ''

# Show descriptions.
zstyle ':completion:*' format '%F{yellow}-- %d --%f'

# Case-insensitive completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Better process completion.
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'

#Cache completions.
zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
#
# mkdir -p "$XDG_CACHE_HOME/zsh"
#
# -C skips security check after first compdump exists.
compinit -C
