[English](CONTRIBUTING_en.md) | [简体中文](CONTRIBUTING.md)

# 参与贡献 (Contributing to Snippet Collector)

首先，非常感谢您对 **Snippet Collector** 社区感兴趣！🎉 我们非常欢迎不同背景和技术栈的开发者加入进来，无论是改进文档、提交一个 Bug、还是为全平台架构贡献新代码，您的支持都是项目成长的主要动力。

为了让协作更加顺畅，降低新人的上手焦虑，请仔细阅读这份指南。如果您在过程里遇到任何困难或者不清晰的地方，请尽管在 Issue 留言，我们会热情地为您解答。

## 🗺️ 我该如何参与？(How Can I Contribute?)

### 提交您的第一个 Issue
如果您发现了任何 Bug 或有新想法，请浏览现有的 Issue 看是否已经被提出过。如果没有，请使用我们的 [Bug Report] 或 [Feature Request] 模板来创建一个 Issue，它将强制收集必要的信息以帮助我们最高效地定位问题。

### 本地开发环境与工作流
1. 您需要先在 GitHub 上 **Fork** 此仓库。
2. 将其 clone 到您本地：
   ```bash
   git clone https://github.com/nothing248/snippet_collect.git
   cd snippet_collect
   ```
3. 基于 `main` 分支拉取一个新的特性分支用于开发：
   ```bash
   git checkout -b feature/your-awesome-feature
   ```

### 💻 代码审查与格式要求 (Code Style & Linting)
由于 Snippet Collector 是一个**多技术栈**生态（包含 Shell, Lua, AutoHotkey v2, JavaScript/Autojs6），我们偏好明确的代码风格限定，以防止碎片化：
- **JavaScript (Android/Autojs6)**：请保持与 [Google JavaScript Style Guide] 的一致，提交前建议通过 ESLint 校验。如在您本地：
   ```bash
   npx eslint Android/XiaoMi/*.js
   ```
- **Shell (macOS/Linux)**：请遵循 [Google Shell Style Guide]。提交前，我们**强烈要求**在本地通过 ShellCheck 进行规范校验，这将阻止大多数运行时错误：
   ```bash
   shellcheck MacOS/SnippetCollector.sh
   # 或者项目下的所有 sh 脚本
   ```
- **Lua (macOS/Hammerspoon)**：代码缩进须使用 4 个空格，避免在表结尾留空元素。可使用 `luacheck` 工具进行规范测试：
   ```bash
   luacheck MacOS/*.lua
   ```
- **全局基础配置**：如果是编写通用文档（如 Markdown）或纯文本模板，推荐您在编辑器开启 Prettier 设置项，确保换行格式和标题缩进被正确格式化。

### 提交 Pull Request (提交 PR)
1. 确保您的分支代码在您本地修改对应的操作系统（Android/Windows/OSX）已通**实机连调且跑通基础用例**。
2. 在您的 Fork 仓库上发起对应 PR，并且将目标分支设置为当前大仓库的 `main` 分支。
3. 务必根据我们置入的 PULL_REQUEST_TEMPLATE 要求如实填写，打勾 CheckList。
4. 您的 PR 必须通过我们的社区审查（如果有需要修改的地方，维护组成员会用十分友善的态度在讨论区帮您共同优化代码）。

再次感谢，Snippet Collector 世界因为您的力量而变得更好！
