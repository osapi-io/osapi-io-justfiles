# Copyright (c) 2026 John Dewey
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
# React recipes for osapi-io projects.
#
# These recipes use Bun as the package manager and script runner. Prettier
# handles formatting and ESLint handles linting, both configured by the
# consuming project.
#
# Projects can extend these by defining their own recipes that depend on
# the `react::` namespace.

# Directory holding the React application, relative to the repository root.
# Set JUST_REACT_DIR when the app is not at the root — osapi's lives in ui/.
# Consumers previously forked react.mod.just to change its working directory,
# which meant committing a fetched file.
react_dir := env("JUST_REACT_DIR", ".")
fmt_pattern := env("JUST_FMT_PATTERN", "src/**/*.{ts,tsx,css}")

# --- Setup ---

# Install all dependencies
[group('setup')]
deps:
    cd {{ react_dir }} && bun install

# --- Dev ---

# Start development server
[group('dev')]
dev:
    cd {{ react_dir }} && bun run dev

# --- Build ---

# Production build
[group('build')]
build:
    cd {{ react_dir }} && bun run build

# --- Lint ---

# Report likely mistakes in source
[group('lint')]
lint:
    cd {{ react_dir }} && bun run lint

# --- Test ---

# Test all (fmt check, lint, build)
[group('test')]
test: fmt-check lint build

# --- Fmt ---

# Reformat source with Prettier
[group('fmt')]
fmt:
    cd {{ react_dir }} && bunx prettier --write "{{ fmt_pattern }}"

# Check source formatting
[group('fmt')]
fmt-check:
    cd {{ react_dir }} && bunx prettier --check "{{ fmt_pattern }}"

# --- Codegen ---

# Generate TypeScript SDK from OpenAPI spec
[group('codegen')]
generate:
    cd {{ react_dir }} && npx orval
