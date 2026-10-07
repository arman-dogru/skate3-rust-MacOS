#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This build script must run on macOS." >&2
  exit 2
fi
if [[ "$(uname -m)" != "arm64" ]]; then
  echo "Apple Silicon (arm64) is required; current architecture: $(uname -m)." >&2
  exit 2
fi
command -v cargo >/dev/null || { echo "Rust is required. Install it from https://rustup.rs" >&2; exit 2; }
command -v cmake >/dev/null || { echo "CMake is required (for SDL3). Install with: brew install cmake" >&2; exit 2; }
cargo build -p skate-game --bin skate3rust --release --no-default-features "$@"
echo "Built: target/release/skate3rust"
