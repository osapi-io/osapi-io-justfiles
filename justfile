# Justfile formatting recipes run against local recipe files.

import 'just/just.just'

# Check justfile formatting
test: just-fmt-check

# Format and lint before committing
ready: just-fmt
