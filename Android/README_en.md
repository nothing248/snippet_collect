[English](README_en.md) | [简体中文](README.md)

# 🤖 Snippet Collector (Android Edition)

Due to the extremely strict limitations on background permissions and clipboard operations in higher versions of Android, this implementation adopts an accessibility-based solution based on **Autojs6**. To bypass system warnings about high-frequency clipboard reads (such as MIUI's prompts and anti-copying strategies), we refactored the collection logic and adopted an **intelligent event-listening driven polling** architecture to achieve a low-power, imperceptible extraction experience.

## ⚙️ How It Works

This script adopts a **"dynamic and static combined"** strategy:
1. **Silent Sleep**: It mounts an invisible, untouchable `1x1` transparent floating window to keep the application alive, making the system recognize the process as pseudo-foreground.
2. **Event Listening**: The script globally listens for system view layer changes (`WINDOW_STATE_CHANGED`). Only when a suspected copying behavior occurs (such as a menu, floating toolbar, or dialog box popping up) will it initiate a very short (default 60 seconds) high-frequency monitoring cycle.
3. **Background Interception**: During the burst monitoring period, the script listens to the system's underlying Logcat printing (e.g., `AiCrEngine_MiuiClipboardManager` on MIUI systems). Once it is confirmed that the clipboard has been genuinely and non-repetitively updated, it intercepts the text immediately.
4. **Floating Confirmation**: A capsule floating ball with a countdown timer (with a blue `T` icon on the left) pops up. Clicking this floating window bundles the data with the currently active `APP_Name:APP_PACKAGE` and (if in a browser environment) the URL, then formats and saves it locally. If the countdown ends without a click, it is automatically ignored.

## 📦 Dependencies

- Platform Core: [AutoJs6](https://github.com/SuperMonster003/AutoJs6)
- Permission Status:
  - Required: **Accessibility Services** feature is enabled.
  - Required: Granted read storage and write storage permissions.
  - Required: Granted **Display over other apps** permission.
  - Recommended: ADB privilege escalation based on **Shizuku** (perfectly solves the system UI flickering issue caused by high-frequency polling).

## 🚀 Basic Installation & Configuration

1. Install and launch AutoJs6 on your Android device.
2. Copy or import `Android/XiaoMi/SnippetCollector.js` (or relevant version script) into your AutoJs6 directory.
3. Edit the script to replace `TARGET_DIR` at the beginning of the file with your local collection directory (e.g., the directory mounted by note-taking software like Obsidian).
   ```javascript
   const TARGET_DIR = "/sdcard/Documents/obsidians/me/me/01_inbox/collect";
   ```
4. Click the "Run" button for this script in AutoJs6, after which it can remain running in the background.

## 🪄 Advanced Configuration: Shizuku Mode (Highly Recommended)

> **Why use Shizuku?**
> In the "normal mode" where Shizuku is not activated, because the script lacks the underlying permission to listen to the system's log stream (Logcat), the system can only judge whether the content has changed by constantly and proactively requesting the system clipboard during the monitoring period.
> Under some customized systems, this high-frequency interception will cause the native system copy menu bar to exhibit a **UI flickering fallback mechanism** (which is a normal callback phenomenon due to the inability to detect logs).
> 
> **Activating Shizuku can fundamentally resolve the menu flickering issue**: The script will utilize the silent log reading privilege provided by Shizuku to detect user copy behaviors directly from system logs. It will only extract clipboard text when the log reports new content.

### Shizuku Installation and Authorization Steps:

1. **Install Shizuku Client**: Please go to CoolAPK, Google Play, or [GitHub Releases](https://github.com/RikkaApps/Shizuku/releases) to download and install Shizuku.
2. **Activate Shizuku**:
   - **Wireless debugging activation (recommended for Android 11+)**: Enter the phone system's developer options > Enable "Wireless debugging" > Enter Shizuku and click Start via Wireless debugging > Pair in developer mode.
   - **Connect to computer to activate (Android 10 or below)**: Connect the phone to the computer and run the adb shell command provided by Shizuku `adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh`.
3. **Open online permissions to AutoJs6**:
   - In Shizuku's main interface, find and click into "Authorized x apps".
   - Turn on the authorization switch for Autojs6.
4. **Restart the script and enjoy**: Return to Autojs6 and re-run `SnippetCollector.js`. When the script starts, it will automatically detect the opening of the `shizuku.execCommand` capability and output it in the log, saying a complete farewell to the flicker of normal detection!

## ⚡ Browser URL Capture Support

This system has a built-in full-screen UI View element retrieval mechanism, supporting the extraction of browsed URLs in the following mobile browsers:
- Chrome
- Brave
- Edge
- Kiwi Browser
- Firefox
- Opera

*Note: If you find that the URL of a new browser version is not captured correctly, you can add discrimination rules to the corresponding capture list by retrieving UI id, text, and other element features.*

## ⚠️ Known Issues and Compatibility

- **Flickering Issue**: In normal mode (without connecting Shizuku), due to the inability to effectively listen to the LOG, the copy menu bar may flicker, which is a normal phenomenon resulting from a strategic compromise. It is strongly recommended to fix this issue via `Shizuku` mode.
- **ROM Adaptation Differences**: Currently, the sniffing targets in this configuration and Logcat heavily align with the underlying log parameters of **Xiaomi MIUI / HyperOS** (`AiCrEngine_MiuiClipboardManager`). However, for native Android and other domestic customized ROMs with different log fields, you simply need to manually analyze the system logs and replace the `LOG_FILTER` value at the beginning of the script for perfect horizontal compatibility.
