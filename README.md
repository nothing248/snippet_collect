[English](README_en.md) | [简体中文](README.md)

# 📝 Snippet Collector

**针对不同平台的文本摘录解决方案**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)]()
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)]()

<div align="center">
  <img src="https://github.com/user-attachments/assets/377db5b3-ef0d-420b-9db3-6efbaac7b2af" alt="Windows Demo" height="280">
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/ffcf7788-e363-47ec-8ce1-f22719c939ca" alt="Android Demo" height="280">
</div>

---

## 💡 简介 (Introduction)

在移动端和桌面端进行学习、研究或资料整理时，我们经常遇到无法复制、复制步骤繁琐或是跨应用摘录体验割裂的问题。**Snippet Collector** 应运而生。

本项目是一个基于多平台成熟脚本引擎的**轻量级文本摘录解决方案**。它能够有效绕过部分 APP 自带的复制限制，提供极其简单的交互体验，帮助您随时随地、不受限制地收集所需的灵感与文本。

## ✨ 核心亮点 (Key Features)

*   🔓 **无视限制**：利用底层自动化接口，智能绕过部分 APP 的复制自实现限制。
*   🚀 **成熟引擎**：基于 AutoKey、Autojs6 等久经考验的脚本底层，稳定高效。
*   🪶 **轻量实现**：拒绝臃肿，用最少的代码实现极客级的摘录体验。
*   🕹️ **极简交互**：操作直观（如悬浮球、快捷键），打断感极低，开箱即用。
*   🧩 **多栈支持**：涵盖 AutoKey 脚本、Autojs6 脚本、Shell 脚本与 Lua 脚本，满足不同终端的定制需求。

## 🚀 快速开始 (Quick Start)

### 1. 获取代码

```bash
git clone https://github.com/nothing248/snippet_collect.git
cd snippet_collect
```

### 2. 平台安装指南

由于 Snippet Collector 需要针对不同操作系统调用不同的脚本方案，每一个平台都需要具体的安装指导，请参考对应文档：

*   🍎 [macOS 安装与配置向导](MacOS/README.md)
*   🤖 [Android (Autojs6) 安装向导](Android/README.md)
*   🐧 [Windows (AutoKey) 安装向导](Windows/README.md)

## 📖 使用示例 (Usage/Examples)

### 场景一：Android 端突破复制限制
在部分禁止文本选中的内容型 APP 中，唤出本工具的悬浮球工具，点击“提取当前页”。Autojs6 脚本将自动扫描当前屏幕视图流，提取结构化文本并自动为您保存至剪贴板或指定文件。

### 场景二：桌面端一键全量摘录
在 macOS 或 Windows 环境中，选中任意复杂排版网页内的文字，按下快捷键（如 `Cmd+Q`），背后的 Shell/Lua 脚本瞬间运转，获取纯文本及原文链接，静默追加至您的 Obsidian/Logseq 每日日志中。

## 🗺️ 路线图 (Roadmap)

- [ ] 基于 Autojs6 的 Android 其他手机厂适配支持
- [ ] 云同步支持
- [ ] 摘录市场

<!-- ## ❤️ 支持与赞助 (Sponsorship)

**Snippet Collector** 是出于对知识管理效率的极致追求而诞生的开源个人极客工具，它完全免费体验且没有任何侵入式商业广告。

若是这个小小的工具恰好在某个碎片化的阅读时刻为您节省了宝贵的时间，或是改善了您过去割裂的摘录流体验，您可以考虑通过赞助来支持本项目的持续维护进程！
您的每一份支持，都将化作深夜维护者手旁的一杯咖啡☕️，或是转化为覆盖更多设备测试模型的全职投入。我们绝非在寻求施舍，而是坚信开源生态的互相激励与回馈能让世界变得更好。 -->

<!-- <div align="center"> -->
  <!-- <a href="https://github.com/sponsors/nothing248"><img src="https://img.shields.io/badge/Sponsor-GitHub-EA4AAA?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Sponsors"></a>
  <a href="https://www.buymeacoffee.com/nothing248"><img src="https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee"></a>
  <br><br> -->
  <!-- 建议：将二维码图片上传至项目的 docs 文件夹或 GitHub 图床，并替换下面的链接 -->
  <!-- <img src="https://via.placeholder.com/200x200.png?text=WeChat+QR" width="160" alt="微信赞助"> -->
  <!-- &nbsp;&nbsp;&nbsp;&nbsp; -->
  <!-- <img src="https://qiniu.sxyxy.top/支付宝-个人收钱码.png" width="160" alt="支付宝赞助"> -->
  <!-- <p><em>（国内用户推荐直接扫描 微信 / 支付宝 二维码进行快速支持）</em></p> -->
<!-- </div> -->

<!-- ### 🌟 赞助者名人堂 (Wall of Fame)
衷心感谢以下为本项目发电的早期战略支持者（名次不分先后）：
* *虚位以待... 期待您的加入！* -->

<!-- > ⚖️ **财务透明与信任声明 (Transparency & Trust)**
> 您所赞助的所有款项，将 100% 透明地反哺于核心开源建设：包括但不限于：维持多类型跨终端脚本更新迭代的长期云服务支持、采购兼容性适配所需的特定系统测试真机、以及用做奖金池向做出杰出代码贡献的社区其他开发者分发激励。每一笔高于特定周期的入账，我们都会在版本迭代的 Release 中为您署名致谢。 -->

## 🤝 参与贡献 (Contributing)

发现 Bug 或是有了新点子？我们热烈欢迎您的加入！

请在提交 PR（Pull Request）之前，阅读我们的 [CONTRIBUTING.md](CONTRIBUTING.md) 以了解代码规范及提交流程。

## 📄 许可协议 (License)  

本项目基于 [MIT License](LICENSE) 协议开源。您可以自由地使用、修改和分发。

## 🙏 致谢 (Acknowledgments)

Snippet Collector 的平稳运行离不开以下优秀项目的支持：

*   [Autojs6](https://github.com/SuperMonster003/AutoJs6) - 安卓平台强大的 JavaScript 自动化工具
*   [AutoKey](https://github.com/autokey/autokey) - 灵活的桌面自动化工具
*   [Hammerspoon](https://www.hammerspoon.org/) - 极客级 macOS 桌面自动化利器
*   [LINUX DO](https://linux.do/) - 感谢 LINUX DO 社区的支持与反馈。
---

<div align="center">
  如果这个工具改善了您的知识整理流，请考虑给它一颗 ⭐️ Star 以表支持！
</div>