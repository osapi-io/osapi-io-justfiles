# md.just

Formats every `.md` file in the repository with
[mdformat](https://pypi.org/project/mdformat/), run via
[uvx](https://docs.astral.sh/uv/).

Use this for repos that keep documentation at the root. Use
[`docusaurus.just`](../docusaurus/README.md) for Docusaurus sites under `docs/`.

## Usage

Unlike the other modules, `md.just` is consumed with `import?` rather than
`mod?`. Its recipes are flat and prefixed, so it needs no `.mod.just` shim and
runs from the importing justfile's directory:

```just
import? '.just/remote/md.just'

# Fetch shared justfiles from osapi-justfiles
fetch:
    mkdir -p .just/remote
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/md/md.just -o .just/remote/md.just
```

Then:

```bash
just fetch          # Download the shared recipe file
just md-fmt         # Reformat all markdown
just md-fmt-check   # Check formatting (non-zero exit on drift)
```

## Recipes

| Recipe         | Description                                |
| -------------- | ------------------------------------------ |
| `md-fmt`       | Reformat repository markdown with mdformat |
| `md-fmt-check` | Check repository markdown formatting       |

## Requirements

[uv](https://docs.astral.sh/uv/) only. Nothing is installed into or committed to
the consuming repo. `uvx` runs mdformat from a cache, versions are pinned in the
recipe, and formatting options are passed on the command line. There is no
`package.json`, lockfile, or config file to maintain.

The `mdformat-gfm` plugin is not optional. Without it mdformat is
CommonMark-only and will silently mangle GitHub-flavored tables into prose.

The recipes pin the interpreter to Python 3.13 via `uvx --python`. mdformat's
`--exclude` flag requires 3.13 or newer; on an older interpreter the flag does
not exist and mdformat exits 2 with `unrecognized arguments`. Pinning makes the
behavior identical on a laptop and in CI, and uv downloads the interpreter if it
is missing.

## Exclusions

Excluded by default: `node_modules/`, `.worktrees/`, `.claude/`, and `.just/`.

`.claude/` is skipped because those files are generated, and their generator
rewrites them, and reformatting them creates a loop where CI and the generator
fight each other.

**⚠️ Do not point `md.just` and `docusaurus.just` at the same files.** They use
different formatters (mdformat vs prettier) and produce different output, so
each would undo the other. A repo may use both, but on disjoint paths. Since
`md.just` scans the whole repo, a repo with a Docusaurus site under `docs/` must
exclude it:

```just
set allow-duplicate-variables := true

import? '.just/remote/md.just'

md_extra_excludes := "--exclude 'docs/**'"
```

Note that mdformat does not understand GitHub alert syntax (`> [!WARNING]`) and
will reflow it into a plain blockquote. Use bold text for callouts in repos
formatted by this module.

## Configuration

| Variable            | Default | Description                                   |
| ------------------- | ------- | --------------------------------------------- |
| `md_version`        | `1.0.0` | mdformat version                              |
| `md_gfm_version`    | `1.0.0` | mdformat-gfm plugin version                   |
| `md_wrap`           | `80`    | Line wrap width                               |
| `md_extra_excludes` | (empty) | Extra `--exclude` flags added to the defaults |
| `md_python`         | `3.13`  | Python interpreter (`--exclude` needs 3.13+)  |

Override any of them by setting `allow-duplicate-variables` and assigning again:

```just
set allow-duplicate-variables := true

import? '.just/remote/md.just'

md_wrap := "100"
```
