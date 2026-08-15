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

| Variable             | Default     | Purpose                                  |
| -------------------- | ----------- | ---------------------------------------- |
| `go_coverage_target` | `100`       | Minimum total coverage; below this fails |
| `go_coverage_dir`    | `.coverage` | Where the profile is written             |
| `go_main_package`    | `main.go`   | Entry point for builds                   |
| `go_fmt_excludes`    | (empty)     | Paths gofumpt and golines skip           |

Each also reads an environment variable — `JUST_COVERAGE_TARGET`,
`JUST_COVERAGE_DIR`, `JUST_MAIN_PACKAGE`, `JUST_GO_FMT_EXCLUDES` — for use in
CI, where there is no justfile to edit.

### Overriding from the consuming justfile

Assign after the import. This needs `set allow-duplicate-variables := true`,
because just otherwise rejects a variable with two definitions:

```just
set allow-duplicate-variables := true

import? '.just/remote/go.just'

go_coverage_target := "99.9"
```

An `export` in the consuming justfile does **not** work. `env()` resolves
against the process environment when just parses the file, and `export` only
populates the environment of recipes — so the module would keep its default.

## 📄 License

The [MIT](../LICENSE) License.
