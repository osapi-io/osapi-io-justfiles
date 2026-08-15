# Justfile formatting recipes run against local recipe files.
#
# Flat modules read their configuration from the environment. Setting it here
# means the lint below checks them with real values, the same way a consuming
# repository runs them.

export JUST_COVERAGE_TARGET := "100"
export JUST_REACT_DIR := "."

# Check justfile formatting
test:
    just --justfile just.just --working-directory . fmt-check

# Format and lint before committing
ready:
    just --justfile just.just --working-directory . fmt
