# Usage Guide

## Table of Contents

1. [Installation](#installation)
2. [Quick Start](#quick-start)
3. [Command Reference](#command-reference)
4. [Configuration](#configuration)
5. [Platform-Specific Notes](#platform-specific-notes)

---

## Installation

### Prerequisites

- Node.js 14+ or Bun 1.0+
- Shopify CLI 3.x
- Windows 10+ / macOS 10.14+ / Linux

### Install via NPM

```bash
npm install -g @superfatiao/shopify-dev-tools
```

### Install from Source

```bash
git clone https://github.com/SuperFaTiao/shopify-dev-tools.git
cd shopify-dev-tools

# Windows
.\install.bat

# Linux/macOS
chmod +x install.sh
./install.sh
```

---

## Quick Start

### Interactive Mode

```bash
sfd
```

The tool will prompt for your store domain.

### Direct Mode

```bash
sfd mystore.myshopify.com
```

### With Custom Memory

```bash
sfd mystore.myshopify.com -m 8192
```

---

## Command Reference

### Main Command: `sfd`

```
sfd [store-domain] [options]
```

### Options

| Option | Long | Description | Default |
|--------|------|-------------|---------|
| `-h` | `--help` | Show help | - |
| `-v` | `--version` | Show version | - |
| `-m` | `--memory` | Memory limit (MB) | 4096 |
| `-l` | `--lang` | Language (en/zh) | auto |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `SHOPIFY_STORE` | Default store domain |
| `SFD_MEMORY` | Memory limit in MB |
| `SFD_THRESHOLD` | Restart threshold in MB |
| `SFD_LANG` | Interface language |

---

## Configuration

### .sfdrc (Project-level)

Create `.sfdrc` in your theme root:

```json
{
  "memory": 8192,
  "threshold": 7000,
  "theme": "My Theme",
  "language": "en"
}
```

### Bun Configuration (.bunrc)

```toml
[run]
nodeArgs = ["--max-old-space-size=4096", "--optimize-for-size"]

[smol]
enabled = false
```

---

## Platform-Specific Notes

### Windows

**PowerShell:**
- May require execution policy change
- Run as Administrator if installing globally

**CMD:**
- Uses `sfd.cmd` wrapper
- Requires Node.js in PATH

### macOS

- May need Xcode Command Line Tools
- Install via Homebrew alternative:
  ```bash
  brew install node
  npm install -g @superfatiao/shopify-dev-tools
  ```

### Linux

- Tested on Ubuntu 20.04+, Debian 10+, CentOS 8+
- May require `sudo` for global install
- WSL2 supported

---

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.
