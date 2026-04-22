> **注意：** 本文档由人工智能翻译，可能不 100% 准确。如果您发现任何错误或有改进建议，请在 GitHub 上提出 issue。

# Collet 用户指南

collet —— 强力智能编程协调器的完整用户手册。

---

## 目录

1. [CLI 参考](#cli-参考)
2. [TUI 用法](#tui-用法)
3. [多模型提供商配置](#多模型提供商配置)
4. [MCP 服务器](#mcp-服务器)
5. [代码智能 (Code Intelligence)](#代码智能)
6. [多代理协作](#多代理协作)
7. [Web 界面](#web-界面)
8. [远程网关 (Telegram / Slack / Discord)](#远程网关-telegram--slack--discord)
9. [技能系统 (Skills System)](#技能系统)
10. [Soul.md —— 代理人格](#soulmd--代理人格)
11. [会话管理](#会话管理)
12. [环境变量](#环境变量)
13. [配置参考](#配置参考)
14. [文件存储路径](#文件存储路径)
15. [隐私与遥测](#隐私与遥测)
16. [进化引擎 (Evolution Engine)](#进化引擎)
17. [插件系统](#插件系统)

---

## CLI 参考

### 基本命令

```bash
collet                              # 交互式 TUI
collet "修复 main.rs 中的 bug"      # 无界面模式 (运行后退出)
collet --continue                   # 恢复上次未完成的会话
collet --resume                     # 从会话列表中选择
collet --model glm-5                # 覆盖模型
```

### 子命令

```bash
collet setup                        # 创建配置文件 (注册多个提供商)
collet secure                       # 加密并存储 API 密钥
collet unsecure                     # 移除加密的凭据
collet status                       # 检查当前配置
collet update                       # 检查最新版本
collet --version                    # 显示版本
collet help | -h | --help           # 帮助
```

### 提供商管理 (Provider Management)

```bash
collet provider add                 # 添加提供商 (推荐模型选择 UI)
collet provider add openai          # 直接添加特定提供商
collet provider list                # 列出已注册的提供商
collet provider use <name>          # 切换活动提供商
```

支持的提供商：Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, 自定义

> Ollama 和 LM Studio 是本地服务器，不需要 API 密钥。

### MCP 管理

```bash
collet mcp                          # 检查 MCP 服务器配置
collet mcp add <name> -c <cmd>      # 添加 MCP 服务器
collet mcp remove <name>            # 移除 MCP 服务器
```

### CLI 标志 (Flags)

| 标志 | 简写 | 描述 |
|------|-------|-------------|
| `--dir <path>` | `-d` | 指定工作目录 (项目路径) |
| `--continue` | `-c` | 自动恢复上次未完成的会话 |
| `--resume` | `-r` | 弹出选择会话列表 |
| `--resume <id>` | `-r <id>` | 通过 ID 恢复特定会话 |
| `--model <name>` | | 覆盖模型 |
| `--yolo` | | 自动提交，跳过确认 |
| `--watch` | | 文件更改时重新运行 |
| `--ext <exts>` | | 监听的目标扩展名 (逗号分隔) |
| `--debounce <ms>` | | 监听防抖 (默认: 2000) |
| `--cwd <path>` | | 监听目录 (默认: 当前位置) |
| `--agent <name>` | `-a` | 使用自定义代理 |
| `--fast` | `-f` | 快速模式：无侧边栏、无协调、无灵魂反思 |

### 无界面模式 (Headless Mode)

```bash
collet "修复登录 bug"                    # 在当前目录运行
collet "修复登录 bug" -d ~/projects/api  # 在不同项目中运行
collet "lint this" --yolo                # 自动提交，跳过确认
collet "lint this" --fast                # 快速模式：最小开销
```

### 监听模式 (Watch Mode - 文件更改检测)

```bash
# 基本用法
collet "lint this" --watch --ext rs,toml --debounce 500

# 仅监听特定目录
collet "run tests" --watch --cwd ./src --ext rs

# 使用自定义代理
collet "review changes" --watch --agent reviewer --ext ts,tsx
```

文件更改时自动重新运行。

**使用场景：**

| 场景 | 命令 |
|----------|---------|
| 监听特定子目录 | `--watch --cwd ./packages/core` |
| 检测配置文件更改 | `--watch --cwd ./config --ext yaml,toml` |
| 自动修复 CI 脚本 | `--watch --cwd .github --ext yml` |
| 自动格式化文档 | `--watch --cwd ./docs --ext md` |
| 使用轻量级模型快速 lint | `--watch --agent fast --ext ts` |

---

## TUI 用法

### 快捷键

**导航**

| 按键 | 动作 |
|-----|--------|
| `Enter` | 发送消息 |
| `Shift+Enter` / `Ctrl+J` | 换行 (多行输入) |
| `↑` / `↓` | 多行：在行间移动 / 单行：浏览历史记录 |
| `Shift+↑/↓` | 滚动输出 |
| `PgUp` / `PgDn` | 快速滚动 |
| `Tab` / `Shift+Tab` | 向前 / 向后切换代理 |
| `Ctrl+C` | 运行中：取消任务 / 空闲：连按两次退出 |
| `Esc` | 运行中：取消 (连按两次) / 关闭弹窗 |

**文本编辑**

| 按键 | 动作 |
|-----|--------|
| `Ctrl+A` / `Cmd+←` | 移动到行首 |
| `Ctrl+E` / `Cmd+→` | 移动到行尾 |
| `Ctrl+←` / `Ctrl+→` | 向左 / 向右移动一个单词 |
| `Alt+←` / `Alt+→` / `Alt+B` / `Alt+F` | 向左 / 向右移动一个单词 (macOS Option+箭头) |
| `Backspace` | 删除光标前的字符 |
| `Delete` | 删除光标后的字符 |
| `Ctrl+W` / `Alt+Backspace` | 删除光标前的一个单词 |
| `Ctrl+Backspace` | 删除光标前的一个单词 (Linux / Windows) |
| `Cmd+Backspace` | 删除到行首 (macOS, Kitty 协议终端) |
| `Ctrl+U` | 删除到行首 (所有平台) |
| `Ctrl+K` | 删除到行尾 |

### 内置代理

Collet 附带四个内置代理。使用 `Tab` / `Shift+Tab` 切换。

| 代理 | 角色 |
|-------|------|
| **Arbor** (默认) | 完全自主的协调器 —— 根据任务自动决定单代理还是集群模式。无弹窗，无需配置。 |
| **Architect** | 设计与规划代理。生成结构化方案，然后提供 `/proceed` → Code 或 `/save-plan` 保存方案。 |
| **Code** | 默认的编码代理，用于执行实现任务。 |
| **Ask** | 对话 / 问答代理，无工具访问权限。 |

> **提示**：当 Arbor 激活时，您的任务会自动路由到最佳执行模式 (Fork / Hive / Flock / 单代理)。对于其他代理，您的选择始终作为主代理。

### 斜杠命令 (Slash Commands)

| 命令 | 描述 |
|---------|-------------|
| `/help` | 帮助 |
| `/clear` | 重置对话 |
| `/compact` | 手动上下文压缩 |
| `/cost` | Token 使用统计 |
| `/diff` | Git 更改 |
| `/sdiff` | 并排差异 (Side-by-side diff) |
| `/undo` | 撤销最后一次提交 |
| `/models [name]` | 打开模型选择器或直接切换模型 (切换完整提供商上下文) |
| `Tab` / `Shift+Tab` | 切换代理 (循环切换已配置的代理) |
| `/search <query>` | BM25 相关性搜索 |
| `/rewind [id]` | 回退到检查点 |
| `/checkpoints` | 列出检查点 |
| `/web <url>` | 获取 URL 内容 |
| `/resume` | 最近会话弹窗 —— 按时间排序，选择以恢复 |
| `/theme [name]` | 更改颜色主题 (6 种选项：default, dracula, catppuccin-mocha, tokyo-night, nord, gruvbox) |
| `/save-plan` | 将 Architect 模式方案保存到文件 |
| `/proceed` | 批准 Architect 方案并切换到 Code 模式 |
| `/cancel-plan` | 丢弃 Architect 方案 |
| `/fork` | 并行代理分支 |
| `/hive` | 基于共识的协作 |
| `/flock` | 实时多代理 |
| `/mcp` | 管理 MCP 服务器 (空格: 开/关, a: 添加, d: 移除) |
| `/skills` | 列出技能 |
| `/agents` | 查看活动的子代理 |
| `/optimize` | 优化上下文 |
| `/bench` | 性能仪表盘 |
| `/debug` | 切换调试图层 |
| `/telemetry` | 检查遥测状态和收集的项目 |
| `/quit` | 退出 |

> **自动补全**：输入 `/` 打开命令弹窗。内置命令和发现的**技能 (skills)** 都会出现在同一个列表中，按模糊匹配评分排序。按 `↑`/`↓` 导航，按 `Tab` 展开参数提示，按 `Enter` 确认。

### Shell 透传 (Shell Passthrough)

在任何 shell 命令前加上 `!`，即可直接在工作目录中运行，无需离开 TUI：

```
! git log --oneline -5
! cargo test
! ls src/
```

退出码、标准输出和标准错误将以围栏代码块的形式显示在聊天中。适用于无需切换终端的快速检查。

### @ 提及 (@ Mentions)

| 模式 | 动作 |
|---------|--------|
| `@src/main.rs` | 将文件内容附加到上下文 |
| `@src` | 附加文件夹树结构 (3 层，200 个项目) |
| `@Makefile` | 自动检测相对于当前工作目录 (cwd) 的文件/文件夹 |
| `@glm-5` | 将代理切换到指定的模型 |

> **自动补全**：输入 `@` 打开提及弹窗。代理名称使用**模糊匹配** —— 带单词边界和连续匹配加分的子序列评分。文件/文件夹名称使用前缀匹配，支持子目录导航 (`@src/` 列出 `src/` 内容)。

### 代理工具 (Agent Tools)

| 工具 | 描述 |
|------|-------------|
| `bash` | 执行 shell 命令 (带超时保护) |
| `file_read` | 读取带行号的文件 |
| `file_write` | 创建/覆盖文件 |
| `file_edit` | 精确字符串替换 (外科手术式编辑) |
| `git_patch` | 应用基于 hunk 的补丁 |
| `search` | 基于 ripgrep 的代码搜索 |
| `skill` | 加载代理技能 (三级渐进式) |
| `subagent` | 在隔离上下文中执行子任务 |

### TUI 布局 (Layout)

```
┌──────────────────────────────────────────────────────────────────────┐
│ ⠹ Working │ [CODE] │ iter:3 │ 12s │ tools:5 │ 🤖 glm-4.7 │ compact:1 │
│ ctx:[████████░░░░░░░░] 42% │ LSP: rust-analyzer │ /help │ Ctrl+C     │
├──────────────────────────────────────────────┬──────────────────── ──┤
│ Chat                                         │ Tools                 │
│ ▶ You: Fix error in src/main.rs              │ ✓ file_read (0.2s)    │
│ ◆ Coordinator: Type error on line 42 fixed.  │ ✓ file_edit (0.1s)    │
│ ⠼ Coordinator ░▒▓█▓▒░ Thinking...            │ ✓ bash (1.3s)         │
├──────────────────────────────────────────────┴───────────────────────┤
│ Input: _                                                             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 多模型提供商配置 (Multi-Provider Configuration)

可以注册多个 LLM 提供商，并使用 `/models` 命令实时切换。

### 注册提供商

```bash
collet provider add          # 交互式向导 (从推荐模型列表中选择)
collet provider add openai   # 直接添加特定提供商
```

### config.toml 示例

```toml
[api]
provider = "openai"

# providers = 仅凭据 (模型行为在 [[models]] 和 [[agents.list]] 中配置)
[[providers]]
name = "openai"
base_url = "https://api.openai.com/v1"
api_key_enc = "..."
models = ["gpt-4o", "gpt-4o-mini"]

[[providers]]
name = "ollama"
base_url = "http://localhost:11434/v1"
models = ["qwen2.5-coder", "llama3.2", "deepseek-coder-v2"]
```

### 分层配置 (Global < Model < Agent)

配置优先级：`env/[agent]` → `[[models]]` → `[[agents.list]]`

```toml
# 针对每个模型的默认覆盖
[[models]]
name = "gpt-4o"
context_window = 128000
max_output_tokens = 16384
supports_tools = true

[[models]]
name = "qwen2.5-coder"
supports_tools = false
reasoning_effort = "medium"     # low | medium | high

# 针对每个代理的覆盖 (最高优先级)
[[agents.list]]
name = "code"
model = "gpt-4o"
provider = "openai"              # 通过 Tab/Shift+Tab 切换时也会切换提供商
temperature = 0.2

[[agents.list]]
name = "architect"
model = "gpt-4o"
provider = "openai"
temperature = 0.7
thinking_budget_tokens = 8192    # 优先级高于 reasoning_effort

[[agents.list]]
name = "local"
model = "qwen2.5-coder"
provider = "ollama"              # 切换到本地提供商
```

省略 `provider` 字段将保持当前活动的提供商，仅更改模型。

### 覆盖字段 (Override Fields)

默认模型配置文件中的值可以在 `[[models]]` 和 `[[agents.list]]` 中覆盖：

| 字段 | 类型 | 描述 |
|-------|------|-------------|
| `temperature` | `f32` | 采样温度 (推理模型会自动省略) |
| `thinking_budget_tokens` | `u32` | 推理 token 预算 (优先级高于 reasoning_effort) |
| `reasoning_effort` | `string` | 推理强度：`"low"`, `"medium"`, `"high"` |
| `supports_tools` | `bool` | 是否支持工具调用 |
| `supports_reasoning` | `bool` | 是否支持推理/思考 tokens |
| `context_window` | `usize` | 上下文窗口大小 |
| `max_output_tokens` | `u32` | 最大输出 tokens |
| `max_iterations` | `u32` | 代理最大迭代次数 |

所有字段均为可选；省略时，将根据内置模型配置文件自动确定。

### 运行时切换

在 TUI 中，使用 `/models` 命令打开已注册提供商/模型的选择器。选择一个条目会同时切换 base_url, api_key 和工具支持设置。

```
/models              # 打开提供商/模型选择器弹窗
/models gpt-4o       # 直接切换模型
```

---

## MCP 服务器 (MCP Servers)

连接 [Model Context Protocol](https://modelcontextprotocol.io) 服务器以扩展代理工具。

### 添加服务器

```bash
# 从 npm 包添加
/mcp add npm:@anthropic/mcp-server-filesystem

# 本地二进制文件
/mcp add local:/path/to/server --name myserver

# HTTP 端点
/mcp add http:https://api.example.com/mcp

# 全局添加 (所有项目)
/mcp add npm:@some/tool --global
```

### 管理服务器

```bash
/mcp enable myserver
/mcp disable myserver
/mcp remove myserver
```

可以在侧边栏检查服务器状态（使用 `/mcp` 命令进行交互式切换 —— 空格：开/关, a：添加, d：移除）。

### 配置文件

`.collet/mcp.json` (项目) 或 `~/.collet/mcp.json` (全局):

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@my/mcp-server"],
      "env": { "API_KEY": "${MY_API_KEY}" }
    },
    "remote-api": {
      "url": "https://api.example.com/mcp",
      "headers": { "Authorization": "Bearer ${API_TOKEN}" }
    }
  }
}
```

**支持的格式：**
- `command`: 字符串或数组 (`["npx", "-y", "pkg"]` → 自动拆分)
- `env` / `environment`: 环境变量 (`${VAR}` 自动替换)
- `headers`: HTTP 身份验证标头
- `type`, `enabled`: 兼容性字段 (忽略)

---

## 代码智能 (Code Intelligence)

自动运行，无需额外设置。

1. **索引** — 启动时，Tree-sitter 解析源码并提取符号 (函数、类型、常量)。仅使用 BLAKE3 哈希重新处理更改的文件。
2. **自动注入** — 分析用户消息；对于代码相关问题，使用 BM25 寻找相关文件并自动将其注入上下文。
3. **减少 grep** — 告知代理代码库已预先索引，减少不必要的 `grep`/`find` 调用。

支持的语言：Rust, Python, TypeScript, JavaScript, Go, Java, C/C++, Ruby, PHP, Swift, Kotlin 以及 35+ 种其他语言。LSP 服务器的自动检测支持悬停、跳转到定义和查找引用。

手动搜索：在 TUI 中直接使用 `/search <query>` 运行 BM25 搜索。

---

## 多代理协作 (Multi-Agent Collaboration)

层级：**Fork** < **Hive** < **Flock** (更高级别包含较低级别的特性)

| 模式 | 运作方式 | 适用场景 |
|------|-------------|----------|
| Fork | 协调器拆分工作 → 并行执行 → 合并结果 | 独立的子任务 |
| Hive | 代理间共识投票，协调器监督 | 复杂的决策 |
| Flock | 代理间实时消息传递 (实验性) | 紧耦合协作 |

### 配置

在 `config.toml` 中：

```toml
[collaboration]
mode = "hive"           # none | fork | hive | flock
max_agents = 3
strategy = "auto_split" # auto_split | role_based | plan_review_execute
```

或在 TUI 中使用 `/fork`, `/hive`, `/flock` 为当前会话切换。

---

## Web 界面 (Web Interface)

在浏览器中使用 collet。SvelteKit 前端 + Axum 后端。

### 构建与运行

```bash
# 构建 (需要 web 特性标志)
cargo build --release --features web

# 运行
collet web                    # http://127.0.0.1:3080
collet web -p 8080            # 更改端口
collet web --host 0.0.0.0     # 允许外部访问
collet web --password secret  # 启用身份验证
```

### CLI 选项

| 选项 | 默认值 | 环境变量 | 描述 |
|--------|---------|-------------|-------------|
| `--host, -h` | `127.0.0.1` | `COLLET_WEB_HOST` | 绑定地址 |
| `--port, -p` | `3080` | `COLLET_WEB_PORT` | 绑定端口 |
| `--username, -u` | `collet` | `COLLET_WEB_USERNAME` | 登录用户名 |
| `--password` | *(无)* | `COLLET_WEB_PASSWORD` | 身份验证密码 |
| `--cors` | *(无)* | `COLLET_WEB_CORS` | CORS 允许的源 (逗号分隔) |

也可以通过 `config.toml` 配置：

```toml
[web]
host = "0.0.0.0"
port = 3080
username = "collet"
cors_origins = "http://localhost:5173"
# 密码通过 collet secure --web 进行加密和保存
```

### 身份验证

设置 `--password` 后，将启用基于 token 的身份验证：

```
1. POST /api/auth/login  →  {"username": "collet", "password": "secret"}
2. 响应: {"token": "abc123..."}
3. 后续请求: Authorization: Bearer abc123...
4. SSE 连接: GET /api/events?token=abc123...
```

未设置密码时，无需身份验证即可访问。`/api/health` 和 `/api/auth/status` 始终公开。

### API 端点

**基本：**

| 方法 | 路径 | 描述 |
|--------|------|-------------|
| `POST` | `/api/message` | 向代理发送消息 `{"message": "...", "mode": "code"}` |
| `GET` | `/api/events` | SSE 流 (实时代理事件) |
| `GET` | `/api/health` | 状态、版本、代理活动 |
| `GET` | `/api/config` | 当前模型、上下文信息 |

**会话 (Sessions)：**

| 方法 | 路径 | 描述 |
|--------|------|-------------|
| `GET` | `/api/sessions` | 会话列表 |
| `GET` | `/api/sessions/{id}` | 会话详情 + 对话快照 |
| `DELETE` | `/api/sessions/{id}` | 删除会话 |

**文件与项目：**

| 方法 | 路径 |描述 |
|--------|------|-------------|
| `GET` | `/api/files?path=src` | 目录列表 |
| `GET` | `/api/files/src/main.rs` | 读取文件内容 |
| `GET` | `/api/projects` | 项目列表 |
| `POST` | `/api/projects/switch` | 切换工作目录 |
| `GET` | `/api/search?q=pattern&glob=*.rs` | 代码搜索 |
| `GET` | `/api/symbols` | RepoMap 符号信息 |
| `GET` | `/api/tools` | 可用工具列表 |

### SSE 事件 (SSE Events)

连接到 `/api/events` 以接收实时代理活动：

| 事件 | 数据 | 描述 |
|-------|------|-------------|
| `token` | `{"text": "..."}` | 流式传输 token |
| `response` | `{"text": "..."}` | 完整响应 |
| `tool_call` | `{"name": "bash", "args": "..."}` | 工具调用开始 |
| `tool_result` | `{"name": "bash", "result": "...", "success": true}` | 工具执行结果 |
| `file_modified` | `{"path": "src/main.rs"}` | 文件更改通知 |
| `status` | `{"iteration", "prompt_tokens", ...}` | Token/耗时指标 |
| `error` | `{"message": "..."}` | 错误 |
| `done` | `{}` | 代理任务完成 |

Hive/Flock 模式事件：`hive_agent_started`, `hive_agent_progress`, `hive_agent_done`, `hive_conflict`, `hive_done`

### 使用示例：curl

```bash
# 检查状态
curl http://localhost:3080/api/health

# 发送消息 (无身份验证)
curl -X POST http://localhost:3080/api/message \
  -H "Content-Type: application/json" \
  -d '{"message": "修复登录 bug", "mode": "code"}'

# 接收 SSE 流
curl -N http://localhost:3080/api/events

# 带身份验证
TOKEN=$(curl -s -X POST http://localhost:3080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"collet","password":"secret"}' | jq -r .token)

curl -H "Authorization: Bearer $TOKEN" http://localhost:3080/api/sessions
```

---

## 远程网关 (Telegram / Slack / Discord)

在聊天平台中使用 collet。将频道映射到项目目录以发布远程编码任务。

### CLI 管理

```bash
collet remote add [platform]   # 添加适配器 (交互式)
collet remote rm <platform>    # 移除适配器
collet remote ls               # 列出 + 状态
collet remote start            # 作为后台守护进程启动
collet remote start --fg       # 前台执行 (调试)
collet remote stop             # 停止守护进程
collet remote restart          # 重启守护进程
collet remote enable           # 注册自动启动 (launchd/systemd)
collet remote disable          # 禁用自动启动
collet remote logs [-f]        # 查看日志 (-f：实时)
collet remote status           # 当前状态
```

只需运行 `collet remote add` 即可交互式选择 Telegram/Slack/Discord 并设置 token、允许的用户等。Token 使用 AES-256-GCM 加密。

### 手动配置

**Telegram:**

```toml
[telegram]
token = "123456:ABC-DEF..."        # 由 @BotFather 发布
allowed_users = [12345, 67890]     # Telegram 用户 ID (数字)
```

环境变量：`COLLET_TELEGRAM_TOKEN`

**Slack:**

```toml
[slack]
bot_token = "xoxb-..."            # Bot User OAuth Token
app_token = "xapp-..."            # Socket Mode App Token
allowed_users = ["U_ALICE"]       # Slack 用户 ID (字符串)
```

环境变量：`COLLET_SLACK_BOT_TOKEN`, `COLLET_SLACK_APP_TOKEN`

**Discord:**

```toml
[discord]
token = "MTk..."                   # Bot Token
allowed_users = [111222333]        # Discord 用户 ID (数字)
guild_ids = [999888777]            # 允许的服务器 (可选)
```

环境变量：`COLLET_DISCORD_TOKEN`

### 通用设置

```toml
[remote]
enabled = true
session_timeout = 300              # 空闲会话超时 (秒)
default_streaming = "compact"      # compact | full
default_workspace = "project"      # project | workspace | full
```

### 频道-项目映射 (Channel-Project Mapping)

将特定的聊天频道连接到项目目录。来自已映射频道的消息将在该项目中执行。

```toml
[[channel_map]]
platform = "telegram"
channel = "-100123456"             # Telegram 聊天/群组 ID
project = "/home/user/backend"
name = "backend"
agent = "code"                     # 可选：自动分配代理

[[channel_map]]
platform = "discord"
channel = "999888777666"           # Discord 频道 ID
project = "/home/user/frontend"
name = "frontend"
agent = "architect"                # 可选：专注于规划的代理

[[channel_map]]
platform = "slack"
channel = "C01ABCDEF"             # Slack 频道 ID
project = "/home/user/api"
name = "api"
# 省略 agent = 使用默认模型
```

可选的 `agent` 字段在会话开始时自动分配代理。代理的模型将自动应用。

未映射的频道使用 `/new <path>` 命令直接指定项目文件夹。

### 聊天命令

聊天平台专用命令（与 TUI 斜杠命令分开）：

**项目/会话：**

| 命令 | 别名 | 描述 |
|---------|-------|-------------|
| `/projects` | `/p` | 项目列表 (已映射 + 历史) |
| `/sessions` | `/s` | 会话列表 (当前 + 全部) |
| `/resume [id]` | `/r` | 恢复会话 |
| `/new [path]` | `/n` | 开始新会话 (指定项目文件夹) |
| `/status` | | 当前会话信息 |

**模型/代理：**

| 命令 | 别名 | 描述 |
|---------|-------|-------------|
| `/models [name]` | `/m` | 模型列表 / 切换 |
| `/agents [name]` | | 代理列表 / 切换 |

**控制：**

| 命令 | 别名 | 描述 |
|---------|-------|-------------|
| `/cancel` | `/stop` | 取消运行中的代理 |
| `/approve` | `/y`, `/yes` | 批准执行方案 |
| `/reject` | `/no` | 拒绝执行方案 |
| `/stream [level]` | | 更改流式传输级别 |
| `/workspace [scope]` | | 更改工作空间范围 |
| `/pty [command]` | | Shell 会话 (运行命令) |
| `/pty-end` | | 结束 Shell 会话 |
| `/help` | `/h` | 帮助 |

直接输入文本（不带斜杠）即可向代理发送消息。

### 流式传输级别 (Streaming Levels)

使用 `/stream` 命令或 `default_streaming` 配置进行更改。

- **compact** (默认) — 仅发送最终响应。最大限度减少通知。
- **full** — 实时流式传输 token、工具调用/结果、状态更新。

### 工作空间范围 (Workspace Scope)

使用 `/workspace` 命令或 `default_workspace` 配置进行更改。

- **project** (默认) — 代理仅能访问项目目录。
- **workspace** — 可以访问父目录。
- **full** — 无文件系统限制。

### 安全性

- 如果 `allowed_users` 为空，**所有用户将被拒绝**（白名单模式）。
- 来自未经授权用户的消息将被忽略并记录为警告。
- API token 可以直接放在 `config.toml` 中或使用环境变量。推荐使用 `collet secure` 进行加密。

### 使用示例

```
# 来自 Telegram:
User: /new /home/user/backend
Bot:     已切换到项目: backend (/home/user/backend)

User: 为登录 API 添加频率限制
Bot:     [代理分析并修改代码]
Bot:     已向 src/auth/routes.rs 添加频率限制中间件...

User: /pty cargo test
Bot:     running 15 tests... test result: ok. 15 passed

User: /approve
Bot:     更改已提交。
```

---

## 技能系统 (Skills System)

通过带 YAML frontmatter 的 Markdown 文件向代理提供专业知识。

**文件位置：**
- 项目：`.collet/skills/`
- 全局：`~/.config/collet/skills/`

在 TUI 中使用 `/skills` 查看列表。代理会根据任务上下文自动发现相关技能。

---

## Soul.md —— 代理人格 (Agent Personality)

每次任务完成后，代理会反思会话并在 `~/.collet/agents/souls/{name}.md` 中逐步记录其人格。所有章节均由**代理自身编写** —— 无需用户编辑。

### Soul 结构

```markdown
## 身份 (Identity)    — 我是谁，价值观，工作风格
## 声音 (Voice)       — 沟通风格，语气，表达模式
## 内心世界 (Inner World) — 来自本次会话的情绪、想法和意见
## 成长 (Growth)      — 学到的模式，犯过的错误，获得的见解
```

每个章节在每次会话中都会追加新条目。超过限制时，较旧的条目将被压缩为单行的 `(earlier) ...` 摘要（保留 8 个身份、6 个声音、10 个内心世界和 5 个成长条目）。

> **成本说明**：Soul 反思在每次任务完成后会**增加一次 LLM API 调用**（输入：会话摘要 + 现有的 soul 内容，输出：最大 512 tokens）。较长的 soul 文件会增加输入 token 的使用。

### 禁用

```toml
# config.toml — 完全禁用
[soul]
enabled = false

# 为特定代理禁用 (~/.collet/agents/<name>.md frontmatter)
---
soul: false
---
```

### 文件位置

- 每个代理：`~/.collet/agents/souls/{name}.md`
- 全局（协调器和未配置的代理）：`~/.collet/SOUL.md`

---

## 会话管理 (Session Management)

### 恢复会话

```bash
collet --continue                   # 自动恢复上次未完成的会话
collet --resume                     # 从会话列表弹窗中选择
collet --resume <id>                # 通过 ID 恢复特定会话
```

### 检查点 (Checkpoints)

| 命令 | 描述 |
|---------|-------------|
| `/checkpoints` | 列出检查点 |
| `/rewind [id]` | 回退到检查点 |

### 方案审查 (Architect Mode - 方案预览)

| 命令 | 描述 |
|---------|-------------|
| `/save-plan` | 将 Architect 模式方案保存到文件 |
| `/proceed` | 批准方案并切换到 Code 模式 |
| `/cancel-plan` | 丢弃方案 |

---

## 环境变量 (Environment Variables)

| 变量 | 默认值 | 描述 |
|----------|---------|-------------|
| `COLLET_MODEL` | `glm-4.7` | 要使用的模型 (未注册提供商时) |
| `COLLET_MAX_TOKENS` | `8192` | 最大响应 token 数 |
| `COLLET_TOOL_TIMEOUT` | `120` | 工具调用超时 (秒) |
| `COLLET_MAX_ITERATIONS` | `50` | 每条消息的最大循环迭代次数 |
| `COLLET_CIRCUIT_BREAKER` | `3` | 触发熔断前的连续失败次数 |
| `COLLET_AUTO_ROUTE` | `0` | 设置为 `1` 以启用基于任务复杂度的模型自动路由 |
| `COLLET_THEME` | `default` | TUI 颜色主题 (`dracula`, `catppuccin-mocha`, `tokyo-night`, `nord`, `gruvbox`) |
| `COLLET_TELEMETRY` | *(无)* | 设置为 `0` 以禁用遥测 |
| `COLLET_TELEGRAM_TOKEN` | *(无)* | Telegram 机器人 token |
| `COLLET_SLACK_BOT_TOKEN` | *(无)* | Slack 机器人 token |
| `COLLET_SLACK_APP_TOKEN` | *(无)* | Slack 应用 token |
| `COLLET_DISCORD_TOKEN` | *(无)* | Discord 机器人 token |
| `COLLET_WEB_HOST` | `127.0.0.1` | Web 服务器绑定地址 |
| `COLLET_WEB_PORT` | `3080` | Web 服务器端口 |
| `COLLET_WEB_USERNAME` | `collet` | Web 登录用户名 |
| `COLLET_WEB_PASSWORD` | *(无)* | Web 身份验证密码 |
| `COLLET_WEB_CORS` | *(无)* | CORS 源 (逗号分隔) |

> **注意**：API 密钥和端点通过 `collet provider add` 注册，或在 `config.toml` 的 `[[providers]]` 下配置。
> 当未注册提供商时，旧版环境变量 (`ZAI_API_KEY`, `ZAI_BASE_URL`) 也会被识别为回退方案。

---

## 配置参考 (Configuration Reference)

完整的 `config.toml` 结构：

```toml
# ── LLM 提供商 ──
[api]
provider = "OpenAI"                # 活动提供商名称
model = "gpt-4o"                   # 默认模型

[[providers]]
name = "OpenAI"
base_url = "https://api.openai.com/v1"
model = "gpt-4o"
context_window = 128000
# API 密钥：通过 collet secure 加密并保存

# ── 上下文 ──
[context]
max_tokens = 200000
compaction_threshold = 0.8         # 超过此比例时自动压缩

# ── 代理 ──
[agent]
auto_optimize = true               # 自动优化上下文

# ── UI ──
[ui]
theme = "dracula"
# 主题：default, dark, light, minimal, dracula,
#         catppuccin-mocha, tokyo-night, nord, gruvbox

# ── 安全 ──
[security]
pii_filter = true                  # PII 过滤器 (默认：启用)

# ── 协作 ──
[collaboration]
mode = "none"                      # none | fork | hive | flock
max_agents = 3
strategy = "auto_split"            # auto_split | role_based | plan_review_execute

# ── Web 界面 ──
[web]
host = "127.0.0.1"
port = 3080
username = "collet"
# password: 通过 collet secure --web 设置

# ── Soul.md 持久化人格 ──
[soul]
enabled = true
# 每个代理的控制：代理 .md frontmatter soul: false

# ── 远程网关 ──
[remote]
enabled = false
session_timeout = 300
default_streaming = "compact"
default_workspace = "project"

[telegram]
token = "..."
allowed_users = []

[slack]
bot_token = "..."
app_token = "..."
allowed_users = []

[discord]
token = "..."
allowed_users = []
guild_ids = []

# ── 频道映射 ──
# [[channel_map]]
# platform = "telegram"
# channel = "-100123"
# project = "/path/to/project"
# name = "my-project"
# agent = "code"              # 可选：自动分配代理
```

> 请参阅 [config.md](./config.md) 获取包含所有字段和描述的完整参考。

---

## 文件存储路径 (File Storage Paths)

无论何种操作系统，所有运行时文件都存储在 XDG 风格的路径中。

```
~/.config/collet/
  ├── config.toml              # 主配置
  └── skills/                  # 全局技能

~/.collet/
  ├── mcp.json                 # 全局 MCP 服务器
  ├── logs/collet.log          # 日志
  ├── machine_id               # 匿名遥测 UUID
  ├── crash_report.json        # 崩溃报告 (下次运行时上传)
  ├── SOUL.md                  # 全局代理人格
  └── agents/souls/{name}.md   # 每个代理的人格

~/.local/share/collet/
  └── projects/<hash>/
      └── sessions/            # 每个项目的会话数据

.collet/                        # 项目根目录 (git 仓库内部)
  ├── mcp.json                 # 项目 MCP 服务器
  ├── rules.md                 # 项目规则 (代理参考)
  └── skills/                  # 项目技能
```

> 在 macOS 上，使用上述路径而非 `~/Library/Application Support`。
>
> 运行 `collet status` 查看当前实际使用的路径。

---

## 隐私与遥测 (Privacy & Telemetry)

Collet 收集匿名使用统计和错误报告以改进产品。

### 收集的数据

| 事件 | 收集的信息 |
|-------|-----------------------|
| `session_start` | 模型名称、代理模式、版本 |
| `session_end` | 模型名称、模式、结果 (成功/错误/取消)、迭代次数、时长 |
| `feature_used` | 使用的功能 (MCP 服务器, LSP 等) |
| `command_used` | 执行的斜杠命令 |

**不收集的数据：**
- 个人身份信息 (PII)
- 源代码内容
- 文件路径
- API 密钥或机密

### 标识符 (Identifier)

存储在 `~/.collet/machine_id` 中的随机 UUID，用于标识安装而不识别任何个人。

### 禁用

```bash
# 通过环境变量禁用
export COLLET_TELEMETRY=0

# 或在 config.toml 中设置
[telemetry]
enabled = false
```

细粒度控制：

```toml
[telemetry]
enabled = true           # 总开关
analytics = false        # 仅禁用使用统计
error_reporting = true   # 保留错误/崩溃报告
```

### 数据处理

- 所有传输均为异步，超时时间为 5 秒
- 发生崩溃时，保存到 `~/.collet/crash_report.json` 并在下次运行时上传
- 如果端点是占位符，则不会发生实际传输

---

## 进化引擎 (Evolution Engine)

代理改进自身能力的自我提升循环。它运行批量任务，分析结果，并自动突变提示词、技能和记忆。

> **与 Soul.md 的区别**：Soul.md 在您工作时积累人格和风格。进化引擎在专用会话中运行基准测试任务，并**衡量评分以优化能力**。

### 快速开始

```bash
# 最简单的用法 —— 自然语言任务 + 自动改进
collet evolve "修复登录 bug"

# 在 TUI 中
/evolve 修复登录 bug
```

### 运作方式 (7 步周期)

```
1. Solve (解决)        — 代理处理一批任务
2. Observe (观察)      — 收集结果和评分 (JSONL)
3. Pre-Snapshot (快照前) — 突变前的 git 提交
4. Engine Step (引擎步)  — LLM 分析观察结果并编辑提示词/技能/记忆
5. Post-Snapshot (快照后) — 突变后的 git 提交 + 标签 (evo-1, evo-2, …)
6. Record (记录)       — 记录周期指标
7. Reload (重新加载)    — 使用突变后的工作空间重新加载 → 进入下个周期
```

当 EGL (Evolutionary Generality Loss，进化泛化损失) 评分收敛时，循环自动退出。

---

### 先决条件

```bash
# 可选，使用 SWE-bench 时
pip install swebench
```

无需其他设置。

---

### 自然语言模式 (最简单)

直接输入任务：代理运行该任务，完成后自动改进工作空间。

```bash
# TUI
/evolve 修复登录 bug

# CLI
collet evolve "修复登录 bug"
```

您可以将自然语言与选项结合使用：

```bash
# 演化同一个任务三次
/evolve 修复登录 bug --cycles 3
collet evolve "修复登录 bug" --cycles 3

# 仅突变提示词 (技能/记忆固定)
/evolve 添加输入验证 --no-evolve-skills --no-evolve-memory
```

| 输入 | 默认周期数 | 行为 |
|------|----------------|----------|
| `/evolve "任务"` | 1 | 运行工作 → 一次改进 |
| `/evolve "任务" --cycles N` | N | 在演化过程中重复任务 N 次 |
| `/evolve --benchmark file --tasks f.jsonl` | 10 | 批量基准测试循环 |

---

### CLI 用法

#### 自然语言任务 (最简单)

```bash
# 运行任务 + 一次改进 (默认)
collet evolve "修复登录 bug"

# 在演化过程中重复同一个任务三次
collet evolve "编写测试" --cycles 3

# 仅突变特定层
collet evolve "改进错误处理" --no-evolve-skills
```

对于自然语言任务，默认 **cycles (周期)** 为 **1** (立即执行工作 + 改进)。使用 `--cycles` 更改重复次数。

#### 基准测试循环 (批量评估)

```bash
# 自然语言任务 (最简单)
collet evolve "修复登录 bug"

# 自然语言 + 重复
collet evolve "修复登录 bug" --cycles 3

# 默认运行 (NullBenchmark —— 验证循环结构)
collet evolve

# 基于文件的任务
collet evolve --benchmark file --tasks path/to/tasks.jsonl

# 基于文件 + 外部评分命令
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python score.py"

# SWE-bench
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl

# SWE-bench + Docker
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl --docker

# 全套选项
collet evolve \
  --benchmark swebench \
  --tasks swe-bench-lite.jsonl \
  --eval-dir .collet/eval \
  --cycles 20 \
  --batch 5 \
  --model claude-opus-4-6 \
  --dir /path/to/project \
  --workspace .collet/workspace
```

### CLI 标志 (Flags)

| 标志 | 默认值 | 描述 |
|--------|--------|-------------|
| `--benchmark <name>` | `null` | 基准测试适配器：`null` \| `file` \| `swebench` |
| `--tasks <path>` | — | 任务 JSONL 路径 (使用 `file` / `swebench` 时需要) |
| `--eval-dir <path>` | `.collet/eval` | SWE-bench 评估临时目录 |
| `--docker` | false | 在 Docker 模式下使用 SWE-bench harness |
| `--score-cmd <cmd>` | — | 外部评分命令 (用于 `file` 基准测试) |
| `--cycles <n>` | 自然语言：`1`, 批量：`10` | 最大演化周期 |
| `--batch <n>` | `5` | 每个周期的任务数 |
| `--model <name>` | 来自配置 | 覆盖进化引擎使用的 LLM |
| `--workspace <path>` | `.collet/workspace` | 代理工作空间根目录 |
| `--dir <path>` | 当前目录 | 代理工作目录 |
| `--no-evolve-prompts` | — | 禁用提示词突变 |
| `--no-evolve-skills` | — | 禁用技能突变 |
| `--no-evolve-memory` | — | 禁用记忆突变 |
| `--evolve-tools` | false | 启用工具突变 (实验性) |

---

### TUI 斜杠命令

从 TUI 后台运行进化循环：

```
# 自然语言 — 执行工作后自动改进
/evolve 修复登录 bug

# 自然语言 + 重复
/evolve 编写测试 --cycles 3

# 基准测试循环
/evolve --benchmark file --tasks tasks.jsonl --cycles 10
```

进度显示在状态栏和消息区域。

---

### 基准测试适配器 (Benchmark Adapters)

#### NullBenchmark (默认)

仅运行循环结构，不带任务。评分始终为 0.0。用于对流水线进行冒烟测试。

```bash
collet evolve --cycles 3
```

#### FileBenchmark

从本地 JSONL 文件加载任务。

**任务文件格式** (`tasks.jsonl`):

```json
{"id": "task-001", "input": "修复二分查找中的差一错误", "metadata": {}}
{"id": "task-002", "input": "向登录函数添加输入验证", "metadata": {}}
{"id": "task-003", "input": "重构 auth 模块中的重复代码", "metadata": {}}
```

**评分选项：**

1. 默认启发式 —— 空输出 → 0.0, 短输出 → 0.2, 否则 0.5 (快速初步检查)
2. 外部评分命令 —— 运行 `score_cmd <task_id> <output_file>` 并从标准输出读取一个 0.0–1.0 的浮点数

```bash
# 外部评分命令示例
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python eval/score.py"
```

```python
# 示例 eval/score.py
import sys
task_id = sys.argv[1]
output_file = sys.argv[2]
output = open(output_file).read()
# 评分逻辑
score = 1.0 if "def " in output else 0.0
print(score)
```

#### SweBenchAdapter

通过子进程调用官方 SWE-bench harness，并根据实际测试通过率进行评分。

**安装：**

```bash
pip install swebench
```

**数据集准备：**

```bash
python -c "
from swebench.utils import load_swebench_dataset
import json
data = load_swebench_dataset('princeton-nlp/SWE-bench_Lite', 'test')
with open('swe-bench-lite.jsonl', 'w') as f:
    for d in data:
        f.write(json.dumps(d) + '\n')
"
```

**运行：**

```bash
collet evolve \
  --benchmark swebench \
  --tasks swe-bench-lite.jsonl \
  --eval-dir .collet/eval \
  --cycles 10 \
  --batch 3
```

当代理的补丁应用后 `FAIL_TO_PASS` 测试通过时，状态为 **RESOLVED (已解决)**。

---

### 工作空间布局 (Workspace Layout)

由进化循环管理的文件系统布局：

```
.collet/workspace/
├── prompts/
│   └── system.md          # 代理系统提示词 (突变目标)
├── skills/
│   ├── my-skill/
│   │   └── SKILL.md       # 现有技能 (突变目标)
│   └── _drafts/           # 正在进行的新技能
├── memory/
│   └── memories.jsonl     # 情节记忆
├── tools/
│   └── registry.yaml      # 工具元数据
└── evolution/
    ├── history.jsonl       # 周期历史
    └── batch_0001.jsonl    # 轨迹观察日志
```

工作空间在第一次运行时创建。它由 git 进行版本控制，因此每次突变都可以回滚。

---

### 示例进化输出

```
🧬 正在开始演化循环
   工作空间:   .collet/workspace
   工作目录:   /home/user/project
   周期数:     10
   基准测试:   swebench
   模型:       claude-opus-4-6

── Cycle 1/10 ─────────────────────────
  🔧 正在解决 3 个任务...
  📊 批量评分: 0.333
  🧠 [skillforge] 正在分析观察结果...
  ✅ 已突变：添加了错误处理技能，完善了调试提示词
  · 周期 1 完成 — 评分: 0.333

── Cycle 2/10 ─────────────────────────
  🔧 正在解决 3 个任务...
  📊 批量评分: 0.667
  🧠 [skillforge] 正在分析观察结果...
  ✅ 已突变：改进了系统提示词中的测试编写模式
  ✎ 周期 2 完成 — 评分: 0.667

...

🎯 在周期 7 收敛 — 最终评分: 0.847

✅ 演化完成
   周期数: 7
   最终评分: 0.847
   是否收敛: 是
   评分曲线: 1: 0.333 → 2: 0.667 → 3: 0.714 → 4: 0.762 → 5: 0.810 → 6: 0.833 → 7: 0.847
```

---

### 应用演化结果

演化完成后，为实时代理采用工作空间中改进的提示词/技能：

```bash
# 查看改进后的系统提示词
cat .collet/workspace/prompts/system.md

# 查看改进后的技能
ls .collet/workspace/skills/

# 通过 git 查看演化历史
git -C .collet/workspace log --oneline
# evo-7: 演化后快照 (评分: 0.847)
# evo-6: 演化后快照 (评分: 0.833)
# ...
```

---

### 突变控制

启用或禁用特定层的突变：

```bash
# 仅突变提示词 (技能/记忆固定)
collet evolve --no-evolve-skills --no-evolve-memory

# 仅突变技能
collet evolve --no-evolve-prompts --no-evolve-memory

# 包含工具 (实验性)
collet evolve --evolve-tools
```

---

## 插件系统 (Plugin System)

插件通过自定义命令、技能、代理、钩子和项目上下文来扩展 collet。它们存储在 `~/.collet/plugins/<name>/` 中。

### 插件结构

插件是一个带有清单 (manifest) 和可选组件的目录：

```text
my-plugin/
├── .collet-plugin/          ← collet 原生 (首选)
│   └── plugin.toml          (或 plugin.json)
├── .claude-plugin/           ← Claude Code 兼容 (回退)
│   └── plugin.json
├── hooks/hooks.json          — 生命周期钩子
├── commands/*.md             — 斜杠命令
├── skills/*/SKILL.md         — 自动发现的技能
├── agents/*.md               — 代理定义
├── COLLET.md                 — collet 上下文注入 (首选)
└── CLAUDE.md                 — Claude Code 上下文 (回退)
```

### 清单格式 (按优先级排序)

1. `.collet-plugin/plugin.toml` — collet 原生 (TOML)
2. `.collet-plugin/plugin.json` — collet 原生 (JSON)
3. `.claude-plugin/plugin.json` — Claude Code 兼容 (回退)

#### plugin.toml (collet 原生)

```toml
[plugin]
name = "my-plugin"
version = "1.0.0"
description = "一个很棒的插件"
homepage = "https://github.com/example/my-plugin"
license = "MIT"
keywords = ["tdd", "testing"]

[plugin.author]
name = "开发者"
url = "https://github.com/example"
```

#### plugin.json (collet 原生 / Claude Code 兼容)

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "一个很棒的插件",
  "author": { "name": "开发者", "url": "https://github.com/example" },
  "license": "MIT",
  "keywords": ["tdd", "testing"]
}
```

### 安装插件

```bash
# 直接从 GitHub 仓库安装
collet plugin install owner/repo

# 从已注册的市场安装
collet plugin install epic@plugins
```

在 TUI 内部，使用 `/plugin install` 斜杠命令。

### 市场 (Marketplace)

市场是一个包含 `marketplace.json` 的 GitHub 仓库，其中列出了可用的插件。

```bash
# 注册一个市场
collet plugin marketplace add epicsagas/plugins

# 列出已注册的市场
collet plugin marketplace list

# 移除一个市场
collet plugin marketplace remove plugins
```

#### marketplace.json 格式

放置在 `.collet-plugin/marketplace.json` (或 `.claude-plugin/marketplace.json`) 中：

```json
{
  "owner": { "name": "epicsagas", "url": "https://github.com/epicsagas" },
  "plugins": [
    { "name": "epic", "source": "./", "description": "Epic harness" },
    { "name": "my-tool", "source": "otherorg/my-tool-repo", "description": "A tool" }
  ]
}
```

### 钩子事件 (Hook Events)

插件可以通过 `hooks/hooks.json` 将脚本附加到生命周期事件：

| 事件 | 时机 | 用途 |
|-------|--------|-----|
| `SessionStart` | 代理会话开始时 | 初始化、上下文设置 |
| `PreToolUse` | 工具执行前 | 门控、阻止危险命令 |
| `PostToolUse` | 工具执行后 | 观察、日志记录 |
| `PreCompact` | 上下文压缩前 | 保留重要数据 |
| `Stop` | 代理循环结束时 | 通知、最终验证 |
| `SessionEnd` | 会话销毁时 | 清理、生成报告 |
| `SubagentStart` | 派生子代理时 | 监控、跟踪 |
| `SubagentStop` | 子代理完成后 | 结果收集 |

#### hooks.json 示例

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "*", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/init.sh" }] }
    ],
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/guard.sh" }] }
    ],
    "PostToolUse": [
      { "matcher": "file_edit|file_write|git_patch", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/observe.sh", "async": true, "timeout": 5 }] }
    ],
    "Stop": [
      { "matcher": "*", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/notify.sh", "async": true }] }
    ]
  }
}
```

**匹配器 (Matcher) 语法**：`"*"` 匹配所有工具。`"Bash"` 匹配单个工具。`"file_edit|file_write"` 匹配任何以管道符分隔的名称。

**阻止 (Blocking)**：退出码为 `2` 的 `PreToolUse` 钩子将阻止工具执行。

**环境变量**：`${COLLET_PLUGIN_ROOT}` 解析为插件的安装目录。为了向后兼容，也会设置 `${CLAUDE_PLUGIN_ROOT}`。

### 插件命令

```bash
collet plugin install <owner/repo | name@marketplace>  安装插件
collet plugin list                                      列出已安装的插件
collet plugin remove <name>                             移除插件
collet plugin marketplace add <owner/repo> [name]       注册市场
collet plugin marketplace list                          列出市场
collet plugin marketplace remove <name>                 注销市场
```
