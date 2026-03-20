#!/usr/bin/env bash
#
# SuperFaTiao Shopify Dev Tools - Unix Installer
# Supports: Linux, macOS, WSL
#

set -e

echo "============================================"
echo "  SuperFaTiao Shopify Dev Tools Installer"
echo "============================================"
echo

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="${HOME}/.local/share/superfatiao-shopify-dev"
BIN_DIR="${INSTALL_DIR}/bin"

# Detect shell
SHELL_NAME=$(basename "$SHELL")
SHELL_CONFIG=""

case "$SHELL_NAME" in
    bash)
        SHELL_CONFIG="${HOME}/.bashrc"
        ;;
    zsh)
        SHELL_CONFIG="${HOME}/.zshrc"
        ;;
    fish)
        SHELL_CONFIG="${HOME}/.config/fish/config.fish"
        ;;
    *)
        SHELL_CONFIG="${HOME}/.profile"
        ;;
esac

# Create directories
echo -e "${YELLOW}[1/5]${NC} Creating directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "${HOME}/.local/bin"

# Copy files
echo -e "${YELLOW}[2/5]${NC} Installing files..."
cp -r "$(dirname "$0")/bin/"* "$BIN_DIR/"
[ -d "$(dirname "$0")/scripts" ] && cp -r "$(dirname "$0")/scripts" "$INSTALL_DIR/"
[ -d "$(dirname "$0")/locales" ] && cp -r "$(dirname "$0")/locales" "$INSTALL_DIR/"
cp "$(dirname "$0")/README.md" "$INSTALL_DIR/" 2>/dev/null || true
cp "$(dirname "$0")/README.zh.md" "$INSTALL_DIR/" 2>/dev/null || true
cp "$(dirname "$0")/package.json" "$INSTALL_DIR/" 2>/dev/null || true

# Make scripts executable
echo -e "${YELLOW}[3/5]${NC} Setting permissions..."
chmod +x "$BIN_DIR/"*

# Create symlink
echo -e "${YELLOW}[4/5]${NC} Creating symlinks..."
ln -sf "$BIN_DIR/sfd.sh" "${HOME}/.local/bin/sfd"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":${HOME}/.local/bin:"* ]]; then
    echo -e "${YELLOW}[5/5]${NC} Updating shell configuration..."

    if [ "$SHELL_NAME" = "fish" ]; then
        mkdir -p "$(dirname "$SHELL_CONFIG")"
        echo "set -x PATH \"\$HOME/.local/bin\" \$PATH" >> "$SHELL_CONFIG"
    else
        echo "" >> "$SHELL_CONFIG"
        echo "# SuperFaTiao Dev Tools" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_CONFIG"
        echo "export SFD_INSTALL=\"$INSTALL_DIR\"" >> "$SHELL_CONFIG"
        echo "alias sfd='sfd.sh'" >> "$SHELL_CONFIG"
    fi
    echo -e "${GREEN}[OK]${NC} Shell configured"
else
    echo -e "${GREEN}[OK]${NC} PATH already configured"
fi

# Create man page (optional)
if [ -d "/usr/local/share/man/man1" ]; then
    cat > /tmp/sfd.1 << 'EOF'
.TH SFD 1 "2024" "SuperFaTiao" "User Commands"
.SH NAME
sfd \- SuperFaTiao Shopify Dev Tools
.SH SYNOPSIS
.B sfd
[\fISTORE\fR] [\fIOPTIONS\fR]
.SH DESCRIPTION
Universal Memory-Safe Development Kit for Shopify Themes
.SH OPTIONS
.TP
.BR \-h ", " \-\-help
Show help message
.TP
.BR \-v ", " \-\-version
Show version
.TP
.BR \-m ", " \-\-memory " " \fIMB\fR
Set memory limit (default: 4096)
.TP
.BR \-l ", " \-\-lang " " \fILANG\fR
Set language (en/zh)
.SH ENVIRONMENT
.TP
.B SFD_MEMORY
Memory limit in MB
.TP
.B SFD_LANG
Interface language
.TP
.B SHOPIFY_STORE
Default store domain
.SH SEE ALSO
Shopify CLI documentation: https://shopify.dev/docs/themes/tools/cli
EOF
    sudo cp /tmp/sfd.1 /usr/local/share/man/man1/ 2>/dev/null || true
fi

echo
echo "============================================"
echo "  Installation Complete!"
echo "============================================"
echo
echo -e "Location: ${GREEN}$INSTALL_DIR${NC}"
echo
echo "Usage:"
echo "  sfd [store-domain] [options]"
echo
echo "Examples:"
echo "  sfd                          # Interactive"
echo "  sfd mystore.myshopify.com   # Direct store"
echo "  sfd -m 8192                 # 8GB memory"
echo
echo -e "${YELLOW}Please restart your terminal or run:${NC}"
echo "  source $SHELL_CONFIG"
echo
echo "============================================"
