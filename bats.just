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

# BATS integration test recipes for osapi-io projects.

# Install BATS and shfmt dependencies
[group: 'setup']
deps:
    go get github.com/bats-core/bats-core@latest
    bash $(go env GOMODCACHE)/$(go list -m github.com/bats-core/bats-core | tr ' ' @)/install.sh ./vendor/bats
    go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Reformat .bats files with shfmt
[group: 'fmt']
fmt:
    find . -name '*.bats' -not -path './test/vendor/*' -exec shfmt -w {} +

# Check .bats file formatting
[group: 'fmt']
fmt-check:
    find . -name '*.bats' -not -path './test/vendor/*' -exec shfmt -l -d {} +

# Run BATS integration tests
[group: 'test']
test: fmt-check
    ./vendor/bats/bin/bats .
