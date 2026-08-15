# just.just

Formats and checks every justfile in the repository using `just --fmt`.

Covers both `justfile` and any `*.just` recipe files, recursively.

## 📦 Usage

Consumed with `import?` rather than `mod?`. Recipes are flat and prefixed, so it
needs no `.mod.just` shim and runs from the importing justfile's directory:

```just
import? '.just/remote/just.just'

# Fetch shared justfiles from osapi-justfiles
fetch:
    mkdir -p .just/remote
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/just/just.just -o .just/remote/just.just
```

Then:

```bash
just fetch            # Download the shared recipe file
just just-fmt         # Reformat all justfiles
just just-fmt-check   # Check formatting (non-zero exit on drift)
```

## ✨ Recipes

| Recipe           | Description                             |
| ---------------- | --------------------------------------- |
| `just-fmt`       | Reformat justfiles with canonical style |
| `just-fmt-check` | Check justfile formatting               |

## 📋 Requirements

[just](https://just.systems) only. Formatting uses `just --fmt --unstable`,
which is built into the binary — there is nothing else to install.

## 🚫 Exclusions

Excluded: `.worktrees/`, `.claude/`, and `.just/`.

`.just/` is skipped because it holds the fetched copies of these shared files.
Checking them would make a consuming repo's CI fail whenever this repo's
formatting changes, rather than when the consuming repo's own justfiles drift.
