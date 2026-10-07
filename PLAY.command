#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
if [[ ! -x target/release/skate3rust ]]; then
  ./scripts/build-macos.sh
fi
exec ./target/release/skate3rust --assets assets "$@"
