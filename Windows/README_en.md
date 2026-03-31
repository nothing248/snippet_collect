[English](README_en.md) | [简体中文](README.md)

# 🐧 Snippet Collector (Windows Edition)

This is the text extraction implementation for the Windows environment. It is written in the extremely lightweight and widely popular **AutoHotkey v2 (AHK)**. It provides an ultimately smooth content archiving experience with minimal system overhead.

## ⚙️ How It Works

1. The user selects text and presses the global shortcut key (default `Alt + Q`).
2. The AHK script captures the shortcut key, clears the system clipboard for use, and then simulates sending a `Ctrl + C` copy command to the system.
3. Retrieves foreground active application process information (handle, window name, executable process name).
4. If the current active window is identified as a browser, the script briefly focuses the address bar using `Ctrl + L` combined with copy to silently pull the current page's URL.
5. Waits for the clipboard to finish loading, then extracts the text for formatting (handling invalid blank lines and indentation configurations).
6. Concatenates the text, URL (if any), timestamp, etc., into Markdown, and appends it to the Markdown date file for the current day in the specified directory.
7. Pops up a ToolTip to inform that the collection was successful.

## 📦 Dependencies

- System: Windows 10 / 11
- Tool: [AutoHotkey v2.0+](https://www.autohotkey.com/v2/)

### Supported Browsers for URL Extraction
This script supports common Chromium-based and Firefox browsers. Built-in matching includes but is not limited to:
- Google Chrome (`chrome.exe`)
- Microsoft Edge (`msedge.exe`)
- Mozilla Firefox (`firefox.exe`)
- Brave Browser (`brave.exe`)
- Opera (`opera.exe`)

## 🚀 Installation & Usage Workflow

### 1. Modify Save Path
Open `Windows/SnippetCollector.ahk` with a text editor (like VSCode or Notepad).
Modify the frontend configuration item `TargetDir` to point to your local note-taking software's Inbox folder:
```autohotkey
TargetDir := "E:\docs\obsidians\me\01_inbox\collect"
```

### 2. Run the Script
After installing the AutoHotkey v2 environment, simply double-click the `SnippetCollector.ahk` file. If it runs successfully, because `#SingleInstance Force` is enabled in the code, it will silently reside in the system tray area (a green `H` icon in the lower right corner of the screen).

### 3. Auto-start on Boot (Recommended Optional Configuration)
Create a shortcut for `SnippetCollector.ahk`.
Press `Win + R` to call up the run box, type `shell:startup` to enter the system startup folder, paste and drag the previously created shortcut into this folder to achieve an auto-ready service upon boot.

## ⌨️ Default Shortcut

- `Alt + Q`: Save the highlighted selected text.

> **Note:** When this suite is activated, due to the limitations of control-based simulated keystrokes needed to get the browser URL, it is a normal phenomenon for the screen to show an extremely brief blue highlight focus effect on the address bar.
