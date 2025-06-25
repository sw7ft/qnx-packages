#!/bin/sh

# QPKG Installer for BlackBerry 10
# Quick setup script for Term49 users

echo "🚀 Installing QPKG - QNX Package Manager..."
echo

# Download QPKG from GitHub
echo "📥 Downloading QPKG from GitHub..."

if command -v curl >/dev/null 2>&1; then
    curl -L -o qpkg "https://raw.githubusercontent.com/sw7ft/qnx-packages/main/qpkg"
elif command -v wget >/dev/null 2>&1; then
    wget -O qpkg "https://raw.githubusercontent.com/sw7ft/qnx-packages/main/qpkg"
else
    echo "❌ Error: Neither curl nor wget found."
    echo "Please install one of these tools to download packages."
    exit 1
fi

if [ $? -eq 0 ] && [ -f qpkg ]; then
    chmod +x qpkg 2>/dev/null
    echo "✅ QPKG installed successfully!"
    echo
    echo "📦 Usage:"
    echo "  sh qpkg list            # Show available packages"
    echo "  sh qpkg install nano    # Install nano text editor"
    echo "  sh qpkg install quickjs # Install QuickJS JavaScript engine"
    echo
    echo "🎯 Testing installation..."
    sh qpkg --help | head -3
    echo
    echo "🌟 Ready to install QNX packages!"
else
    echo "❌ Failed to download QPKG"
    echo "Please check your internet connection and try again."
    exit 1
fi
