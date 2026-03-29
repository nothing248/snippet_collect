# 🐧 Snippet Collector (Windows 版)

这是针对 Windows 环境的文本摘录实现。采用了极度轻量化、普及度极高的 **AutoHotkey v2 (AHK)** 编写而成。以最小的系统开销提供极致流畅的内容归档体验。

## ⚙️ 工作原理

1. 用户选中文本后按下全局快捷键（默认 `Alt + Q`）。
2. AHK 脚本捕获快捷键，清空系统剪贴板备用，然后模拟对系统发送 `Ctrl + C` 的复制指令。
3. 获取前台活动应用进程信息（句柄、窗口名称、可执行文件进程名）。
4. 如果当前活动窗口被认定为浏览器，脚本会短暂聚焦地址栏利用 `Ctrl + L` 配合复制来静默拉取当前页面的 URL。
5. 等待剪贴板载入完毕后，提取文本进行格式编排（处理无效空行与缩进配置）。
6. 把文本、URL（如有）、时间戳等拼接为 markdown，并追加到指定文件目录下当天的 Markdown 日期文件中。
7. 弹出工具提示（ToolTip）告知收集成功。

## 📦 依赖要求

- 系统：Windows 10 / 11
- 工具：[AutoHotkey v2.0+](https://www.autohotkey.com/v2/)

### 支持获取 URL 的浏览器
该脚本支持常见的 Chromium 内核及 Firefox 浏览器，内置匹配包含但不限于：
- Google Chrome (`chrome.exe`)
- Microsoft Edge (`msedge.exe`)
- Mozilla Firefox (`firefox.exe`)
- Brave Browser (`brave.exe`)
- Opera (`opera.exe`)

## 🚀 安装与使用流程

### 1. 修改保存路径
用文本编辑器（如 VSCode 或 记事本）打开 `Windows/SnippetCollector.ahk`。
修改前排配置项 `TargetDir`，指向你的本地笔记软件 Inbox 文件夹：
```autohotkey
TargetDir := "E:\docs\obsidians\me\01_inbox\collect"
```

### 2. 运行脚本
安装 AutoHotkey v2 环境后，直接双击 `SnippetCollector.ahk` 文件。若成功运行，由于代码中开启了 `#SingleInstance Force`，它会静默驻留在系统托盘区（屏幕右下角绿色的 `H` 图标）。

### 3. 开机自启 (可选推荐配置)
创建一个 `SnippetCollector.ahk` 的快捷方式。
按 `Win + R` 调出运行框，输入 `shell:startup` 进入系统开机启动文件夹，将之前创建的快捷方式粘贴拉入该文件夹内，即可实现开机自动就绪服务。

## ⌨️ 默认快捷键

- `Alt + Q`：保存高亮的选中文本。

> **注意：** 当激活该套件的瞬间，因受制于基于控件模拟按键的局限性，由于需要获取浏览器 URL，画面出现极为短暂的地址栏蓝底聚焦特效属正常现象。
