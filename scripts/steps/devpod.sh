#!/usr/bin/env bash

install_devpod_cli() {
  require_cmd curl
  require_cmd sudo

  log_info "Installing DevPod CLI..."

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN

  curl -L \
    -o "$tmp_dir/devpod" \
    "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
  sudo install -c -m 0755 "$tmp_dir/devpod" "$HOME/.local/bin/"

  log_ok "DevPod CLI installed."
}

setup_devpod_podman_provider() {
  require_cmd devpod
  require_cmd podman

  log_info "Configuring DevPod docker provider to use Podman..."

  devpod provider add docker || true

  devpod provider set-options docker \
    -o DOCKER_PATH=podman

  log_ok "DevPod docker provider configured to use Podman."
}

setup_ssh_agent(){
  if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
  fi
}

setup_devpod() {
  setup_ssh_agent
  install_devpod_cli
  setup_devpod_podman_provider
  log_ok "DevPod setup finished."
}
