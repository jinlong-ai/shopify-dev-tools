# SuperFaTiao Shopify 开发工具

[![版本](https://img.shields.io/badge/版本-1.0.0-blue.svg)](https://github.com/SuperFaTiao/shopify-dev-tools)
[![许可](https://img.shields.io/badge/许可-MIT-green.svg)](LICENSE)
[![平台](https://img.shields.io/badge/平台-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/Shell-PowerShell%20%7C%20Bash%20%7C%20Node-orange.svg)]()

**通用内存安全 Shopify 主题开发套件**

通过自动监控、重启和跨平台支持，防止 Bun/Node 内存崩溃。

[English](README.md) | [文档](docs/)

---

## 🌟 特性

- 🛡️ **5层防护**：配置 → 脚本 → 构建 → 监控 → 优化
- 💻 **跨平台**：Windows (PowerShell/CMD)、macOS/Linux (Bash)、Node.js、Bun
- 🌐 **多语言**：英文和中文界面
- 🚀 **零配置**：开箱即用，可选一次性设置
- 📊 **实时监控**：每10秒检查内存
- 🔄 **自动重启**：内存超阈值时优雅重启
- 📦 **多种安装方式**：NPM、Git 克隆或直接下载

---

## 📦 安装

### 方式 1：NPM（推荐）

```bash
npm install -g @superfatiao/shopify-dev-tools
```

### 方式 2：Git 克隆

```bash
git clone https://github.com/SuperFaTiao/shopify-dev-tools.git
cd shopify-dev-tools
npm link
```

### 方式 3：直接下载

下载最新版本并解压到你的主题目录。

---

## 🚀 快速开始

### 基本用法

```bash
# 交互模式（提示输入商店）
sfd

# 指定商店
sfd mystore.myshopify.com

# 自定义内存限制
sfd mystore.myshopify.com -m 8192

# 设置语言偏好
sfd --lang zh
```

### 平台专用

**Windows PowerShell：**
```powershell
.\sfd.ps1 -Store mystore.myshopify.com
```

**Windows CMD：**
```cmd
sfd mystore.myshopify.com
```

**Linux/macOS：**
```bash
./sfd.sh mystore.myshopify.com
```

**Node.js：**
```bash
node bin/sfd mystore.myshopify.com
```

---

## 🛡️ 工作原理

```
┌─────────────────────────────────────────────────────────┐
│  第1层：配置     │  .bunrc / 环境变量                   │
├─────────────────────────────────────────────────────────┤
│  第2层：脚本     │  PowerShell / Bash / Node            │
├─────────────────────────────────────────────────────────┤
│  第3层：构建     │  流式 + 分批处理                     │
├─────────────────────────────────────────────────────────┤
│  第4层：监控     │  实时内存检查                        │
├─────────────────────────────────────────────────────────┤
│  第5层：优化     │  自动重启 + 清理                     │
└─────────────────────────────────────────────────────────┘
```

**保护机制：**
1. **内存限制**：设置 Node.js 堆为 4GB（可配置）
2. **监控**：每10秒检查内存
3. **阈值**：使用超过 85%（3500MB）时重启
4. **优雅重启**：保存工作、清理内存、恢复
5. **最大重启**：限制5次重启防止循环

---

## ⚙️ 配置

### 环境变量

| 变量 | 描述 | 默认值 |
|------|------|--------|
| `SHOPIFY_STORE` | 默认商店域名 | - |
| `SFD_MEMORY` | 内存限制（MB） | 4096 |
| `SFD_THRESHOLD` | 重启阈值（MB） | 3500 |
| `SFD_LANG` | 界面语言（en/zh） | 自动 |
| `NODE_OPTIONS` | Node.js 选项 | 自动设置 |

### 命令行选项

```
用法：sfd [商店域名] [选项]

选项：
  -h, --help        显示帮助
  -v, --version     显示版本
  -m, --memory      设置内存限制（MB）
  -l, --lang        设置语言（en/zh）

示例：
  sfd                                      # 交互模式
  sfd mystore.myshopify.com               # 直接指定商店
  sfd -m 8192                             # 8GB 内存限制
  sfd --lang zh                           # 中文界面
```

### Bun 配置（.bunrc）

```toml
[run]
nodeArgs = ["--max-old-space-size=4096", "--optimize-for-size"]

[smol]
enabled = false  # 启用激进 GC
```

---

## 📁 项目结构

```
shopify-dev-tools/
├── bin/
│   ├── sfd              # 主 Node.js 入口
│   ├── sfd.ps1          # PowerShell 版本
│   └── sfd.sh           # Bash 版本
├── scripts/
│   ├── build.js         # 内存安全构建
│   ├── optimize.js      # 资源优化
│   ├── profile.js       # 内存分析
│   └── clean.js         # 清理工具
├── locales/
│   ├── en.json          # 英文字符串
│   └── zh.json          # 中文字符串
├── docs/
│   ├── USAGE.md         # 详细用法
│   ├── API.md           # API 文档
│   └── TROUBLESHOOTING.md
├── README.md            # 英文文档
├── README.zh.md         # 本文档
└── package.json
```

---

## 🐛 故障排除

### "未找到 Shopify CLI"

```bash
npm install -g @shopify/cli
```

### 仍然出现"内存不足"

1. 增加内存限制：
   ```bash
   sfd mystore.myshopify.com -m 8192
   ```

2. 在 `.bunrc` 中启用 smol 模式：
   ```toml
   [smol]
   enabled = true
   ```

3. 检查内存泄漏：
   ```bash
   npm run profile
   ```

### PowerShell 执行策略

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 权限被拒绝（Linux/Mac）

```bash
chmod +x bin/sfd.sh
```

---

## 🤝 贡献

1. Fork 仓库
2. 创建功能分支（`git checkout -b feature/amazing`）
3. 提交更改（`git commit -m '添加 amazing 功能'`）
4. 推送到分支（`git push origin feature/amazing`）
5. 打开 Pull Request

请确保：
- 所有文件使用 UTF-8 编码
- 代码使用英文注释
- 同时更新 README.md 和 README.zh.md

---

## 📄 许可

MIT 许可证 - 参见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- [Shopify CLI](https://shopify.dev/docs/themes/tools/cli)
- [Bun](https://bun.sh)
- [Node.js](https://nodejs.org)

---

**Made with ❤️ by SuperFaTiao**

[⬆ 返回顶部](#superfatiao-shopify-开发工具)
