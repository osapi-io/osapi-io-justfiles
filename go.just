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

# Go recipes for osapi-io projects.
#
# These recipes use `go tool` to run tools declared in the consuming project's
# go.mod via Go 1.24+ tool directives. Run `just init` to add the required
# tool dependencies to your go.mod, then `just deps` to install them.
#
# Required tool dependencies:
#   - github.com/golangci/golangci-lint/v2/cmd/golangci-lint    (vet)
#   - github.com/boumenot/gocover-cobertura                     (unit-cov)
#   - mvdan.cc/gofumpt                                          (fmt, fmt-check)
#   - github.com/segmentio/golines                               (fmt, fmt-check)
#   - github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen  (generate)
#   - github.com/golang/mock/mockgen                             (generate)

git_root := `git rev-parse --show-toplevel`
main_package := env("JUST_MAIN_PACKAGE", "main.go")
os_tags := if os() == "linux" { `if grep -iq 'ubuntu' /etc/os-release 2>/dev/null; then echo '-tags=ubuntu'; fi` } else { "" }

# Add required tool dependencies to go.mod
[group: 'setup']
init:
    go get -tool github.com/golangci/golangci-lint/v2/cmd/golangci-lint
    go get -tool github.com/boumenot/gocover-cobertura
    go get -tool mvdan.cc/gofumpt
    go get -tool github.com/segmentio/golines
    go get -tool github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen
    go get -tool github.com/golang/mock/mockgen

# Module maintenance (download + tidy)
[group: 'setup']
mod:
    go mod download
    go mod tidy
    #!/usr/bin/env bash
    if [ -d examples/ ] && [ "$(ls examples/)" ]; then
        for dir in examples/*/; do
            (cd "${dir}" && go mod tidy)
        done
    fi

# Report likely mistakes in packages
[group: 'lint']
vet:
    go tool github.com/golangci/golangci-lint/v2/cmd/golangci-lint run --config {{ git_root }}/.golangci.yml

# Compile and run Go program
[group: 'dev']
run *args:
    go run {{ main_package }} {{ args }}

# Test packages
[group: 'test']
unit:
    go test {{ os_tags }} -parallel 5 -race -v ./...

# Generate coverage
[group: 'test']
unit-cov:
    GOEXPERIMENT=nocoverageredesign go test {{ os_tags }} -race -coverprofile=cover.out -v $(go list ./...)
    grep -v -f .coverignore cover.out > cover.tmp && mv cover.tmp cover.out
    go tool github.com/boumenot/gocover-cobertura < cover.out > cobertura.xml
    go tool cover -func=cover.out

# Generate coverage and show heatmap
[group: 'test']
unit-cov-map: unit-cov
    go tool cover -html=cover.out

# Test all (mod, fmt check, docs check, vet, coverage)
[group: 'test']
test: mod fmt-check docs-check vet unit-cov

# Reformat Go files with gofumpt + golines
[group: 'fmt']
fmt:
    find . -type f -name '*.go' ! -name '*.gen.go' ! -name '*.pb.go' | xargs go tool mvdan.cc/gofumpt -l -w
    find . -type f -name '*.go' ! -name '*.gen.go' ! -name '*.pb.go' | xargs go tool github.com/segmentio/golines --base-formatter="go tool mvdan.cc/gofumpt" -w

# Check Go file formatting
[group: 'fmt']
fmt-check:
    test -z "$(find . -type f -name '*.go' ! -name '*.gen.go' ! -name '*.pb.go' | xargs go tool mvdan.cc/gofumpt -d -e | tee /dev/stderr)"
    test -z "$(find . -type f -name '*.go' ! -name '*.gen.go' ! -name '*.pb.go' | xargs go tool github.com/segmentio/golines --dry-run --base-formatter="go tool mvdan.cc/gofumpt" -l | tee /dev/stderr)"

# Generate Go files by processing source
[group: 'codegen']
generate:
    go generate ./...

# Check if docs are outdated by verifying git status
[group: 'docs']
docs-check:
    #!/usr/bin/env bash
    if [[ -n "$(git status --porcelain docs/)" ]]; then
        echo "Documentation is outdated! Run 'just docs-generate' to regenerate and commit changes."
        exit 1
    fi
