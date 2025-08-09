NMAP for BlackBerry QNX 8 ARM
==============================

This is a cross-compiled version of Nmap 7.95 for BlackBerry QNX 8 ARM devices.

INSTALLATION:
1. Copy the entire deployment directory to your QNX 8 device
2. Place the 'bin/nmap' executable in your PATH (e.g., /accounts/1000/shared/misc/bin/)
3. Copy the 'share/nmap' data directory to /accounts/1000/shared/misc/share/

DEPENDENCIES:
This build requires the following QNX 8 system libraries (should be pre-installed):
- libm.so.2 (math library)
- libsocket.so.3 (QNX socket library) 
- libc.so.3 (QNX C library)

The following libraries are INCLUDED in this package:
- libssl.so.1.1 & libcrypto.so.1.1 (OpenSSL)
- libgcc_s.so.1 (GCC support library)
- libstdc++.so.6 (C++ standard library)
- libz.so.2 (zlib compression)

INCLUDED LIBRARIES:
This package includes ALL required shared libraries for nmap:
- libssl.so.1.1 (OpenSSL SSL/TLS library)
- libcrypto.so.1.1 (OpenSSL crypto library) 
- libgcc_s.so.1 (GCC support library)
- libstdc++.so.6 (C++ standard library)
- libz.so.2 (zlib compression library)

These should be placed in a library directory that's in your LD_LIBRARY_PATH or
copied to the system library directory on your QNX 8 device.

FEATURES:
- Host discovery and port scanning
- Service detection and version identification
- OS fingerprinting (limited on QNX)
- SSL/TLS scanning support
- NSE (Nmap Scripting Engine) with Lua scripts
- XML output support

LIMITATIONS:
- No ncat utility (due to OpenSSL compatibility issues)
- No ndiff or zenmap GUI
- Some advanced features may be limited due to QNX system constraints

USAGE:
./nmap -A target_host    # Aggressive scan
./nmap -sS target_host   # SYN stealth scan
./nmap -sV target_host   # Version detection
./nmap -O target_host    # OS detection

BUILD INFO:
- Compiler: arm-blackberry-qnx8eabi-gcc 9.3.0
- Target: arm-blackberry-nto-qnx8eabi
- Built: August 2024
- OpenSSL: 1.1.1w (custom build)
- Size: ~2.9MB binary + ~30MB data files

For more information, visit: https://nmap.org