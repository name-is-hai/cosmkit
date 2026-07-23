#!/usr/bin/env bash

COSMKIT_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# shellcheck source=/dev/null
source "$COSMKIT_HOME/scripts/lib/log.sh"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}
