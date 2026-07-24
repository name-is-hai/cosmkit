#!/usr/bin/env bash

install_flatpaks() {
  require_cmd flatpak

  log_info "Adding Flathub remote..."

  flatpak remote-add --if-not-exists \
    flathub \
    https://flathub.org/repo/flathub.flatpakrepo

  local file="$COSMKIT_HOME/packages/flatpak.packages"

  [[ -f "$file" ]] || die "Package file not found: $file"

  mapfile -t apps < <(grep -vE '^\s*#|^\s*$' "$file")

  if [[ "${#apps[@]}" -eq 0 ]]; then
    log_warn "No Flatpak apps found in $file"
    return
  fi

  log_info "Installing Flatpak apps..."
  flatpak install -y --or-update flathub "${apps[@]}"

  log_ok "Flatpak apps installed."
}
