# Audio Player

Professional audio playback and capture utilities for QNX 8 ARM / BlackBerry 10.

## Package Contents

- **demoCaptureEco** - Audio capture demonstration utility with echo cancellation
- **demoPlayWav** - WAV file playback utility
- **libnixtla-audio.so** - Nixtla audio processing library

## Installation

```bash
# Using QPKG (recommended)
qpkg install audioplayer

# Manual installation
tar -xzf audioplayer.tar.gz -C $HOME/qnx-packages/
```

## Usage

### Playing WAV files
```bash
# Add to PATH (if not using QPKG)
export PATH="$HOME/qnx-packages/audioplayer/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/qnx-packages/audioplayer/lib:$LD_LIBRARY_PATH"

# Play a WAV file
demoPlayWav /path/to/your/audio.wav
```

### Audio Capture with Echo Cancellation
```bash
# Capture audio with echo cancellation
demoCaptureEco
```

## Technical Details

- **Architecture**: ARM EABI5 (QNX 8 compatible)
- **Dependencies**: libnixtla-audio.so (included)
- **Runtime**: Dynamically linked with `/usr/lib/ldqnx.so.2`
- **Tested on**: BlackBerry 10 devices with Term49

## Library Dependencies

The package includes all required libraries:
- `libnixtla-audio.so` - Custom audio processing library

## File Structure

```
audioplayer/
├── bin/
│   ├── demoCaptureEco     # Audio capture utility
│   └── demoPlayWav        # WAV playback utility
├── lib/
│   └── libnixtla-audio.so # Audio processing library
├── share/
│   └── doc/              # Documentation directory
└── README.md             # This file
```

## License

Audio utilities and custom library - License details to be confirmed with package maintainer.

## Support

- Compatible with BlackBerry 10 Term49 environment
- Tested on QNX 8 ARM architecture
- Part of the QPKG package collection

---

**Package Size**: 62KB  
**QPKG Category**: Media  
**Auto-Wrapper**: ✅ Automatically handles library dependencies  
**Maintainer**: SW7FT QNX Packages 