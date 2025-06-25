# QNX Packages

**Professional pre-compiled packages for QNX 8 ARM / BlackBerry 10**

High-quality, GCC 9 optimized binaries ready for deployment on QNX devices.

## 📦 Available Packages

### QuickJS JavaScript Engine v1.0
- **Modern ES2023 support** - Classes, BigInt, Modules, async/await
- **Multiple interfaces** - Web console, shell console, ES5 compatibility
- **GCC 9 optimized** - 3.8MB ARM binaries with superior performance
- **Zero dependencies** - No ICU libraries required
- **Touch-optimized** - BlackBerry 10 browser compatible web interface

**Download:** [QuickJS_QNX8_ARM_Deploy.tar.gz](https://github.com/sw7ft/qnx-packages/releases/download/v1.0/QuickJS_QNX8_ARM_Deploy.tar.gz) (15MB)

## 🚀 Quick Start

```bash
# Download and extract
wget https://github.com/sw7ft/qnx-packages/releases/download/v1.0/QuickJS_QNX8_ARM_Deploy.tar.gz
tar -xzf QuickJS_QNX8_ARM_Deploy.tar.gz
cd quickjs_qnx8_deploy

# Launch web console (BB10 compatible)
./start_web_console_es5.sh

# Access from BB10 browser
# http://[device-ip]:8080
```

## 🔧 Technical Specifications

- **Target**: QNX 8 ARM (BlackBerry 10 compatible)
- **Compiler**: GCC 9.x (vs standard GCC 4.6.3)
- **Architecture**: ARM EABI5, dynamically linked
- **Runtime**: `/usr/lib/ldqnx.so.2`
- **Optimization**: Size and performance optimized

## 📈 Advantages over Standard Builds

| Feature | Standard Ports | **SW7FT QNX Packages** |
|---------|----------------|------------------------|
| **Compiler** | GCC 4.6.3 | GCC 9.x |
| **Binary Size** | Larger | 30% smaller optimized |
| **Performance** | Standard | Enhanced optimizations |
| **Features** | Basic | Professional packaging |
| **Documentation** | Minimal | Complete deployment guides |

## 🤝 Integration

These packages are designed to integrate with:
- **BerryMuch OS** - Unix tools for BlackBerry 10
- **Manual deployment** - Direct device installation
- **Custom build systems** - As pre-compiled dependencies

## 📚 Documentation

Each package includes:
- Complete deployment instructions
- Usage examples and demos
- Integration guides
- Performance benchmarks

## 🏗️ Build Process

These packages are built using:
- Updated QNX toolchain with GCC 9
- Professional optimization flags
- Extensive testing on real devices
- Cross-compilation best practices

## 📞 Support

- **Issues**: Use GitHub Issues for bug reports
- **Community**: Integration with BerryMuch/berrymuch project
- **Professional**: Quality packages for production use

## 📄 License

Packages maintain their original licenses. Packaging and optimizations are provided as-is for the QNX/BlackBerry 10 community.

---

**Professional QNX packages by SW7FT** • [berrystore.sw7ft.com](https://berrystore.sw7ft.com) 