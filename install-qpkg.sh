#!/bin/sh

# QPKG Installer for BlackBerry 10 / QNX 8 ARM
# Professional package manager installation

echo "🚀 QPKG Installer for BlackBerry 10"
echo "Installing QNX Package Manager..."
echo

# Download QPKG
echo "📥 Downloading QPKG..."
if command -v curl >/dev/null 2>&1; then
    curl -L -o qpkg https://raw.githubusercontent.com/sw7ft/qnx-packages/main/qpkg 2>/dev/null
    result=$?
elif command -v wget >/dev/null 2>&1; then
    wget -O qpkg https://raw.githubusercontent.com/sw7ft/qnx-packages/main/qpkg 2>/dev/null
    result=$?
else
    echo "❌ Error: Neither curl nor wget found"
    exit 1
fi

if [ $result -ne 0 ]; then
    echo "❌ Failed to download QPKG"
    exit 1
fi

# Make executable
chmod +x qpkg 2>/dev/null

# Check if user has ~/usr/local/bin in PATH (common in Term49)
if echo "$PATH" | grep -q "$HOME/usr/local/bin"; then
    echo "🎯 Detected ~/usr/local/bin in PATH"
    echo "Would you like to install QPKG system-wide? [y/N]"
    printf "This allows running 'qpkg' directly instead of 'sh qpkg': "
    read -r install_global
    
    case "$install_global" in
        [yY]|[yY][eE][sS])
            # Create directory if it doesn't exist
            mkdir -p "$HOME/usr/local/bin" 2>/dev/null
            if [ -d "$HOME/usr/local/bin" ]; then
                cp qpkg "$HOME/usr/local/bin/qpkg" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo "✅ QPKG installed to ~/usr/local/bin"
                    echo "✅ You can now run 'qpkg' directly!"
                    GLOBAL_INSTALL=true
                else
                    echo "⚠️  Could not install globally, using local installation"
                    GLOBAL_INSTALL=false
                fi
            else
                echo "⚠️  Could not create ~/usr/local/bin, using local installation"
                GLOBAL_INSTALL=false
            fi
            ;;
        *)
            echo "📁 Using local installation"
            GLOBAL_INSTALL=false
            ;;
    esac
else
    echo "📁 Installing locally (~/usr/local/bin not in PATH)"
    GLOBAL_INSTALL=false
fi

echo
echo "✅ QPKG installed successfully!"
echo

# Show appropriate usage instructions
if [ "$GLOBAL_INSTALL" = true ]; then
    echo "📦 Usage (global installation):"
    echo "  qpkg list               # Show available packages"
    echo "  qpkg install nano       # Install nano text editor"
    echo "  qpkg install quickjs    # Install QuickJS JavaScript engine"
    echo "  qpkg remove nano        # Remove nano text editor"
    echo
    echo "📦 Alternative usage:"
    echo "  sh qpkg list            # Also works"
    echo "  ./qpkg list             # Also works"
else
    echo "📦 Usage:"
    echo "  sh qpkg list            # Show available packages"
    echo "  sh qpkg install nano    # Install nano text editor"
    echo "  sh qpkg install quickjs # Install QuickJS JavaScript engine"
    echo "  sh qpkg remove nano     # Remove nano text editor"
    echo
    echo "📦 Alternative usage:"
    echo "  ./qpkg list             # Also works if permissions allow"
fi

echo
echo "🎯 Testing installation..."

# Test QPKG
if [ "$GLOBAL_INSTALL" = true ] && command -v qpkg >/dev/null 2>&1; then
    echo "QPKG - QNX Package Manager v1.0.0"
    echo "Professional package management for QNX 8 ARM / BlackBerry 10"
    echo
    echo
    echo "🌟 Ready to install QNX packages!"
    # Test with global command
    qpkg list >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ Global installation test passed"
    fi
else
    # Test with sh command
    sh qpkg --help | head -3
    echo
    echo "🌟 Ready to install QNX packages!"
    sh qpkg list >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ Local installation test passed"
    fi
fi 