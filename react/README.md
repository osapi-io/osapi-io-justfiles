# react.just

Builds, lints, formats, and serves a React application with
[Bun](https://bun.sh), [Prettier](https://prettier.io),
[ESLint](https://eslint.org), and [orval](https://orval.dev).

## 📦 Usage

`react.just` is consumed with `import?` rather than `mod?`. Its recipes are flat
and prefixed, so it needs no `.mod.just` shim.

The importing justfile **must** define `react_dir` — the directory holding the
React application, relative to the repository root:

```just
react_dir := "ui"

import? '.just/remote/react.just'

# Fetch shared justfiles from osapi-justfiles
fetch:
    mkdir -p .just/remote
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/react/react.just -o .just/remote/react.just
```

Use `react_dir := "."` when the application is at the repository root.

Then:

```bash
just fetch              # Download the shared recipe file
just react-deps         # Install dependencies
just react-dev          # Start the development server
just react-build        # Production build
just react-fmt          # Reformat with Prettier
just react-fmt-check    # Check formatting
just react-lint         # Run ESLint
just react-test         # fmt-check, lint, build
just react-generate     # Regenerate the TypeScript SDK with orval
```

## ⚙️ Configuration

| Variable                 | Default                 | Purpose                         |
| ------------------------ | ----------------------- | ------------------------------- |
| `react_dir`              | **required**            | Directory holding the React app |
| `JUST_REACT_FMT_PATTERN` | `src/**/*.{ts,tsx,css}` | Glob Prettier formats           |

`react_dir` is a justfile variable because it differs per repository.
`JUST_REACT_FMT_PATTERN` is an environment variable because it is an optional
knob with a sensible default.

### Overriding the directory

Set the environment variable in the consuming justfile:

```just
export JUST_REACT_DIR := "ui"
```

The module keeps its own default, so it still parses and lints on its own.

## 📄 License

The [MIT](../LICENSE) License.
