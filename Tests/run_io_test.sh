#!/usr/bin/env sh
# Builds and runs the Tests/Io package and asserts its output, verifying the
# linker's I/O thunks (GetStdHandle / WriteConsoleW) end-to-end.
#
# Usage:
#   Tests/run_io_test.sh [path-to-rux]
#   RUX=/path/to/rux Tests/run_io_test.sh
#
# The rux binary is taken from $RUX, then the first argument, then a few common
# build locations, then $PATH.
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PKG="$SCRIPT_DIR/Io"

RUX="${RUX:-${1:-}}"
if [ -z "$RUX" ]; then
    for candidate in \
        "$SCRIPT_DIR/../build/rux" \
        "$SCRIPT_DIR/../build/clang/rux" \
        "$SCRIPT_DIR/../build/msvc/rux" \
        "$SCRIPT_DIR/../build/Release/rux" \
        "$(command -v rux 2>/dev/null || true)"; do
        if [ -n "$candidate" ] && [ -x "$candidate" ]; then
            RUX="$candidate"
            break
        fi
    done
fi
if [ -z "$RUX" ]; then
    echo "error: rux binary not found; set RUX or pass it as the first argument" >&2
    exit 2
fi

echo "Using rux: $RUX"
( cd "$PKG" && "$RUX" build >/dev/null )

BIN="$PKG/Bin/Debug/io_test"
[ -f "$BIN" ] || BIN="$BIN.exe"
if [ ! -f "$BIN" ]; then
    echo "error: built executable not found at $BIN" >&2
    exit 2
fi

EXPECTED="Hello from a Rux binary via I/O thunks!"

set +e
ACTUAL=$("$BIN")
CODE=$?
set -e

if [ "$ACTUAL" = "$EXPECTED" ] && [ "$CODE" -eq 0 ]; then
    echo "PASS: I/O thunks produced the expected output"
    exit 0
fi

echo "FAIL: I/O thunk test mismatch" >&2
echo "  expected: [$EXPECTED] (exit 0)" >&2
echo "  actual:   [$ACTUAL] (exit $CODE)" >&2
exit 1
