#!/usr/bin/env bash
# 强制 UTF-8 locale，防止 Hammerspoon/Automator 子进程无 locale 时中文乱码
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# =============================================================================
# SnippetCollector.sh — macOS 版选中文字上下文记录器
# 对标 AutoHotkey SnippetCollector.ahk（Alt+Q）
#
# 触发方式：通过 Automator Quick Action 绑定系统快捷键（推荐 Option+Q）
#
# 功能：
#   1. 读取当前选中的文字（模拟 Cmd+C）
#   2. 获取当前应用名、窗口标题、浏览器 URL
#   3. 格式化写入按日期命名的 Markdown 文件
#   4. 显示系统通知 + 屏幕横幅提示
# =============================================================================

# --- 配置区域 ---
TARGET_DIR="$HOME/Documents/self/notes/me/01_inbox/collect"  # 修改为你的 Obsidian inbox 目录
LOG_FILE="$(dirname "$0")/script_log.log"

# =============================================================================
# 工具函数
# =============================================================================

write_log() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# 显示 macOS 系统通知
show_notification() {
    local title="$1"
    local message="$2"
    osascript -e "display notification \"$message\" with title \"$title\""
}

# =============================================================================
# 1. 获取选中文字（模拟 Cmd+C，读取剪贴板）
# =============================================================================

# 备份当前剪贴板内容到临时文件（用文件而非变量，避免多字节字符被截断）
TMP_OLD_CLIP=$(mktemp)
TMP_NEW_CLIP=$(mktemp)
pbpaste > "$TMP_OLD_CLIP" 2>/dev/null

# 模拟 Cmd+C（让前台应用复制选中内容）
osascript -e 'tell application "System Events" to keystroke "c" using command down'

# 等待剪贴板更新
sleep 0.3

# 由于从某些现代浏览器（如 Chrome 下的 Gemini、ChatGPT 等）直接 pbpaste 获取纯文本会彻底丢失段落结构，
# 这里优先尝试提取剪贴板底层 HTML 并利用操作系统的 textutil 重新解析出包含完美排版缩进和换行的纯文本。
TMP_HTML=$(mktemp)
osascript -e 'the clipboard as "HTML"' 2>/dev/null | perl -ne 's/.*«data HTML//i; s/».*//; print chr(hex($1)) while /([0-9a-f]{2})/ig' > "$TMP_HTML"

if [ -s "$TMP_HTML" ]; then
    # 通过 perl 清理各种零宽字符、将 textutil 输出的系统圆点列表转换回 Markdown 的 “- ” 列表，并转换不换行空格
    textutil -convert txt -format html "$TMP_HTML" -stdout 2>/dev/null | \
    perl -Mutf8 -CSD -pe 's/\x{200B}|\x{200C}|\x{200D}|\x{FEFF}|\x{FFFC}//g; s/\x{00A0}/ /g; s/^([ \t]*)(?:\x{2022}|\x{25E6}|\x{25AA}|-)[ \t]+/$1- /g; s/\r\n|\r/\n/g;' > "$TMP_NEW_CLIP"
else
    # 纯文本或无 HTML 的情况，安全兜底，同样过滤一遍非法边界字符
    pbpaste | \
    perl -Mutf8 -CSD -pe 's/\x{200B}|\x{200C}|\x{200D}|\x{FEFF}|\x{FFFC}//g; s/\x{00A0}/ /g; s/\r\n|\r/\n/g;' > "$TMP_NEW_CLIP" 2>/dev/null
fi
rm -f "$TMP_HTML"
CONTEXT_TEXT=$(cat "$TMP_NEW_CLIP")

if [ -z "$CONTEXT_TEXT" ]; then
    write_log "错误: 未检测到选中的文本或复制超时。"
    show_notification "SnippetCollector" "❌ 未检测到选中文本，请先选中内容再触发。"
    exit 1
fi

# =============================================================================
# 2. 获取当前时间 & 文件路径
# =============================================================================

CURRENT_DATE=$(date "+%Y%m%d")
CURRENT_DATETIME=$(date "+%Y-%m-%d %H:%M:%S")
FILE_NAME="$TARGET_DIR/${CURRENT_DATE}.md"

# =============================================================================
# 3. 检查并创建目录
# =============================================================================

if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    write_log "创建目录: $TARGET_DIR"
fi

# =============================================================================
# 4. 获取上下文信息（应用名、窗口标题、浏览器 URL）
# =============================================================================

# 获取当前最前台应用名（进程名）
APP_NAME=$(osascript <<'APPLESCRIPT'
tell application "System Events"
    set frontApp to first application process whose frontmost is true
    return name of frontApp
end tell
APPLESCRIPT
)

# 获取窗口标题
WINDOW_TITLE=$(osascript <<'APPLESCRIPT'
tell application "System Events"
    set frontApp to first application process whose frontmost is true
    try
        set winTitle to name of front window of frontApp
        return winTitle
    on error
        return ""
    end try
end tell
APPLESCRIPT
)

# 获取浏览器 URL（支持 Chrome、Safari、Firefox、Edge、Arc、Brave）
get_browser_url() {
    local app="$1"
    local url="N/A"

    case "$app" in
        "Google Chrome" | "Chromium" | "Brave Browser" | "Microsoft Edge" | "Arc")
            url=$(osascript <<APPLESCRIPT
tell application "$app"
    try
        return URL of active tab of front window
    on error
        return "N/A"
    end try
end tell
APPLESCRIPT
            )
            ;;
        "Safari" | "Safari Technology Preview")
            url=$(osascript <<APPLESCRIPT
tell application "Safari"
    try
        return URL of front document
    on error
        return "N/A"
    end try
end tell
APPLESCRIPT
            )
            ;;
        "Firefox")
            # Firefox 不直接支持 AppleScript 获取 URL，尝试地址栏复制法
            OLD_CLIP_INNER=$(pbpaste 2>/dev/null || echo "")
            osascript -e 'tell application "System Events" to keystroke "l" using command down'
            sleep 0.2
            osascript -e 'tell application "System Events" to keystroke "c" using command down'
            sleep 0.2
            url=$(pbpaste 2>/dev/null)
            osascript -e 'tell application "System Events" to key code 53'  # Esc
            # 恢复剪贴板
            echo "$OLD_CLIP_INNER" | pbcopy
            # 验证是否是 URL
            if [[ "$url" != *"://"* ]]; then
                url="N/A"
            fi
            ;;
        *)
            url="N/A"
            ;;
    esac

    echo "$url"
}

URL=$(get_browser_url "$APP_NAME")

# =============================================================================
# 5. 格式化文本
# =============================================================================
# 将多个连续空行合并为单个空行，并对每行添加两个空格缩进（Markdown 列表格式）
# 使用 printf 而非 echo，避免转义符被解释；LC_ALL=en_US.UTF-8 确保 sed 正确处理中文
FORMATTED_TEXT=$(printf '%s\n' "$CONTEXT_TEXT" \
    | sed '/^[[:space:]]*$/d; s/^/  /' \
    | awk 'NF || prev_nf { print } { prev_nf = NF }')

# # 使用代码块包裹，100% 确保保留换行，不会被 Markdown 引擎压缩折叠
# FORMATTED_TEXT=$(printf '```text\n%s\n```' "$CONTEXT_TEXT")

# =============================================================================
# 6. 写入 Markdown 文件
# =============================================================================

# 根据 URL 是否有效，渲染来源链接或纯文本
if [[ "$URL" == "N/A" ]]; then
    SOURCE_INFO="*${APP_NAME}:${WINDOW_TITLE}*"
else
    SOURCE_INFO="<a href=\"${URL}\">${APP_NAME}:${WINDOW_TITLE}</a>"
fi

# 格式：
# ## YYYY-MM-DD HH:mm:ss
#
# > $context（每行前有引用缩进）
#
# <p align="right"> $SOURCE_INFO </p>

OUTPUT_ENTRY="## ${CURRENT_DATETIME}

${FORMATTED_TEXT}

<p align=\"right\"> ${SOURCE_INFO} </p>"

printf '%s\n' "$OUTPUT_ENTRY" >> "$FILE_NAME"

# =============================================================================
# 7. 恢复剪贴板 & 反馈通知
# =============================================================================

# 恢复原始剪贴板内容（从临时文件恢复，保留完整二进制内容）
cat "$TMP_OLD_CLIP" | pbcopy
rm -f "$TMP_OLD_CLIP" "$TMP_NEW_CLIP"

write_log "成功记录片段到: $FILE_NAME"
show_notification "SnippetCollector ✅" "已记录到 ${CURRENT_DATE}.md"
