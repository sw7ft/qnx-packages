#!/bin/bash
# Dillo QNX 8 Startup Script

# Set library path to include FLTK and X11 libraries
export LD_LIBRARY_PATH="$(pwd)/lib:$HOME/bb10_xeyes_deploy/lib:$LD_LIBRARY_PATH"

# Set display (adjust as needed for your X server)
export DISPLAY=${DISPLAY:-:0}

# Set Dillo configuration directory
export DILLO_CONFIG_DIR="$(pwd)/etc/dillo"

# Launch Dillo
echo "Starting Dillo Web Browser for QNX 8..."
echo "Library path: $LD_LIBRARY_PATH"
echo "Display: $DISPLAY"
echo "Config: $DILLO_CONFIG_DIR"

# Start DPI daemon first
./bin/dpid &
DPID_PID=$!

# Small delay for dpid to start
sleep 1

# Launch Dillo
./bin/dillo "$@"

# Clean up dpid when dillo exits
kill $DPID_PID 2>/dev/null
