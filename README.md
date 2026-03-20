<div align="center">

<img src="https://img.shields.io/badge/SuperFaTiao-Shopify%20Dev%20Tools-blue?style=for-the-badge&logo=shopify&logoColor=white" alt="SuperFaTiao Shopify Dev Tools" />

# 🛡️ Shopify Dev Tools

**Universal Memory-Safe Development Kit for Shopify Themes**

[![Version](https://img.shields.io/npm/v/@superfatiao/shopify-dev-tools)](https://www.npmjs.com/package/@superfatiao/shopify-dev-tools)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/shell-PowerShell%20%7C%20Bash%20%7C%20Node-orange.svg)]()

[English](README.md) | [中文](README.zh.md) | [Usage Guide](docs/USAGE.md)

</div>

---

## ✨ What is this?

A **memory-safe** development toolkit that prevents Bun/Node.js crashes when developing Shopify themes. Automatically monitors memory usage and gracefully restarts the dev server when thresholds are exceeded.

### 🎯 Perfect for:
- Large Shopify themes with many files
- Long development sessions
- Low-memory environments
- Teams needing stable dev environments

---

## 🚀 Quick Start

### Installation

```bash
# Via NPM (Recommended)
npm install -g @superfatiao/shopify-dev-tools

# Via Git
git clone https://github.com/SuperFaTiao/shopify-dev-tools.git
cd shopify-dev-tools && npm link
```

### Usage

```bash
# Interactive mode (prompts for store)
sfd

# Direct mode
sfd mystore.myshopify.com

# With custom memory limit
sfd mystore.myshopify.com -m 8192
```

**That's it!** The tool will automatically:
- Set memory limit to 4GB
- Monitor every 10 seconds
- Restart gracefully at 85% usage
- Preserve your work

---

## 🛡️ How It Protects You

```
┌─────────────────────────────────────────────────────────┐
│  BEFORE: Memory Crash                                   │
│  Shopify CLI → High Memory → 💥 Crash → Lost work       │
├─────────────────────────────────────────────────────────┤
│  AFTER: Auto Protection                                 │
│  Shopify CLI → Monitor → Threshold → 🔄 Restart → ✅    │
└─────────────────────────────────────────────────────────┘
```

**5-Layer Protection:**
1. **Config** - Sets 4GB memory limit
2. **Monitor** - Checks every 10s
3. **Threshold** - Restarts at 85%
4. **Graceful** - Saves work, clears memory
5. **Limit** - Max 5 restarts (prevents loops)

---

## 💻 Platform Support

| Platform | Shell | Command |
|----------|-------|---------|
| Windows | PowerShell | `sfd` or `.\sfd.ps1` |
| Windows | CMD | `sfd` |
| macOS | Bash/Zsh | `sfd` or `./sfd.sh` |
| Linux | Bash | `sfd` or `./sfd.sh` |
| Any | Node.js | `node bin/sfd` |

---

## 🌍 Multi-Language Support

Auto-detects your system language:

```bash
# Force English
sfd --lang en

# Force Chinese
sfd --lang zh
```

Or set environment variable:
```bash
export SFD_LANG=zh  # Always Chinese
```

---

## ⚙️ Configuration

### Command Line Options

```
Usage: sfd [store-domain] [options]

Options:
  -h, --help        Show help
  -v, --version     Show version
  -m, --memory      Memory limit in MB (default: 4096)
  -l, --lang        Language: en or zh (default: auto)

Examples:
  sfd                                      # Interactive mode
  sfd mystore.myshopify.com                # Direct store
  sfd -m 8192                              # 8GB memory limit
  sfd --lang zh                            # Chinese interface
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SHOPIFY_STORE` | Default store domain | - |
| `SFD_MEMORY` | Memory limit (MB) | 4096 |
| `SFD_THRESHOLD` | Restart threshold (MB) | 3500 |
| `SFD_LANG` | Interface language | auto |

### Bun Configuration

Create `.bunrc` in your theme root:

```toml
[run]
nodeArgs = ["--max-old-space-size=4096", "--optimize-for-size"]

[smol]
enabled = false  # Set true for aggressive GC
```

---

## 📦 Installation Methods

### Method 1: NPM (Recommended)

```bash
npm install -g @superfatiao/shopify-dev-tools
sfd mystore.myshopify.com
```

### Method 2: Direct Download

```bash
# Download latest release
curl -L https://github.com/SuperFaTiao/shopify-dev-tools/releases/latest/download/shopify-dev-tools.zip -o sfd.zip
unzip sfd.zip
cd shopify-dev-tools

# Run directly
node bin/sfd mystore.myshopify.com
```

### Method 3: Windows Installer

```powershell
# Download and run install.bat
.\install.bat

# Then use globally
sfd mystore.myshopify.com
```

### Method 4: Unix Installer

```bash
# Download and run
chmod +x install.sh
./install.sh

# Restart terminal
sfd mystore.myshopify.com
```

---

## 🐛 Troubleshooting

### "Out of memory" still occurs?

```bash
# Increase to 8GB
sfd mystore.myshopify.com -m 8192

# Or enable aggressive GC in .bunrc
[smol]
enabled = true
```

### Permission denied (Linux/Mac)?

```bash
chmod +x bin/sfd.sh
```

### PowerShell execution policy?

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for more.

---

## 📁 Project Structure

```
shopify-dev-tools/
├── bin/
│   ├── sfd              # Main Node.js entry (cross-platform)
│   ├── sfd.ps1          # PowerShell version (Windows)
│   └── sfd.sh           # Bash version (Linux/Mac)
├── docs/
│   ├── USAGE.md         # Detailed usage guide
│   ├── USAGE.zh.md      # Chinese usage guide
│   └── TROUBLESHOOTING.md
├── README.md            # This file
├── README.zh.md         # Chinese README
├── LICENSE              # MIT License
├── install.bat          # Windows installer
├── install.sh           # Unix installer
└── package.json         # NPM configuration
```

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md).

### Quick Start for Contributors

```bash
# Fork and clone
git clone https://github.com/your-username/shopify-dev-tools.git
cd shopify-dev-tools

# Install dependencies
npm install

# Make changes
# ...

# Test
npm test

# Submit PR
git push origin feature/your-feature
```

---

## 📈 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

## 🙏 Acknowledgments

- [Shopify CLI](https://shopify.dev/docs/themes/tools/cli) - The official CLI
- [Bun](https://bun.sh) - Fast JavaScript runtime
- [Node.js](https://nodejs.org) - JavaScript runtime

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file.

---

<div align="center">

**Made with ❤️ by [SuperFaTiao](https://github.com/SuperFaTiao)**

⭐ Star this repo if it helps you!

[Report Bug](https://github.com/SuperFaTiao/shopify-dev-tools/issues) · [Request Feature](https://github.com/SuperFaTiao/shopify-dev-tools/issues)

</div>
