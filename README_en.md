[English](README_en.md) | [简体中文](README.md)

# 📝 Snippet Collector

**A cross-platform text extraction solution**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)]()
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)]()

<div align="center">
  <img src="https://github.com/user-attachments/assets/377db5b3-ef0d-420b-9db3-6efbaac7b2af" alt="Windows Demo" height="280">
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/ffcf7788-e363-47ec-8ce1-f22719c939ca" alt="Android Demo" height="280">
</div>

---

## 💡 Introduction

When studying, researching, or organizing information on mobile and desktop platforms, we often encounter situations where text cannot be copied, the copying process is cumbersome, or the cross-app extraction experience is fragmented. **Snippet Collector** was born to solve this.

This project is a **lightweight text extraction solution** based on mature script engines across multiple platforms. It effectively bypasses copying restrictions imposed by certain apps and provides an extremely simple interactive experience, helping you collect needed inspirations and text anytime, anywhere, without limitations.

## ✨ Key Features

*   🔓 **Bypass Restrictions**: Utilizes low-level automation interfaces to intelligently bypass self-implemented copying restrictions of certain apps.
*   🚀 **Mature Engines**: Built on battle-tested scripting foundations like AutoKey and Autojs6, ensuring stability and efficiency.
*   🪶 **Lightweight Implementation**: Refusing bloat, implementing geek-level extraction experience with minimal code.
*   🕹️ **Minimalist Interaction**: Intuitive operations (such as floating ball, shortcut keys) with minimal interruption, ready to use out of the box.
*   🧩 **Multi-Stack Support**: Covers AutoKey scripts, Autojs6 scripts, Shell scripts, and Lua scripts to meet the customization needs of different terminals.

## 🚀 Quick Start

### 1. Get the Code

```bash
git clone https://github.com/nothing248/snippet_collect.git
cd snippet_collect
```

### 2. Platform Installation Guides

Since Snippet Collector needs to invoke different scripting solutions for different operating systems, each platform requires specific installation guidelines. Please refer to the corresponding documentation:

*   🍎 [macOS Installation & Configuration Guide](MacOS/README_en.md)
*   🤖 [Android (Autojs6) Installation Guide](Android/README_en.md)
*   🐧 [Windows (AutoKey) Installation Guide](Windows/README_en.md)

## 📖 Usage/Examples

### Scenario 1: Bypassing Copy Restrictions on Android
In content-based apps that prohibit text selection, summon the floating ball tool of this utility and click "Extract Current Page." The Autojs6 script will automatically scan the current screen view hierarchy, extract structured text, and automatically save it to your clipboard or a specified file.

### Scenario 2: One-Click Full Extraction on Desktop
In a macOS or Windows environment, select text within any complex formatting webpage, hit your shortcut key (e.g., `Cmd+Q`), and the underlying Shell/Lua script will instantly run, retrieve the raw text and original URL, and silently append it to your Obsidian/Logseq daily log.

## 🗺️ Roadmap

- [ ] Support adaptation for other Android phone brands based on Autojs6
- [ ] Cloud sync support
- [ ] Extraction Market

<!-- ## ❤️ Support & Sponsorship -->

<!-- **Snippet Collector** is an open-source personal geek tool born out of an ultimate pursuit of knowledge management efficiency. It's completely free to experience and contains no intrusive commercial ads.

If this small tool happens to save you precious time during a fragmented reading moment or improves your previously disjointed extraction workflow, please consider supporting the project's continuous maintenance through a sponsorship! Your support will be converted into a cup of coffee ☕️ for the maintainer deep into the night or into full-time commitment to covering more device testing models. We are not begging, but we firmly believe that mutual motivation and feedback within the open-source ecosystem can make the world a better place.

<div align="center">
  <img src="https://qiniu.sxyxy.top/支付宝-个人收钱码.png" width="160" alt="Alipay Sponsorship">
</div>

> ⚖️ **Transparency & Trust Statement**
> All sponsored funds will be 100% transparently reinvested into core open-source construction: including but not limited to maintaining long-term cloud service support for multi-type cross-terminal script updates, purchasing specific real devices needed for compatibility testing, and distributing incentives to other community developers making outstanding code contributions. For every contribution exceeding a certain cycle, we will acknowledge you by name in the release notes of version iterations. -->

## 🤝 Contributing

Found a bug or have a new idea? We warmly welcome you to join us!

Before submitting a PR (Pull Request), please read our [CONTRIBUTING_en.md](CONTRIBUTING_en.md) to understand the code conventions and submission process.

## 📄 License

This project is open-sourced under the [MIT License](LICENSE). You are free to use, modify, and distribute it.

## 🙏 Acknowledgments

The smooth operation of Snippet Collector depends on the support of the following excellent projects:

*   [Autojs6](https://github.com/SuperMonster003/AutoJs6) - Powerful JavaScript automation tool for the Android platform
*   [AutoKey](https://github.com/autokey/autokey) - Flexible desktop automation tool
*   [Hammerspoon](https://www.hammerspoon.org/) - Geek-level macOS desktop automation weapon
*   [LINUX DO](https://linux.do/) - Thanks to the support and feedback from the LINUX DO community.

---

<div align="center">
  If this tool improved your knowledge organization workflow, please consider giving it a ⭐️ Star to show your support!
</div>
