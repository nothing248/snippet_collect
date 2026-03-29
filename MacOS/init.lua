-- SnippetCollector 全局热键 (Option+Q)
local snippetScript = os.getenv("HOME") .. "/Documents/projetcs/self/script/macos/SnippetCollector.sh"

hs.hotkey.bind({"alt"}, "q", function()
    hs.task.new("/bin/bash", function(exitCode, stdOut, stdErr)
        -- 脚本内部已处理通知，这里只做错误兜底
        if exitCode ~= 0 then
            hs.notify.new({title="SnippetCollector", informativeText="错误: " .. stdErr}):send()
        end
    end, {snippetScript}):start()
end)

hs.notify.new({title="Hammerspoon", informativeText="SnippetCollector 热键已加载 (Option+Q)"}):send()