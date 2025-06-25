# Package Guidelines

**Standards for QNX packages in this repository**

## Directory Structure

Each package should follow this structure:
```
package-name/
├── README.md                 # Package-specific documentation
├── package-file.tar.gz       # The actual package
└── build-notes.md           # Optional: How it was built
```

## Package Requirements

### Binary Requirements
- **Target**: QNX 8 ARM (BlackBerry 10 compatible)
- **Architecture**: ARM EABI5, dynamically linked
- **Runtime**: `/usr/lib/ldqnx.so.2`
- **File format**: ELF 32-bit LSB pie executable

### Packaging Standards
- **Format**: `.tar.gz` archives
- **Structure**: Complete deployment package with `bin/`, `lib/`, `include/`, `docs/`
- **Size**: Optimized for minimal footprint
- **Dependencies**: Document any QNX library requirements

### Documentation Requirements
- **README.md**: Usage instructions, features, installation
- **Examples**: Ready-to-run code examples
- **Performance**: Benchmarks vs alternatives
- **Integration**: BerryMuch compatibility notes

## Compiler Standards

### Preferred: GCC 9+
- Advanced optimizations available
- Better ARM instruction scheduling
- Link-time optimization (LTO) support
- Superior binary size optimization

### Acceptable: GCC 4.6.3+
- Standard BB10 NDK toolchain
- Basic ARM cross-compilation
- Compatible with BerryMuch build system

## Quality Assurance

### Testing Requirements
- **Device testing**: Verified on real BlackBerry 10 hardware
- **Performance**: Startup time and memory usage documented  
- **Compatibility**: Works with standard QNX utilities
- **Integration**: Compatible with BerryMuch package system

### Optimization Guidelines
- Size optimization over speed (mobile device constraints)
- ARM-specific optimizations when possible
- Minimal external dependencies
- Clear documentation of build flags used

## Release Process

1. **Package Creation**: Build and test on QNX device
2. **Documentation**: Complete README with examples
3. **Repository**: Add to appropriate subdirectory
4. **GitHub Release**: Create versioned release with binaries
5. **Integration**: Update BerryMuch ports if applicable

## Examples

See existing packages:
- `quickjs/` - JavaScript engine with web console
- More packages coming soon...

---

**Professional QNX packages by SW7FT** 