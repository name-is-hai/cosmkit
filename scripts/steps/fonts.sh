#!/usr/bin/env bash

install_fonts() {
  require_cmd curl
  require_cmd unzip
  require_cmd fc-cache

  log_info "Installing JetBrainsMono Nerd Font..."

  local tmp_dir
  tmp_dir="$(mktemp -d)" || return 1
  trap "rm -rf '$tmp_dir'" RETURN

  mkdir -p "$HOME/.local/share/fonts"

  curl -fL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
    -o "$tmp_dir/JetBrainsMono.zip"

  unzip -q "$tmp_dir/JetBrainsMono.zip" -d "$tmp_dir/JetBrainsMono"

  cp "$tmp_dir"/JetBrainsMono/*.ttf "$HOME/.local/share/fonts/"

  fc-cache -fv

  log_ok "JetBrainsMono Nerd Font installed."
}
