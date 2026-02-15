# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Shared [just](https://just.systems/) recipes used by osapi-io projects via the
[remote justfiles](https://just.systems/man/en/remote-justfiles.html) pattern.
Consuming projects use `import?` with a fetch recipe to pull these files.

## Repository Structure

- `go.just` - Go build, test, lint, and formatting recipes
- `bats.just` - BATS integration test recipes
- `docs.just` - Docusaurus documentation recipes

## Conventions

### Recipe Style

- Use `#` comment above each recipe as its description
- Use `[group: 'name']` attributes to organize recipes (setup, test, fmt, lint, dev, build, codegen, docs)
- Use `[private]` for helper recipes not meant to be called directly
- Use kebab-case for recipe names (e.g., `fmt-check`, `unit-cov`)
- Use `#!/usr/bin/env bash` shebang for multi-line shell blocks
- Parameters use just syntax: `recipe param:` not shell args

### Variables

- Use `env("VAR", "default")` for user-configurable values
- Use backtick expressions for shell-derived values (e.g., `` git_root := `git rev-parse --show-toplevel` ``)
- Prefix env vars with `JUST_` to avoid collisions (e.g., `JUST_MAIN_PACKAGE`)

### License Header

All `.just` files must include the MIT license header at the top using `#` comments with year 2026.

### Dependencies Between Recipes

- Use just dependency syntax: `recipe: dep1 dep2`
- The `test` recipe should chain all checks (mod, fmt-check, vet, unit-cov)
- Keep recipes independently runnable where possible

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/) with the
50/72 rule:

- **Subject line**: max 50 characters, imperative mood, capitalized, no period
- **Body**: wrap at 72 characters, separated from subject by a blank line
- **Format**: `type(scope): description`
- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`
- Summarize the "what" and "why", not the "how"

Example:
```
feat(go): add init recipe for tool dependencies

Add a recipe that runs `go get -tool` for all required tool
dependencies, making it easy to bootstrap a new project's go.mod.
```

### Parity with Taskfiles

These recipes mirror `osapi-io-taskfiles/`. When updating recipes here, consider
whether the corresponding taskfile needs the same change. Recipe name mapping:

| Taskfile | Justfile |
|---|---|
| `go:test` | `test` |
| `go:unit` | `unit` |
| `go:unit:cov` | `unit-cov` |
| `go:vet` | `vet` |
| `go:fmt` | `fmt` |
| `go:fmt:check` | `fmt-check` |
| `bats:test` | `test` |
| `docs:start` | `start` |
