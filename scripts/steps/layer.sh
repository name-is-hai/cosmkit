#!/usr/bin/env bash

read_packages() {
  local file="$1"

  [[ -f "$file" ]] || die "Package file not found: $file"

  grep -vE '^\s*#|^\s*$' "$file"
}

layer_package_file() {
  local file="$1"

  require_cmd rpm-ostree

  log_info "Layering packages from $file"

  mapfile -t packages < <(read_packages "$file")

  if [[ "${#packages[@]}" -eq 0 ]]; then
    log_warn "No packages found in $file"
    return
  fi

  sudo rpm-ostree install --idempotent --apply-live "${packages[@]}"

  log_ok "Layered packages from $file"
  log_warn "Reboot may be required."
}

layer_host_packages() {
  layer_package_file "$COSMKIT_HOME/packages/host.packages"
}

layer_input_packages() {
  layer_package_file "$COSMKIT_HOME/packages/input.packages"
}

layer_nvidia_packages() {
  layer_package_file "$COSMKIT_HOME/packages/nvidia.packages"
}
