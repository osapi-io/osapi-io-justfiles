[![just lint](https://img.shields.io/github/actions/workflow/status/osapi-io/osapi-justfiles/just-lint.yml?branch=main&style=for-the-badge)](https://github.com/osapi-io/osapi-justfiles/actions/workflows/just-lint.yml)
[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=for-the-badge)](LICENSE)
[![conventional commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge)](https://conventionalcommits.org)
[![built with just](https://img.shields.io/badge/Built_with-Just-black?style=for-the-badge&logo=just&logoColor=white)](https://just.systems)
![gitHub commit activity](https://img.shields.io/github/commit-activity/m/osapi-io/osapi-justfiles?style=for-the-badge)

# osapi-justfiles

A justfile used by osapi-io projects.

## 📦 Usage

Shared recipes are consumed as
[just modules](https://just.systems/man/en/modules.html). Each module has a
shim file (`*.mod.just`) that sets the working directory and imports the actual
recipe file. Both are fetched from this repo.

```just
mod go '.just/remote/go.mod.just'
mod bats '.just/remote/bats.mod.just'

# Fetch shared justfiles from osapi-justfiles
fetch:
    mkdir -p .just/remote
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/go.mod.just -o .just/remote/go.mod.just
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/go.just -o .just/remote/go.just
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/bats.mod.just -o .just/remote/bats.mod.just
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/bats.just -o .just/remote/bats.just
```

Then run `just fetch` to download the shared recipes, and they become available
under their module namespace:

```bash
$ just fetch        # Download shared justfiles
$ just go::deps     # Install all Go tool dependencies
$ just go::test     # Run all Go checks
$ just go::fmt      # Auto-format code
$ just bats::test   # Run BATS integration tests
```

Add `.just/` to `.gitignore`:

```
.just/
```

### Lazy tool dependencies

Each recipe installs its own tool dependencies on first use via private `_*-deps`
recipes. There is no need to run `deps` before using a recipe — tools are
pulled automatically. `go::deps` is a convenience that installs all tools
upfront.

Projects define a top-level `deps` recipe that calls each module's `deps`:

```just
# Install all dependencies
deps: go::deps bats::deps
    go get -tool github.com/golang/mock/mockgen
```

### Documentation generation

`go::docs` and `go::docs-check` use
[gomarkdoc](https://github.com/princjef/gomarkdoc) to generate one markdown
file per package into `JUST_DOCS_DIR`, skipping `mocks` and `main` packages.
`docs-check` is **not** included in `go::test` by default — add it to your
project's `test` recipe where needed:

```just
test: go::test go::docs-check bats::test
```

## ✨ Available Recipes

Modules are moving into their own directories, each documenting itself:

| Module  | Description                                       | Docs                               |
| ------- | ------------------------------------------------- | ---------------------------------- |
| `go`    | Go build, test, coverage gate, format, lint       | [go/README.md](go/README.md)       |
| `md`    | Repository markdown formatting (mdformat via uvx) | [md/README.md](md/README.md)       |
| `react` | React app build, lint, format, SDK codegen (Bun)  | [react/README.md](react/README.md) |

Modules not yet moved are documented inline below.

### docs.just

| Recipe         | Description                           |
| -------------- | ------------------------------------- |
| `deps`         | Install global dependencies (redocly) |
| `build`        | Build documentation site              |
| `start`        | Start dev server                      |
| `serve`        | Preview built site                    |
| `clean`        | Clean build directory                 |
| `bump version` | Create new docs version               |
| `deploy`       | Build and deploy                      |
| `fmt`          | Format docs with prettier             |
| `fmt-check`    | Check docs formatting                 |
| `generate`     | Generate OpenAPI docs                 |

**Environment variables:**

- `JUST_DOCS_HOST` - dev server host (default: `localhost`)
- `JUST_DOCS_PORT` - dev server port (default: `3001`)

### docker.just

| Recipe  | Description                           |
| ------- | ------------------------------------- |
| `build` | Build the Docker image                |
| `push`  | Push the Docker image to the registry |

**Environment variables:**

- `JUST_DOCKER_IMAGE` - image name (default: `osapi-justfiles`)
- `JUST_DOCKER_TAG` - image tag (default: `latest`)

Consuming projects can copy `.just` files directly from the image instead of
using `curl`:

```dockerfile
COPY --from=registry.gitlab.com/osapi-io/osapi-justfiles:latest /*.just .just/remote/
```

### just.just

| Recipe      | Description                             |
| ----------- | --------------------------------------- |
| `fmt`       | Reformat justfiles with canonical style |
| `fmt-check` | Check justfile formatting               |

## 🤝 Contributing

See the [Contributing](CONTRIBUTING.md) guide for prerequisites, setup,
conventions, and the PR workflow.

## 📄 License

The [MIT](LICENSE) License.
