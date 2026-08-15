# md.just

Formats every `.md` file in the repository with
[mdformat](https://pypi.org/project/mdformat/), run via
[uvx](https://docs.astral.sh/uv/).

Use this for repos that keep documentation at the root. Use
[`docs.just`](../README.md#docsjust) for Docusaurus sites under `docs/`.

## 📦 Usage

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

## ✨ Recipes

| Recipe         | Description                                |
| -------------- | ------------------------------------------ |
| `md-fmt`       | Reformat repository markdown with mdformat |
| `md-fmt-check` | Check repository markdown formatting       |

## 📋 Requirements

[uv](https://docs.astral.sh/uv/) only. Nothing is installed into or committed to
the consuming repo — `uvx` runs mdformat from a cache, versions are pinned in
the recipe, and formatting options are passed on the command line. There is no
`package.json`, lockfile, or config file to maintain.

The `mdformat-gfm` plugin is not optional. Without it mdformat is
CommonMark-only and will silently mangle GitHub-flavored tables into prose.

## 🚫 Exclusions

Excluded by default: `node_modules/`, `.worktrees/`, `.claude/`, and `.just/`.

`.claude/` is skipped because openspec generates those files and regenerates
them on `openspec update` — reformatting them creates a loop where CI and the
generator fight each other.

**⚠️ Do not point `md.just` and `docs.just` at the same files.** They use
different formatters (mdformat vs prettier) and produce different output, so
each would undo the other. A repo may use both, but on disjoint paths. Since
`md.just` scans the whole repo, a repo with a Docusaurus site under `docs/` must
exclude it:

```bash
export JUST_MDFORMAT_EXCLUDES="--exclude 'docs/**'"
```

Note that mdformat does not understand GitHub alert syntax (`> [!WARNING]`) and
will reflow it into a plain blockquote. Use bold text for callouts in repos
formatted by this module.

## ⚙️ Environment variables

| Variable                    | Default | Description                                   |
| --------------------------- | ------- | --------------------------------------------- |
| `JUST_MDFORMAT_VERSION`     | `1.0.0` | mdformat version                              |
| `JUST_MDFORMAT_GFM_VERSION` | `1.0.0` | mdformat-gfm plugin version                   |
| `JUST_MDFORMAT_WRAP`        | `80`    | Line wrap width                               |
| `JUST_MDFORMAT_EXCLUDES`    | (empty) | Extra `--exclude` flags added to the defaults |
