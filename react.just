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

fmt_pattern := env("JUST_FMT_PATTERN", "src/**/*.{ts,tsx,css}")

# --- Setup ---

# Install all dependencies
[group('setup')]
deps:
    bun install

# --- Dev ---

# Start development server
[group('dev')]
dev:
    bun run dev

# --- Build ---

# Production build
[group('build')]
build:
    bun run build

# --- Lint ---

# Report likely mistakes in source
[group('lint')]
lint:
    bun run lint

# --- Test ---

# Test all (fmt check, lint, build)
[group('test')]
test: fmt-check lint build

# --- Fmt ---

# Reformat source with Prettier
[group('fmt')]
fmt:
    bunx prettier --write "{{ fmt_pattern }}"

# Check source formatting
[group('fmt')]
fmt-check:
    bunx prettier --check "{{ fmt_pattern }}"

# --- Codegen ---

# Generate TypeScript SDK from OpenAPI spec
[group('codegen')]
generate:
    npx orval
