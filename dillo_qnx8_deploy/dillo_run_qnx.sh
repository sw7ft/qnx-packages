#!/accounts/1000/shared/misc/clitools/bin/bash
# Dillo QNX 8 Startup Script - QNX Optimized Version

# Function to show usage
show_usage() {
    echo "Dillo QNX 8 Web Browser Launcher"
    echo ""
    echo "Usage:"
    echo "  $0                           # Use current DISPLAY or default :0"
    echo "  $0 IP:DISPLAY              # Set specific display (e.g., 192.168.1.100:0)"
    echo "  DISPLAY_IP=IP $0            # Set IP via environment variable"
    echo ""
    echo "Examples:"
    echo "  $0 192.168.1.100:0         # Connect to X server at 192.168.1.100"
    echo "  $0 localhost:0             # Connect to local X server"
    echo "  DISPLAY_IP=10.0.0.5 $0     # Use environment variable"
    echo ""
    exit 0
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
fi

# Get current directory (where this script is located)
SCRIPT_DIR=$(cd $(dirname $0) && pwd)
cd $SCRIPT_DIR

echo "=== Dillo QNX 8 Startup ==="
echo "Script directory: $SCRIPT_DIR"

# Determine display setting
if [ -n "$1" ] && [ "$1" != "--help" ] && [ "$1" != "-h" ]; then
    # Display specified as command line argument
    DISPLAY_SETTING="$1"
    echo "Using display from command line: $DISPLAY_SETTING"
elif [ -n "$DISPLAY_IP" ]; then
    # Display IP specified via environment variable
    DISPLAY_SETTING="${DISPLAY_IP}:0"
    echo "Using display from DISPLAY_IP environment variable: $DISPLAY_SETTING"
elif [ -n "$DISPLAY" ]; then
    # Use existing DISPLAY environment variable
    DISPLAY_SETTING="$DISPLAY"
    echo "Using existing DISPLAY environment variable: $DISPLAY_SETTING"
else
    # Default to local display
    DISPLAY_SETTING=":0"
    echo "Using default display: $DISPLAY_SETTING"
    echo "Note: If X server is on different IP, run: $0 YOUR_IP:0"
fi

# Set up library paths
export LD_LIBRARY_PATH="$SCRIPT_DIR/lib:$HOME/bb10_xeyes_deploy/lib:$LD_LIBRARY_PATH"

# Set display
export DISPLAY="$DISPLAY_SETTING"

# Critical: Set up DPI environment for QNX
export DILLO_DPI_DIR="$SCRIPT_DIR/lib/dillo/dpi"
export DPIDRC_DIR="$SCRIPT_DIR/etc/dillo"

# Set Dillo configuration directory
export DILLO_CONFIG_DIR="$SCRIPT_DIR/etc/dillo"

# Show startup information
echo "Library path: $LD_LIBRARY_PATH"
echo "Display: $DISPLAY"
echo "Config: $DILLO_CONFIG_DIR"
echo "DPI Directory: $DILLO_DPI_DIR"
echo ""

# Check critical files
if [ ! -f "$SCRIPT_DIR/bin/dillo" ]; then
    echo "ERROR: Dillo binary not found at $SCRIPT_DIR/bin/dillo"
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/lib/libgcc_s.so.1" ]; then
    echo "ERROR: libgcc_s.so.1 not found. Please copy from toolchain."
    exit 1
fi

if [ ! -d "$SCRIPT_DIR/lib/dillo/dpi" ]; then
    echo "ERROR: DPI directory not found at $SCRIPT_DIR/lib/dillo/dpi"
    exit 1
fi

# Check if bb10_xeyes_deploy exists
if [ ! -d "$HOME/bb10_xeyes_deploy/lib" ]; then
    echo "Warning: bb10_xeyes_deploy/lib not found in $HOME"
    echo "   Make sure your X11 libraries are available"
fi

# Test if we can execute the binary
echo "Testing Dillo binary..."
if ! ldd "$SCRIPT_DIR/bin/dillo" >/dev/null 2>&1; then
    echo "ERROR: Dillo binary has missing dependencies"
    echo "Run: ldd $SCRIPT_DIR/bin/dillo"
    exit 1
fi

echo "Dillo binary dependencies OK"

# Start DPI daemon with explicit paths
echo "Starting DPI daemon..."
cd "$SCRIPT_DIR"

# Create dpidrc file with correct paths if it doesn't exist
if [ ! -f "$SCRIPT_DIR/etc/dillo/dpidrc" ]; then
    mkdir -p "$SCRIPT_DIR/etc/dillo"
    echo "# DPI configuration for QNX" > "$SCRIPT_DIR/etc/dillo/dpidrc"
    echo "dpi_dir=$SCRIPT_DIR/lib/dillo/dpi" >> "$SCRIPT_DIR/etc/dillo/dpidrc"
fi

./bin/dpid &
DPID_PID=$!

# Small delay for dpid to start
sleep 2

# Launch Dillo
echo "Launching Dillo..."
./bin/dillo "$@"
DILLO_EXIT_CODE=$?

# Clean up dpid when dillo exits
echo "Cleaning up..."
kill $DPID_PID 2>/dev/null

if [ $DILLO_EXIT_CODE -eq 0 ]; then
    echo "Dillo exited normally"
else
    echo "Dillo exited with error code: $DILLO_EXIT_CODE"
fi

exit $DILLO_EXIT_CODE
