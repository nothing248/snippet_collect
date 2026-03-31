[English](CONTRIBUTING_en.md) | [简体中文](CONTRIBUTING.md)

# Contributing to Snippet Collector

First of all, thank you so much for your interest in the **Snippet Collector** community! 🎉 We warmly welcome developers from different backgrounds and technology stacks to join us. Whether it's improving documentation, submitting a bug, or contributing new code to the cross-platform architecture, your support is the main driving force behind the project's growth.

To make collaboration smoother and reduce the onboarding anxiety for newcomers, please read this guide carefully. If you encounter any difficulties or unclear parts during the process, please feel free to leave a message in the Issues section, and we will enthusiastically answer your questions.

## 🗺️ How Can I Contribute?

### Submit Your First Issue
If you find any bugs or have new ideas, please browse existing Issues to see if they have already been proposed. If not, please use our [Bug Report] or [Feature Request] templates to create an Issue. This will enforce the collection of necessary information to help us locate the problem most efficiently.

### Local Development Environment & Workflow
1. You first need to **Fork** this repository on GitHub.
2. Clone it to your local machine:
   ```bash
   git clone https://github.com/nothing248/snippet_collect.git
   cd snippet_collect
   ```
3. Pull a new feature branch based on the `main` branch for development:
   ```bash
   git checkout -b feature/your-awesome-feature
   ```

### 💻 Code Style & Linting
Since Snippet Collector is a **multi-stack** ecosystem (including Shell, Lua, AutoHotkey v2, JavaScript/Autojs6), we prefer explicit code style constraints to prevent fragmentation:
- **JavaScript (Android/Autojs6)**: Please keep consistent with the [Google JavaScript Style Guide]. It is recommended to pass ESLint validation before submitting. For example, locally:
   ```bash
   npx eslint Android/XiaoMi/*.js
   ```
- **Shell (macOS/Linux)**: Please follow the [Google Shell Style Guide]. Before submitting, we **strongly require** local specification validation via ShellCheck, which will prevent most runtime errors:
   ```bash
   shellcheck MacOS/SnippetCollector.sh
   # Or for all sh scripts in the project
   ```
- **Lua (macOS/Hammerspoon)**: Code indentation must use 4 spaces. Avoid leaving empty elements at the end of tables. You can use the `luacheck` tool for specification testing:
   ```bash
   luacheck MacOS/*.lua
   ```
- **Global Basic Configuration**: If writing general documentation (like Markdown) or plain text templates, we recommend turning on Prettier settings in your editor to ensure that line break formatting and heading indentations are correctly formatted.

### Submitting a Pull Request (PR)
1. Ensure your branch code has passed **real device joint debugging and basic use cases** for the corresponding operating system (Android/Windows/macOS) modified locally.
2. Initiate the corresponding PR on your Forked repository, and set the target branch to the `main` branch of the main repository.
3. Be sure to fill it out truthfully according to our PULL_REQUEST_TEMPLATE requirements and check off the CheckList.
4. Your PR must pass our community review (if there are areas needing modification, maintaining members will help you optimize the code together in the discussion area with a very friendly attitude).

Thanks again; the Snippet Collector world is better because of your power!
