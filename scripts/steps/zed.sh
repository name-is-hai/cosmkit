#! /usr/bin/env bash

install_zed() {
  require_cmd curl

  log_info "Installing Zed Editor..."

  curl -f https://zed.dev/install.sh | sh

  log_ok "Zed Editor installed."
}
