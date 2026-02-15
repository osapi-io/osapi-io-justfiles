# osapi-io-justfiles

A justfile used by osapi-io projects.

## Usage

Shared recipes are consumed as
[just modules](https://just.systems/man/en/modules.html). Each module has a
shim file (`*.mod.just`) that sets the working directory and imports the actual
recipe file. Both are fetched from this repo.

```just
mod go '.just/remote/go.mod.just'
mod bats '.just/remote/bats.mod.just'

# Fetch shared justfiles from osapi-io-justfiles
fetch:
    mkdir -p .just/remote
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-io-justfiles/refs/heads/main/go.mod.just -o .just/remote/go.mod.just
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-io-justfiles/refs/heads/main/go.just -o .just/remote/go.just
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-io-justfiles/refs/heads/main/bats.mod.just -o .just/remote/bats.mod.just
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-io-justfiles/refs/heads/main/bats.just -o .just/remote/bats.just
```

Then run `just fetch` to download the shared recipes, and they become available
under their module namespace:

```bash
$ just fetch        # Download shared justfiles
$ just go::init     # Add default tool dependencies to go.mod
$ just go::test     # Run all Go checks
$ just go::fmt      # Auto-format code
$ just bats::test   # Run BATS integration tests
```

Add `.just/` to `.gitignore`:

```
.just/
```

### Project-specific tools

`go::init` installs only the tools required by shared recipes (golangci-lint,
gocover-cobertura, gofumpt, golines). Projects can add their own extras by
defining a top-level `init` recipe that depends on `go::init`:

```just
# Add shared + project-specific tool dependencies
init: go::init
    go get -tool github.com/golang/mock/mockgen
    go get -tool github.com/princjef/gomarkdoc/cmd/gomarkdoc
```

## Available Recipes

### go.just

| Recipe | Description |
|---|---|
| `init` | Add required tool dependencies to go.mod |
| `mod` | Module maintenance (download + tidy) |
| `vet` | Run golangci-lint |
| `run *args` | Compile and run Go program |
| `unit` | Run unit tests |
| `unit-cov` | Run tests with coverage |
| `unit-cov-map` | Coverage with HTML heatmap |
| `test` | Run all checks (mod, fmt, docs, vet, coverage) |
| `fmt` | Auto-format with gofumpt + golines |
| `fmt-check` | Check formatting |
| `generate` | Run go generate |
| `docs-check` | Check if docs are outdated |

**Environment variables:**

- `JUST_MAIN_PACKAGE` - main package path (default: `main.go`)
- `JUST_COVERAGE_DIR` - coverage output directory (default: `.coverage`)

### bats.just

| Recipe | Description |
|---|---|
| `deps` | Install BATS and shfmt |
| `fmt` | Format .bats files |
| `fmt-check` | Check .bats formatting |
| `test` | Run BATS integration tests |

### docs.just

| Recipe | Description |
|---|---|
| `deps` | Install global dependencies (redocly) |
| `build` | Build documentation site |
| `start` | Start dev server |
| `serve` | Preview built site |
| `clean` | Clean build directory |
| `bump version` | Create new docs version |
| `deploy` | Build and deploy |
| `fmt` | Format docs with prettier |
| `fmt-check` | Check docs formatting |
| `generate` | Generate OpenAPI docs |

**Environment variables:**

- `DOCS_HOST` - dev server host (default: `localhost`)
- `DOCS_PORT` - dev server port (default: `3001`)

## License

The [MIT](LICENSE) License.
