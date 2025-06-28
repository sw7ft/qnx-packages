# JerryScript

Lightweight JavaScript engine with ES6 support for QNX 8 ARM / BlackBerry 10.

## Package Contents

- **jerry** - JerryScript JavaScript engine with ES6 features

## Installation

```bash
# Using QPKG (recommended)
qpkg install jerryjs

# Manual installation
tar -xzf jerryjs.tar.gz -C $HOME/qnx-packages/
```

## Usage

### Running JavaScript files
```bash
# Add to PATH (if not using QPKG)
export PATH="$HOME/qnx-packages/jerryjs/bin:$PATH"

# Execute JavaScript files
jerry script.js

# Interactive REPL mode
jerry
```

### Example JavaScript
```javascript
// test.js
console.log("Hello from JerryScript!");

// ES6 features
const arr = [1, 2, 3];
const doubled = arr.map(x => x * 2);
console.log(doubled);

// Modern JavaScript
class Calculator {
    add(a, b) {
        return a + b;
    }
}

const calc = new Calculator();
console.log(calc.add(5, 3));
```

```bash
jerry test.js
```

## Technical Details

- **Architecture**: ARM EABI5 (QNX 8 compatible)
- **JavaScript Version**: ES6+ support
- **Runtime**: Dynamically linked with `/usr/lib/ldqnx.so.2`
- **Binary Size**: ~727KB (optimized for embedded systems)
- **Tested on**: BlackBerry 10 devices with Term49

## Features

- **ES6 Support**: Arrow functions, classes, const/let, template literals
- **Lightweight**: Designed for resource-constrained environments
- **REPL Mode**: Interactive JavaScript console
- **File Execution**: Run JavaScript files directly
- **Standard Library**: Core JavaScript APIs

## File Structure

```
jerryjs/
├── bin/
│   └── jerry              # JerryScript executable
├── share/
│   └── doc/              # Documentation directory
└── README.md             # This file
```

## License

JerryScript is licensed under the Apache License 2.0.

## Support

- Compatible with BlackBerry 10 Term49 environment
- Tested on QNX 8 ARM architecture
- Part of the QPKG package collection

---

**Package Size**: 364KB  
**QPKG Category**: JavaScript Engines  
**Auto-Wrapper**: ✅ Automatically handles library dependencies  
**Maintainer**: SW7FT QNX Packages 