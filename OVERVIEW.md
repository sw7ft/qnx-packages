# QPKG Package Manager - Technical Overview & Standards

## 🎯 Architecture Overview

QPKG is a GitHub-powered package manager specifically designed for QNX 8 ARM / BlackBerry 10 devices. It leverages GitHub's infrastructure for zero-cost hosting and global CDN delivery.

### Core Components

1. **Package Manager (`qpkg`)** - POSIX shell script for BB10 compatibility
2. **Package Registry (`packages.json`)** - JSON manifest with metadata
3. **GitHub Repository** - Hosting for packages and releases
4. **Installer Script (`install-qpkg.sh`)** - One-command setup

### Package Storage Strategy

- **Small packages** (<50MB): Stored directly in repository
- **Large packages** (>50MB): Hosted via GitHub Releases
- **Automatic detection**: QPKG warns users and shows progress for large packages

## 📦 Package Standards

### Package Structure Requirements

All packages must follow this directory structure:

```
package-name/
├── README.md              # Package documentation
├── package-name.tar.gz    # Main archive (or .zip)
├── metadata.json          # Package metadata (optional)
└── install.sh            # Custom installation script (optional)
```

### Package Naming Convention

- **Package names**: lowercase, hyphenated (e.g., `quickjs`, `x11-xeyes`)
- **Archive files**: `{package-name}.tar.gz` or `{package-name}.zip`
- **Version suffixes**: `{package-name}-{version}.tar.gz` (e.g., `mysql-5.6.49.tar.gz`)

### Archive Content Standards

Archives should contain a well-organized structure:

```
extracted-package/
├── bin/                   # Executables (added to PATH suggestions)
├── lib/                   # Shared libraries
├── include/               # Header files (for development packages)
├── share/                 # Documentation, man pages, data files
├── etc/                   # Configuration files
├── README.md              # Package-specific documentation
├── LICENSE                # License file
└── INSTALL.md             # Installation/usage instructions
```

## 🔧 Technical Standards

### Target Architecture

- **Platform**: QNX 8 ARM (BlackBerry 10 compatible)
- **Architecture**: ARM EABI5, dynamically linked with `/usr/lib/ldqnx.so.2`
- **Toolchain**: GCC 9+ recommended (produces smaller, optimized binaries)

### Library Handling

**For packages with dependencies:**

1. **Static linking** (preferred): Include all dependencies in the binary
2. **Bundled libraries**: Include required `.so` files in `lib/` directory
3. **System libraries**: Document QNX system requirements in README

**Library search paths:**
```bash
# QPKG suggests adding to user's environment
export LD_LIBRARY_PATH="$HOME/qnx-packages/{package}/lib:$LD_LIBRARY_PATH"
```

### Binary Optimization

- **Strip symbols**: Use `strip` to reduce binary size
- **Optimization flags**: `-O2 -s` for production builds
- **Size targets**: 
  - Small utilities: <1MB
  - Medium packages: 1-15MB  
  - Large packages: 15-50MB
  - Mega packages: >50MB (require user confirmation)

## 📝 Package Manifest Schema

Each package in `packages.json` follows this schema:

```json
{
  "package-name": {
    "version": "1.0.0",
    "description": "Brief description of the package",
    "size": "15MB",
    "download_url": "https://github.com/sw7ft/qnx-packages/raw/main/package-name/package-name.tar.gz",
    "installation": "extract",
    "dependencies": [],
    "architecture": "QNX 8 ARM",
    "license": "MIT",
    "homepage": "https://project-homepage.com",
    "maintainer": "Your Name <email@example.com>"
  }
}
```

### Required Fields

- `version`: Semantic version (e.g., "1.0.0")
- `description`: One-line description (max 80 chars)
- `size`: Human-readable size with unit (e.g., "15MB", "164KB")
- `download_url`: Direct download link
- `installation`: Always "extract" for current QPKG version
- `architecture`: Always "QNX 8 ARM"

### Optional Fields

- `dependencies`: Array of package names (not yet implemented)
- `license`: SPDX license identifier
- `homepage`: Project website
- `maintainer`: Package maintainer contact

## 🚀 Package Development Workflow

### 1. Build Phase

```bash
# Using GCC 9+ toolchain for QNX 8 ARM
export CC=qcc
export CFLAGS="-Vgcc_ntoarmv7le -O2 -s"
export LDFLAGS="-Wl,--gc-sections"

# Configure, build, and strip
./configure --host=arm-unknown-nto-qnx8.0.0eabi
make -j$(nproc)
strip your-binary
```

### 2. Package Creation

```bash
# Create package directory
mkdir -p package-name/{bin,lib,share,etc}

# Copy files to appropriate locations
cp your-binary package-name/bin/
cp *.so package-name/lib/
cp docs/* package-name/share/

# Create documentation
cat > package-name/README.md << 'EOF'
# Package Name

Description of your package.

## Installation
```bash
sh qpkg install package-name
```

## Usage
```bash
# Add to PATH if needed
export PATH="$HOME/qnx-packages/package-name/bin:$PATH"

# Run the program
your-binary --help
```
EOF

# Create archive
tar -czf package-name.tar.gz package-name/
```

### 3. Size Optimization

```bash
# Check package size
du -sh package-name.tar.gz

# If >50MB, consider:
# 1. Strip debugging symbols
# 2. Remove unnecessary files
# 3. Use better compression
# 4. Split into multiple packages
```

### 4. Testing on BlackBerry 10

```bash
# Test installation
sh qpkg install your-package

# Test execution
cd qnx-packages/your-package
./bin/your-binary --version

# Test library loading
ldd bin/your-binary
```

## 📋 Package Categories

### JavaScript Engines
- **QuickJS**: Modern ES2023 with web console
- **Duktape**: Compact ES5/ES6 engine
- **JerryScript**: IoT-focused engine

### Development Tools
- **CMake**: Build system generator
- **PHP**: Scripting language with web server

### System Utilities
- **Nano**: Text editor
- **SSH Pass**: SSH authentication helper
- **Netcat**: Network utility

### Graphics & Multimedia
- **SDL2**: Graphics and multimedia library
- **X11**: Research packages and demos
- **Audio Player**: BB10-native audio player

### Networking
- **Links**: Text-based web browser
- **MySQL**: Database server

### Libraries
- **NCurses**: Terminal control library

## 🔍 Quality Checklist

Before submitting a package:

- [ ] **Binary works** on actual BB10 device
- [ ] **Size optimized** (stripped, compressed)
- [ ] **Documentation** complete (README.md)
- [ ] **Dependencies** bundled or documented
- [ ] **License** clearly specified
- [ ] **Archive structure** follows standards
- [ ] **Manifest entry** complete and accurate
- [ ] **Testing** performed on Term49

## 🎯 Future Enhancements

### Planned Features

1. **Dependency management**: Automatic dependency resolution
2. **Package verification**: SHA256 checksums
3. **Update system**: Package version checking
4. **Local repository**: Support for private package repositories
5. **Build system**: Automated package building from source

### Package Ideas

- **Development**: GCC toolchain, Git, Make, GDB
- **Networking**: OpenSSH, cURL, wget, rsync
- **Multimedia**: FFmpeg, ImageMagick
- **Languages**: Python, Lua, Perl, Ruby
- **Databases**: SQLite, PostgreSQL client
- **Games**: Classic terminal games, emulators

## 📚 References

- [QNX Documentation](https://www.qnx.com/developers/docs/)
- [BlackBerry 10 Development](https://developer.blackberry.com/)
- [GitHub Releases API](https://docs.github.com/en/rest/releases)
- [POSIX Shell Standards](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)

---

**QPKG Package Manager** - Professional package management for QNX 8 ARM / BlackBerry 10  
Repository: https://github.com/sw7ft/qnx-packages 