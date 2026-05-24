# homebrew-dora

Homebrew tap for [dora](https://github.com/rach/dora) — personal semantic memory
for notes and code.

## Install

```sh
brew install rach/dora/dora
```

The first time you do this, Homebrew auto-taps `rach/homebrew-dora`. Subsequent
upgrades work with the standard `brew upgrade dora`.

Or, in two steps:

```sh
brew tap rach/dora
brew install dora
```

## Supported platforms

| Platform | Install method |
|---|---|
| macOS Apple Silicon (arm64) | Prebuilt binary from the dora GitHub release |
| macOS Intel (x86_64) | Build from source: `cargo install --git https://github.com/rach/dora --tag v0.2.0` |
| Linux | Build from source: same `cargo install` command |

Intel macOS + Linux bottles will land alongside cross-platform release artifacts;
the formula will pick them up automatically when they appear.

## Verify

```sh
dora --version
# dora 0.2.0
```

Then follow the [dora setup steps](https://github.com/rach/dora#tutorial--your-first-search-in-5-minutes)
to register a source and wire dora into Claude Code.

For instant re-indexing on file changes (and auto-pickup of newly-added sources),
start the background watcher as a launchd service:

```sh
brew services start dora
```

That runs `dora watch` under launchd with auto-restart on login + crash, logging
to `/opt/homebrew/var/log/dora-watch.log`. Safe to run before registering any
sources — the watcher picks up the first `dora source add` automatically.
Manage it via the standard `brew services {start|stop|restart|list} dora`. See
the [main README's watcher
section](https://github.com/rach/dora#step-55--optional-run-a-background-watcher)
for the non-brew (`nohup`-based) alternative.

## Maintaining this tap

For every dora release:

1. Cut a `vX.Y.Z` tag in the dora repo and upload `dora-fs-vX.Y.Z-macos-arm64.tar.gz`
   to the GitHub release.
2. Compute the SHA256 of the tarball: `shasum -a 256 dora-fs-vX.Y.Z-macos-arm64.tar.gz`.
3. Update `version`, `url`, and `sha256` in `Formula/dora.rb`.
4. Commit + push. `brew upgrade dora` picks it up on the user's next run.
