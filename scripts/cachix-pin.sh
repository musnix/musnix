#!/usr/bin/env bash
#
# Build the flake's cachix-pin package, push its closure to Cachix, and pin it
# so the check result and its build inputs survive garbage collection.
#
# Usage: scripts/cachix-pin.sh [CACHE]
#
# Requires cachix to be authenticated (`cachix authtoken` or
# CACHIX_AUTH_TOKEN).
#

set -o errexit
set -o nounset
set -o pipefail

CACHE=${1:-musnix}
PIN_NAME=${PIN_NAME:-check-closure}
KEEP_REVISIONS=${KEEP_REVISIONS:-1}

cd -- "$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")/.."

pin=$(nix build --no-link --print-out-paths .#cachix-pin)

>&2 echo "- pushing $pin to $CACHE"
cachix push "$CACHE" "$pin"

>&2 echo "- pinning $pin as $PIN_NAME (keeping $KEEP_REVISIONS revisions)"
cachix pin "$CACHE" "$PIN_NAME" "$pin" --keep-revisions "$KEEP_REVISIONS"
