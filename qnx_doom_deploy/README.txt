QNX Doom Deployment Package
============================

******TEST ONLY FOR BLACKBERRY PASSPORT - NO AUDIO******

Built with QNX 8 ARM toolchain and X11 display forwarding

Installation:
1. Copy entire qnx_doom_deploy directory to QNX device
2. Make sure Android X server app is running
3. Set DISPLAY environment variable to X server IP
4. Run: ./scripts/doom_run.sh

IMPORTANT: Run directly on device, NOT over SSH!

Controls:
- Arrow keys: Move
- Ctrl: Fire
- Space: Use/Open doors
- Shift: Run
- Esc: Menu
