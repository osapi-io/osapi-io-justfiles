# AGENTS.md

Test: `just test` | Fix formatting: `just ready`

Read @CONTRIBUTING.md first. It covers prerequisites, how to test a change
against a real consumer, the recipe conventions, and the pull request workflow —
all of which apply to agents exactly as they apply to people. This file carries
only what is specific to agents.

## Running tools

Invoke tools through `mise`, not from your path:

```bash
mise exec -- just test
```

`mise` is active in a person's shell and supplies the versions `.mise.toml`
declares. An agent's shell has no activation, so a bare `just` resolves to
whatever is installed globally — usually an older version.

The symptom is a check that fails here and passes in continuous integration, on
a file nobody edited. When that happens, establish which version ran before
treating the failure as real.

## Where the rules come from

The architecture is specified in
[osapi-io/specs](https://github.com/osapi-io/specs) under `osapi-justfiles/`,
whose `.specify/memory/` is the standing record. When a convention here and the
specification disagree, the specification wins — say so rather than following
the code.

A change that alters how modules are structured, consumed, or named is a change
to that specification first, and to this repository second.

## A shared recipe cannot be tested here

Every repository in the organization fetches these files from `main`. Nothing in
this repository exercises a recipe end to end, so "it looks right" is not
evidence. Test against a real consumer by pointing its `fetch` recipe at your
branch, and say in the PR which consumer you ran.

## Repository structure

| Path                                  | What it is                                                     |
| ------------------------------------- | -------------------------------------------------------------- |
| `<module>/<module>.just`              | A module's recipes, with its own README beside it              |
| `<module>.just` + `<module>.mod.just` | Older shim-based module, documented in the root README         |
| `justfile`                            | This repository's own recipes, which dogfood the `just` module |
| `Dockerfile`, `.dockerignore`         | Publishes every recipe file, flattened, as a scratch image     |

Two consumption styles exist. Both are specified; neither is a mistake to be
corrected on sight.

## Task tracking

Implementation planning and execution uses the superpowers plugin workflows
(`writing-plans` and `executing-plans`). Plans live in `docs/plans/`, created
when the first plan is written.
