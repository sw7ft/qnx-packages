# QNX Packages

**Professional pre-compiled packages for QNX 8 ARM / BlackBerry 10**

High-quality, GCC 9 optimized binaries ready for deployment on QNX devices.

## 📦 Available Packages

### JavaScript Engines
#### QuickJS v1.0 🚀
- **Modern ES2023 support** - Classes, BigInt, Modules, async/await
- **Web console** - Touch-optimized BB10 interface, 3.8MB ARM binaries
- **Download:** [QuickJS_QNX8_ARM_Deploy.tar.gz](https://github.com/sw7ft/qnx-packages/releases/download/v1.0/QuickJS_QNX8_ARM_Deploy.tar.gz) (15MB)

#### Duktape 🔧
- **ES5/ES6 JavaScript engine** - Compact and embeddable
- **Download:** [duktape_bb10.tar.gz](duktape/duktape_bb10.tar.gz) (188KB)

#### JerryScript 🔧  
- **IoT JavaScript engine** - ES6 features, ultra-lightweight
- **Download:** [jerryjs_es6_bb10.tar.gz](jerryjs/jerryjs_es6_bb10.tar.gz) (372KB)

### Development Tools
#### CMake 🛠️
- **Build system** - Version 3.1.1 and 3.24.2 available
- **Download:** [cmake-3.24.2-linux-x86_64.tar.gz](cmake/cmake-3.24.2-linux-x86_64.tar.gz) (47MB)

#### PHP 7.4.33 🌐
- **Web development** - Full PHP runtime for QNX
- **Download:** [php-7.4.33-qnx.zip](php/php-7.4.33-qnx.zip) (8MB)

### System Utilities
#### Nano Text Editor ✏️
- **Terminal text editor** - Lightweight and user-friendly
- **Download:** [nano_bb10.tar.gz](nano/nano_bb10.tar.gz) (164KB)

#### SSH Pass 🔐
- **SSH automation** - Non-interactive SSH password authentication
- **Download:** [sshpass-106-modified-berrymuch.tar.gz](sshpass/sshpass-106-modified-berrymuch.tar.gz) (167KB)

#### Netcat 🌐
- **Networking Swiss Army knife** - TCP/UDP debugging and data transfer
- **Download:** [nc.zip](netcat/nc.zip) (42KB)

### Graphics & UI
#### SDL2 🎮
- **Graphics library** - Cross-platform multimedia development
- **Download:** [SDL2-2.0.9.tar](https://github.com/sw7ft/qnx-packages/releases/download/v1.0/SDL2-2.0.9.tar) (66MB)

#### X11 Research 🔬
- **X11 investigation** - BB10 X11 compatibility research
- **Download:** [bb10_x11_research.zip](x11-research/bb10_x11_research.zip) (1.7MB)

#### X11 Xeyes 👀
- **X11 demo** - Complete working X11 application example
- **Download:** [bb10_x11_xeyes_complete.zip](x11-xeyes/bb10_x11_xeyes_complete.zip) (2.6MB)

### Libraries
#### NCurses 📟
- **Terminal UI library** - Text-based user interface development
- **Download:** [ncurses-6.4.tar](ncurses/ncurses-6.4.tar) (19MB)

### Networking
#### Links Browser 🌐
- **Text-mode web browser** - Lightweight browsing for BB10
- **Download:** [links_bb10.tar.gz](links/links_bb10.tar.gz) (563KB)

### Databases
#### MySQL 5.6.49 🗄️
- **Relational database** - Full MySQL server for QNX
- **Download:** [mysql-5.6.49.tar](https://github.com/sw7ft/qnx-packages/releases/download/v1.0/mysql-5.6.49.tar) (270MB)

### Embedded Systems
#### RISC-V RV32IMA 🔧
- **RISC-V emulation** - 32-bit RISC-V processor implementation
- **Download:** [bb10-mini-rv32ima-full.zip](rv32ima/bb10-mini-rv32ima-full.zip) (13MB)

### Media
#### Audio Player 🎵
- **Media playback** - Audio playback application for BB10
- **Download:** [audioplayer.zip](audioplayer/audioplayer.zip) (62KB)

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

## 📁 Repository Structure

```
qnx-packages/
├── README.md                 # This file - repository overview
├── docs/                     # Shared documentation
│   └── package-guidelines.md # Standards for packages
├── JavaScript Engines/
│   ├── quickjs/              # ES2023 JavaScript engine (15MB)
│   ├── duktape/              # ES5/ES6 compact engine (188KB)  
│   └── jerryjs/              # IoT JavaScript engine (372KB)
├── Development Tools/
│   ├── cmake/                # Build system (47MB)
│   └── php/                  # PHP 7.4.33 runtime (8MB)
├── System Utilities/
│   ├── nano/                 # Text editor (164KB)
│   ├── sshpass/              # SSH automation (167KB)
│   └── netcat/               # Network debugging (42KB)
├── Graphics & Libraries/
│   ├── sdl2/                 # Graphics library (66MB)
│   ├── x11-research/         # X11 BB10 research (1.7MB)
│   ├── x11-xeyes/            # X11 demo app (2.6MB)
│   └── ncurses/              # Terminal UI library (19MB)
├── Networking & Data/
│   ├── links/                # Text web browser (563KB)
│   └── mysql/                # Database server (270MB)
├── Embedded Systems/
│   └── rv32ima/              # RISC-V emulation (13MB)
└── Media/
    └── audioplayer/          # Audio playback (62KB)
```

**Total Collection**: 15+ professional QNX packages (~460MB)

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