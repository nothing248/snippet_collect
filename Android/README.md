[English](README_en.md) | [简体中文](README.md)

# 🤖 Snippet Collector (Android 版)

由于 Android 高版本对后台权限和剪贴板操作的限制极其严苛，本实现采用了基于 **Autojs6** 的无障碍方案。为了规避系统对高频读取剪贴板的警告（如 MIUI 的提示和防复制策略），我们重构了采集逻辑，采用**智能事件监听驱动的轮询**架构，实现低耗电、无感知的摘录体验。

## ⚙️ 工作原理

该脚本采用 **“动静结合”** 的策略：
1. **静默休眠**：挂载了一个不可见、不可触摸的 `1x1` 透明点悬浮窗用于应用程序保活，使进程被系统认定为准前台。
2. **事件监听**：脚本全局监听系统视图层变化 (`WINDOW_STATE_CHANGED`)，当且仅当发生疑似复制行为（例如弹出了菜单、悬浮工具栏或对话框）时，才会开启一段极短（默认为 60秒）的高频监测周期。
3. **后台截获**：在突发监测期内，脚本会监听系统底层的 Logcat 打印（如 MIUI 系统的 `AiCrEngine_MiuiClipboardManager`），一旦确定剪贴板发生真实更新且非重复，则立刻截获文本。
4. **悬浮确认**：弹出一个带有倒计时的胶囊悬浮球（左侧带蓝色的 `T` 图标）。点击该悬浮窗，数据就会与当前正在激活的 `APP_Name:APP_PACKAGE` 以及（若是浏览器环境的）URL 进行打包，并保存格式化到本地。若倒计时结束未点击，则自动忽略。

## 📦 依赖要求

- 平台核心：[AutoJs6](https://github.com/SuperMonster003/AutoJs6)
- 权限状态：
  - 必须：**无障碍服务** 功能已启动。
  - 必须：授予读取存储和写入存储权限。
  - 必须：授予 **显示悬浮窗**（Display over other apps）的权限。
  - 推荐：基于 **Shizuku** 的 ADB 提权（能完美解决因高频轮询所导致的系统 UI 闪烁问题）。

## 🚀 基础安装与配置

1. 在 Android 设备上安装并启动 AutoJs6。
2. 将 `Android/XiaoMi/SnippetCollector.js` （或者相关版本的脚本）拷贝或导入到 AutoJs6 目录中。
3. 编辑脚本，替换文件开头的 `TARGET_DIR` 为您的本地（例如 Obsidian 等笔记软件挂载的）收集目录。
   ```javascript
   const TARGET_DIR = "/sdcard/Documents/obsidians/me/me/01_inbox/collect";
   ```
4. 点击 AutoJs6 中本脚本的 “运行” 按钮，随后可在后台保持运行。

## 🪄 进阶配置：Shizuku 模式 (强烈推荐)

> **为什么要使用 Shizuku？**
> 在未激活 Shizuku 的“普通模式”下，脚本由于没有底层权限去监听系统的日志流 (Logcat)，系统触发监察期间只能靠不断地主动请求系统剪贴板来判断内容是否发生变化。
> 在部分定制系统下，这种高频率的截获会导致系统原生复制菜单栏发生**UI闪烁退回机制**（属由于无权探测日志导致的正常回调现象）。
> 
> **激活 Shizuku 后可以从根本上解决菜单闪烁问题**：脚本将利用 Shizuku 提供的静默读取日志特权，直接从系统日志侦测用户的复制行为，只有在日志报告存在新内容时才会去提取剪贴板文本。

### Shizuku 安装与授权步骤：

1. **安装 Shizuku 客户端**：请前往酷安、Google Play 或 [GitHub Releases](https://github.com/RikkaApps/Shizuku/releases) 下载并安装 Shizuku。
2. **激活 Shizuku**：
   - **无线调试激活 (推荐 Android 11+)**：进入手机系统的开发者选项 > 开启“无线调试” > 进入 Shizuku 点击通过无线调试启动 > 在开发者模式中配对。
   - **连接电脑激活 (Android 10 或以下)**：将手机连接至电脑并运行 Shizuku 提供的 adb shell 指令 `adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh`。
3. **向 AutoJs6 开放在线权限**：
   - 在 Shizuku 的主界面中，找到并点击进入“已授权 x 个应用”。
   - 将 Autojs6 的授权开关打开。
4. **重启脚本并享受**：回到 Autojs6 重新运行 `SnippetCollector.js`。脚本启动时将自动检测到 `shizuku.execCommand` 能力的开通并在日志中输出，彻底告别普通检测的闪烁！

## ⚡ 浏览器 URL 捕获支持

本系统内置了一套全屏幕 UI View 元素检索机制，支持在以下移动端浏览器中提取浏览到的网址：
- Chrome
- Brave
- Edge
- Kiwi Browser
- Firefox
- Opera

*注：若您发现新版浏览器的 URL 未被正确抓取，可以通过检索 UI id、text 等元素特征，向对应的抓取列表中补充判别规则。*

## ⚠️ 已知问题与兼容性

- **闪烁问题**：在普通模式下（未连接 Shizuku）因无法有效的监听 LOG，可能会出现复制菜单栏闪烁的情况，是正常策略妥协的现象。强烈建议通过 `Shizuku` 模式修复该问题。
- **Rom 适配差异**：目前该配置和 Logcat 探嗅目标重点贴合 **Xiaomi MIUI / HyperOS** 的日志底层参数（`AiCrEngine_MiuiClipboardManager`），但对由于日志字段不同的原生 Andorid 以及其他类型国产定制 ROM，只需手动调整分析系统日志，并替换脚本头部的 `LOG_FILTER` 值即可完美横向兼容。
