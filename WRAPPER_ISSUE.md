# QPKG Auto-Wrapper Technology Issue

> **Status: RESOLVED – Fixed in qpkg commit 8da4e14 (2025-06-26)**
>
> The wrapper generator now:
> 1. Exports `LD_LIBRARY_PATH` safely whether or not the variable is already set.
> 2. Converts user-supplied relative paths to absolute before changing directory, preserving caller context.
> 3. Executes the real binary from its own `bin/` dir for correct relative-asset look-ups.
>
> Reinstalling any package (or deleting and regenerating its wrapper) picks up the fix. Verified with `demoPlayWav` running from arbitrary directories without "Can't access shared library" errors.

## Problem Statement

The QPKG v2.0.0 Auto-Wrapper Technology is **NOT working as designed**. While packages install correctly and commands are found in PATH, the auto-generated wrapper scripts are failing to properly execute binaries with library dependencies.

## Expected Behavior

When a user runs:
```bash
demoPlayWav piano2.wav
```

The auto-wrapper should:
1. Automatically set up the correct library paths
2. Change to the appropriate working directory
3. Execute the binary seamlessly from any location
4. Work transparently without user intervention

## Actual Behavior

### What Works:
- ✅ Package installation to `$HOME/qnx-packages/audioplayer/`
- ✅ PATH expansion (command is found: `which demoPlayWav` works)
- ✅ Wrapper script is created and made executable
- ✅ Manual execution works when using correct directory context

### What Fails:
- ❌ Auto-wrapper execution from arbitrary directories
- ❌ Transparent library dependency resolution

### Error Symptoms:
```bash
$ demoPlayWav piano2.wav
file �� cannot be read
AL lib: ReleaseALC: 1 device not closed
```

### Manual Workaround (Should NOT be necessary):
```bash
$ cd ~/qnx-packages/audioplayer/bin && ./demoPlayWav ~/piano2.wav
WAV file loaded.
Source(1) assigned and retained.
Buffer(1) loaded with data and retained.
Buffer(1) linked with source(1).
```

## Root Cause Analysis

The wrapper script is being created, but it's not properly handling the working directory context that the binary requires. The `demoPlayWav` binary has hardcoded relative path dependencies that require it to be executed from its specific directory.

## Current Wrapper Implementation

The wrapper script is generated in `qpkg` script around line 200+ in the `create_wrapper_script()` function:

```bash
# Create wrapper script
cat > "$wrapper_script" << 'EOF'
#!/bin/sh

# QPKG Auto-generated wrapper script
# This script automatically sets up the library environment for the binary

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$(dirname "$SCRIPT_DIR")"

# Set up library path to include package lib directory
if [ -d "$PKG_DIR/lib" ]; then
    export LD_LIBRARY_PATH="$PKG_DIR/lib:$LD_LIBRARY_PATH"
fi

# Copy any required libraries to satisfy relative path dependencies
if [ -d "$PKG_DIR/lib" ] && [ ! -f "$PKG_DIR/libnixtla-audio.so" ]; then
    for lib in "$PKG_DIR/lib"/*.so*; do
        if [ -f "$lib" ]; then
            lib_name=$(basename "$lib")
            # Create symlink in package root for relative path access
            ln -sf "lib/$lib_name" "$PKG_DIR/$lib_name" 2>/dev/null
        fi
    done
fi

# Change to the binary directory for relative path dependencies
cd "$SCRIPT_DIR"

# Execute the original binary with all arguments
exec "./BINARY_NAME.bin" "$@"
EOF
```

## Issues with Current Implementation

1. **Working Directory Context**: While the wrapper does `cd "$SCRIPT_DIR"`, this may not be sufficient for all relative path dependencies
2. **Library Path Resolution**: The `LD_LIBRARY_PATH` setup might not be covering all dependency scenarios
3. **Execution Context**: The binary may require additional environment setup beyond what's currently provided

## Impact

This breaks the core value proposition of QPKG v2.0.0:
- Users cannot run installed commands transparently
- Manual workarounds defeat the purpose of a package manager
- The "Auto-Wrapper Technology" marketing claim is false

## Required Fix

The wrapper script needs to be enhanced to:
1. Ensure all relative path dependencies are properly resolved
2. Set up the complete execution environment the binary expects
3. Handle all edge cases for library loading
4. Work reliably from any calling directory

## Test Case

**Success Criteria**: This command should work from any directory:
```bash
demoPlayWav piano2.wav
```

**Current Status**: ❌ FAILING - Requires manual directory change

## Priority

**HIGH** - This is a core functionality failure that breaks the primary user experience of the package manager. 