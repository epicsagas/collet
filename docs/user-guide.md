# Collet User Guide

<p align="center">
  <a href="../i18n/KR/user-guide.md">🇰🇷 한국어</a> |
  <a href="../i18n/CN/user-guide.md">🇨🇳 简体中文</a> |
  <a href="../i18n/JP/user-guide.md">🇯🇵 日本語</a> |
  <a href="../i18n/DE/user-guide.md">🇩🇪 Deutsch</a> |
  <a href="../i18n/FR/user-guide.md">🇫🇷 Français</a> |
  <a href="../i18n/ES/user-guide.md">🇪🇸 Español</a> |
  <a href="../i18n/BR/user-guide.md">🇧🇷 Português</a> |
  <a href="../i18n/RU/user-guide.md">🇷🇺 Русский</a> |
  <a href="../i18n/IN/user-guide.md">🇮🇳 हिन्दी</a> |
  <a href="../i18n/AE/user-guide.md">🇦🇪 العربية</a>
</p>

Complete user manual for collet — the relentless agentic coding orchestrator.

---

## Table of Contents

1. [CLI Reference](#cli-reference)
2. [TUI Usage](#tui-usage)
3. [Multi-Provider Configuration](#multi-provider-configuration)
4. [MCP Servers](#mcp-servers)
5. [Code Intelligence](#code-intelligence)
6. [Multi-Agent Collaboration](#multi-agent-collaboration)
7. [Web Interface](#web-interface)
8. [Remote Gateway (Telegram / Slack / Discord)](#remote-gateway-telegram--slack--discord)
9. [Skills System](#skills-system)
10. [Soul.md — Agent Personality](#soulmd--agent-personality)
11. [Session Management](#session-management)
12. [Environment Variables](#environment-variables)
13. [Configuration Reference](#configuration-reference)
14. [File Storage Paths](#file-storage-paths)
15. [Privacy & Telemetry](#privacy--telemetry)
16. [Evolution Engine](#evolution-engine)
17. [Plugin System](#plugin-system)

---

## CLI Reference

### Basic Commands

```bash
collet                              # Interactive TUI
collet "fix the bug in main.rs"     # Headless (runs then exits)
collet --continue                   # Restore last incomplete session
collet --resume                     # Select from session list
collet --model glm-5                # Override model
```

### Subcommands

```bash
collet setup                        # Create config file (register multiple providers)
collet secure                       # Encrypt and store API key
collet unsecure                     # Remove encrypted credentials
collet status                       # Check current configuration
collet update                       # Check for latest version
collet --version                    # Display version
collet help | -h | --help           # Help
```

### Provider Management

```bash
collet provider add                 # Add a provider (recommended model selection UI)
collet provider add openai          # Add a specific provider directly
collet provider list                # List registered providers
collet provider use <name>          # Switch active provider
```

Supported providers: Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, Custom

> Ollama and LM Studio are local servers and do not require an API key.

### MCP Management

```bash
collet mcp                          # Check MCP server configuration
collet mcp add <name> -c <cmd>      # Add an MCP server
collet mcp remove <name>            # Remove an MCP server
```

### CLI Flags

| Flag | Short | Description |
|------|-------|-------------|
| `--dir <path>` | `-d` | Specify working directory (project path) |
| `--continue` | `-c` | Auto-resume last incomplete session |
| `--resume` | `-r` | Select from session list popup |
| `--resume <id>` | `-r <id>` | Resume specific session by ID |
| `--model <name>` | | Override model |
| `--yolo` | | Auto-commit, skip confirmations |
| `--watch` | | Rerun on file changes |
| `--ext <exts>` | | Watch target extensions (comma-separated) |
| `--debounce <ms>` | | Watch debounce (default: 2000) |
| `--cwd <path>` | | Watch directory (default: current location) |
| `--agent <name>` | `-a` | Use custom agent |
| `--fast` | `-f` | Fast mode: no sidebar, no swarm, no soul reflection |

### Headless Mode

```bash
collet "fix the login bug"                    # Run in current directory
collet "fix the login bug" -d ~/projects/api  # Run in different project
collet "lint this" --yolo                     # Auto-commit, skip confirmations
collet "lint this" --fast                    # Fast mode: minimal overhead
```

### Watch Mode (File Change Detection)

```bash
# Basic usage
collet "lint this" --watch --ext rs,toml --debounce 500

# Watch only specific directory
collet "run tests" --watch --cwd ./src --ext rs

# Use custom agent
collet "review changes" --watch --agent reviewer --ext ts,tsx
```

Automatically reruns when files change.

**Use Cases:**

| Scenario | Command |
|----------|---------|
| Watch specific subdirectory | `--watch --cwd ./packages/core` |
| Detect config file changes | `--watch --cwd ./config --ext yaml,toml` |
| Auto-fix CI scripts | `--watch --cwd .github --ext yml` |
| Auto-format documentation | `--watch --cwd ./docs --ext md` |
| Fast linting with lightweight model | `--watch --agent fast --ext ts` |

---

## TUI Usage

### Key Bindings

**Navigation**

| Key | Action |
|-----|--------|
| `Enter` | Send message |
| `Shift+Enter` / `Ctrl+J` | New line (multi-line input) |
| `↑` / `↓` | Multi-line: move between lines / Single-line: navigate history |
| `Shift+↑/↓` | Scroll output |
| `PgUp` / `PgDn` | Fast scroll |
| `Tab` / `Shift+Tab` | Switch agent forward / backward |
| `Ctrl+C` | Running: cancel task / Idle: press twice to exit |
| `Esc` | Running: cancel (press twice) / Close popup |

**Text Editing**

| Key | Action |
|-----|--------|
| `Ctrl+A` / `Cmd+←` | Move to line start |
| `Ctrl+E` / `Cmd+→` | Move to line end |
| `Ctrl+←` / `Ctrl+→` | Move word left / right |
| `Alt+←` / `Alt+→` / `Alt+B` / `Alt+F` | Move word left / right (macOS Option+Arrow) |
| `Backspace` | Delete character before cursor |
| `Delete` | Delete character after cursor |
| `Ctrl+W` / `Alt+Backspace` | Delete word before cursor |
| `Ctrl+Backspace` | Delete word before cursor (Linux / Windows) |
| `Cmd+Backspace` | Delete to line start (macOS, Kitty-protocol terminals) |
| `Ctrl+U` | Delete to line start (all platforms) |
| `Ctrl+K` | Delete to line end |

### Built-in Agents

Collet ships four built-in agents. Switch between them with `Tab` / `Shift+Tab`.

| Agent | Role |
|-------|------|
| **Arbor** (default) | Fully autonomous orchestrator — decides single-agent vs swarm mode automatically per task. No popup, no configuration required. |
| **Architect** | Design and planning agent. Produces a structured plan, then offers `/proceed` → Code or `/save-plan` to save. |
| **Code** | Default coding agent for implementation tasks. |
| **Ask** | Conversational / question-answering agent without tool access. |

> **Tip**: When Arbor is active, your task is automatically routed to the optimal execution mode (Fork / Hive / Flock / single-agent). For other agents, your selection is always honoured as the primary agent.

### Slash Commands

| Command | Description |
|---------|-------------|
| `/help` | Help |
| `/clear` | Reset conversation |
| `/compact` | Manual context compaction |
| `/cost` | Token usage statistics |
| `/diff` | Git changes |
| `/sdiff` | Side-by-side diff |
| `/undo` | Revert last commit |
| `/models [name]` | Open model picker or switch model directly (switches full provider context) |
| `Tab` / `Shift+Tab` | Switch agent (cycles through configured agents) |
| `/search <query>` | BM25 relevance search |
| `/rewind [id]` | Revert to a checkpoint |
| `/checkpoints` | List checkpoints |
| `/web <url>` | Fetch URL content |
| `/resume` | Recent sessions popup — sorted by latest, select to restore |
| `/theme [name]` | Change color theme (6 options: default, dracula, catppuccin-mocha, tokyo-night, nord, gruvbox) |
| `/save-plan` | Save Architect mode plan to a file |
| `/proceed` | Approve Architect plan and switch to Code mode |
| `/cancel-plan` | Discard Architect plan |
| `/fork` | Parallel agent branching |
| `/hive` | Consensus-based collaboration |
| `/flock` | Real-time multi-agent |
| `/mcp` | Manage MCP servers (space: on/off, a: add, d: remove) |
| `/skills` | List skills |
| `/agents` | View active sub-agents |
| `/optimize` | Optimize context |
| `/bench` | Performance dashboard |
| `/debug` | Toggle debug overlay |
| `/telemetry` | Check telemetry status and collected items |
| `/quit` | Quit |

> **Autocomplete**: Type `/` to open the command popup. Both built-in commands and discovered **skills** appear in the same list, ranked by fuzzy match score. Press `↑`/`↓` to navigate, `Tab` to expand with argument hint, `Enter` to confirm.

### Shell Passthrough

Prefix any shell command with `!` to run it directly in the working directory without leaving the TUI:

```
! git log --oneline -5
! cargo test
! ls src/
```

The exit code, stdout, and stderr are displayed as a fenced code block in the chat. Useful for quick checks without switching terminals.

### @ Mentions

| Pattern | Action |
|---------|--------|
| `@src/main.rs` | Attach file content to context |
| `@src` | Attach folder tree structure (3 levels, 200 items) |
| `@Makefile` | Auto-detect file/folder relative to cwd |
| `@glm-5` | Switch agent to the specified model |

> **Autocomplete**: Type `@` to open the mention popup. Agent names use **fuzzy matching** — subsequence scoring with word-boundary and consecutive-match bonuses. File/folder names use prefix matching with subdirectory navigation (`@src/` lists `src/` contents).

### Agent Tools

| Tool | Description |
|------|-------------|
| `bash` | Execute shell commands (with timeout protection) |
| `file_read` | Read file with line numbers |
| `file_write` | Create/overwrite a file |
| `file_edit` | Precise string replacement (Surgical Edit) |
| `git_patch` | Apply hunk-based patches |
| `search` | ripgrep-based code search |
| `skill` | Load Agent Skill (3-tier progressive) |
| `subagent` | Execute subtask in an isolated context |

### TUI Layout

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

## Multi-Provider Configuration

Multiple LLM providers can be registered and switched in real time using the `/models` command.

### Registering Providers

```bash
collet provider add          # Interactive wizard (select from recommended model list)
collet provider add openai   # Add a specific provider directly
```

### config.toml Example

```toml
[api]
provider = "openai"

# providers = credentials only (model behavior is configured in [[models]] and [[agents.list]])
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

### Hierarchical Configuration (Global < Model < Agent)

Configuration priority: `env/[agent]` → `[[models]]` → `[[agents.list]]`

```toml
# Per-model default overrides
[[models]]
name = "gpt-4o"
context_window = 128000
max_output_tokens = 16384
supports_tools = true

[[models]]
name = "qwen2.5-coder"
supports_tools = false
reasoning_effort = "medium"     # low | medium | high

# Per-agent overrides (highest priority)
[[agents.list]]
name = "code"
model = "gpt-4o"
provider = "openai"              # Provider also switches when toggling via Tab/Shift+Tab
temperature = 0.2

[[agents.list]]
name = "architect"
model = "gpt-4o"
provider = "openai"
temperature = 0.7
thinking_budget_tokens = 8192    # Takes precedence over reasoning_effort

[[agents.list]]
name = "local"
model = "qwen2.5-coder"
provider = "ollama"              # Switch to local provider
```

Omitting the `provider` field keeps the currently active provider and changes only the model.

### Override Fields

Default model profile values can be overridden in `[[models]]` and `[[agents.list]]`:

| Field | Type | Description |
|-------|------|-------------|
| `temperature` | `f32` | Sampling temperature (automatically omitted for reasoning models) |
| `thinking_budget_tokens` | `u32` | Reasoning token budget (takes precedence over reasoning_effort) |
| `reasoning_effort` | `string` | Reasoning intensity: `"low"`, `"medium"`, `"high"` |
| `supports_tools` | `bool` | Whether tool calling is supported |
| `supports_reasoning` | `bool` | Whether reasoning/thinking tokens are supported |
| `context_window` | `usize` | Context window size |
| `max_output_tokens` | `u32` | Maximum output tokens |
| `max_iterations` | `u32` | Maximum agent iterations |

All fields are optional; when omitted, values are determined automatically from the built-in model profile.

### Runtime Switching

In the TUI, use the `/models` command to open the registered provider/model picker. Selecting an entry switches the base_url, api_key, and tool support settings all at once.

```
/models              # Open provider/model picker popup
/models gpt-4o       # Switch model directly
```

---

## MCP Servers

Connect [Model Context Protocol](https://modelcontextprotocol.io) servers to extend agent tools.

### Adding Servers

```bash
# From npm package
/mcp add npm:@anthropic/mcp-server-filesystem

# Local binary
/mcp add local:/path/to/server --name myserver

# HTTP endpoint
/mcp add http:https://api.example.com/mcp

# Add globally (all projects)
/mcp add npm:@some/tool --global
```

### Managing Servers

```bash
/mcp enable myserver
/mcp disable myserver
/mcp remove myserver
```

Server status can be checked in the sidebar (`/mcp` command for interactive toggle — space: on/off, a: add, d: remove).

### Configuration File

`.collet/mcp.json` (project) or `~/.collet/mcp.json` (global):

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

**Supported formats:**
- `command`: string or array (`["npx", "-y", "pkg"]` → automatically split)
- `env` / `environment`: environment variables (`${VAR}` automatically substituted)
- `headers`: HTTP authentication headers
- `type`, `enabled`: compatibility fields (ignored)

---

## Code Intelligence

Works automatically without additional setup.

1. **Indexing** — On startup, Tree-sitter parses source and extracts symbols (functions, types, constants). Only changed files are reprocessed using BLAKE3 hashing.
2. **Auto-injection** — Analyzes user messages; for code-related questions, finds relevant files using BM25 and automatically injects them into context.
3. **Reduce grep** — Informs the agent that the codebase is pre-indexed, reducing unnecessary `grep`/`find` calls.

Supported languages: Rust, Python, TypeScript, JavaScript, Go, Java, C/C++, Ruby, PHP, Swift, Kotlin, and 35+ more. Auto-detection of LSP servers enables hover, go-to-definition, and find-references.

Manual search: Run BM25 search directly in TUI with `/search <query>`.

---

## Multi-Agent Collaboration

Hierarchy: **Fork** < **Hive** < **Flock** (higher tiers include lower features)

| Mode | How It Works | Best For |
|------|-------------|----------|
| Fork | Coordinator splits work → parallel execution → merge results | Independent sub-tasks |
| Hive | Consensus voting between agents, coordinator oversight | Complex decision-making |
| Flock | Real-time agent-to-agent messaging (experimental) | Tightly coupled collaboration |

### Configuration

In `config.toml`:

```toml
[collaboration]
mode = "hive"           # none | fork | hive | flock
max_agents = 3
strategy = "auto_split" # auto_split | role_based | plan_review_execute
```

Or switch per-session in TUI using `/fork`, `/hive`, `/flock`.

---

## Web Interface

Use collet in your browser. SvelteKit frontend + Axum backend.

### Build and Run

```bash
# Build (requires web feature flag)
cargo build --release --features web

# Run
collet web                    # http://127.0.0.1:3080
collet web -p 8080            # Change port
collet web --host 0.0.0.0     # Allow external access
collet web --password secret  # Enable authentication
```

### CLI Options

| Option | Default | Environment | Description |
|--------|---------|-------------|-------------|
| `--host, -h` | `127.0.0.1` | `COLLET_WEB_HOST` | Bind address |
| `--port, -p` | `3080` | `COLLET_WEB_PORT` | Bind port |
| `--username, -u` | `collet` | `COLLET_WEB_USERNAME` | Login username |
| `--password` | *(none)* | `COLLET_WEB_PASSWORD` | Authentication password |
| `--cors` | *(none)* | `COLLET_WEB_CORS` | CORS allowed origins (comma-separated) |

Can also be configured via `config.toml`:

```toml
[web]
host = "0.0.0.0"
port = 3080
username = "collet"
cors_origins = "http://localhost:5173"
# password is encrypted and saved via collet secure --web
```

### Authentication

When `--password` is set, token-based authentication is enabled:

```
1. POST /api/auth/login  →  {"username": "collet", "password": "secret"}
2. Response: {"token": "abc123..."}
3. Subsequent requests: Authorization: Bearer abc123...
4. SSE connection: GET /api/events?token=abc123...
```

Without password set, access is available without authentication. `/api/health` and `/api/auth/status` are always public.

### API Endpoints

**Basic:**

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/api/message` | Send message to agent `{"message": "...", "mode": "code"}` |
| `GET` | `/api/events` | SSE stream (real-time agent events) |
| `GET` | `/api/health` | Status, version, agent activity |
| `GET` | `/api/config` | Current model, context info |

**Sessions:**

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/sessions` | Session list |
| `GET` | `/api/sessions/{id}` | Session details + conversation snapshot |
| `DELETE` | `/api/sessions/{id}` | Delete session |

**Files and Projects:**

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/files?path=src` | Directory listing |
| `GET` | `/api/files/src/main.rs` | Read file contents |
| `GET` | `/api/projects` | Project list |
| `POST` | `/api/projects/switch` | Change working directory |
| `GET` | `/api/search?q=pattern&glob=*.rs` | Code search |
| `GET` | `/api/symbols` | RepoMap symbol info |
| `GET` | `/api/tools` | Available tools list |

### SSE Events

Connect to `/api/events` to receive real-time agent activity:

| Event | Data | Description |
|-------|------|-------------|
| `token` | `{"text": "..."}` | Streaming token |
| `response` | `{"text": "..."}` | Complete response |
| `tool_call` | `{"name": "bash", "args": "..."}` | Tool call started |
| `tool_result` | `{"name": "bash", "result": "...", "success": true}` | Tool execution result |
| `file_modified` | `{"path": "src/main.rs"}` | File change notification |
| `status` | `{"iteration", "prompt_tokens", ...}` | Token/timing metrics |
| `error` | `{"message": "..."}` | Error |
| `done` | `{}` | Agent task complete |

Hive/Flock mode events: `hive_agent_started`, `hive_agent_progress`, `hive_agent_done`, `hive_conflict`, `hive_done`

### Usage Example: curl

```bash
# Check status
curl http://localhost:3080/api/health

# Send message (no authentication)
curl -X POST http://localhost:3080/api/message \
  -H "Content-Type: application/json" \
  -d '{"message": "fix the login bug", "mode": "code"}'

# Receive SSE stream
curl -N http://localhost:3080/api/events

# With authentication
TOKEN=$(curl -s -X POST http://localhost:3080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"collet","password":"secret"}' | jq -r .token)

curl -H "Authorization: Bearer $TOKEN" http://localhost:3080/api/sessions
```

---

## Remote Gateway (Telegram / Slack / Discord)

Use collet from chat platforms. Map channels to project directories to issue remote coding tasks.

### CLI Management

```bash
collet remote add [platform]   # Add adapter (interactive)
collet remote rm <platform>    # Remove adapter
collet remote ls               # List + status
collet remote start            # Start as background daemon
collet remote start --fg       # Foreground execution (debug)
collet remote stop             # Stop daemon
collet remote restart          # Restart daemon
collet remote enable           # Register for auto-start (launchd/systemd)
collet remote disable          # Disable auto-start
collet remote logs [-f]        # View logs (-f: real-time)
collet remote status           # Current status
```

Just run `collet remote add` to interactively choose between Telegram/Slack/Discord and set token, allowed users, etc. Tokens are encrypted with AES-256-GCM.

### Manual Configuration

**Telegram:**

```toml
[telegram]
token = "123456:ABC-DEF..."        # Issued by @BotFather
allowed_users = [12345, 67890]     # Telegram user ID (numeric)
```

Environment variable: `COLLET_TELEGRAM_TOKEN`

**Slack:**

```toml
[slack]
bot_token = "xoxb-..."            # Bot User OAuth Token
app_token = "xapp-..."            # Socket Mode App Token
allowed_users = ["U_ALICE"]       # Slack user ID (string)
```

Environment variables: `COLLET_SLACK_BOT_TOKEN`, `COLLET_SLACK_APP_TOKEN`

**Discord:**

```toml
[discord]
token = "MTk..."                   # Bot Token
allowed_users = [111222333]        # Discord user ID (numeric)
guild_ids = [999888777]            # Allowed servers (optional)
```

Environment variable: `COLLET_DISCORD_TOKEN`

### Common Settings

```toml
[remote]
enabled = true
session_timeout = 300              # Idle session timeout (seconds)
default_streaming = "compact"      # compact | full
default_workspace = "project"      # project | workspace | full
```

### Channel-Project Mapping

Connect specific chat channels to project directories. Messages from mapped channels execute in that project.

```toml
[[channel_map]]
platform = "telegram"
channel = "-100123456"             # Telegram chat/group ID
project = "/home/user/backend"
name = "backend"
agent = "code"                     # optional: auto-assign agent

[[channel_map]]
platform = "discord"
channel = "999888777666"           # Discord channel ID
project = "/home/user/frontend"
name = "frontend"
agent = "architect"                # optional: planning-focused agent

[[channel_map]]
platform = "slack"
channel = "C01ABCDEF"             # Slack channel ID
project = "/home/user/api"
name = "api"
# agent omitted = use default model
```

The optional `agent` field auto-assigns an agent when the session starts. The agent's model is applied automatically.

Unmapped channels use `/new <path>` command to specify project folder directly.

### Chat Commands

Dedicated commands for chat platforms (separate from TUI slash commands):

**Project/Session:**

| Command | Alias | Description |
|---------|-------|-------------|
| `/projects` | `/p` | Project list (mapped + history) |
| `/sessions` | `/s` | Session list (current + all) |
| `/resume [id]` | `/r` | Resume session |
| `/new [path]` | `/n` | Start new session (specify project folder) |
| `/status` | | Current session info |

**Model/Agent:**

| Command | Alias | Description |
|---------|-------|-------------|
| `/models [name]` | `/m` | Model list / switch |
| `/agents [name]` | | Agent list / switch |

**Control:**

| Command | Alias | Description |
|---------|-------|-------------|
| `/cancel` | `/stop` | Cancel running agent |
| `/approve` | `/y`, `/yes` | Approve execution plan |
| `/reject` | `/no` | Reject execution plan |
| `/stream [level]` | | Change streaming level |
| `/workspace [scope]` | | Change workspace scope |
| `/pty [command]` | | Shell session (run command) |
| `/pty-end` | | End shell session |
| `/help` | `/h` | Help |

Type text without slash to send message to agent.

### Streaming Levels

Change with `/stream` command or `default_streaming` config.

- **compact** (default) — Send only final response. Minimize notifications.
- **full** — Stream tokens, tool calls/results, status updates in real-time.

### Workspace Scope

Change with `/workspace` command or `default_workspace` config.

- **project** (default) — Agent can only access project directory.
- **workspace** — Can access parent directory.
- **full** — No filesystem restrictions.

### Security

- If `allowed_users` is empty, **all users are denied** (whitelist model).
- Messages from unauthorized users are ignored and logged as warnings.
- API tokens can be placed directly in `config.toml` or use environment variables. Recommend using `collet secure` for encryption.

### Usage Example

```
# From Telegram:
User: /new /home/user/backend
Bot:     Switched to project: backend (/home/user/backend)

User: Add rate limiting to login API
Bot:     [Agent analyzes and modifies code]
Bot:     Added rate limiter middleware to src/auth/routes.rs...

User: /pty cargo test
Bot:     running 15 tests... test result: ok. 15 passed

User: /approve
Bot:     Changes committed.
```

---

## Skills System

Provide specialized knowledge to agents via markdown files with YAML frontmatter.

**File locations:**
- Project: `.collet/skills/`
- Global: `~/.config/collet/skills/`

View list in TUI with `/skills`. Agents automatically discover relevant skills based on task context.

---

## Soul.md — Agent Personality

After each task completes, the agent reflects on the session and progressively records its personality in `~/.collet/agents/souls/{name}.md`. All sections are **written by the agent itself** — no user editing required.

### Soul Structure

```markdown
## Identity    — Who I am, values, working style
## Voice       — Communication style, tone, expression patterns
## Inner World — Emotions, thoughts, and opinions from this session
## Growth      — Patterns learned, mistakes made, insights gained
```

Each section receives new entries appended each session. When the limit is exceeded, older entries are compressed into a single-line `(earlier) ...` summary (retaining 8 Identity, 6 Voice, 10 Inner World, and 5 Growth entries).

> **Cost note**: Soul reflection adds **one additional LLM API call** per task completion (input: session summary + existing soul content, output: max 512 tokens). Longer soul files will increase input token usage.

### Disabling

```toml
# config.toml — disable entirely
[soul]
enabled = false

# Disable for a specific agent (~/.collet/agents/<name>.md frontmatter)
---
soul: false
---
```

### File Locations

- Per-agent: `~/.collet/agents/souls/{name}.md`
- Global (coordinator and unconfigured agents): `~/.collet/SOUL.md`

---

## Session Management

### Restoring Sessions

```bash
collet --continue                   # Auto-resume last incomplete session
collet --resume                     # Select from session list popup
collet --resume <id>                # Resume specific session by ID
```

### Checkpoints

| Command | Description |
|---------|-------------|
| `/checkpoints` | List checkpoints |
| `/rewind [id]` | Revert to a checkpoint |

### Plan Review (Architect Mode)

| Command | Description |
|---------|-------------|
| `/save-plan` | Save Architect mode plan to a file |
| `/proceed` | Approve plan and switch to Code mode |
| `/cancel-plan` | Discard plan |

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `COLLET_MODEL` | `glm-4.7` | Model to use (when no provider is registered) |
| `COLLET_MAX_TOKENS` | `8192` | Maximum response tokens |
| `COLLET_TOOL_TIMEOUT` | `120` | Tool call timeout (seconds) |
| `COLLET_MAX_ITERATIONS` | `50` | Maximum loop iterations per message |
| `COLLET_CIRCUIT_BREAKER` | `3` | Number of consecutive failures before tripping |
| `COLLET_AUTO_ROUTE` | `0` | Set to `1` to enable task-complexity-based model auto-routing |
| `COLLET_THEME` | `default` | TUI color theme (`dracula`, `catppuccin-mocha`, `tokyo-night`, `nord`, `gruvbox`) |
| `COLLET_TELEMETRY` | *(none)* | Set to `0` to disable telemetry |
| `COLLET_TELEGRAM_TOKEN` | *(none)* | Telegram bot token |
| `COLLET_SLACK_BOT_TOKEN` | *(none)* | Slack bot token |
| `COLLET_SLACK_APP_TOKEN` | *(none)* | Slack app token |
| `COLLET_DISCORD_TOKEN` | *(none)* | Discord bot token |
| `COLLET_WEB_HOST` | `127.0.0.1` | Web server bind address |
| `COLLET_WEB_PORT` | `3080` | Web server port |
| `COLLET_WEB_USERNAME` | `collet` | Web login username |
| `COLLET_WEB_PASSWORD` | *(none)* | Web authentication password |
| `COLLET_WEB_CORS` | *(none)* | CORS origins (comma-separated) |

> **Note**: API keys and endpoints are registered via `collet provider add` or configured under `[[providers]]` in `config.toml`.
> Legacy environment variables (`ZAI_API_KEY`, `ZAI_BASE_URL`) are also recognized as a fallback when no provider is registered.

---

## Configuration Reference

Full `config.toml` structure:

```toml
# ── LLM Provider ──
[api]
provider = "OpenAI"                # Active provider name
model = "gpt-4o"                   # Default model

[[providers]]
name = "OpenAI"
base_url = "https://api.openai.com/v1"
model = "gpt-4o"
context_window = 128000
# API key: encrypted and saved via collet secure

# ── Context ──
[context]
max_tokens = 200000
compaction_threshold = 0.8         # Auto-compress above this ratio

# ── Agent ──
[agent]
auto_optimize = true               # Auto optimize context

# ── UI ──
[ui]
theme = "dracula"
# Themes: default, dark, light, minimal, dracula,
#         catppuccin-mocha, tokyo-night, nord, gruvbox

# ── Security ──
[security]
pii_filter = true                  # PII filter (default: enabled)

# ── Collaboration ──
[collaboration]
mode = "none"                      # none | fork | hive | flock
max_agents = 3
strategy = "auto_split"            # auto_split | role_based | plan_review_execute

# ── Web Interface ──
[web]
host = "127.0.0.1"
port = 3080
username = "collet"
# password: set via collet secure --web

# ── Soul.md Persistent Personality ──
[soul]
enabled = true
# Per-agent control: agent .md frontmatter soul: false

# ── Remote Gateway ──
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

# ── Channel Mapping ──
# [[channel_map]]
# platform = "telegram"
# channel = "-100123"
# project = "/path/to/project"
# name = "my-project"
# agent = "code"              # optional: auto-assign agent
```

> See [config.md](./config.md) for the complete reference with all fields and descriptions.

---

## File Storage Paths

All runtime files are stored in XDG-style paths regardless of OS.

```
~/.config/collet/
  ├── config.toml              # Main configuration
  └── skills/                  # Global skills

~/.collet/
  ├── mcp.json                 # Global MCP servers
  ├── logs/collet.log          # Logs
  ├── machine_id               # Anonymous telemetry UUID
  ├── crash_report.json        # Crash reports (uploaded on next run)
  ├── SOUL.md                  # Global agent personality
  └── agents/souls/{name}.md   # Per-agent personality

~/.local/share/collet/
  └── projects/<hash>/
      └── sessions/            # Per-project session data

.collet/                        # Project root (inside git repo)
  ├── mcp.json                 # Project MCP servers
  ├── rules.md                 # Project rules (agent reference)
  └── skills/                  # Project skills
```

> On macOS, the above paths are used instead of `~/Library/Application Support`.
>
> Run `collet status` to see the actual paths in use.

---

## Privacy & Telemetry

Collet collects anonymous usage statistics and error reports to improve the product.

### Collected Data

| Event | Collected Information |
|-------|-----------------------|
| `session_start` | Model name, agent mode, version |
| `session_end` | Model name, mode, result (success/error/cancelled), iteration count, duration |
| `feature_used` | Features used (MCP server, LSP, etc.) |
| `command_used` | Slash commands executed |

**Data NOT collected:**
- Personally identifiable information (PII)
- Source code content
- File paths
- API keys or secrets

### Identifier

A random UUID stored in `~/.collet/machine_id` that identifies the installation without identifying any individual.

### Disabling

```bash
# Disable via environment variable
export COLLET_TELEMETRY=0

# Or in config.toml
[telemetry]
enabled = false
```

Granular control:

```toml
[telemetry]
enabled = true           # Master switch
analytics = false        # Disable usage statistics only
error_reporting = true   # Keep error/crash reporting
```

### Data Handling

- All transmissions are asynchronous with a 5-second timeout
- On crash, saved to `~/.collet/crash_report.json` and uploaded on next run
- No actual transmission occurs if the endpoint is a placeholder

---

## Evolution Engine

A self-improvement loop where the agent refines its own capabilities. It runs batches of tasks, analyzes results, and automatically mutates prompts, skills, and memory.

> **Difference from Soul.md**: Soul.md accumulates personality and style while you work. The Evolution Engine runs benchmark tasks in dedicated sessions and **measures scores to optimize capability**.

### Quick Start

```bash
# Simplest usage — natural-language task + automatic improvement
collet evolve "fix the login bug"

# In the TUI
/evolve fix the login bug
```

### How it works (7-step cycle)

```
1. Solve        — Agent processes a batch of tasks
2. Observe      — Collect results and scores as JSONL
3. Pre-Snapshot — git commit before mutation
4. Engine Step  — LLM analyzes observations and edits prompts/skills/memory
5. Post-Snapshot — git commit + tags after mutation (evo-1, evo-2, …)
6. Record       — Log cycle metrics
7. Reload       — Reload with the mutated workspace → next cycle
```

The loop exits automatically when the EGL (Evolutionary Generality Loss) score converges.

---

### Prerequisites

```bash
# Optional, when using SWE-bench
pip install swebench
```

No other setup is required.

---

### Natural-language mode (simplest)

Enter a task directly: the agent runs it, then automatically improves the workspace when done.

```bash
# TUI
/evolve fix the login bug

# CLI
collet evolve "fix the login bug"
```

You can combine natural language with options:

```bash
# Evolve the same task three times
/evolve fix the login bug --cycles 3
collet evolve "fix the login bug" --cycles 3

# Mutate prompts only (skills/memory fixed)
/evolve add input validation --no-evolve-skills --no-evolve-memory
```

| Input | Default cycles | Behavior |
|------|----------------|----------|
| `/evolve "task"` | 1 | Run work → one improvement |
| `/evolve "task" --cycles N` | N | Repeat the task N times while evolving |
| `/evolve --benchmark file --tasks f.jsonl` | 10 | Batch benchmark loop |

---

### CLI usage

#### Natural-language tasks (simplest)

```bash
# Run task + one improvement (default)
collet evolve "fix the login bug"

# Same task three times while evolving
collet evolve "write the tests" --cycles 3

# Mutate specific layers only
collet evolve "improve error handling" --no-evolve-skills
```

With a natural-language task, the default **cycles** is **1** (immediate work + improvement). Use `--cycles` to change how many times to repeat.

#### Benchmark loop (batch evaluation)

```bash
# Natural-language task (simplest)
collet evolve "fix the login bug"

# Natural language + repeats
collet evolve "fix the login bug" --cycles 3

# Default run (NullBenchmark — verify loop structure)
collet evolve

# File-based tasks
collet evolve --benchmark file --tasks path/to/tasks.jsonl

# File-based + external score command
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python score.py"

# SWE-bench
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl

# SWE-bench + Docker
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl --docker

# Full option set
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

### CLI flags

| Flag | Default | Description |
|--------|--------|-------------|
| `--benchmark <name>` | `null` | Benchmark adapter: `null` \| `file` \| `swebench` |
| `--tasks <path>` | — | Path to task JSONL (`file` / `swebench` required) |
| `--eval-dir <path>` | `.collet/eval` | SWE-bench evaluation scratch directory |
| `--docker` | false | Use SWE-bench harness in Docker mode |
| `--score-cmd <cmd>` | — | External scoring command (for `file` benchmark) |
| `--cycles <n>` | Natural language: `1`, batch: `10` | Maximum evolution cycles |
| `--batch <n>` | `5` | Tasks per cycle |
| `--model <name>` | from config | Override LLM for the evolution engine |
| `--workspace <path>` | `.collet/workspace` | Agent workspace root |
| `--dir <path>` | current directory | Agent working directory |
| `--no-evolve-prompts` | — | Disable prompt mutation |
| `--no-evolve-skills` | — | Disable skill mutation |
| `--no-evolve-memory` | — | Disable memory mutation |
| `--evolve-tools` | false | Enable tool mutation (experimental) |

---

### TUI slash command

Run the evolution loop in the background from the TUI:

```
# Natural language — work then auto-improve
/evolve fix the login bug

# Natural language + repeats
/evolve write the tests --cycles 3

# Benchmark loop
/evolve --benchmark file --tasks tasks.jsonl --cycles 10
```

Progress appears in the status bar and message area.

---

### Benchmark adapters

#### NullBenchmark (default)

Runs the loop structure only, with no tasks. Score is always 0.0. Use to sanity-check the pipeline.

```bash
collet evolve --cycles 3
```

#### FileBenchmark

Loads tasks from a local JSONL file.

**Task file format** (`tasks.jsonl`):

```json
{"id": "task-001", "input": "Fix the off-by-one error in binary search", "metadata": {}}
{"id": "task-002", "input": "Add input validation to the login function", "metadata": {}}
{"id": "task-003", "input": "Refactor duplicate code in auth module", "metadata": {}}
```

**Scoring options:**

1. Default heuristic — empty output → 0.0, short output → 0.2, otherwise 0.5 (quick smoke check)
2. External score command — run `score_cmd <task_id> <output_file>` and read a 0.0–1.0 float from stdout

```bash
# External score command example
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python eval/score.py"
```

```python
# Example eval/score.py
import sys
task_id = sys.argv[1]
output_file = sys.argv[2]
output = open(output_file).read()
# Scoring logic
score = 1.0 if "def " in output else 0.0
print(score)
```

#### SweBenchAdapter

Invokes the official SWE-bench harness via subprocess and scores by real test pass rate.

**Installation:**

```bash
pip install swebench
```

**Dataset preparation:**

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

**Run:**

```bash
collet evolve \
  --benchmark swebench \
  --tasks swe-bench-lite.jsonl \
  --eval-dir .collet/eval \
  --cycles 10 \
  --batch 3
```

**RESOLVED** when `FAIL_TO_PASS` tests pass after the agent’s patch is applied.

---

### Workspace layout

Filesystem layout managed by the evolution loop:

```
.collet/workspace/
├── prompts/
│   └── system.md          # Agent system prompt (mutation target)
├── skills/
│   ├── my-skill/
│   │   └── SKILL.md       # Existing skills (mutation target)
│   └── _drafts/           # New skills in progress
├── memory/
│   └── memories.jsonl     # Episodic memory
├── tools/
│   └── registry.yaml      # Tool metadata
└── evolution/
    ├── history.jsonl       # Cycle history
    └── batch_0001.jsonl    # Trajectory observation log
```

The workspace is created on first run. It is version-controlled with git, so every mutation can be rolled back.

---

### Example evolution output

```
🧬 Starting evolution loop
   Workspace:   .collet/workspace
   Working dir: /home/user/project
   Cycles:      10
   Benchmark:   swebench
   Model:       claude-opus-4-6

── Cycle 1/10 ─────────────────────────
  🔧 Solving 3 tasks...
  📊 Batch score: 0.333
  🧠 [skillforge] Analyzing observations...
  ✅ Mutated: Added error handling skill, refined debugging prompt
  · Cycle 1 done — score: 0.333

── Cycle 2/10 ─────────────────────────
  🔧 Solving 3 tasks...
  📊 Batch score: 0.667
  🧠 [skillforge] Analyzing observations...
  ✅ Mutated: Improved test writing pattern in system prompt
  ✎ Cycle 2 done — score: 0.667

...

🎯 Converged at cycle 7 — final score: 0.847

✅ Evolution complete
   Cycles: 7
   Final score: 0.847
   Converged: yes
   Score curve: 1: 0.333 → 2: 0.667 → 3: 0.714 → 4: 0.762 → 5: 0.810 → 6: 0.833 → 7: 0.847
```

---

### Applying evolution results

After evolution, adopt improved prompts/skills from the workspace for the live agent:

```bash
# Review improved system prompt
cat .collet/workspace/prompts/system.md

# Review improved skills
ls .collet/workspace/skills/

# Evolution history via git
git -C .collet/workspace log --oneline
# evo-7: post-evolution snapshot (score: 0.847)
# evo-6: post-evolution snapshot (score: 0.833)
# ...
```

---

### Mutation control

Enable or disable mutation for specific layers:

```bash
# Evolve prompts only (skills/memory fixed)
collet evolve --no-evolve-skills --no-evolve-memory

# Evolve skills only
collet evolve --no-evolve-prompts --no-evolve-memory

# Include tools (experimental)
collet evolve --evolve-tools
```

---

## Plugin System

Plugins extend collet with custom commands, skills, agents, hooks, and project context. They are stored in `~/.collet/plugins/<name>/`.

### Plugin Structure

A plugin is a directory with a manifest and optional components:

```text
my-plugin/
├── .collet-plugin/          ← collet native (preferred)
│   └── plugin.toml          (or plugin.json)
├── .claude-plugin/           ← Claude Code compat (fallback)
│   └── plugin.json
├── hooks/hooks.json          — lifecycle hooks
├── commands/*.md             — slash commands
├── skills/*/SKILL.md         — auto-discovered skills
├── agents/*.md               — agent definitions
├── COLLET.md                 — collet context injection (preferred)
└── CLAUDE.md                 — Claude Code context (fallback)
```

### Manifest Formats (Priority Order)

1. `.collet-plugin/plugin.toml` — collet native (TOML)
2. `.collet-plugin/plugin.json` — collet native (JSON)
3. `.claude-plugin/plugin.json` — Claude Code compatible (fallback)

#### plugin.toml (collet native)

```toml
[plugin]
name = "my-plugin"
version = "1.0.0"
description = "A great plugin"
homepage = "https://github.com/example/my-plugin"
license = "MIT"
keywords = ["tdd", "testing"]

[plugin.author]
name = "Developer"
url = "https://github.com/example"
```

#### plugin.json (collet native / Claude Code compat)

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "A great plugin",
  "author": { "name": "Developer", "url": "https://github.com/example" },
  "license": "MIT",
  "keywords": ["tdd", "testing"]
}
```

### Installing Plugins

```bash
# Install directly from a GitHub repo
collet plugin install owner/repo

# Install from a registered marketplace
collet plugin install epic@plugins
```

Inside the TUI, use the `/plugin install` slash command.

### Marketplace

A marketplace is a GitHub repo containing a `marketplace.json` that lists available plugins.

```bash
# Register a marketplace
collet plugin marketplace add epicsagas/plugins

# List registered marketplaces
collet plugin marketplace list

# Remove a marketplace
collet plugin marketplace remove plugins
```

#### marketplace.json format

Place in `.collet-plugin/marketplace.json` (or `.claude-plugin/marketplace.json`):

```json
{
  "owner": { "name": "epicsagas", "url": "https://github.com/epicsagas" },
  "plugins": [
    { "name": "epic", "source": "./", "description": "Epic harness" },
    { "name": "my-tool", "source": "otherorg/my-tool-repo", "description": "A tool" }
  ]
}
```

### Hook Events

Plugins can attach scripts to lifecycle events via `hooks/hooks.json`:

| Event | Timing | Use |
|-------|--------|-----|
| `SessionStart` | Agent session starts | Initialization, context setup |
| `PreToolUse` | Before tool execution | Guard, block dangerous commands |
| `PostToolUse` | After tool execution | Observation, logging |
| `PreCompact` | Before context compaction | Preserve important data |
| `Stop` | Agent loop ending | Notifications, final validation |
| `SessionEnd` | Session teardown | Cleanup, report generation |
| `SubagentStart` | Subagent spawned | Monitoring, tracking |
| `SubagentStop` | Subagent completed | Result collection |

#### hooks.json example

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

**Matcher syntax**: `"*"` matches all tools. `"Bash"` matches a single tool. `"file_edit|file_write"` matches any pipe-separated name.

**Blocking**: A `PreToolUse` hook that exits with code `2` will block the tool execution.

**Environment variables**: `${COLLET_PLUGIN_ROOT}` resolves to the plugin's install directory. `${CLAUDE_PLUGIN_ROOT}` is also set for backward compatibility.

### Plugin Commands

```bash
collet plugin install <owner/repo | name@marketplace>  Install a plugin
collet plugin list                                      List installed plugins
collet plugin remove <name>                             Remove a plugin
collet plugin marketplace add <owner/repo> [name]       Register a marketplace
collet plugin marketplace list                          List marketplaces
collet plugin marketplace remove <name>                 Unregister a marketplace
```
