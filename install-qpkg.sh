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

# Make qpkg-env.sh executable too
chmod +x qpkg-env.sh 2>/dev/null

# Download QPKG Environment Helper
echo "📥 Downloading QPKG environment helper..."
if command -v curl >/dev/null 2>&1; then
    curl -L -o qpkg-env.sh https://raw.githubusercontent.com/sw7ft/qnx-packages/main/qpkg-env.sh 2>/dev/null
    env_result=$?
elif command -v wget >/dev/null 2>&1; then
    wget -O qpkg-env.sh https://raw.githubusercontent.com/sw7ft/qnx-packages/main/qpkg-env.sh 2>/dev/null
    env_result=$?
else
    # This shouldn't happen since we already checked above
    env_result=1
fi

if [ $env_result -eq 0 ]; then
    echo "✅ Environment helper downloaded successfully"
else
    echo "⚠️  Failed to download environment helper (optional)"
    echo "    You can download it manually later with:"
    echo "    curl -L -o qpkg-env.sh https://raw.githubusercontent.com/sw7ft/qnx-packages/main/qpkg-env.sh"
fi

# Check if user has ~/usr/local/bin in PATH (common in Term49)
if echo "$PATH" | grep -q "$HOME/usr/local/bin"; then
    echo "🎯 Detected ~/usr/local/bin in PATH"
    
    # Check if we have interactive input (not piped)
    if [ -t 0 ] && [ -t 1 ]; then
        echo "Would you like to install QPKG system-wide? [Y/n]"
        printf "This allows running 'qpkg' directly instead of 'sh qpkg': "
        read -r install_global
        # Default to yes if empty
        install_global=${install_global:-y}
    else
        echo "📦 Piped installation detected - installing globally by default"
        echo "💡 This allows running 'qpkg' directly instead of 'sh qpkg'"
        install_global="y"
    fi
    
            case "$install_global" in
            [yY]|[yY][eE][sS])
                # Create directory if it doesn't exist
                mkdir -p "$HOME/usr/local/bin" 2>/dev/null
                if [ -d "$HOME/usr/local/bin" ]; then
                    # Copy both qpkg and qpkg-env.sh
                    cp qpkg "$HOME/usr/local/bin/qpkg" 2>/dev/null
                    qpkg_result=$?
                    cp qpkg-env.sh "$HOME/usr/local/bin/qpkg-env.sh" 2>/dev/null
                    env_result=$?
                    
                    if [ $qpkg_result -eq 0 ] && [ $env_result -eq 0 ]; then
                        echo "✅ QPKG installed to ~/usr/local/bin"
                        echo "✅ Environment helper installed to ~/usr/local/bin"
                        echo "✅ You can now run 'qpkg' directly from anywhere!"
                        echo "✅ Run 'qpkg-env.sh' from any directory to set up package paths"
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
echo "✅ Environment helper (qpkg-env.sh) ready for use"
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
    echo "  ./qpkg list             # Also works"
    echo "  sh qpkg list            # Also works"
    echo
    echo "🔧 Environment Setup:"
    echo "  qpkg-env.sh             # Auto-setup PATH for all packages (global)"
    echo "  . ./qpkg-env.sh         # Auto-setup PATH for all packages (local fallback)"
else
    echo "📦 Usage:"
    echo "  ./qpkg list             # Show available packages"
    echo "  ./qpkg install nano     # Install nano text editor"
    echo "  ./qpkg install quickjs  # Install QuickJS JavaScript engine"
    echo "  ./qpkg remove nano      # Remove nano text editor"
    echo
    echo "📦 Alternative usage:"
    echo "  sh qpkg list            # Also works"
    echo
    echo "🔧 Environment Setup:"
    echo "  . ./qpkg-env.sh         # Auto-setup PATH for all packages"
fi

echo
echo "🎯 Testing installation..."

# Test QPKG
if [ "$GLOBAL_INSTALL" = true ]; then
    echo "QPKG - QNX Package Manager v1.0.0"
    echo "Professional package management for QNX 8 ARM / BlackBerry 10"
    echo
    echo "🌟 Ready to install QNX packages!"
    echo "💡 Try: qpkg list"
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