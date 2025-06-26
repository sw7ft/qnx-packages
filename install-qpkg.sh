#!/bin/sh

# QPKG Installer for BlackBerry 10 / QNX 8 ARM
# Professional package manager installation
# Version 2.0 - Enhanced installer with robust error handling

set -e  # Exit on any error

# Color codes for better output (if terminal supports it)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Helper functions
print_status() {
    echo "${GREEN}✅${NC} $1"
}

print_warning() {
    echo "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo "${RED}❌${NC} $1"
}

print_info() {
    echo "${BLUE}💡${NC} $1"
}

print_header() {
    echo
    echo "${BLUE}🚀 QPKG Installer for BlackBerry 10${NC}"
    echo "Installing QNX Package Manager v2.0 with Auto-Wrapper Technology..."
    echo
}

# Detect BB10/Term49 environment
detect_environment() {
    TERM49_DETECTED=false
    BB10_DETECTED=false
    
    # Check for Term49 specific indicators
    if [ -n "$TERM" ] && echo "$TERM" | grep -q "xterm"; then
        if [ -d "/base/usr/bin" ] || [ -f "/usr/bin/blackberry-launcher" ]; then
            BB10_DETECTED=true
            if [ -n "$QTDIR" ] || echo "$PATH" | grep -q "Term49"; then
                TERM49_DETECTED=true
            fi
        fi
    fi
    
    # Check for common BB10 paths
    if echo "$PATH" | grep -q "$HOME/usr/local/bin"; then
        PATH_HAS_USR_LOCAL=true
    else
        PATH_HAS_USR_LOCAL=false
    fi
    
    if [ "$BB10_DETECTED" = true ]; then
        print_status "BlackBerry 10 environment detected"
        if [ "$TERM49_DETECTED" = true ]; then
            print_status "Term49 terminal environment detected"
        fi
    fi
}

# Check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    # Check for download tools
    if command -v curl >/dev/null 2>&1; then
        DOWNLOAD_TOOL="curl"
        print_status "curl found for downloads"
    elif command -v wget >/dev/null 2>&1; then
        DOWNLOAD_TOOL="wget"
        print_status "wget found for downloads"
    else
        print_error "Neither curl nor wget found - cannot download files"
        exit 1
    fi
    
    # Check shell compatibility
    if [ -z "$BASH_VERSION" ]; then
        print_status "POSIX shell detected (BB10 compatible)"
    else
        print_warning "Bash detected - ensure BB10 compatibility"
    fi
    
    # Check write permissions
    if [ ! -w "$(pwd)" ]; then
        print_error "No write permission in current directory"
        exit 1
    fi
    
    print_status "System requirements check passed"
}

# Download files with progress and retry
download_file() {
    local url="$1"
    local output="$2"
    local description="$3"
    local max_attempts=3
    local attempt=1
    
    print_info "Downloading $description..."
    
    while [ $attempt -le $max_attempts ]; do
        if [ $attempt -gt 1 ]; then
            print_warning "Retry attempt $attempt of $max_attempts..."
        fi
        
        case "$DOWNLOAD_TOOL" in
            curl)
                if curl -L --fail --show-error --silent -o "$output" "$url" 2>/dev/null; then
                    print_status "$description downloaded successfully"
                    return 0
                fi
                ;;
            wget)
                if wget -q -O "$output" "$url" 2>/dev/null; then
                    print_status "$description downloaded successfully"
                    return 0
                fi
                ;;
        esac
        
        attempt=$((attempt + 1))
        if [ $attempt -le $max_attempts ]; then
            sleep 2
        fi
    done
    
    print_error "Failed to download $description after $max_attempts attempts"
    return 1
}

# Download core QPKG files
download_qpkg_files() {
    local base_url="https://raw.githubusercontent.com/sw7ft/qnx-packages/main"
    
    # Download main qpkg script
    if ! download_file "$base_url/qpkg" "qpkg" "QPKG main script"; then
        exit 1
    fi
    
    # Download environment helper
    if ! download_file "$base_url/qpkg-env.sh" "qpkg-env.sh" "QPKG environment helper"; then
        print_warning "Environment helper download failed (optional component)"
        ENV_HELPER_AVAILABLE=false
    else
        ENV_HELPER_AVAILABLE=true
    fi
    
    # Make files executable
    chmod +x qpkg 2>/dev/null || {
        print_error "Could not make qpkg executable"
        exit 1
    }
    
    if [ "$ENV_HELPER_AVAILABLE" = true ]; then
        chmod +x qpkg-env.sh 2>/dev/null || {
            print_warning "Could not make qpkg-env.sh executable"
        }
    fi
    
    print_status "All QPKG files downloaded and configured"
}

# Determine installation type and perform installation
perform_installation() {
    GLOBAL_INSTALL=false
    
    if [ "$PATH_HAS_USR_LOCAL" = true ]; then
        print_status "Detected ~/usr/local/bin in PATH"
        
        # Interactive installation choice
        if [ -t 0 ] && [ -t 1 ]; then
            echo
            echo "Would you like to install QPKG system-wide to ~/usr/local/bin?"
            echo "This allows running 'qpkg' directly instead of './qpkg' or 'sh qpkg'"
            printf "Install globally? [Y/n]: "
            read -r install_choice
            install_choice=${install_choice:-y}
        else
            print_info "Non-interactive installation - using global install by default"
            install_choice="y"
        fi
        
        case "$install_choice" in
            [yY]|[yY][eE][sS])
                install_globally
                ;;
            *)
                print_info "Using local installation"
                ;;
        esac
    else
        print_info "Installing locally (~/usr/local/bin not in PATH)"
    fi
}

# Install QPKG globally
install_globally() {
    local target_dir="$HOME/usr/local/bin"
    
    # Create directory if needed
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir" 2>/dev/null || {
            print_warning "Could not create $target_dir - using local installation"
            return 1
        }
    fi
    
    # Copy main script
    if cp qpkg "$target_dir/qpkg" 2>/dev/null; then
        print_status "QPKG installed to ~/usr/local/bin"
        GLOBAL_INSTALL=true
    else
        print_warning "Could not install qpkg globally - using local installation"
        return 1
    fi
    
    # Copy environment helper if available
    if [ "$ENV_HELPER_AVAILABLE" = true ]; then
        if cp qpkg-env.sh "$target_dir/qpkg-env.sh" 2>/dev/null; then
            print_status "Environment helper installed globally"
        else
            print_warning "Could not install environment helper globally"
        fi
    fi
    
    print_status "Global installation completed successfully"
}

# Setup environment in user profile
setup_environment() {
    print_info "Setting up permanent environment configuration..."
    
    # Use a consistent installation directory regardless of where script is run
    local qpkg_install_dir="$HOME/qnx-packages"
    local profile_file="$HOME/.profile"
    local bashrc_file="$HOME/.bashrc"
    
    # Backup existing profile
    if [ -f "$profile_file" ] && [ ! -f "$profile_file.qpkg-backup" ]; then
        cp "$profile_file" "$profile_file.qpkg-backup" 2>/dev/null && {
            print_status "Created ~/.profile backup"
        }
    fi
    
    # Check if QPKG is already configured
    if [ -f "$profile_file" ] && grep -q "QPKG Package Manager" "$profile_file" 2>/dev/null; then
        print_warning "QPKG environment already configured in ~/.profile"
        return 0
    fi
    
    # Add QPKG configuration using a function for reliable path expansion
    {
        echo
        echo "# QPKG Package Manager - Auto-generated configuration"
        echo "# Added by QPKG installer on $(date)"
        echo "qpkg_setup_env() {"
        echo "    if [ -d \"\$HOME/qnx-packages\" ]; then"
        echo "        for pkg_dir in \"\$HOME/qnx-packages\"/*; do"
        echo "            if [ -d \"\$pkg_dir/bin\" ]; then"
        echo "                export PATH=\"\$PATH:\$pkg_dir/bin\""
        echo "            fi"
        echo "            if [ -d \"\$pkg_dir/lib\" ]; then"
        echo "                export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:\$pkg_dir/lib\""
        echo "            fi"
        echo "        done"
        echo "    fi"
        echo "}"
        echo "qpkg_setup_env"
        
        if [ "$GLOBAL_INSTALL" = true ] && [ "$ENV_HELPER_AVAILABLE" = true ]; then
            echo "# Optional: Source QPKG environment helper"
            echo "# . qpkg-env.sh  # Uncomment to auto-load package environments"
        fi
        
        echo "# End QPKG configuration"
        echo
    } >> "$profile_file" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "Environment configuration added to ~/.profile"
        print_info "All installed packages will be available in new shells"
    else
        print_warning "Could not modify ~/.profile - manual setup may be required"
        show_manual_setup_instructions
    fi
    
    # Also try .bashrc if it exists (some setups use this)
    if [ -f "$bashrc_file" ] && [ "$BASH_VERSION" ]; then
        print_info "Also adding configuration to ~/.bashrc"
        {
            echo
            echo "# QPKG Package Manager paths"
            echo "qpkg_setup_env() {"
            echo "    if [ -d \"\$HOME/qnx-packages\" ]; then"
            echo "        for pkg_dir in \"\$HOME/qnx-packages\"/*; do"
            echo "            if [ -d \"\$pkg_dir/bin\" ]; then"
            echo "                export PATH=\"\$PATH:\$pkg_dir/bin\""
            echo "            fi"
            echo "            if [ -d \"\$pkg_dir/lib\" ]; then"
            echo "                export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:\$pkg_dir/lib\""
            echo "            fi"
            echo "        done"
            echo "    fi"
            echo "}"
            echo "qpkg_setup_env"
        } >> "$bashrc_file" 2>/dev/null
    fi
}

# Show manual setup instructions if automatic setup fails
show_manual_setup_instructions() {
    echo
    print_warning "Manual setup required:"
    echo "Add these lines to your ~/.profile:"
    echo
    echo "qpkg_setup_env() {"
    echo "    if [ -d \"\$HOME/qnx-packages\" ]; then"
    echo "        for pkg_dir in \"\$HOME/qnx-packages\"/*; do"
    echo "            if [ -d \"\$pkg_dir/bin\" ]; then"
    echo "                export PATH=\"\$PATH:\$pkg_dir/bin\""
    echo "            fi"
    echo "            if [ -d \"\$pkg_dir/lib\" ]; then"
    echo "                export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:\$pkg_dir/lib\""
    echo "            fi"
    echo "        done"
    echo "    fi"
    echo "}"
    echo "qpkg_setup_env"
    echo
}

# Test the installation
test_installation() {
    print_info "Testing QPKG installation..."
    
    local test_passed=true
    
    # Test qpkg execution
    if [ "$GLOBAL_INSTALL" = true ]; then
        if qpkg --version >/dev/null 2>&1; then
            print_status "Global qpkg installation test passed"
        else
            print_warning "Global qpkg test failed"
            test_passed=false
        fi
    else
        if ./qpkg --version >/dev/null 2>&1; then
            print_status "Local qpkg installation test passed"
        elif sh qpkg --version >/dev/null 2>&1; then
            print_status "Local qpkg (sh mode) installation test passed"
        else
            print_warning "Local qpkg test failed"
            test_passed=false
        fi
    fi
    
    # Test environment helper if available
    if [ "$ENV_HELPER_AVAILABLE" = true ]; then
        if [ -f "qpkg-env.sh" ] && [ -x "qpkg-env.sh" ]; then
            print_status "Environment helper ready"
        else
            print_warning "Environment helper test failed"
        fi
    fi
    
    if [ "$test_passed" = true ]; then
        print_status "Installation test completed successfully"
    else
        print_warning "Some installation tests failed - check configuration"
    fi
}

# Show usage instructions
show_usage_instructions() {
    echo
    echo "${BLUE}📦 QPKG Installation Complete!${NC}"
    echo
    
    if [ "$GLOBAL_INSTALL" = true ]; then
        echo "${GREEN}Global Installation Commands:${NC}"
        echo "  qpkg list               # Show available packages"
        echo "  qpkg install nano       # Install nano text editor"
        echo "  qpkg install quickjs    # Install QuickJS JavaScript engine"
        echo "  qpkg remove nano        # Remove installed package"
        echo
        echo "${BLUE}Alternative usage:${NC}"
        echo "  ./qpkg list             # Local execution"
        echo "  sh qpkg list            # Shell execution"
    else
        echo "${GREEN}Local Installation Commands:${NC}"
        echo "  ./qpkg list             # Show available packages"
        echo "  ./qpkg install nano     # Install nano text editor"
        echo "  ./qpkg install quickjs  # Install QuickJS JavaScript engine"
        echo "  ./qpkg remove nano      # Remove installed package"
        echo
        echo "${BLUE}Alternative usage:${NC}"
        echo "  sh qpkg list            # Shell execution"
    fi
    
    echo
    echo "${BLUE}🔧 Environment Setup:${NC}"
    print_status "Automatically configured in ~/.profile"
    print_info "Start a new shell or run: . ~/.profile"
    
    if [ "$ENV_HELPER_AVAILABLE" = true ]; then
        echo
        echo "${BLUE}🚀 Environment Helper:${NC}"
        if [ "$GLOBAL_INSTALL" = true ]; then
            echo "  qpkg-env.sh             # Setup current shell environment"
        else
            echo "  ./qpkg-env.sh           # Setup current shell environment"
        fi
        print_info "Use when you need packages in current shell immediately"
    fi
    
    echo
    echo "${GREEN}🎯 Quick Start:${NC}"
    if [ "$GLOBAL_INSTALL" = true ]; then
        echo "  qpkg list | head        # Show first few packages"
        echo "  qpkg install nano       # Install a lightweight editor"
    else
        echo "  ./qpkg list | head      # Show first few packages"
        echo "  ./qpkg install nano     # Install a lightweight editor"
    fi
    
    if [ "$TERM49_DETECTED" = true ]; then
        echo
        print_info "Term49 Tip: All packages are optimized for BlackBerry 10!"
    fi
}

# Cleanup on exit
cleanup() {
    # Remove any temporary files if needed
    if [ -f ".qpkg-install.tmp" ]; then
        rm -f ".qpkg-install.tmp" 2>/dev/null
    fi
}

trap cleanup EXIT

# Main installation flow
main() {
    print_header
    detect_environment
    check_requirements
    download_qpkg_files
    perform_installation
    setup_environment
    test_installation
    show_usage_instructions
    
    echo
    print_status "QPKG installation completed successfully!"
    print_info "Welcome to the QNX Package Manager ecosystem!"
}

# Run main installation
main "$@" 