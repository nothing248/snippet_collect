/**
 * AutoHotkey v2 脚本：选中文字上下文记录器
 * 快捷键：Alt+Q
 * 功能：获取选中文字及其上下文（应用名、标题、URL），记录到按日期命名的 Markdown 文件中。
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; --- 配置区域 ---
TargetDir := "E:\docs\obsidians\me\01_inbox\collect" ; 文件保存目录，默认脚本所在目录
LogFile := A_ScriptDir "\script_log.log" ; 日志文件路径

; --- 快捷键设置: Alt+Q ---
!q::
{
    try {
        ; 1. 获取选中文字 (使用剪贴板中转)
        A_Clipboard := "" ; 清空剪贴板
        Send("^c") ; 发送 Ctrl+C
        if !ClipWait(1) { ; 等待剪贴板数据，超时1秒
            WriteLog("错误: 未检测到选中的文本或复制超时。")
            return
        }
        ContextText := A_Clipboard

        ; 2. 获取当前时间
        CurrentDate := FormatTime(, "yyyyMMdd")
        CurrentDateTime := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileName := TargetDir "\" CurrentDate ".md"

        ; 3. 检查并创建目录/文件 (AHK v2 FileAppend 会自动处理不存在的文件，但我们显式检查下)
        if !DirExist(TargetDir) {
            DirCreate(TargetDir)
            WriteLog("创建目录: " TargetDir)
        }

        ; 4. 获取上下文信息
        ActiveHWND := WinActive("A")
        if !ActiveHWND {
            WriteLog("错误: 无法获取活跃窗口。")
            return
        }

        AppName := WinGetProcessName(ActiveHWND)
        Title := WinGetTitle(ActiveHWND)
        URL := GetBrowserURL(ActiveHWND, AppName)

        ; 优化格式：如果存在多个换行，则只保留一个
        ContextText := RegExReplace(ContextText, "(\r?\n){2,}", "$1")
        ; 缩进 context 的每一行，使其符合 Markdown 列表格式
        ContextText := RegExReplace(ContextText, "m)^", "  ")

        ; 5. 格式化并写入文件
        ; 格式要求：
        ; - $datetime
        ;
        ;   $context
        ;
        ; <p align="right"> 点击访问：<a href="$url">$app_name:$title</a> </p>

        OutputEntry := "## " . CurrentDateTime . "`n`n" . ContextText . "`n`n<p align=`"right`"> <a href=`"" .
            URL . "`">" . AppName . ":" . Title . "</a> </p>`n"

        FileAppend(OutputEntry, FileName, "UTF-8")

        ; 6. 反馈与日志
        WriteLog("成功记录片段到: " FileName)
        ToolTip("已记录到 " CurrentDate ".md")
        SetTimer () => ToolTip(), -2000 ; 2秒后消失

    } catch Any as e {
        WriteLog("发生异常: " e.Message "`n堆栈: " e.Stack)
        MsgBox("脚本运行出错，请查看日志。`n" e.Message, "错误", 16)
    }
}

/**
 * 获取浏览器 URL
 * 针对常见浏览器使用不同的获取策略
 */
GetBrowserURL(hwnd, appName) {
    ; 常见的浏览器进程列表
    Browsers := "chrome.exe,msedge.exe,firefox.exe,brave.exe,opera.exe"

    if !InStr(Browsers, appName)
        return "N/A"

    try {
        ; 对于多数基于 Chromium 的浏览器，地址栏通常在特定的 UI 结构中
        ; 这里使用一个较为简单的兼容性方案：通过快捷键临时获取
        ; 注意：这种方法会稍微闪一下地址栏，但在没有 UI Automation 库的情况下最稳定

        ; 备份当前剪贴板
        OldClip := ClipboardAll()
        A_Clipboard := ""

        ; 激活窗口并尝试获取地址
        WinActivate(hwnd)
        Send("^l")        ; 定位到地址栏 (Ctrl+L)
        Sleep(50)         ; 等待响应
        Send("^c")        ; 复制 (Ctrl+C)
        ClipWait(0.5)     ; 等待复制完成

        URL := A_Clipboard

        ; 恢复现场
        Send("{Esc}")     ; 退出地址栏焦点
        A_Clipboard := OldClip

        ; 如果获取到的不是明显的 URL，返回 N/A
        if !InStr(URL, "://") && !InStr(URL, "localhost")
            return "N/A"

        return URL
    } catch {
        return "N/A"
    }
}

/**
 * 写入日志文件
 */
WriteLog(Text) {
    try {
        Timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend("[" Timestamp "] " Text "`n", LogFile, "UTF-8")
    }
}
