# 用法指南

## 目录

1. [安装](#安装)
2. [快速开始](#快速开始)
3. [命令参考](#命令参考)
4. [配置](#配置)
5. [平台特定说明](#平台特定说明)

---

## 安装

### 前提条件

- Node.js 14+ 或 Bun 1.0+
- Shopify CLI 3.x
- Windows 10+ / macOS 10.14+ / Linux

### 通过 NPM 安装

```bash
npm install -g @superfatiao/shopify-dev-tools
```

### 从源码安装

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

## 快速开始

### 交互模式

```bash
sfd
```

工具会提示输入商店域名。

### 直接模式

```bash
sfd mystore.myshopify.com
```

### 自定义内存

```bash
sfd mystore.myshopify.com -m 8192
```

---

## 命令参考

### 主命令：`sfd`

```
sfd [商店域名] [选项]
```

### 选项

| 选项 | 长选项 | 描述 | 默认值 |
|------|--------|------|--------|
| `-h` | `--help` | 显示帮助 | - |
| `-v` | `--version` | 显示版本 | - |
| `-m` | `--memory` | 内存限制（MB） | 4096 |
| `-l` | `--lang` | 语言（en/zh） | 自动 |

### 环境变量

| 变量 | 描述 |
|------|------|
| `SHOPIFY_STORE` | 默认商店域名 |
| `SFD_MEMORY` | 内存限制（MB） |
| `SFD_THRESHOLD` | 重启阈值（MB） |
| `SFD_LANG` | 界面语言 |

---

## 配置

### .sfdrc（项目级）

在主题根目录创建 `.sfdrc`：

```json
{
  "memory": 8192,
  "threshold": 7000,
  "theme": "My Theme",
  "language": "zh"
}
```

### Bun 配置（.bunrc）

```toml
[run]
nodeArgs = ["--max-old-space-size=4096", "--optimize-for-size"]

[smol]
enabled = false
```

---

## 平台特定说明

### Windows

**PowerShell：**
- 可能需要更改执行策略
- 全局安装时以管理员身份运行

**CMD：**
- 使用 `sfd.cmd` 包装器
- 需要 Node.js 在 PATH 中

### macOS

- 可能需要 Xcode 命令行工具
- 通过 Homebrew 替代安装：
  ```bash
  brew install node
  npm install -g @superfatiao/shopify-dev-tools
  ```

### Linux

- 在 Ubuntu 20.04+、Debian 10+、CentOS 8+ 上测试
- 全局安装可能需要 `sudo`
- 支持 WSL2

---

## 故障排除

参见 [TROUBLESHOOTING.md](TROUBLESHOOTING.md) 了解常见问题。
