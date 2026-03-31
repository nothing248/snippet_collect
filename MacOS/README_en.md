[English](README_en.md) | [简体中文](README.md)

# 🍎 Snippet Collector (macOS Edition)

This is the text extraction implementation for the macOS environment. It uses **Hammerspoon** as the hotkey binding entry point, and calls backend **Bash scripts** and **AppleScript** to achieve an automated closed loop of "select, copy, get source, write".

## ⚙️ How It Works

1. The user selects text and presses the global shortcut key (default `Option + Q`).
2. Hammerspoon listens to the shortcut key and silently calls the backend Bash script.
3. The script backs up the current clipboard and sends `Cmd + C` to extract the selected text content.
4. Uses `osascript` (AppleScript) to get the currently active application name and window title.
5. (Optional) If the foreground is a supported browser, it also extracts the current webpage's URL via AppleScript.
6. Finally, the formatted clipboard content, application name, and URL are concatenated, appended to a `.md` file named with the current date, and feedback is given via system notification.

## 📦 Dependencies

- System: macOS 10.12+ 
- Tool: [Hammerspoon](https://www.hammerspoon.org/)

### Supported Browsers for Context Environment (URL Extraction)
This script has built-in support for the following browsers:
- Google Chrome / Chromium
- Safari / Safari Technology Preview
- Firefox
- Microsoft Edge
- Brave Browser
- Arc

## 🚀 Installation & Configuration

### 1. Configure the Backend Bash Script Route
Open the `MacOS/SnippetCollector.sh` file:
- Modify the value of `TARGET_DIR`, setting it to the local path where you store your fragmented notes (e.g., your Obsidian's Inbox directory).

It is recommended to grant execution permissions to the script:
```bash
chmod +x MacOS/SnippetCollector.sh
```

### 2. Configure Hammerspoon Hotkey
Integrate the code from `MacOS/init.lua` into your local `~/.hammerspoon/init.lua`:
- Ensure the path in the `snippetScript` variable correctly points to the absolute path of the `SnippetCollector.sh` you just modified.

Then reload the configuration in the Hammerspoon console (Reload Config).

## ⌨️ Default Shortcut

- `Option + Q`: One-click save of currently selected text and its source.

## 🔧 Custom Formatting
If you need to adjust the typography of the recorded text in Markdown (e.g., adding highlight blocks, modifying citation headers, etc.), you can directly modify the `printf` and `OUTPUT_ENTRY` templates in the `Format Text` and `Write to Markdown File` sections of `SnippetCollector.sh`.
