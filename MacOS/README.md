# 🍎 Snippet Collector (macOS 版)

这是针对 macOS 环境的文本摘录实现。它使用 **Hammerspoon** 作为热键绑定入口，并调用后端的 **Bash 脚本** 和 **AppleScript** 来实现自动化的“选中、复制、获取来源、写入”闭环。

## ⚙️ 工作原理

1. 用户选中文本后按下全局快捷键（默认 `Option + Q`）。
2. Hammerspoon 监听到快捷键，静默调用后端的 Bash 脚本。
3. 脚本备份当前剪贴板，发送 `Cmd + C` 提取选中的文本内容。
4. 利用 `osascript` (AppleScript) 获取当前激活的应用程序名称和窗口标题。
5. （可选）如果前台是支持的浏览器，还会通过 AppleScript 提取当前网页的 URL。
6. 最后，将格式化后的剪贴板内容、应用名和 URL 拼接后，附加保存到以当天日期命名的 `.md` 文件中，并通过系统通知反馈。

## 📦 依赖要求

- 系统：macOS 10.12+ 
- 工具：[Hammerspoon](https://www.hammerspoon.org/)

### 支持环境上下文（提取 URL）的浏览器
该脚本内置了对以下浏览器的支持：
- Google Chrome / Chromium
- Safari / Safari Technology Preview
- Firefox
- Microsoft Edge
- Brave Browser
- Arc

## 🚀 安装与配置

### 1. 配置 Bash 后台脚本路线
打开 `MacOS/SnippetCollector.sh` 文件：
- 修改 `TARGET_DIR` 的值，将其设定为您存放笔记碎片的本地路径（例如 Obsidians 的 Inbox 目录）。

建议对脚本赋予执行权限：
```bash
chmod +x MacOS/SnippetCollector.sh
```

### 2. 配置 Hammerspoon 热键
将 `MacOS/init.lua` 中的代码整合到您本地的 `~/.hammerspoon/init.lua` 中：
- 确保 `snippetScript` 变量的路径正确指向您刚才修改的 `SnippetCollector.sh` 绝对路径。

然后在 Hammerspoon 的控制台中重新加载配置 (Reload Config)。

## ⌨️ 默认快捷键

- `Option + Q`：一键保存当前选中的文字及其来源。

## 🔧 自定义格式
若需调整记录文本在 Markdown 内的排版（例如增加高亮块、修改引用头等），您可以直接在 `SnippetCollector.sh` 的 `格式化文本` 及 `写入 Markdown 文件` 区域修改 `printf` 和 `OUTPUT_ENTRY` 的模板。
