#!/usr/bin/env bash

setup_rpmfusion_repos() {
  require_cmd rpm-ostree
  require_cmd rpm

  log_info "Setting up RPM Fusion repos..."

  sudo rpm-ostree install --idempotent --apply-live \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

  log_ok "RPM Fusion repos installed."
  log_warn "A reboot may be required before using RPM Fusion packages."
}

setup_ghostty_repo() {
  require_cmd curl

  log_info "Setting up Ghostty COPR repo..."

  source /etc/os-release

  curl -fsSL \
    "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" \
    | sudo tee "/etc/yum.repos.d/ghostty.repo" >/dev/null

  log_ok "Ghostty COPR repo configured."
}

setup_cloudflare_warp_repo() {
  require_cmd curl

  log_info "Setting up Cloudflare WARP repo..."

  curl -fsSL \
    "https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo" \
    | sudo tee "/etc/yum.repos.d/cloudflare-warp.repo" >/dev/null

  log_ok "Cloudflare WARP repo configured."
}

setup_starship_repo() {
  require_cmd curl

  log_info "Setting up Starship COPR repo..."

  source /etc/os-release

  curl -fsSL \
    "https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-${VERSION_ID}/atim-starship-fedora-${VERSION_ID}.repo" \
    | sudo tee "/etc/yum.repos.d/starship.repo" >/dev/null

  log_ok "Starship COPR repo configured."
}

setup_mise_repo() {
  require_cmd curl

  log_info "Setting up mise COPR repo..."

  source /etc/os-release

  curl -fsSL \
    "https://copr.fedorainfracloud.org/coprs/jdxcode/mise/repo/fedora-${VERSION_ID}/jdxcode-mise-fedora-${VERSION_ID}.repo" \
    | sudo tee "/etc/yum.repos.d/mise.repo" >/dev/null

  log_ok "mise COPR repo configured."
}

setup_repos() {
  setup_rpmfusion_repos
  setup_ghostty_repo
  setup_cloudflare_warp_repo
  setup_starship_repo

  # Only enable this if you want mise on host.
  # If mise only lives inside toolbox, you do not need this.
  # setup_mise_repo

  log_ok "All repos configured."
}
