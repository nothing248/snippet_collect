// =============================================================================
// SnippetCollector - 轮询触发版 (经实测兼容性最佳)
// 需要权限：无障碍服务 + 悬浮窗 + 读写存储
// =============================================================================

// 确保无障碍服务已开启
auto.waitFor();

const TARGET_DIR = "/sdcard/Documents/obsidians/me/me/01_inbox/collect";
const LOG_FILE = "/sdcard/Documents/scripts/snippet_log.txt";
const POPUP_TIMEOUT_S = 2;    // 确认窗超时秒数
const DURATION_SECONDS = 60;   // 轮询时长
const POLLING_INTERVAL = 800; // 轮询间隔
const LOG_FILTER = `AiCrEngine_MiuiClipboardManager:I *:S`

// const { getClip } = require('clip_manager');

let activeWin = null;
let activeTimer = null;

// =============================================================================
// 高级伪装机制：1x1 透明常驻悬浮窗
// 原理：系统将拥有活动悬浮窗的 App 视为“准前台”，不仅能大幅降低被杀概率，
// 更能极大减少触发“频繁读取剪贴板”的系统隐私警告和闪烁。
// =============================================================================
let dummyWin = floaty.rawWindow('<frame bg="#00000000" w="1px" h="1px"></frame>');
ui.run(() => dummyWin.setTouchable(false));

// let pkg = context.packageName;
// shizuku(`appops set ${pkg} READ_CLIPBOARD allow`);
// shizuku(`appops set ${pkg} WRITE_CLIPBOARD allow`);
// log("已通过 ADB 强制开启后台剪贴板权限");

// importClass(android.content.Context);
// importClass(android.content.ClipboardManager);
// function getClipElegant() {
//     let cm = context.getSystemService(Context.CLIPBOARD_SERVICE);
//     // 检查是否有内容
//     if (!cm.hasPrimaryClip()) return null;

//     let data = cm.getPrimaryClip();
//     if (data && data.getItemCount() > 0) {
//         // 获取第一条文本
//         let text = data.getItemAt(0).getText();
//         return text ? text.toString() : null;
//     }
//     return null;
// }

// =============================================================================
// 核心：动静结合 - 事件驱动的“突发高频轮询”
// 解决死板循环导致的耗电和无端系统闪烁警告
// =============================================================================
// let lastClip = getClipElegant();
let lastClip = getClip();
let pollEndTime = 0;
let isPolling = false;

let lastLogContent = "";

/**
 * 检查 Shizuku 是否可用并有权限
 */
function isShizukuReady() {
    try {
        if (typeof shizuku === "undefined") return false;
        // 尝试执行 id 命令测试 shell 权限
        let res = shizuku.execCommand("id");
        return res && res.code === 0;
    } catch (e) {
        return false;
    }
}

/**
 * 通过 Logcat 检查是否有新的剪贴板事件
 * MIUI 专用标签: AiCrEngine_MiuiClipboardManager
 */
function hasNewClipboardLog() {
    try {
        // 获取最近的 3 条相关日志 (-t 3 为获取最新 3 行)
        let res = shizuku.execCommand(`logcat -v brief ${LOG_FILTER} -d`);
        if (res && res.result) {
            let currentLog = res.result.trim();
            // 如果日志内容发生化（且非空），则认为有新事件
            if (currentLog !== "" && currentLog !== lastLogContent) {
                lastLogContent = currentLog;
                return true;
            }
        }
    } catch (e) {
        // 忽略错误
    }
    return false;
}

// 开启一段局部的突发轮询（比如长按后持续轮询 8 秒）
function startClipboardPolling(durationSeconds) {
    durationSeconds = durationSeconds || 5;
    pollEndTime = Date.now() + durationSeconds * 1000;
    if (isPolling) return; // 如果已经在轮询中，只更新结束时间，不重开线程

    isPolling = true;
    threads.start(function () {
        log(`开启突发高频轮询 (${durationSeconds}s)...`);

        let shizukuReady = isShizukuReady();
        if (!shizukuReady) log("Shizuku 权限不足或未安装，将回退到标准轮询模式");

        // 只有在这个窗口期内，且屏幕亮着时，才会偷偷读一次剪贴板
        while (Date.now() < pollEndTime && device.isScreenOn()) {
            try {
                // let currentClip = getClipElegant();
                // 优先基于 logcat 判断是否发生复制（优化：减少 getClip 的系统压力）
                if (!shizukuReady || hasNewClipboardLog()) {
                    let currentClip = getClip();
                    if (currentClip && currentClip.trim() !== "" && currentClip !== lastClip) {
                        log("成功捕获到新复制内容！");
                        lastClip = currentClip;

                        let appInfo = getCurrentAppInfo();
                        let url = getBrowserUrl(appInfo.pkg);

                        ui.run(function () {
                            dismissCurrentPopup();
                            showConfirmPopup(currentClip, appInfo, url);
                        });
                    }
                }
            } catch (e) {
                // 放任不管
            }
            sleep(POLLING_INTERVAL); // 高频读取的频次
        }
        isPolling = false;
        log("突发轮询结束，进入静默休眠");
    });
}

// ============== 侦测“可能复制”的危险动作 ==============

// 监听所有可能的弹窗事件
auto.registerEvent("WINDOW_STATE_CHANGED", function (event) {
    if (!event) return;

    let className = event.getClassName() ? event.getClassName().toString() : "";
    let pkgName = event.getPackageName() ? event.getPackageName().toString() : "";

    // 排除输入法弹起，防止打字时频繁触发
    if (pkgName.includes("inputmethod")) return;
    if (pkgName.includes("org.autojs.autojs6")) return;

    // 只要有悬浮层、菜单、弹窗出现，不管里面有没有“复制”字样，一律唤醒 5 秒监听！
    let isMenuClass = className === "android.widget.FrameLayout" ||
        className.includes("PopupWindow") ||
        className.includes("Menu") ||
        className.includes("Select") ||
        className.includes("FloatingToolbar") ||
        className.includes("Dialog");

    if (isMenuClass) {
        // log("👀 发现弹窗动作，类名：" + pkgName + " : " + className + "，唤醒 " + DURATION_SECONDS + " 秒监听...");
        startClipboardPolling(DURATION_SECONDS);
    }
});

// 保活机制：让主脚本永不退出
setInterval(() => { }, 1000);


// =============================================================================
// 系统级悬浮确认窗 (漂亮白底圆角药丸 + 蓝色T图标)
// =============================================================================

function showConfirmPopup(text, appInfo, url) {
    let win = floaty.window(
        '<frame w="wrap_content" h="wrap_content" padding="16dp">' +
        // 外层白色阴影大药丸
        '  <card cardCornerRadius="24dp" cardElevation="6dp" cardBackgroundColor="#FFFFFF" w="wrap_content" h="wrap_content">' +
        // baselineAligned="false" 强制几何居中，解决蓝底T和文字因基线不对齐导致的垂直偏差
        '    <horizontal id="btnSave" gravity="center_vertical" baselineAligned="false" padding="10dp 10dp 10dp 10dp" w="wrap_content" h="wrap_content" foreground="?selectableItemBackground">' +
        // 蓝底白色T圆角矩形图标，配合 layout_gravity="center_vertical"
        '      <card cardCornerRadius="8dp" cardElevation="0dp" cardBackgroundColor="#3B82F6" layout_gravity="center_vertical" w="32dp" h="32dp" marginRight="12dp">' +
        '        <text text="T" textColor="#FFFFFF" textSize="18sp" textStyle="bold" gravity="center" w="match_parent" h="match_parent"/>' +
        '      </card>' +
        '      <text text="收藏所选文本" textColor="#333333" textSize="15sp" textStyle="bold" layout_gravity="center_vertical"/>' +
        '      <text id="txtCount" textColor="#999999" textSize="12sp" marginLeft="6dp" layout_gravity="center_vertical"/>' +
        '    </horizontal>' +
        '  </card>' +
        '</frame>'
    );

    activeWin = win;

    // Y值中下部，X值写满设备宽度 (device.width)，系统会自动计算并在最右侧贴边显示
    win.setPosition(device.width / 2, device.height / 2 - 800);

    win.txtCount.setText("(" + POPUP_TIMEOUT_S + "s)");

    // 倒计时线程
    let timerThread = threads.start(function () {
        for (let i = POPUP_TIMEOUT_S; i >= 0; i--) {
            if (activeWin !== win) return;
            try {
                ui.run(() => win.txtCount.setText("(" + i + "s)"));
            } catch (e) { return; }
            sleep(1000);
        }
        dismissPopup(win);
    });
    activeTimer = timerThread;

    // 整个药丸都可以点击保存
    win.btnSave.on("click", function () {
        if (activeTimer) activeTimer.interrupt();
        dismissPopup(win);
        threads.start(() => saveSnippet(text, appInfo, url));
    });
}

function dismissPopup(win) {
    if (!win) return;
    try { ui.run(() => win.close()); } catch (e) { }
    if (activeWin === win) activeWin = null;
}

function dismissCurrentPopup() {
    if (activeTimer) { try { activeTimer.interrupt(); } catch (e) { } activeTimer = null; }
    if (activeWin) { dismissPopup(activeWin); }
}

// =============================================================================
// 写入 Obsidian Markdown 文件
// =============================================================================

function saveSnippet(text, appInfo, url) {
    try {
        let now = new Date();
        let dateStr = formatDate(now, "yyyyMMdd");
        let dtStr = formatDate(now, "yyyy-MM-dd HH:mm:ss");
        let filePath = TARGET_DIR + "/" + dateStr + ".md";

        let indented = text.split("\n")
            .filter(function (l) { return l.trim() !== ""; })
            .map(function (l) { return "  " + l; })
            .join("\n");

        let entry = "## " + dtStr + "\n\n" + indented + "\n\n" +
            '<p align="right"> <a href="' + url + '">' + appInfo.name + ':' + appInfo.pkg + '</a> </p>\n';

        if (!files.isDir(TARGET_DIR)) files.createWithDirs(TARGET_DIR + "/.keep");
        log("文件路径: " + filePath + "\n" + entry);
        files.append(filePath, entry);

        // writeLog("成功记录到: " + filePath);
        ui.run(() => toast("✅ 已记录到 " + dateStr + ".md"));

    } catch (e) {
        // writeLog("保存失败: " + e.message);
        ui.run(() => toast("❌ 保存失败: " + e.message));
    }
}

// =============================================================================
// 工具函数
// =============================================================================

function getCurrentAppInfo() {
    let pkg = currentPackage() || "unknown";
    let name = pkg;
    try {
        name = context.getPackageManager()
            .getApplicationLabel(context.getPackageManager().getApplicationInfo(pkg, 0))
            .toString();
    } catch (e) { }
    return { pkg: pkg, name: name };
}

function getBrowserUrl(pkg) {
    // 只有在常见的浏览器包名下，才调用全屏幕控件检索
    const BROWSER_PACKAGES = [
        "com.android.chrome",
        "com.brave.browser",
        "com.microsoft.emmx",
        "com.kiwibrowser.browser",
        "org.mozilla.firefox",
        "com.opera.browser"
    ];

    if (BROWSER_PACKAGES.indexOf(pkg) === -1) {
        return "N/A";
    }

    try {
        // 使用经过测试的组合全局无障碍检索框架！这种方式比单独去 root 查询更彻底且不容易脱壳
        let urlNode = selector().idContains("url_bar").findOnce() ||
            selector().idContains("location_bar").findOnce() ||
            selector().idContains("mozac_browser_toolbar_url_view").findOnce() ||
            selector().idContains("address_bar_text").findOnce() ||
            selector().descContains("地址栏").findOnce() ||
            selector().textContains("https://").findOnce() ||
            selector().textContains("http://").findOnce();

        if (urlNode && urlNode.text()) {
            return `https://${urlNode.text().toString()}`;
        } else if (urlNode && urlNode.desc()) {
            return `https://${urlNode.desc().toString()}`; // 万一放在 desc 属性里
        }

        return "未能自动识别 URL";
    } catch (e) {
        log("URL抓取异常: " + e.message);
        return "N/A";
    }
}

function formatDate(d, fmt) {
    return fmt
        .replace("yyyy", d.getFullYear())
        .replace("MM", String(d.getMonth() + 1).padStart(2, "0"))
        .replace("dd", String(d.getDate()).padStart(2, "0"))
        .replace("HH", String(d.getHours()).padStart(2, "0"))
        .replace("mm", String(d.getMinutes()).padStart(2, "0"))
        .replace("ss", String(d.getSeconds()).padStart(2, "0"));
}

// function writeLog(msg) {
//     let ts = new Date().toLocaleString("zh-CN");
//     files.append(LOG_FILE, "[" + ts + "] " + msg + "\n");
// }
