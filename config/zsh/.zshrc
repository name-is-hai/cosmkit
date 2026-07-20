# This lets ~/.zshrc be a symlink to cosmkit/config/zsh/.zshrc.

export COSMKIT_HOME="$HOME/.local/share/cosmkit"
export ZSH_CONFIG_DIR="${COSMKIT_HOME}/config/zsh"

if [[ -d "$ZSH_CONFIG_DIR/zshrc.d" ]]; then
 
  for file in "$ZSH_CONFIG_DIR"/zshrc.d/*.zsh; do
    [[ -r "$file" ]] && source "$file"
  done
fi

