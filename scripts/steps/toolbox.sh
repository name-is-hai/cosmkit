#!/usr/bin/env bash

read_packages() {
  local file="$1"

  [[ -f "$file" ]] || die "Package file not found: $file"

  grep -vE '^\s*#|^\s*$' "$file"
}

toolbox_exists() {
  local name="$1"

  toolbox list --containers | awk '{print $2}' | grep -qx "$name"
}

create_toolbox_if_missing() {
  local name="$1"

  require_cmd toolbox

  if toolbox_exists "$name"; then
    log_ok "Toolbox $name already exists"
  else
    log_info "Creating toolbox $name"
    toolbox create "$name"
    log_ok "Toolbox $name created"
  fi
}

setup_toolbox_terminfo() {
  local name="$1"

  log_info "Setting up Ghostty terminfo inside toolbox: $name"

  toolbox run --container "$name" bash -lc '
    set -euo pipefail

    mkdir -p "$HOME/.terminfo/x"

    if [[ -f /run/host/usr/share/terminfo/x/xterm-ghostty ]]; then
      cp /run/host/usr/share/terminfo/x/xterm-ghostty "$HOME/.terminfo/x/"
      echo "Installed xterm-ghostty terminfo"
    else
      echo "Host xterm-ghostty terminfo not found, skipping"
    fi
  '

  log_ok "Toolbox terminfo setup finished: $name"
}

setup_mise_packages() {
  local name="$1"

  log_info "Setting up mise repos inside toolbox: $name"

  toolbox run --container "$name" env COSMKIT_DIR="$COSMKIT_DIR" bash -lc '
    set -euo pipefail

    source "$COSMKIT_DIR/scripts/lib/common.sh"
    source "$COSMKIT_DIR/scripts/steps/repos.sh"

    setup_mise_repo

    sudo dnf makecache
  '
  "$COSMKIT_DIR/bin/cosmkit-setup-mise"

  log_ok "Toolbox mise packages management configured: $name"
}

install_toolbox_packages() {
  local name="$1"
  local file="$2"

  create_toolbox_if_missing "$name"
  setup_toolbox_terminfo "$name"
  setup_mise_packages "$name"

  mapfile -t packages < <(read_packages "$file")

  if [[ "${#packages[@]}" -eq 0 ]]; then
    log_warn "No packages found in $file"
    return
  fi

  log_info "Checking sudo inside toolbox $name..."
  toolbox run --container "$name" sudo -v

  log_info "Installing packages into toolbox $name..."
  toolbox run --container "$name" sudo dnf install -y "${packages[@]}"

  log_ok "Toolbox packages installed into $name"
}

setup_dev_toolbox() {
  local name="${1:-dev}"

  install_toolbox_packages "$name" "$COSMKIT_DIR/packages/toolbox.packages"

  "$COSMKIT_DIR/bin/cosmkit-setup-nvim"

}
