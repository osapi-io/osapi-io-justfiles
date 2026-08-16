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

### Overriding a default

Set `allow-duplicate-variables` and assign the variable again:

```just
set allow-duplicate-variables := true

import? '.just/remote/go.just'

go_coverage_target := "99.9"
```

The assignment is in scope when just parses the file, so
`just go-unit-cov-check` and `just test` agree, and a one-off override works on
the command line:

```bash
just go_coverage_target=95 go-unit-cov-check
```

Do not use `export` for this. It reaches child processes but not the parse of
its own file, so a recipe run by name would use the default while the same
recipe reached through another recipe used the override.

## 📄 License

The [MIT](../LICENSE) License.
