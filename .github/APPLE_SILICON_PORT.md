# Apple Silicon port verification

This fork imports upstream revision `af5640486253bd940d9b21c5029a9f835cd3e087` and verifies `skate3rust` natively on GitHub's ARM64 macOS runner with `cargo check` and a release build using `--no-default-features`.

The Windows installer/updater and release packaging remain intentionally excluded from the macOS execution path. Prepared game assets are supplied with `--assets DIRECTORY` or `SKATE3_ASSETS`.
