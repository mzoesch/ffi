#!/usr/bin/env bash

# Runs the ffi-checker on all projects located in /examples/
# -v for verbose output

VERBOSE=0
while getopts "v" opt; do
    case $opt in 
        v) VERBOSE=1 ;;
        *) ;;
    esac
done

CURR=$(dirname "$0")
PROJ=$(find "$CURR"/examples -mindepth 1 -maxdepth 1 -type d | sort)

for p in $PROJ; do
    pushd $p > /dev/null
    IDK=$(cargo clean 2>&1)

    if ((VERBOSE)); then
        OUTPUT=$(RUST_BACKTRACE=full RUST_LOG=info cargo ffi-checker 2>&1)
        echo "---- $p ----"
        echo "$OUTPUT"
        echo "------------"
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
