# go.just

Builds, tests, formats, lints, and measures coverage for a Go project using
[gofumpt](https://github.com/mvdan/gofumpt),
[golines](https://github.com/segmentio/golines),
[golangci-lint](https://golangci-lint.run), and `go test`.

## 📦 Usage

`go.just` is consumed with `import?` rather than `mod?`. Its recipes are flat
and prefixed, so it needs no `.mod.just` shim:

```just
import? '.just/remote/go.just'

# Fetch shared justfiles from osapi-justfiles
fetch:
    mkdir -p .just/remote
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/go/go.just -o .just/remote/go.just
```

Then:

```bash
just fetch                 # Download the shared recipe file
just go-deps               # Install tool dependencies
just go-test               # mod, fmt-check, vet, coverage gate
just go-unit               # Unit tests only
just go-unit-cov           # Generate a coverage profile
just go-unit-cov-check     # Fail below the coverage target
just go-unit-cov-gaps      # Open a heatmap of files under 100%
just go-fmt                # Reformat with gofumpt and golines
just go-fmt-check          # Check formatting
just go-vet                # Run golangci-lint
just go-generate           # Run go generate
```

## ⚙️ Configuration

`go_coverage_target` is **required** — see below. The rest have defaults:

| Variable          | Default     | Purpose                        |
| ----------------- | ----------- | ------------------------------ |
| `go_coverage_dir` | `.coverage` | Where the profile is written   |
| `go_main_package` | `main.go`   | Entry point for builds         |
| `go_fmt_excludes` | (empty)     | Paths gofumpt and golines skip |

Each also reads an environment variable — `JUST_COVERAGE_DIR`,
`JUST_MAIN_PACKAGE`, `JUST_GO_FMT_EXCLUDES` — for use in CI, where there is no
justfile to edit.

### Overriding a default

Set the environment variable on the recipe that invokes the module. Recipes in a
consuming justfile call module recipes as child processes, which inherit it:

```just
export JUST_COVERAGE_TARGET := "99.9"
```

The module keeps its own default, so it still parses and lints on its own.

## 📄 License

The [MIT](../LICENSE) License.
