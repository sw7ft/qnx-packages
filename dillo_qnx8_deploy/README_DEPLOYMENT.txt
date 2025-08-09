# Dillo Web Browser - QNX 8 Deployment Package

## What's Included
- Dillo 3.2.0 web browser (ARM binary for QNX 8)
- FLTK 1.3.9 GUI libraries with X11 support
- All DPI plugins (bookmarks, downloads, file browser, etc.)
- Configuration files and startup script

## Binary Information
- Architecture: ARM EABI5 for BlackBerry QNX 8
- Size: ~6.5MB main binary + plugins + libraries
- GUI: FLTK with X11 backend
- Features: HTTP/1.1, cookies, bookmarks, downloads, CSS, HTML5

## Prerequisites on Device
1. X11 server running (your Android X server app)
2. Your existing bb10_xeyes_deploy directory with X11 libraries
3. DISPLAY environment variable set (usually :0)

## Installation
1. Copy this entire directory to your QNX device
2. Ensure bb10_xeyes_deploy is in your home directory
3. Make sure X11 server is running
4. Run: ./dillo_run.sh

## Manual Launch (Alternative)
If the script doesn't work, you can launch manually:

```bash
export LD_LIBRARY_PATH="$(pwd)/lib:$HOME/bb10_xeyes_deploy/lib:$LD_LIBRARY_PATH"
export DISPLAY=:0
./bin/dpid &
./bin/dillo
```

## Troubleshooting
- If "library not found" errors: Check that bb10_xeyes_deploy/lib contains X11 libraries
- If "cannot connect to display": Verify X server is running and DISPLAY is set
- If Dillo crashes: Check that all .so files have executable permissions

## Configuration
Edit etc/dillo/dillorc to customize browser settings.

Built successfully on $(date) for BlackBerry QNX 8.
