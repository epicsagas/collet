# config.toml Complete Guide

collet's configuration file is located at `~/.collet/config.toml`.
On first run, default values are automatically generated via `collet setup`.

---

## Table of Contents

1. [Basic Structure](#basic-structure)
2. [[default] — Default Model/Provider](#default)
3. [[agent] — Agent Behavior Control](#agent)
4. [[[agents.list]] — Agent Definitions](#agentslist)
5. [[context] — Context Management](#context)
6. [[hooks] — Automation Hooks](#hooks)
7. [[ui] — Terminal UI](#ui)
8. [[collaboration] — Multi-Agent Collaboration](#collaboration)
9. [[remote] — Remote Server](#remote)
10. [[telegram] / [slack] / [discord] — Messenger Integration](#messenger-integration)
11. [[[models]] — Model Definitions](#models)
12. [[[providers]] — Provider Definitions](#providers)
13. [channel_map — Channel Routing](#channel_map)
14. [[soul] — Agent Persistent Persona](#soul)
15. [Advanced Sections (Optional)](#advanced-sections-optional)
16. [Secret Management (.secrets)](#secret-management-secrets)
17. [Environment Variable Overrides](#environment-variable-overrides)

---

## Basic Structure

```toml
channel_map = []          # optional: channel routing rules

[default]                 # default model/provider
[agent]                   # agent execution parameters

[[agents.list]]           # agent definitions (multiple allowed)
...

[context]                 # context compaction settings
[hooks]                   # automation
[ui]                      # terminal UI
[soul]                    # agent persistent persona (optional)
[collaboration]           # multi-agent (optional)
[remote]                  # remote server (optional)
[telegram]                # Telegram bot (optional)

[[models]]                # model spec definitions
[[providers]]             # provider definitions
```

---

## [default]

Specifies the default provider and model to use.

```toml
[default]
provider = "zai-coding"   # references [[providers]] name
model = "glm-4.7"         # default model (omit to use provider's first model)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `provider` | string | — | Provider name to use |
| `model` | string | provider's first model | Default model name |

> `base_url` is not set here. Always define it in `[[providers]]`.

---

## [agent]

Controls the execution parameters used when an agent processes tasks.

```toml
[agent]
tool_timeout_secs = 30        # max wait time for a single tool call (seconds)
task_timeout_secs = 600       # max execution time for the entire task (seconds)
max_iterations = 50           # max LLM iterations within a single task
max_continuations = 3         # auto-continuation count on context overflow
circuit_breaker_threshold = 3 # halt agent after N consecutive failures
iteration_delay_ms = 50       # delay between iterations (ms); 0 for immediate
auto_optimize = true          # enable auto-optimization based on bench data after completion
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `tool_timeout_secs` | u64 | 30 | Tool timeout |
| `task_timeout_secs` | u64 | 600 | Total task timeout |
| `max_iterations` | u32 | 50 | Max LLM call count |
| `max_continuations` | u32 | 3 | Auto-extension count on context overflow |
| `circuit_breaker_threshold` | u32 | 3 | Circuit breaker threshold |
| `iteration_delay_ms` | u64 | 50 | Delay between iterations (ms) |
| `auto_optimize` | bool | true | Enable auto-optimization advisor |

---

## [[agents.list]]

Defines custom agents at the project or user level.
Invoked as `@agent-name` or `collet run agent-name`.

```toml
[[agents.list]]
name = "code"                  # invoked as @code
model = "default"              # "default" uses the [default] model
description = "..."            # description used by LLM for agent selection
tier = "medium"                # usage priority: light | medium | heavy
tags = ["coding", "testing"]   # routing tags (array or comma-separated string)
system_prompt = """            # agent role instruction
...
"""
```

### Agent Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | ✅ | Lowercase and hyphens only (max 64 chars) |
| `model` | string | ✅ | Model name or `"default"` |
| `description` | string | ✅ | Role description (max 1024 chars), used for LLM matching |
| `tier` | string | — | `light` \| `medium` \| `heavy` |
| `tags` | array/string | — | Routing/search tags |
| `system_prompt` | string | — | Agent system prompt |

### tags Format

All three formats are supported:

```toml
# inline array
tags = ["coding", "testing", "build"]

# TOML block array
tags = [
    "coding",
    "testing",
]

# comma-separated string
tags = "coding, testing, build"
```

`categories` is also recognized as an alias for `tags` (Claude Code compatibility).

### tier Meaning

| tier | Description |
|------|-------------|
| `light` | Read-only, simple Q&A — fast and low-cost |
| `medium` | General coding tasks — balanced |
| `heavy` | Planning, architecture, complex analysis — high-performance model recommended |

---

## [context]

LLM context window management and automatic compaction settings.

```toml
[context]
max_tokens = 200000           # max token count for the context window
compaction_threshold = 0.8    # trigger compaction when usage exceeds this ratio
adaptive_compaction = true    # dynamically adjust compaction timing based on task patterns
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `max_tokens` | u32 | 200000 | Max context tokens |
| `compaction_threshold` | f32 | 0.8 | Compaction trigger ratio (0.0–1.0) |
| `adaptive_compaction` | bool | true | Adaptive compaction |

---

## [hooks]

Controls actions that run automatically on task completion.

```toml
[hooks]
auto_commit = true    # automatically git commit changes after task completion
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `auto_commit` | bool | false | Enable auto-commit |

> With `auto_commit = true`, the agent automatically stages and commits changed files after completing work.
> Commit messages are auto-generated in Conventional Commits format.

---

## [ui]

Terminal UI (TUI) appearance settings.

```toml
[ui]
theme = "catppuccin-mocha"   # color theme
debug_mode = false           # whether to show the debug panel
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `theme` | string | `"default"` | UI theme name |
| `debug_mode` | bool | false | Show debug info overlay |

### Available Themes

| Theme Name | Description |
|------------|-------------|
| `default` | Default monochrome |
| `catppuccin-mocha` | Warm dark theme |
| `catppuccin-latte` | Light theme |
| `dracula` | Dracula dark theme |
| `nord` | Cool blue palette |
| `gruvbox` | Retro warm theme |

---

## [collaboration]

Multi-agent swarm settings for collaborative task execution.

```toml
[collaboration]
mode = "flock"                          # collaboration mode
max_agents = 3                          # max concurrent agents
worker_model = "glm-4.7-flash"          # worker agent model (optional)
coordinator_model = "glm-4.7"          # coordinator model (optional)
worktree = false                        # use git worktree isolation
auto_suggest = true                     # suggest mode upgrade on complex task detection
require_consensus = true                # require agent consensus before convergence
conflict_resolution = "coordinator_resolves"  # conflict resolution strategy
strategy = "auto_split"                 # task distribution strategy
```

### mode Values

| Value | Description |
|-------|-------------|
| `none` | Single agent (default) |
| `fork` | Coordinator splits tasks → parallel execution → merge results |
| `hive` | Peer-to-peer consensus between agents; coordinator monitors only |
| `flock` | Real-time message exchange between agents (similar to AutoGen) |

> Tier relationship: `none < fork < hive < flock`
> Higher modes include all capabilities of lower modes.

### conflict_resolution Values

| Value | Description |
|-------|-------------|
| `coordinator_resolves` | Coordinator LLM adjudicates conflicts (default) |
| `last_writer_wins` | Last write takes precedence (fast, simple) |
| `user_resolves` | Ask the user to resolve conflicts |

### strategy Values

| Value | Description |
|-------|-------------|
| `auto_split` | Coordinator automatically splits tasks (default) |
| `role_based` | Explicitly assign roles via configuration |
| `plan_review_execute` | Architect plans → reviewer checks → worker executes |

### worktree vs File Claiming

- `worktree = false` (default): File-level claiming prevents concurrent writes. Low overhead.
- `worktree = true`: Each agent runs in isolation in a separate git worktree. Use when full isolation is required.

### Environment Variable Overrides

```bash
COLLET_COLLAB_MODE=fork        # override mode
COLLET_COLLAB_MAX_AGENTS=5     # override max agents
COLLET_COLLAB_WORKTREE=true    # override worktree
```

---

## [remote]

Remote server connection settings.

```toml
[remote]
enabled = true
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | bool | false | Enable remote trigger server |

---

## Messenger Integration

### [telegram]

```toml
[telegram]
allowed_users = [123456789]   # list of allowed Telegram user IDs
```

The API token is encrypted and stored in `~/.collet/.secrets` (see [Secret Management](#secret-management-secrets) below).

### [slack]

```toml
[slack]
allowed_users = ["U012ABCDEF"]   # list of allowed Slack user IDs
```

### [discord]

```toml
[discord]
allowed_users = [123456789]   # list of allowed Discord user IDs
guild_ids = [987654321]        # list of allowed server (guild) IDs
```

---

## [[models]]

Defines the specs of models to use. Referenced by `[[providers]]`.

```toml
[[models]]
name = "glm-4.7"
supports_tools = true      # whether function calling is supported
supports_reasoning = true  # whether chain-of-thought reasoning is supported
context_window = 128000    # max context tokens
max_output_tokens = 4096   # max output tokens
```

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Unique model name |
| `supports_tools` | bool | Whether tool calling is supported |
| `supports_reasoning` | bool | Whether reasoning mode is supported |
| `supports_vision` | bool | Whether the model accepts image inputs |
| `context_window` | u32 | Max context token count |
| `max_output_tokens` | u32 | Max output token count |

---

## [[providers]]

Defines how to access AI models.
There are two types: **API type** and **CLI type**.

### API Type (Direct HTTP Calls)

```toml
[[providers]]
name = "zai-coding"
base_url = "https://api.example.com/v4"   # API endpoint
models = ["glm-4.7", "glm-5"]             # list of supported models
```

The API key is encrypted and stored in `~/.collet/.secrets`.

### CLI Type (Wrapping External Tools)

```toml
[[providers]]
name = "claude"
models = ["default"]     # CLI providers typically use a single "default" entry
cli = "claude"           # CLI binary name to execute
cli_args = ["-p"]        # arguments always passed to the CLI
```

CLI providers invoke the binary with the message appended as the last argument:
`claude -p "user message"`

### Supported CLI Provider Examples

```toml
# Gemini CLI
[[providers]]
name = "gemini"
models = ["default"]
cli = "gemini"
cli_args = ["-p"]

# Aider
[[providers]]
name = "aider"
models = ["default"]
cli = "aider"
cli_args = ["--yes", "--no-auto-commits", "--message"]

# OpenCode
[[providers]]
name = "opencode"
models = ["default"]
cli = "opencode"
```

---

## channel_map

Routes channels to project directories with optional agent assignment.

```toml
[[channel_map]]
platform = "telegram"
channel  = "-100123456"      # Telegram chat/group ID
project  = "/home/user/backend"
name     = "backend"
agent    = "code"            # optional: auto-assign agent

[[channel_map]]
platform = "discord"
channel  = "999888777666"    # Discord channel ID
project  = "/home/user/frontend"
name     = "frontend"
agent    = "architect"       # optional: planning-focused agent

[[channel_map]]
platform = "slack"
channel  = "C01ABCDEF"       # Slack channel ID
project  = "/home/user/api"
name     = "api"
# agent omitted = use default model
```

| Field | Type | Description |
|-------|------|-------------|
| `platform` | string | Platform name: `"telegram"`, `"slack"`, `"discord"` |
| `channel` | string | Platform-specific channel ID |
| `project` | string | Absolute path to project directory |
| `name` | string | Human-readable name for display |
| `agent` | string | Optional agent name to auto-assign (e.g., `"architect"`, `"code"`) |

When `agent` is set, the session automatically uses that agent's model when starting.
Users can still switch agents at runtime with `/set-agent <name>`.

If no mapping exists for a channel, users must specify project via `/new <path>` command.

---

## Advanced Sections (Optional)

The sections below work fine with their defaults and **do not need to be present in config.toml**.
Add them only when customization is needed.

### [bench]

Retention period for agent performance data.
`bench.jsonl` is automatically generated on task completion.

```toml
[bench]
retain_days = 90    # retention period for bench data (days), default 90
```

### [debug]

Detailed debug logging settings.

```toml
[debug]
log_level = "info"       # "trace" | "debug" | "info" | "warn" | "error"
log_file = "/tmp/collet.log"  # file logging path (optional)
```

### [paths]

Use when default path overrides are needed.

```toml
[paths]
agents_dir = "~/.collet/agents"   # agent definition directory
skills_dir = "~/.collet/skills"   # skills directory
```

### [security]

Advanced security settings.

```toml
[security]
max_file_size_mb = 10      # max read size for a single file
allow_shell = true         # whether shell command execution is permitted
allowed_paths = ["/tmp"]   # list of allowed access paths
```

### [soul]

Agent persistent persona system. After session completion, the agent writes its emotions, thoughts, and growth through self-reflection to `~/.collet/agents/{name}.soul.md`.

```toml
[soul]
enabled = true    # default true. false disables globally (cannot be overridden per agent)
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | bool | `true` | Global kill switch. `false` disables soul for all agents |

#### Per-Agent Override

When the global setting is `true`, individual agents can be disabled via `.md` frontmatter:

```yaml
---
name: code
soul: false    # disable soul for this agent only
---
```

| Global `[soul]` | Agent `soul:` | Result |
|-----------------|---------------|--------|
| `false` | any | ❌ Disabled |
| `true` | not set | ✅ Enabled |
| `true` | `false` | ❌ Disabled |
| `true` | `true` | ✅ Enabled |

#### Soul.md Structure

```markdown
# Soul

## Identity
- (agent's defined identity)

## Voice
- (agent's communication style and tone)

## Inner World
- (agent's emotions, thoughts, and perceptions — written automatically)

## Growth
- [2026-03-27] Learned Rust async patterns in the first session
```

- **Identity / Voice / Inner World / Growth**: All four sections are written by the agent through automatic post-session reflection
- Inner World retains a maximum of 10 entries; Growth retains the 5 most recent entries with the rest summarized
- The entire file is automatically compacted when it exceeds 8,000 characters

### Image Processing (Vision Fallback)

When you paste or attach an image, collet processes it through a 4-step fallback chain:

| Step | Condition | Action |
|------|-----------|--------|
| 1 | Model supports vision (e.g., GPT-4o, Claude, Gemini) | Send image directly to model |
| 2 | An MCP server exposes a vision tool | Get text caption via MCP |
| 3 | `tesseract` is installed locally | Extract text via OCR |
| 4 | None of the above | Send image metadata only + show install prompt |

#### Installing Tesseract OCR

If your model doesn't support vision, install Tesseract for local OCR:

```bash
# macOS
brew install tesseract

# Ubuntu / Debian
sudo apt install -y tesseract-ocr

# Fedora
sudo dnf install -y tesseract

# Arch Linux
sudo pacman -S tesseract
```

When tesseract is not found and an image is attached, collet will offer to install it automatically via a popup prompt.

#### MCP Vision Server

If you have an MCP server that provides image analysis tools (e.g., `describe_image`, `analyze_image`, `caption_image`), collet will automatically detect and use it. Configure MCP servers in `.collet/mcp.json`:

```json
{
  "mcpServers": {
    "vision": {
      "command": "your-vision-mcp-server",
      "args": []
    }
  }
}
```

---

### [rag.alcove]

Alcove RAG integration settings.

```toml
[rag.alcove]
enabled = true
base_url = "http://localhost:8080"
```

### [telemetry]

Anonymous usage statistics transmission settings.

```toml
[telemetry]
enabled = false    # default false (disabled)
```

---

## Secret Management (.secrets)

Sensitive information such as API keys and tokens is **encrypted with AES-256-GCM and stored in `~/.collet/.secrets`**.
File permissions are automatically set to `0600` (owner read/write only).

### Automatic Migration

If a previous version stored `api_key` directly in `config.toml`, it is automatically migrated to `.secrets` on first run.

### .secrets Structure (Example)

```toml
[api]
api_key_enc = "..."    # encrypted value

[[providers]]
name = "zai-coding"
api_key_enc = "..."

[telegram]
token_enc = "..."
```

> Do not edit the `.secrets` file directly. Manage it via `collet setup` or environment variables.

### Injecting API Keys via Environment Variables

```bash
export COLLET_API_KEY="sk-..."           # default API key
export COLLET_PROVIDER_ZAI_KEY="sk-..."  # specific provider key
export COLLET_TELEGRAM_TOKEN="..."       # Telegram bot token
```

Environment variables take precedence over `.secrets` values.

---

## Environment Variable Overrides

Key values can be overridden via environment variables without a config file.

| Environment Variable | Corresponding Setting | Description |
|----------------------|-----------------------|-------------|
| `COLLET_API_KEY` | `[api] api_key` | Default API key |
| `COLLET_MODEL` | `[default] model` | Default model |
| `COLLET_PROVIDER` | `[default] provider` | Default provider |
| `COLLET_COLLAB_MODE` | `[collaboration] mode` | Collaboration mode |
| `COLLET_COLLAB_MAX_AGENTS` | `[collaboration] max_agents` | Max agent count |
| `COLLET_COLLAB_WORKTREE` | `[collaboration] worktree` | Enable worktree |

---

## Minimal Configuration Example

```toml
[default]
provider = "my-provider"
model = "my-model"

[agent]
max_iterations = 50

[[models]]
name = "my-model"
supports_tools = true
supports_reasoning = false
context_window = 128000
max_output_tokens = 4096

[[providers]]
name = "my-provider"
base_url = "https://api.example.com/v1"
models = ["my-model"]
```

## Full Configuration Example

```toml
channel_map = []

[default]
provider = "zai-coding"
model = "glm-4.7"

[agent]
tool_timeout_secs = 30
task_timeout_secs = 600
max_iterations = 50
max_continuations = 3
circuit_breaker_threshold = 3
iteration_delay_ms = 50
auto_optimize = true

[[agents.list]]
name = "architect"
model = "default"
description = "Planning and design specialist."
tier = "heavy"
tags = ["planning", "design", "architecture"]
system_prompt = """
You are an architect...
"""

[[agents.list]]
name = "code"
model = "default"
description = "Primary coding agent."
tier = "medium"
tags = ["coding", "testing", "debugging"]
system_prompt = """
You are a senior software engineer...
"""

[context]
max_tokens = 200000
compaction_threshold = 0.8
adaptive_compaction = true

[hooks]
auto_commit = false

[ui]
theme = "catppuccin-mocha"
debug_mode = false

[collaboration]
mode = "none"
max_agents = 3
auto_suggest = true
require_consensus = true
conflict_resolution = "coordinator_resolves"
strategy = "auto_split"

[[models]]
name = "glm-4.7"
supports_tools = true
supports_reasoning = true
context_window = 128000
max_output_tokens = 4096

[[providers]]
name = "zai-coding"
base_url = "https://api.example.com/v4"
models = ["glm-4.7"]
```
