# Contributing to SuperFaTiao Shopify Dev Tools

First off, thank you for considering contributing! 🎉

## 🚀 Quick Links

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Issue Tracker](https://github.com/SuperFaTiao/shopify-dev-tools/issues)
- [Pull Requests](https://github.com/SuperFaTiao/shopify-dev-tools/pulls)

## 🛠️ Development Setup

### Prerequisites

- Node.js 14+ or Bun 1.0+
- Git
- Shopify CLI 3.x (for testing)

### Clone and Setup

```bash
# Fork the repo first, then clone your fork
git clone https://github.com/your-username/shopify-dev-tools.git
cd shopify-dev-tools

# Install dependencies
npm install

# Link for local testing
npm link
```

## 📋 Types of Contributions

### 🐛 Bug Reports

When reporting bugs, please include:

- **OS**: Windows 10/macOS/Linux
- **Shell**: PowerShell/Bash/Node
- **Version**: Run `sfd --version`
- **Steps**: Minimal reproduction steps
- **Expected**: What should happen
- **Actual**: What actually happens

Example:
```markdown
**OS**: Windows 11
**Shell**: PowerShell 7.3
**Version**: 1.0.0
**Node**: v18.15.0

**Steps**:
1. Run `sfd mystore.myshopify.com`
2. Wait 5 minutes
3. Memory reaches 4GB

**Expected**: Auto restart
**Actual**: Process hangs
```

### 💡 Feature Requests

We welcome ideas! Please:

- Check existing issues first
- Describe the use case
- Explain why it helps
- Suggest implementation (optional)

### 🔧 Pull Requests

#### Before Submitting

1. **Fork** the repository
2. **Create** a branch: `git checkout -b feature/amazing-feature`
3. **Commit** with clear messages
4. **Test** your changes
5. **Push** to your fork: `git push origin feature/amazing-feature`
6. **Open** a Pull Request

#### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Tests
- `chore`: Build/process

Examples:
```
feat(ps1): add auto-detect for WSL
fix(node): handle null memory values
docs: update installation guide
```

#### Code Standards

**Shell Scripts (Bash/PowerShell):**
- Use 2-space indentation
- Add comments for complex logic
- Handle errors gracefully
- Support UTF-8 encoding

**Node.js:**
- Follow existing code style
- Use ESLint configuration
- Add JSDoc comments
- Handle async/await properly

**Documentation:**
- Update both EN and ZH versions
- Keep examples working
- Use clear, concise language

### 🌍 Internationalization (i18n)

When adding new strings:

1. Add to both `MESSAGES.en` and `MESSAGES.zh` in `bin/sfd`
2. Add to `$script:Messages` in `bin/sfd.ps1`
3. Add to message arrays in `bin/sfd.sh`

Example:
```javascript
// bin/sfd
MESSAGES = {
  en: {
    newFeature: "New feature activated"
  },
  zh: {
    newFeature: "新功能已激活"
  }
}
```

## 🧪 Testing

### Manual Testing

Test on your platform:

```bash
# Test basic functionality
sfd --version
sfd --help

# Test with actual store (use dev store)
sfd test-store.myshopify.com

# Test memory limit
sfd test-store.myshopify.com -m 2048

# Test language
sfd --lang zh
```

### Platform Testing Matrix

| Platform | Priority | Tester Needed |
|----------|----------|---------------|
| Windows 10/11 PowerShell | High | ✅ |
| Windows CMD | High | ❓ |
| macOS Bash/Zsh | High | ❓ |
| Ubuntu 20.04+ | Medium | ❓ |
| WSL2 | Medium | ❓ |

## 📚 Documentation

### Updating Docs

- **README.md**: Main project info
- **docs/USAGE.md**: Detailed usage
- **docs/TROUBLESHOOTING.md**: Common issues
- **CHANGELOG.md**: Version history

**Rule**: Update both English and Chinese versions!

## 🏷️ Release Process

Maintainers only:

1. Update `CHANGELOG.md`
2. Bump version in `package.json`
3. Update README versions
4. Create GitHub Release
5. Publish to NPM

## 💬 Questions?

- Open an [issue](https://github.com/SuperFaTiao/shopify-dev-tools/issues)
- Join discussions
- Email: your-email@example.com

## 🙏 Thank You!

Your contributions make this project better for everyone!

---

**By contributing, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).**
