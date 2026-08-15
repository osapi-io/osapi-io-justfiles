# react.just

Builds, lints, formats, and serves a React application with
[Bun](https://bun.sh), [Prettier](https://prettier.io),
[ESLint](https://eslint.org), and [orval](https://orval.dev).

## 📦 Usage

`react.just` is consumed with `import?` rather than `mod?`. Its recipes are flat
and prefixed, so it needs no `.mod.just` shim.

```just
import? '.just/remote/react.just'

# Fetch shared justfiles from osapi-justfiles
fetch:
    mkdir -p .just/remote
    curl -sSfL https://raw.githubusercontent.com/osapi-io/osapi-justfiles/refs/heads/main/react/react.just -o .just/remote/react.just
```

`react_dir` defaults to `.`, the repository root. Override it when the
application lives elsewhere — see Configuration below.

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

| Variable            | Default                 | Purpose                         |
| ------------------- | ----------------------- | ------------------------------- |
| `react_dir`         | `.`                     | Directory holding the React app |
| `react_fmt_pattern` | `src/**/*.{ts,tsx,css}` | Glob Prettier formats           |

Override by setting `allow-duplicate-variables` and assigning again:

```just
set allow-duplicate-variables := true

import? '.just/remote/react.just'

react_dir := "ui"
```

## 📄 License

The [MIT](../LICENSE) License.
