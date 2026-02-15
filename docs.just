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

# Docusaurus documentation recipes for osapi-io projects.

host := env("DOCS_HOST", "localhost")
port := env("DOCS_PORT", "3001")

# Install yarn packages
[group: 'setup']
[private]
yarn-install:
    yarn install

# Install global dependencies (redocly)
[group: 'setup']
deps:
    npm install -g @redocly/cli

# Build documentation site
[group: 'build']
build: yarn-install
    yarn docusaurus build

# Start development server
[group: 'dev']
start: yarn-install
    yarn docusaurus start --no-open --host={{ host }} --port={{ port }}

# Preview built site
[group: 'dev']
serve: yarn-install
    yarn docusaurus serve --no-open --host={{ host }} --port={{ port }}

# Clean build directory
[group: 'build']
clean:
    rm -rf ./build

# Create a new documentation version
[group: 'build']
bump version:
    yarn docusaurus docs:version {{ version }}

# Build and deploy Docusaurus (requires GIT_USER and GIT_PASS)
[group: 'build']
deploy:
    yarn docusaurus deploy

# Reformat docs with prettier
[group: 'fmt']
fmt: yarn-install
    yarn prettier docs --write --config prettier.config.js --ignore-path .prettierignore

# Check docs formatting with prettier
[group: 'fmt']
fmt-check: yarn-install
    yarn prettier docs --check --config prettier.config.js

# Generate OpenAPI docs
[group: 'codegen']
generate: yarn-install
    rm -rf docs/gen/
    yarn docusaurus gen-api-docs all
