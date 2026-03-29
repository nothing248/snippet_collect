## 🖇️ 关联的 Issue (Related Issue)

<!-- 请输入绑定的 Issue 编号（如果有）。例如：Fixes #123, Resolves #456 -->
> 关联编号：

## 📝 修改内容简要描述 (Description of Changes)

<!-- 请用几句简短的话描述该 PR 引入的变化带来的价值，以及解决了什么实际问题。 -->

## 🧪 测试通过证明 (Testing Documentation)

请说明您是如何用实机或测试集验证这些变更的，并在对应的情况前打勾：
- [ ] 我在本地对应的操作系统/平台（Android / macOS / Windows / Linux 等）下实机完整运行了脚本链条且测试通过。
- [ ] 此功能的异常输入或边界情况（如用户无权限读取剪贴板、未选择文本直接按键等）已经得到了合理的捕获或断言分支处理，不会直接导致上游宿主进程级崩溃。

## ☑️ 提交前 Checklist (Pre-Merge Checklist)

在发起您的 PR 前，拜托您受累再次确认一遍：
- [ ] 遵循了本项目的 Code Style（如使用了 Prettier/ESLint/ShellCheck/Luacheck 等进行了强制级别或人工本地的 Lints 检测）。
- [ ] 代码不包含任何敏感信息（如我个人的真实系统路径、密钥对或个人服务器/邮箱配置）。
- [ ] 如果该 PR 引入或者修改了某个平台的重要配置环节，那么项目下的 `README.md` 或平台私有文档均已同步更新描述逻辑。
