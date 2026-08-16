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
# Documentation recipes for osapi-io projects.

# Docusaurus recipes for osapi-io projects.
#
# This module owns the site directory entirely, including formatting it. The
# content holds MDX and component syntax that a plain markdown formatter cannot
# parse, so prettier -- the Docusaurus ecosystem's formatter -- owns those files.
# The `md` module formats markdown outside this directory and excludes it.

docusaurus_dir := "docs"
docusaurus_host := "localhost"
docusaurus_port := "3001"

[group('setup')]
[private]
_docusaurus-bun-install:
    cd {{ docusaurus_dir }} && bun install

# Install documentation tooling
[group('setup')]
docusaurus-deps: _docusaurus-bun-install

# Build the site
[group('build')]
docusaurus-build: _docusaurus-bun-install
    cd {{ docusaurus_dir }} && bun run docusaurus build

# Start the development server
[group('dev')]
docusaurus-start: _docusaurus-bun-install
    cd {{ docusaurus_dir }} && bun run docusaurus start --no-open --host={{ docusaurus_host }} --port={{ docusaurus_port }}

# Serve the built site
[group('dev')]
docusaurus-serve: _docusaurus-bun-install
    cd {{ docusaurus_dir }} && bun run docusaurus serve --no-open --host={{ docusaurus_host }} --port={{ docusaurus_port }}

# Remove build output
[group('build')]
docusaurus-clean:
    rm -rf {{ docusaurus_dir }}/build

# Cut a versioned docs snapshot
[group('build')]
docusaurus-bump version:
    cd {{ docusaurus_dir }} && bun run docusaurus docs:version {{ version }}

# Deploy the site
[group('build')]
docusaurus-deploy:
    cd {{ docusaurus_dir }} && bun run docusaurus deploy

# Reformat the site with Prettier
[group('fmt')]
docusaurus-fmt: _docusaurus-bun-install
    cd {{ docusaurus_dir }} && bun run prettier . --write --config prettier.config.js --ignore-path .prettierignore

# Check site formatting
[group('fmt')]
docusaurus-fmt-check: _docusaurus-bun-install
    cd {{ docusaurus_dir }} && bun run prettier . --check --config prettier.config.js --ignore-path .prettierignore

# Regenerate the OpenAPI reference pages
[group('codegen')]
docusaurus-generate: _docusaurus-bun-install
    cd {{ docusaurus_dir }} && rm -rf docs/gen/
    cd {{ docusaurus_dir }} && bun run docusaurus gen-api-docs all
