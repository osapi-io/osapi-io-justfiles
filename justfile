# Justfile formatting recipes run against local recipe files.

# Check justfile formatting
test:
    just --justfile just.just --working-directory . fmt-check

# Format and lint before committing
ready:
    just --justfile just.just --working-directory . fmt
