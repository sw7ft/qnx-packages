# QPKG Project Context & AI Assistant Guide

## 🎯 Project Overview

**QPKG** is a GitHub-powered package manager specifically designed for **QNX 8 ARM / BlackBerry 10** devices. This project represents the first modern, comprehensive package management system for the BlackBerry 10 platform.

### What This Project Is

- **Package Manager**: Professional-grade package management for BB10/QNX 8 ARM
- **GitHub-Powered**: Uses GitHub infrastructure for free hosting and global CDN
- **Community-Driven**: Open source with professional standards and documentation
- **Production-Ready**: Tested on actual BlackBerry 10 devices running Term49

### What This Project Is NOT

- Not a general-purpose Linux package manager
- Not compatible with standard ARM Linux distributions
- Not designed for desktop or server environments
- Not a replacement for QNX's native package systems

## 🏗️ Technical Architecture

### Core Components

1. **`qpkg`** (401 lines, POSIX shell)
   - Main package manager executable
   - Features: large package support, progress indicators, resume capability
   - BB10 compatible (tested in Term49 terminal)

2. **`install-qpkg.sh`** (116 lines)
   - One-command installer script
   - Detects Term49 environment and PATH configuration
   - Supports both local and global installation

3. **`packages.json`** (5,582 bytes)
   - Package registry with 16 professional packages
   - Complete metadata for all packages
   - Size-aware categorization

4. **`OVERVIEW.md`** (7,652 bytes)
   - Comprehensive technical documentation
   - Package development standards
   - Quality guidelines and workflows

### Package Collection

**16 Professional Packages** (~460MB total):

**JavaScript Engines:**
- QuickJS (15MB) - ES2023 with web console
- Duktape (188KB) - ES5/ES6 compact engine
- JerryScript (372KB) - IoT JavaScript engine

**Development Tools:**
- CMake 3.1.1 and 3.24.2 (47MB)
- PHP 7.4.33 (8MB)

**System Utilities:**
- Nano editor (164KB)
- SSH Pass (167KB)
- Netcat (42KB)

**Graphics & Libraries:**
- SDL2 (66MB)
- NCurses (19MB)
- X11 research (1.7MB) + Xeyes demo (2.6MB)

**Networking & Data:**
- Links browser (563KB)
- MySQL 5.6.49 (270MB)

**Media & Embedded:**
- Audio player (62KB)
- RISC-V RV32IMA emulation (13MB)

## 🎯 Project Goals & Philosophy

### Primary Goals

1. **Modernize BB10 Development**: Bring modern tools to BlackBerry 10 platform
2. **Professional Quality**: All packages built with GCC 9+ (vs standard GCC 4.6.3)
3. **Zero Infrastructure Costs**: Leverage GitHub for hosting and delivery
4. **Community Growth**: Establish standards for community contributions

### Technical Philosophy

- **GCC 9+ Superiority**: 30% smaller binaries, better optimizations vs GCC 4.6.3
- **Professional Packaging**: Complete documentation, proper structure
- **BB10 Native**: Tested on actual devices, not just emulators
- **Standards-Driven**: Consistent quality across all packages

## 🔧 Development Context

### Target Platform

- **Architecture**: ARM EABI5 (QNX 8 ARM)
- **Dynamic Linker**: `/usr/lib/ldqnx.so.2`
- **Primary Environment**: Term49 terminal app on BlackBerry 10
- **PATH Convention**: `$HOME/usr/local/bin` (Term49 standard)

### Build Environment

- **Toolchain**: GCC 9+ cross-compiler for QNX 8 ARM
- **Optimization**: `-O2 -s` with symbol stripping
- **Linking**: Dynamic linking preferred, static when necessary
- **Testing**: Real BlackBerry 10 devices (not emulation)

### GitHub Structure

- **Repository**: `sw7ft/qnx-packages`
- **Main Branch**: All development on `main`
- **Releases**: GitHub Releases for packages >50MB (MySQL, SDL2)
- **Raw Files**: Direct repository hosting for smaller packages

## 📋 Current State (As of Latest Commit)

### Repository Status
- **Commits**: 6 major commits establishing the system
- **Files**: 4 core files + 16 package directories
- **Documentation**: Complete with standards and overview
- **Testing**: Verified working on BlackBerry 10 Term49

### Key Features Implemented
- ✅ Large package detection and warnings
- ✅ Progress indicators for downloads >50MB
- ✅ Resume capability for interrupted downloads
- ✅ Global vs local installation detection
- ✅ POSIX shell compatibility (BB10 tested)
- ✅ Professional package standards
- ✅ Complete documentation

### Recent Achievements
- Built first modern package manager for BB10
- Migrated 15+ packages from legacy collection
- Established professional development standards
- Created comprehensive documentation
- Tested on actual BlackBerry 10 hardware

## 🚀 Future Development Priorities

### Immediate Next Steps (High Priority)

1. **Dependency Management**
   - Implement package dependency resolution
   - Add dependency checking before installation
   - Create dependency graph visualization

2. **Package Verification**
   - Add SHA256 checksums to packages.json
   - Implement signature verification
   - Add package integrity checking

3. **Update System**
   - Version comparison and update notifications
   - Bulk update capabilities
   - Rollback functionality

### Medium-Term Goals

1. **Build System Integration**
   - Automated package building from source
   - CI/CD pipeline for package updates
   - Cross-compilation automation

2. **Enhanced User Experience**
   - Search functionality within packages
   - Package categories and filtering
   - Installation progress improvements

3. **Community Features**
   - Package submission workflow
   - Community package repository
   - Package rating and reviews

### Long-Term Vision

1. **Ecosystem Expansion**
   - 50+ packages across all categories
   - Development toolchain packages
   - Gaming and multimedia expansion

2. **Advanced Features**
   - Local repository support
   - Mirror synchronization
   - Offline package management

## 🔍 Critical Technical Details

### File Locations & Paths

**Repository Structure:**
```
/Users/mp/Documents/GitHub/qnx-packages-setup/  # Git repository
/Users/mp/Documents/GitHub/                      # Parent directory (watch for duplicates!)
```

**Important**: Files sometimes end up in parent directory due to working directory confusion. Always verify file locations before committing.

### BlackBerry 10 Compatibility Requirements

1. **Shell Compatibility**: Use `#!/bin/sh` (not bash)
2. **PATH Handling**: Respect `$HOME/usr/local/bin` convention
3. **Permission Handling**: Graceful fallback for permission errors
4. **Command Compatibility**: Avoid bash-specific features
5. **Terminal Integration**: Work within Term49 limitations

### Package Size Thresholds

- **Small**: <1MB (utilities, scripts)
- **Medium**: 1-15MB (applications, libraries)
- **Large**: 15-50MB (development tools)
- **Mega**: >50MB (databases, SDKs) - require user confirmation

### GitHub Integration

- **Raw Downloads**: `https://raw.githubusercontent.com/sw7ft/qnx-packages/main/`
- **Release Downloads**: `https://github.com/sw7ft/qnx-packages/releases/download/v1.0/`
- **API Endpoints**: GitHub API for automated operations

## 🎯 AI Assistant Guidelines

### When Working on This Project

1. **Always Check File Locations**: Verify you're in the correct directory
2. **Test BB10 Compatibility**: Consider Term49 limitations
3. **Maintain Standards**: Follow established package standards
4. **Document Changes**: Update relevant documentation
5. **Verify Before Commit**: Check file sizes and content

### Common Pitfalls to Avoid

1. **Directory Confusion**: Files ending up in parent directory
2. **Bash Dependencies**: Using bash-specific features
3. **Path Assumptions**: Assuming standard Linux paths
4. **Size Ignorance**: Not considering BB10 storage limitations
5. **Testing Shortcuts**: Not testing on actual BB10 devices

### Key Commands for Development

```bash
# Navigate to correct directory
cd /Users/mp/Documents/GitHub/qnx-packages-setup

# Check file locations
ls -la && pwd

# Test package manager
sh qpkg list

# Verify BB10 compatibility
grep -n "#!/bin/bash" qpkg  # Should return nothing

# Check package sizes
du -sh */

# Test installation
sh install-qpkg.sh
```

### Essential Context for AI Assistants

1. **User Background**: Experienced developer with professional QNX/BB10 knowledge
2. **Quality Standards**: Professional-grade expectations, not hobby project
3. **Target Audience**: BB10 developers and enthusiasts
4. **Technical Constraints**: BB10 platform limitations must be respected
5. **Community Impact**: This is the first modern package manager for BB10

## 📚 Key Documentation References

- **OVERVIEW.md**: Technical standards and development guidelines
- **README.md**: User-facing documentation and package list
- **packages.json**: Complete package registry with metadata
- **GitHub Issues**: Future feature requests and bug reports

## 🎉 Project Significance

This project represents a significant achievement in the BlackBerry 10 ecosystem:

- **First Modern Package Manager**: No comparable system exists for BB10
- **Professional Quality**: All packages built with modern toolchain
- **Community Foundation**: Establishes standards for future development
- **Zero Infrastructure**: Sustainable through GitHub's free hosting
- **Real-World Tested**: Verified working on actual BB10 hardware

The project bridges the gap between BB10's aging ecosystem and modern development practices, providing a foundation for continued BlackBerry 10 development and community growth.

---

**Project Repository**: https://github.com/sw7ft/qnx-packages  
**Last Updated**: June 2024  
**Status**: Production Ready, Actively Maintained 