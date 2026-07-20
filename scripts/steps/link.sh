#!/usr/bin/env bash

backup_if_exists() {
  local target="$1"

  if [[ -e "$target" && ! -L "$target" ]]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    log_warn "Backing up $target to $backup"
    mv "$target" "$backup"
  fi
}

link_path() {
  local source="$1"
  local target="$2"

  [[ -e "$source" ]] || die "Source does not exist: $source"

  mkdir -p "$(dirname "$target")"
  backup_if_exists "$target"

  ln -snf "$source" "$target"
  log_ok "Linked $target"
}

link_configs() {
  log_info "Linking config files..."

  link_path "$COSMKIT_DIR/config/nvim" "$HOME/.config/nvim"
  link_path "$COSMKIT_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
  link_path "$COSMKIT_DIR/config/ghostty" "$HOME/.config/ghostty"
  link_path "$COSMKIT_DIR/config/git/.gitconfig" "$HOME/.gitconfig"

  log_ok "Config linking finished."
}
