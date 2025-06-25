# QuickJS for QNX 8 ARM

**Modern ES2023 JavaScript Engine with Web Console for BlackBerry 10**

## 📊 Package Information

- **Version**: QuickJS 2024-01-13 + SW7FT Optimizations
- **Size**: 15MB complete deployment package
- **Binaries**: 3.8-3.9MB ARM executables
- **Compiler**: GCC 9.x optimized (vs standard GCC 4.6.3)
- **Target**: QNX 8 ARM / BlackBerry 10

## 🚀 What's Included

### Executables (`bin/`)
- `qjsc` - JavaScript compiler (3.8MB)
- `quickjs_web_console` - Modern web interface
- `quickjs_web_console_es5` - BB10 compatible version
- `quickjs_shell_console` - Terminal interface
- `quickjs_simple_console` - Minimal console

### Libraries (`lib/`)
- `libquickjs.a` - Static library (4.7MB)
- `libquickjs.lto.a` - LTO optimized version (5.9MB)

### Headers (`include/`)
- Complete C API headers for embedding
- All QuickJS development files

### Documentation (`docs/`)
- Deployment guides
- Usage examples
- Integration instructions

## 🌐 Web Console Features

**Professional Web Interface:**
- Touch-optimized for BlackBerry 10 browser
- Syntax highlighting and error display
- Multi-line code input with Ctrl+Enter execution
- Real-time JavaScript execution via HTTP POST
- ES5 and ES6+ compatibility modes

**JavaScript Engine:**
- Full ES2023 support: Classes, BigInt, Modules
- Standard library: Math, Date, JSON, Array methods
- Error handling with stack traces
- Memory-efficient execution

## 📱 Usage Examples

### Quick Start
```bash
# Extract package
tar -xzf QuickJS_QNX8_ARM_Deploy.tar.gz
cd quickjs_qnx8_deploy

# Start web console (BB10 compatible)
./start_web_console_es5.sh

# Access from BB10 browser
# http://[device-ip]:8080
```

### JavaScript Examples Ready to Test
```javascript
// Modern ES2023 Features
const device = { platform: "QNX 8 ARM", engine: "QuickJS" };
console.log(device);

// Classes and Methods
class Counter { 
  constructor() { this.n = 0; } 
  inc() { return ++this.n; } 
}
const c = new Counter(); c.inc();

// BigInt Arithmetic  
const bigNum = 123456789012345678901234567890n;
console.log(bigNum.toString());

// Array Operations
[1,2,3,4,5].filter(x => x % 2 === 0).map(x => x * x)
```

### Command Line Usage
```bash
# Compile JavaScript to C
./bin/qjsc script.js -o compiled.c

# Interactive shell
./bin/quickjs_shell_console

# Simple console
./bin/quickjs_simple_console
```

## 🔧 Integration Options

### BerryMuch Integration
This package is designed to work with the BerryMuch ports system:
```bash
# Via berrymuch (when available)
make build-wip.quickjs
```

### Manual Installation
```bash
# Copy to device standard location
cp -r quickjs_qnx8_deploy /accounts/1000/shared/misc/
```

### C Embedding
```c
#include "quickjs.h"
// Link with lib/libquickjs.a
JSRuntime *rt = JS_NewRuntime();
JSContext *ctx = JS_NewContext(rt);
```

## 📈 Performance Comparison

| Metric | QuickJS (GCC 9) | JavaScriptCore | Node.js |
|--------|-----------------|----------------|---------|
| Binary Size | 3.9MB | 5.6MB | 50MB+ |
| Startup Time | <300μs | ~2s | ~1s |
| Memory Usage | ~1MB | ~5MB | ~10MB |
| Dependencies | None | ICU libs | Many |
| ES2023 Support | ✅ Full | ✅ Full | ✅ Full |

## 🏗️ Build Information

**Optimizations Applied:**
- GCC 9.x advanced optimizations
- Link-time optimization (LTO)
- Size optimization while maintaining performance
- ARM-specific instruction scheduling
- Dead code elimination

**Quality Assurance:**
- Tested on real BlackBerry 10 devices
- Verified ES2023 feature compliance
- Performance benchmarked
- Memory leak testing

## 📞 Support

- **Issues**: Report via GitHub Issues
- **Documentation**: See included README.md and DEPLOY.md
- **Community**: BerryMuch project integration
- **Professional**: Production-ready deployment

---

**Built with GCC 9 optimization by SW7FT** 