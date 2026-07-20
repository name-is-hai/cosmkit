#!/usr/bin/env bash
set -euo pipefail

COSMKIT_REPO="${COSMKIT_REPO:-YOUR_USERNAME/cosmkit}"
COSMKIT_BRANCH="${COSMKIT_BRANCH:-master}"
COSMKIT_HOME="${COSMKIT_HOME:-$HOME/.local/share/cosmkit}"

load_logging() {
  local log_file="$COSMKIT_HOME/scripts/lib/log.sh"

  if [[ -f "$log_file" ]]; then
    # shellcheck source=/dev/null
    source "$log_file"
    return
  fi

  log_info() {
    printf "\033[1;34m[INFO]\033[0m %s\n" "$*"
  }

  log_ok() {
    printf "\033[1;32m[OK]\033[0m %s\n" "$*"
  }

  log_warn() {
    printf "\033[1;33m[WARN]\033[0m %s\n" "$*"
  }

  log_error() {
    printf "\033[1;31m[ERROR]\033[0m %s\n" "$*" >&2
  }

  die() {
    log_error "$*"
    exit 1
  }
}

load_logging

command -v git >/dev/null 2>&1 || die "Missing command: git"

log_info "Installing cosmkit into $COSMKIT_HOME"

if [[ -d "$COSMKIT_HOME/.git" ]]; then
  log_info "Existing install found. Updating..."
  git -C "$COSMKIT_HOME" pull --ff-only
else
  mkdir -p "$(dirname "$COSMKIT_HOME")"
  git clone --branch "$COSMKIT_BRANCH" \
    "https://github.com/$COSMKIT_REPO.git" \
    "$COSMKIT_HOME"
fi

# mkdir -p "$HOME/.local/bin"
#
# for cmd in "$COSMKIT_HOME"/bin/cosmkit-*; do
#   [[ -f "$cmd" ]] || continue
#   ln -snf "$cmd" "$HOME/.local/bin/$(basename "$cmd")"
# done
source "$COSMKIT_HOME/bin/cosmkit-setup"
log_ok "cosmkit installed."
