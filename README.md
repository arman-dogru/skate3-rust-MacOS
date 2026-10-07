<p align="center">
  <img src="docs/images/skating-crab.png" alt="Rust crab riding a skateboard" width="420">
</p>

<h1 align="center">Skate 3 Rust — macOS Apple Silicon</h1>

<p align="center">
  Native macOS ARM64 port of the Skate 3 Rust Engine.<br>
  Built with Rust, Bevy, SDL3, and Metal.
</p>

<p align="center">
  <a href="https://github.com/arman-dogru/skate3-rust-MacOS/actions/workflows/macos.yml"><img src="https://github.com/arman-dogru/skate3-rust-MacOS/actions/workflows/macos.yml/badge.svg" alt="macOS Apple Silicon CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0--only-blue.svg" alt="GPL-3.0-only"></a>
</p>

> [!IMPORTANT]
> This is an experimental engine recreation and macOS port. It is not an official Skate 3 release, does not contain Electronic Arts game assets, and is not affiliated with or endorsed by Electronic Arts.

## Overview

This repository ports the open-source Skate 3 Rust Engine to native Apple Silicon macOS.
The game executable builds directly for `aarch64-apple-darwin`, using Bevy's Metal rendering backend and SDL3 for controller input.

The current engine includes work on skating movement, tricks, grinds, offboard movement, physics, audio, difficulty settings, map loading, mods, networking, and `.skate` map support. Gameplay parity with Skate 3 is still a work in progress.

### macOS status

The Apple Silicon build currently has:

- native ARM64 compilation for macOS;
- a successful `cargo check` of the game executable on an ARM64 macOS runner;
- a successful optimized release build and link of `skate3rust` on ARM64 macOS;
- Bevy rendering through Metal;
- SDL3 controller support;
- native Rust game, physics, audio, map, mod, and networking crates;
- continuous macOS build verification through GitHub Actions.

The build targets Apple Silicon Macs, including M1, M2, M3, M4, and later ARM64 Macs. Intel Macs are not supported by the supplied build script.

## Requirements

You need:

- an Apple Silicon Mac running macOS;
- Xcode Command Line Tools;
- Rust stable;
- CMake;
- a prepared Skate 3 asset directory.

Install the Apple developer command-line tools:

```bash
xcode-select --install
```

Install CMake with Homebrew:

```bash
brew install cmake
```

Install Rust from [rustup.rs](https://rustup.rs/) if `cargo` is not already available.

Verify the basic toolchain:

```bash
uname -m
rustc -V
cargo -V
cmake --version
```

`uname -m` should report `arm64`.

## Build

Clone the repository:

```bash
git clone https://github.com/arman-dogru/skate3-rust-MacOS.git
cd skate3-rust-MacOS
```

Build the optimized native macOS executable:

```bash
./scripts/build-macos.sh
```

This runs the equivalent of:

```bash
cargo build \
  -p skate-game \
  --bin skate3rust \
  --release \
  --no-default-features
```

The resulting executable is:

```text
target/release/skate3rust
```

## Game assets

**Skate 3 assets are not included in this repository.**

The upstream Windows distribution contains a first-run setup/extraction pipeline for preparing data from a legally obtained Skate 3 installation. That Windows setup helper is not currently available as a native macOS program.

For macOS, provide an already prepared asset directory.

### Repository-local assets

Place the prepared asset tree at:

```text
./assets/
```

Then launch with:

```bash
./PLAY.command
```

`PLAY.command` automatically builds the release executable if it does not exist and launches the game using the repository-local `assets/` directory.

### External asset directory

To keep assets elsewhere, set `SKATE3_ASSETS`:

```bash
SKATE3_ASSETS="/absolute/path/to/assets" \
  ./target/release/skate3rust
```

The path must point to an existing prepared asset directory.

## Running directly

With repository-local assets:

```bash
./target/release/skate3rust --assets
```

With an external asset directory:

```bash
SKATE3_ASSETS="/absolute/path/to/assets" \
  ./target/release/skate3rust
```

For day-to-day use on macOS, `./PLAY.command` is the simplest launcher.

## Controls

Gameplay is designed around a compatible gamepad. Controller input is handled through SDL3, which supports common Xbox, PlayStation, Switch, and generic HID controllers supported by SDL on macOS.

Press `Escape` in-game to access available graphics, gameplay, difficulty, and map settings.

## Development

For a fast source-level validation without producing an optimized binary:

```bash
cargo check -p skate-game --bin skate3rust --no-default-features
```

For the release build:

```bash
cargo build -p skate-game --bin skate3rust --release --no-default-features
```

The workspace currently contains:

```text
crates/
├── skate-core
├── skate-audio
├── skate-audio-fma
├── skate-data
├── skate-game
├── skate-dynamics
├── skate-mods
├── skate-net
└── skate-steam-relay
```

The workspace also carries patched dependencies under `vendor/`, including patched Bevy rendering crates and `sdl3-sys`.

## Continuous integration

`.github/workflows/macos.yml` verifies the Apple Silicon build on an ARM64 macOS runner.

CI performs:

```text
cargo check -p skate-game --bin skate3rust --no-default-features
cargo build -p skate-game --bin skate3rust --release --no-default-features
```

It also runs library tests across the portable engine crates and uploads the resulting ARM64 `skate3rust` executable as a workflow artifact when the job succeeds.

## Current limitations

This port is functional at the compilation and native-linking level, but it is not yet a polished macOS distribution.

Known gaps include:

- no native macOS replacement for the Windows first-run asset extractor/setup helper;
- no signed or notarized `.app` bundle;
- no macOS installer or automatic updater;
- no Intel/x86_64 macOS support in the supplied build path;
- gameplay and rendering parity with the original game remain incomplete;
- some upstream tooling is still Windows-specific.

The immediate macOS development path is therefore: build the ARM64 executable, provide prepared assets, run, test, and replace remaining Windows assumptions as they are encountered.

## Upstream and research credits

This fork is based on the work in [`SK8-ENGINE/skate-3-rust-engine`](https://github.com/SK8-ENGINE/skate-3-rust-engine).

The project depends heavily on years of Skate 3 reverse-engineering research and tooling by **dumbad**, including work collected in [`DumbadsSkate3ModdingTools`](https://github.com/Ethanw05/DumbadsSkate3ModdingTools). That research established much of the knowledge required to understand Skate 3's data formats, maps, animation data, collision, challenges, DLC, and other game systems.

Additional upstream work includes renderer, recompilation, engine, tooling, and Rust/Bevy development by the Skate 3 Rust Engine contributors, including Chasm and other contributors credited by the upstream project history.

This macOS repository should be understood as a platform port and continuation of that work, not as an independent reverse-engineering effort.

## Contributing

Contributions that improve the macOS port are useful, particularly in these areas:

- removing Windows-only assumptions from shared code;
- macOS asset setup and extraction;
- `.app` bundle generation;
- code signing and notarization support;
- Metal rendering issues;
- SDL3 controller behavior on macOS;
- filesystem and path portability;
- native networking behavior;
- automated tests on Apple Silicon.

Before submitting a change, run at minimum:

```bash
cargo check -p skate-game --bin skate3rust --no-default-features
```

On Apple Silicon, also run:

```bash
./scripts/build-macos.sh
```

## Legal

This repository does not distribute Skate 3 game data, Electronic Arts code, copyrighted game assets, or trademarks.

You are responsible for obtaining and using any required game data lawfully. The project's source-code license does not grant rights to Electronic Arts content or to third-party map, mod, audio, image, or other copyrighted assets.

Skate, Skate 3, Electronic Arts, EA, and related names and marks belong to their respective owners.

## License

Unless otherwise noted, the project's original source code is licensed under the **GNU General Public License v3.0 only** (`GPL-3.0-only`). See [`LICENSE`](LICENSE).

Third-party and vendored components retain their own copyright notices and licenses.
