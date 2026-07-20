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

setup_toolbox_repos() {
  local name="$1"

  log_info "Setting up mise/starship repos inside toolbox: $name"

  toolbox run --container "$name" env COSMKIT_DIR="$COSMKIT_DIR" bash -lc '
    set -euo pipefail

    source "$COSMKIT_DIR/scripts/lib/common.sh"
    source "$COSMKIT_DIR/scripts/steps/repos.sh"

    setup_mise_repo
    setup_lazygit_repo
    setup_starship_repo

    sudo dnf makecache
  '

  log_ok "Toolbox repos configured: $name"
}

install_toolbox_packages() {
  local name="$1"
  local file="$2"

  create_toolbox_if_missing "$name"
  setup_toolbox_repos "$name"

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
}
