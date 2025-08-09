#!/bin/sh
# QNX Doom Startup Script
# Run this directly on QNX device, NOT over SSH

DOOM_DIR=$(dirname "$0")/..
export LD_LIBRARY_PATH="$DOOM_DIR/lib:$LD_LIBRARY_PATH"

# Set X server IP (change to match your Android X server)
export DISPLAY=${DISPLAY:-"192.168.1.113:0"}
echo "Using X server: $DISPLAY"

cd "$DOOM_DIR"
exec ./bin/doomgeneric_qnx "$@"
