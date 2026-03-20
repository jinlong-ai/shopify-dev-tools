# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial multi-language support (English & Chinese)
- Auto-detection of system language

## [1.0.0] - 2024-03-20

### Added
- ✨ First public release
- 🛡️ 5-layer memory protection system
- 💻 Cross-platform support (Windows/macOS/Linux)
- 🐚 Multi-shell support (PowerShell/Bash/Node.js)
- 🌍 Bilingual documentation (EN & ZH)
- 📊 Real-time memory monitoring (every 10s)
- 🔄 Auto-restart on memory threshold (85%)
- 📦 Multiple installation methods (NPM/Git/Direct)
- 🔧 Configurable memory limits
- 📝 Comprehensive documentation
- 🐛 Troubleshooting guide

### Features

#### Core Protection
- Memory limit enforcement (default 4GB)
- Automatic garbage collection hints
- Graceful restart process
- Maximum restart limit (5 times)
- Process cleanup on exit

#### Platform Support
- **Windows**: PowerShell 5.1+, CMD
- **macOS**: Bash, Zsh
- **Linux**: Bash
- **Universal**: Node.js 14+

#### Internationalization
- English (en)
- Chinese/Simplified (zh)
- Auto-detection from system locale
- Manual language override

#### Installation
- NPM global install
- Git clone + npm link
- Direct download
- Windows installer (install.bat)
- Unix installer (install.sh)

### Technical Details

#### Memory Management
- Sets `NODE_OPTIONS=--max-old-space-size=4096`
- Monitors Node.js heap usage
- Triggers restart at 3500MB (85% of 4GB)
- Clears process and restarts gracefully

#### Scripts
- `bin/sfd`: Node.js entry (cross-platform)
- `bin/sfd.ps1`: PowerShell with i18n
- `bin/sfd.sh`: Bash with i18n

#### Documentation
- README.md (English)
- README.zh.md (Chinese)
- docs/USAGE.md (English)
- docs/USAGE.zh.md (Chinese)
- docs/TROUBLESHOOTING.md

### Known Issues
- PowerShell on Windows may require execution policy change
- Memory detection may show 0MB on some Linux systems
- Git Bash on Windows should use `sfd.cmd` instead of `sfd.sh`

### Security
- No sensitive data logging
- Environment variables only in user scope
- No network requests except Shopify CLI

---

## Release History

- [1.0.0] - 2024-03-20 - Initial Release

[Unreleased]: https://github.com/SuperFaTiao/shopify-dev-tools/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/SuperFaTiao/shopify-dev-tools/releases/tag/v1.0.0
