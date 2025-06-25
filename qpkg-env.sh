#!/bin/sh

# QPKG Environment Setup Helper
# Source this file to add all installed QPKG packages to your PATH and LD_LIBRARY_PATH
# Usage: . ./qpkg-env.sh  or  source ./qpkg-env.sh

QPKG_BASE_DIR="./qnx-packages"

if [ ! -d "$QPKG_BASE_DIR" ]; then
    echo "[qpkg-env] No QPKG packages directory found at $QPKG_BASE_DIR"
    return 1 2>/dev/null || exit 1
fi

echo "[qpkg-env] Setting up environment for QPKG packages..."

# Initialize counters
bins_found=0
libs_found=0

# Add each package's bin and lib directories to PATH and LD_LIBRARY_PATH
for pkg_dir in "$QPKG_BASE_DIR"/*; do
    if [ -d "$pkg_dir" ]; then
        pkg_name=$(basename "$pkg_dir")
        
        # Add bin directory to PATH if it exists
        if [ -d "$pkg_dir/bin" ]; then
            PATH="$pkg_dir/bin:$PATH"
            bins_found=$((bins_found + 1))
            echo "[qpkg-env] ✅ Added $pkg_name/bin to PATH"
        fi
        
        # Add lib directory to LD_LIBRARY_PATH if it exists
        if [ -d "$pkg_dir/lib" ]; then
            if [ -z "$LD_LIBRARY_PATH" ]; then
                LD_LIBRARY_PATH="$pkg_dir/lib"
            else
                LD_LIBRARY_PATH="$pkg_dir/lib:$LD_LIBRARY_PATH"
            fi
            libs_found=$((libs_found + 1))
            echo "[qpkg-env] ✅ Added $pkg_name/lib to LD_LIBRARY_PATH"
        fi
    fi
done

# Export the variables
export PATH
export LD_LIBRARY_PATH

echo "[qpkg-env] 🎯 Environment setup complete!"
echo "[qpkg-env] 📊 Added $bins_found binary directories and $libs_found library directories"

# Show what's available
if [ $bins_found -gt 0 ]; then
    echo "[qpkg-env] 🚀 Available commands from QPKG packages:"
    for pkg_dir in "$QPKG_BASE_DIR"/*; do
        if [ -d "$pkg_dir/bin" ]; then
            pkg_name=$(basename "$pkg_dir")
            printf "[qpkg-env]   %s: " "$pkg_name"
            ls "$pkg_dir/bin" | tr '\n' ' '
            echo
        fi
    done
fi

echo "[qpkg-env] 💡 To make this permanent, add '. ./qpkg-env.sh' to your Term49 profile" 