#!/usr/bin/env bash

# Runs the ffi-checker on all projects located in /examples/
# -v for verbose output
# -t for trace output

TRACE=0
VERBOSE=0
while getopts "tv" opt; do
    case $opt in
        t) TRACE=1 ;;
        v) VERBOSE=1 ;;
        *) ;;
    esac
done

CURR=$(dirname "$0")
PROJ=$(find "$CURR"/examples -mindepth 1 -maxdepth 1 -type d | sort)

for p in $PROJ; do
    pushd $p > /dev/null
    IDK=$(cargo clean 2>&1)

    if ((TRACE)); then
        OUTPUT=$(RUST_BACKTRACE=full RUST_LOG=info cargo ffi-checker 2>&1)
        echo "========== $p =========="
        echo "$OUTPUT"
    elif ((VERBOSE)); then
        OUTPUT=$(RUST_BACKTRACE=full RUST_LOG=info cargo ffi-checker 2>&1)
        echo "========== $p =========="
        echo "$OUTPUT" | grep -Fi "bug info: " 2>&1
    else
        OUTPUT=$(cargo ffi-checker 2>&1)
    fi

    grep -Fi "bug info: " <<< "$OUTPUT" 2>&1 > /dev/null
    RET=$?
    if [ $RET -ne 0 ]; then
        echo "$p: X"
    else
        echo "$p: FOUND"
    fi
    popd > /dev/null
done
