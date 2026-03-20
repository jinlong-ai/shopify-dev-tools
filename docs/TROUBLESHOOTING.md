# Troubleshooting

## Common Issues

### 1. "sfd command not found"

**Cause:** Not installed or not in PATH

**Solution:**
```bash
# Verify installation
which sfd
# or
where sfd

# Reinstall
npm install -g @superfatiao/shopify-dev-tools

# Or add to PATH manually
export PATH="$HOME/.local/bin:$PATH"
```

### 2. "Shopify CLI not found"

**Cause:** Shopify CLI not installed

**Solution:**
```bash
npm install -g @shopify/cli

# Verify
shopify --version
```

### 3. "Out of memory" still occurs

**Cause:** Memory limit too low or memory leak

**Solution:**
```bash
# Increase memory to 8GB
sfd mystore.myshopify.com -m 8192

# Or set globally
export SFD_MEMORY=8192

# Enable aggressive GC in .bunrc:
# [smol]
# enabled = true
```

### 4. PowerShell execution policy error

**Cause:** PowerShell restricts script execution

**Solution:**
```powershell
# Current user only
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or bypass for this session
powershell -ExecutionPolicy Bypass -File sfd.ps1
```

### 5. Permission denied (Linux/Mac)

**Cause:** Script not executable

**Solution:**
```bash
chmod +x bin/sfd.sh
chmod +x install.sh
```

### 6. Language not changing

**Cause:** Environment variable not set

**Solution:**
```bash
# Temporary
SFD_LANG=zh sfd

# Permanent
export SFD_LANG=zh
```

### 7. Auto-restart not working

**Cause:** Process monitoring issue

**Solution:**
```bash
# Check if Node processes are visible
ps aux | grep node

# Try direct Node execution
node bin/sfd mystore.myshopify.com
```

### 8. Memory monitoring shows 0MB

**Cause:** Cannot detect Node processes

**Solution:**
- On some systems, use direct Node execution instead of wrapper
- Check process name: `ps aux | grep -i node`

---

## Platform-Specific

### Windows

**Issue:** Batch file shows garbled text
**Solution:** Ensure UTF-8 encoding in terminal:
```cmd
chcp 65001
```

**Issue:** Installation requires admin
**Solution:** Run PowerShell/CMD as Administrator

### macOS

**Issue:** "command not found" after install
**Solution:**
```bash
# Add to ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Linux

**Issue:** Permission denied on install
**Solution:**
```bash
sudo ./install.sh
# Or install locally:
./install.sh --local
```

---

## Debug Mode

Run with debug output:

```bash
# Bash
debug=1 sfd mystore.myshopify.com

# PowerShell
$env:debug=1; sfd mystore.myshopify.com
```

---

## Getting Help

1. Check logs: `cat .logs/sfd-*.log`
2. Run memory profile: `sfd --profile`
3. Open issue: https://github.com/SuperFaTiao/shopify-dev-tools/issues

---

## Known Limitations

1. **WSL:** May require Windows interop settings
2. **Docker:** Memory limits may not apply in containers
3. **Old Node:** Requires Node.js 14+
4. **Git Bash on Windows:** Use `sfd.cmd` instead of `sfd.sh`
