#!/usr/bin/env bash

install_devpod_cli() {
  require_cmd curl
  require_cmd sudo

  log_info "Installing DevPod CLI..."

  local tmp_dir
  tmp_dir="$(mktemp -d)" || return 1
  trap "rm -rf '$tmp_dir'" RETURN

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

setup_gcr_ssh_agent() {
  log_info "Setting up GCR SSH agent..."

  if ! rpm -q gcr >/dev/null 2>&1; then
    die "gcr package is not installed."
  fi

  if systemctl --user list-unit-files | grep -q '^gcr-ssh-agent.socket'; then
    log_info "Enabling GCR SSH agent socket..."
    systemctl --user enable --now gcr-ssh-agent.socket
    log_ok "gcr-ssh-agent.socket enabled."
  else
    log_warn "gcr-ssh-agent.socket was not found."
    log_warn "Reboot if gcr was just installed, then rerun this script."
  fi

  log_info "Disabling custom ssh-agent.service if it exists..."

  if systemctl --user list-unit-files | grep -q '^ssh-agent.service'; then
    systemctl --user disable --now ssh-agent.service || true
  fi

  log_info "Current SSH_AUTH_SOCK definitions:"

  grep -R --line-number 'SSH_AUTH_SOCK' \
    "$HOME/.profile" \
    "$HOME/.zshenv" \
    "$HOME/.zprofile" \
    "$HOME/.zshrc" \
    "$HOME/.config/environment.d" 2>/dev/null || true

  log_ok "GCR SSH agent setup finished."
  log_warn "Log out and log back into COSMIC for GUI apps to inherit the new SSH_AUTH_SOCK."
  printf '%s\n' \
    '  echo "$SSH_AUTH_SOCK"' \
    '  systemctl --user status gcr-ssh-agent.socket' \
    '  ssh-add -l' \
    '  ssh-add ~/.ssh/id_ed25519' \
    '  ssh -T git@github.com'
}

setup_devpod() {
  setup_gcr_ssh_agent
  install_devpod_cli
  setup_devpod_podman_provider
  log_ok "DevPod setup finished."
}
