#!/usr/bin/env bash

setup_shell() {
  log_info "Checking default shell..."

  local current_shell
  current_shell="$(basename "$SHELL")"

  if [[ "$current_shell" == "zsh" ]]; then
    log_ok "Your shell is already zsh."
    return
  fi

  local zsh_path
  zsh_path="$(command -v zsh || true)"

  [[ -n "$zsh_path" ]] || die "zsh is not installed"

  log_info "Changing shell to zsh..."

  while ! sudo chsh -s "$zsh_path" "$USER"; do
    log_error "Failed to change shell. Retrying..."
    sleep 1
  done

  log_ok "Shell changed to zsh."
}
