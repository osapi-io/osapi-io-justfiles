# osapi-io-justfiles

A justfile used by osapi-io projects.

## Usage

Use the [remote justfiles](https://just.systems/man/en/remote-justfiles.html)
pattern with optional imports:

```just
import? 'go.just'
import? 'bats.just'

# Fetch shared justfiles from osapi-io-justfiles
fetch:
    curl -sSL https://raw.githubusercontent.com/osapi-io/osapi-io-justfiles/main/go.just > go.just
    curl -sSL https://raw.githubusercontent.com/osapi-io/osapi-io-justfiles/main/bats.just > bats.just
```

Then run `just fetch` to download the shared recipes, and they become available
immediately:

```bash
$ just fetch     # Download shared justfiles
$ just init      # Add required tool dependencies to go.mod (first time only)
$ just test      # Run all tests
$ just fmt       # Auto-format code
```

Add the fetched `.just` files to `.gitignore`:

```
go.just
bats.just
docs.just
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
