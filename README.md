# GLM MCP Server - 智谱AI图像分析工具

<div align="center">

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)
![Python](https://img.shields.io/badge/python-3.7%2B-blue.svg)
![Claude](https://img.shields.io/badge/Claude%20Code-compatible-green.svg)

**一个用于在 Claude Code 中集成智谱 AI GLM-4.5V 图像分析功能的 MCP 服务器**

[功能特性](#-功能特性) • [快速开始](#-快速开始) • [安装指南](#-安装指南) • [使用方法](#-使用方法) • [故障排除](#-故障排除)

</div>

## ⚡ 快速开始

### 📥 下载项目

```bash
# 克隆项目
git clone https://github.com/your-username/glm-mcp-server.git
cd glm-mcp-server

# 或者下载ZIP文件并解压
```

### 🚀 一键安装

<details>
<summary><strong>Windows 用户</strong></summary>

1. 双击运行 `install.bat`
2. 按照提示输入您的 GLM API 密钥
3. 重启 Claude Code 即可使用

</details>

<details>
<summary><strong>Linux/Mac 用户</strong></summary>

1. 在终端中运行：`chmod +x install.sh && ./install.sh`
2. 按照提示输入您的 GLM API 密钥
3. 重启 Claude Code 即可使用

</details>

> **注意**：
> - Windows版本使用 `python` 命令
> - Linux/Mac版本使用 `python3` 命令
> - 脚本会自动检测系统中可用的Python版本

### 🎯 验证安装

安装完成后，在 Claude Code 中输入：
```
@图像 ./test.jpg 这是什么？
```

如果看到图像分析结果，说明安装成功！

## ✨ 功能特性

- 🎯 **一键安装**：跨平台自动化安装脚本
- 🔒 **安全配置**：API密钥存储在系统环境变量中
- 🖼️ **多格式支持**：JPG、PNG、GIF、BMP等常见图片格式
- 🌍 **跨平台**：Windows、Linux、macOS全支持
- 📝 **智能分析**：基于GLM-4.5V模型的强大图像理解能力
- 🛠️ **易于维护**：完整的日志系统和错误处理
- 📚 **详细文档**：完整的安装、使用和故障排除指南

## 🔧 手动安装（可选）

如果您需要手动配置，请按照以下步骤：

### 1. 获取 API 密钥
- 访问 [智谱AI控制台](https://open.bigmodel.cn/console)
- 注册并获取您的 API 密钥

### 2. 设置环境变量
#### Windows
```cmd
setx GLM_API_KEY "your_api_key_here" /M
setx GLM_API_BASE "https://open.bigmodel.cn/api/paas/v4/" /M
setx GLM_IMAGE_MODEL "glm-4.5v" /M
```

#### Linux/Mac
在 `~/.bashrc` 或 `~/.zshrc` 中添加：
```bash
export GLM_API_KEY="your_api_key_here"
export GLM_API_BASE="https://open.bigmodel.cn/api/paas/v4/"
export GLM_IMAGE_MODEL="glm-4.5v"
```

### 3. 安装依赖
```bash
pip install zhipuai mcp python-dotenv
```

### 4. 配置 Claude Code
创建或编辑 `%USERPROFILE%\.claude\mcp.json`（Windows）或 `~/.claude/mcp.json`（Linux/Mac）：
```json
{
  "mcpServers": {
    "glm-mcp": {
      "command": "python",
      "args": ["/path/to/glmMcp/main.py"],
      "env": {
        "GLM_API_BASE": "https://open.bigmodel.cn/api/paas/v4/",
        "GLM_IMAGE_MODEL": "glm-4.5v"
      }
    }
  }
}
```

## 📖 使用方法

安装完成后，在 Claude Code 中：

1. 使用 `@图像` 或 `@image` 后跟图片路径来分析图片
2. 例如：`@图像 ./test.jpg 请描述这张图片的内容`
3. 支持常见图片格式：JPG、PNG、GIF、BMP等

## 🔒 安全特性

- ✅ API 密钥存储在系统环境变量中，不暴露在代码中
- ✅ 配置文件不包含敏感信息
- ✅ 支持密钥轮换
- ✅ 默认启用安全模式（仅从环境变量读取API密钥）

## 🛠️ 故障排除

### 1. 安装失败
- 确保已安装 Python 3.7+
- 确保网络连接正常
- 检查是否有权限写入系统环境变量

### 2. API 密钥问题
- 确认 API 密钥是否正确复制
- 检查环境变量是否正确设置
- 验证 API 密钥是否有效

### 3. Claude Code 无法识别
- 重启 Claude Code
- 检查 MCP 配置文件路径是否正确
- 确认权限配置中包含 `mcp__glm-mcp__read_image`

### 4. 图像分析失败
- 检查图片路径是否正确
- 确认图片格式是否支持
- 查看日志文件：`mcpserver.log`

## 📝 更新配置

### 更新 API 密钥
1. 修改系统环境变量 `GLM_API_KEY`
2. 重启 Claude Code

### 更新模型版本
修改环境变量 `GLM_IMAGE_MODEL`，支持的模型：
- `glm-4.5v`（推荐）
- `glm-4v`
- `glm-3v-turbo`

## 📋 文件结构

```
glmMcp/
├── main.py              # 主程序
├── config.py            # 配置管理
├── server.py            # MCP服务器
├── image_processor.py   # 图像处理
├── logger.py            # 日志系统
├── utils.py             # 工具函数
├── install.bat          # Windows一键安装
├── install.sh           # Linux/Mac一键安装
├── test_install.bat     # Windows安装测试
├── test_install.sh      # Linux/Mac安装测试
├── .env.template        # 环境变量模板
├── requirements.txt     # Python依赖
├── README.md            # 使用说明
├── TESTING.md           # 测试指南
└── mcpserver.log        # 日志文件
```

## 🤝 贡献

我们欢迎任何形式的贡献！请查看 [贡献指南](CONTRIBUTING.md) 了解如何参与项目开发。

### 📝 提交问题
- 使用 [GitHub Issues](https://github.com/your-username/glm-mcp-server/issues) 报告问题
- 请提供详细的错误信息和复现步骤
- 附上相关的日志文件内容

### 🔄 提交代码
1. Fork 本项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📊 项目统计

![GitHub stars](https://img.shields.io/github/stars/your-username/glm-mcp-server?style=social)
![GitHub forks](https://img.shields.io/github/forks/your-username/glm-mcp-server?style=social)
![GitHub issues](https://img.shields.io/github/issues/your-username/glm-mcp-server)

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [智谱AI](https://open.bigmodel.cn/) - 提供强大的GLM-4.5V模型
- [Claude Code](https://claude.ai/code) - 优秀的AI编程助手
- [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) - 标准化的AI服务接口

## 📞 支持

- 📧 **问题反馈**：[GitHub Issues](https://github.com/your-username/glm-mcp-server/issues)
- 📖 **文档**：[完整文档](https://github.com/your-username/glm-mcp-server/wiki)
- 💬 **讨论**：[GitHub Discussions](https://github.com/your-username/glm-mcp-server/discussions)

---

<div align="center">

**如果这个项目对您有帮助，请给我们一个 ⭐️ Star**

![Star History](https://img.shields.io/github/stars/your-username/glm-mcp-server?style=for-the-badge)

</div>