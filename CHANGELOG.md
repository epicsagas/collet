# Changelog

All notable changes to collet will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] — 2026-04-17

### Fixed

- **SSE streaming UTF-8 corruption**: Raw byte buffer with `from_utf8` boundary detection prevents CJK/emoji split corruption
- **Tool call ordering non-deterministic**: HashMap iteration → sorted index iteration for deterministic tool dispatch
- **Continuation depth unbounded**: Added `MAX_CONTINUATION_DEPTH = 3` cap to prevent infinite re-queuing chains
- **Blackboard votes lost on update**: `post_to_blackboard` now preserves existing votes when updating entry value
- **Token estimation inaccurate for CJK**: Byte-ratio detection applies 1.5× multiplier for multi-byte text
- **Context truncation after TUI send**: Tool results now truncated before sending to TUI, not after

### Performance

- **Streaming token buffering**: Coalesce 1-3 char tokens into sentence-level chunks (50ms timer + punctuation flush)
- **SSE streaming optimizations**: Flexible `data:` / `data: ` parsing, single-drain buffer, duplicate Done prevention
- **HashSet O(1) lookups**: Replaced Vec::contains in compaction file tracking, checkpoint remaining tasks
- **Arc\<str\> system prompt sharing**: Eliminated per-dispatch String clone via `DispatchContext.system_prompt: Arc<str>`
- **Knowledge base caps**: Query results (100), displayed facts (50), files (80) bounded to prevent unbounded growth
- **Atomic ordering correctness**: `IterationBudget` uses Acquire/Release for cross-thread visibility on ARM
- **Numeric safety**: `saturating_pow` for backoff, `saturating_sub` for max_agents, division-by-zero guard on context tokens

## [0.1.1] — 2026-04-17

### Added

- **`--fast` / `-f` CLI flag**: Skip sidebar, swarm, soul reflection, auto-evolution for faster startup
  - Works in both TUI and non-interactive (no-tty / CI) modes
- **Project name in status bar**: Bottom-right now shows current working directory folder name
- **i18n**: README translations for 10 languages (ko, zh-CN, ja, es, de, fr, pt-BR, ru, ar, hi)
  - AI translation disclaimers and cross-language internal links

### Fixed

- **Session resume/continue broken**: Fixed after `session_snapshot_ids` refactor — loads lightweight metadata at startup, full snapshots on demand
- **`--fast` flag ignored in no-tty mode**: Both TUI and headless paths now respect fast mode

### Changed

- **CI workflow consolidation**: Merged standalone ci.yml and publish.yml into release.yml
- **Unused `App::new()` removed**: Dead code cleanup

### Security

- **Dependency updates**: dompurify, vite, picomatch, @sveltejs/kit (via Dependabot)

## [0.1.0] — 2026-04-16

First tagged release. Full-featured agentic coding orchestrator with multi-agent collaboration, TUI, web UI, and remote gateway.

### Highlights

- Async runtime with multi-provider LLM API (OpenAI-compatible, Ollama, LM Studio, CLI adapters)
- ratatui TUI with 6 themes, slash commands, autocomplete, and session management
- Fork / Hive / Flock multi-agent collaboration with SharedKnowledge and conflict resolution
- MCP protocol integration with lazy loading and BM25 tool search
- LSP integration for real-time diagnostics across 35+ languages
- Remote control gateway (Telegram, Discord, Slack)
- Svelte 5 web frontend with SSE streaming

### Added

- **Core runtime**: Async agent loop with context management, safety guards, and iteration budget
- **Multi-provider API**: OpenAI-compatible providers, Ollama, LM Studio, CLI coding agent adapters
  - `[[models]]` hierarchical config (global < model < agent), `reasoning_effort` parameter
  - Tier-based auto-routing, per-agent provider/model selection
- **Tools**: Surgical file edit, bash execution, search, subagent dispatch, skill framework
  - Tool approval gate: 3-level (Yolo/Auto/Manual) with lock-free runtime switching
  - Auto-truncate large tool results, git intent-to-add after file write
- **BM25 search + Tree-sitter repo map**: BLAKE3 hashing, Go language support, incremental indexing
- **MCP protocol + LSP integration**: Full agent loop integration, collision-safe naming
  - Lazy loading + `tool_search` with BM25-ranked search (auto-deferred when tools > 10)
  - MCP 2025-06 protocol compliance, HTTP streaming (SSE) with session tracking
  - Interactive server toggle popup, deferred tool schema injection
- **LSP**: 48+ server configs for 35+ languages, auto-detect on file creation, install prompts
  - publishDiagnostics reception, per-language semaphore spawn control
- **TUI**: ratatui with 6 themes, slash commands, and app orchestration
  - User message card styling with `bg_surface` background
  - Ctrl+C double-confirm exit, Shift+Enter line break, multiline cursor navigation
  - Non-disruptive commands while agent is busy, diff/sdiff popup overlay
  - Compaction animation, detailed `/compact` summary, config warning hints
  - Search results popup, fuzzy matching for `/` commands and `@` mentions
  - Skill autocomplete, Tab-expand subcommand hints, shell mode (`!cmd`)
  - Click-to-expand file diffs, swarm agent output popup, worker attach/detach view
  - Animated boot splash with rotating taglines, delta diff integration
  - Input prompt ASCII symbols (`>` / `~`), status bar layout improvements
  - macOS Option key fallbacks, native text selection support
- **Fork mode**: Split task to N agents → concurrent execution → merge
- **Hive mode**: Fork + SharedKnowledge, Plan Review protocol, conflict resolution
  - Three strategies: coordinator_resolves, last_writer_wins, user_resolves
  - TUI sidebar per-agent status, `HIVE:N` badge, mode approval popup
- **Flock mode**: Multi-domain agent seeding, collaboration mode auto-recommend
- **Arbor — autonomous orchestrator**: Default agent, auto-selects Fork/Hive/Flock
  - Welcome tips screen, swarm mode panel in welcome screen
- **Remote control gateway**: Telegram, Discord, Slack platform adapters
  - Daemon mode, typing indicators, project discovery, per-channel agent assignment
  - Message queue, session suppression, cancel cleanup, interactive help
  - Rich buttons, text formatting, model/agent selection, session history
  - Cautious approval mode and per-tool permission controls
- **Web server mode** (`--web` flag): axum REST API + SSE event streaming
  - Svelte 5 frontend with Tokyo Night theme, session resume, swarm graph visualization
- **ACP server**: JSON-RPC 2.0 over stdio for IDE integration (JetBrains, VSCode)
- **Evolution engine** (`collet evolve`): 7-phase self-improvement cycle
  - Pluggable mutation strategy, EGL convergence detection, git-based versioning
  - Benchmark adapters (Null, File/JSONL, SWE-bench), natural language task mode
- **RAG tool-based search**: Agent-driven `rag_search` with Alcove + HTTP bridge adapters
  - Swarm mode: results posted as SharedKnowledge facts for cross-worker retrieval
- **Task completion guarantee**: Auto-resume on timeout/iteration limits
  - `StopReason` enum, `ApproachingTimeout` verdict, configurable limits
- **Session-scoped approval cache**: 3-state tracking across parallel agents
- **Telemetry**: Anonymous usage stats with opt-out, PostHog + Sentry integration
- **Soul.md**: Persistent agent personality (Identity/Voice/Inner World/Growth)
  - Soul reflection in subagents, ephemeral toast display
- **Evaluation harness** (`collet eval`): Polyglot, HumanEval, custom, stress test
- **Plugin system**: Lifecycle management, marketplace registry with `@marketplace` syntax
  - Dual manifest support, 3 hook events, security hardening
- **Security**: PII detection popup, `deny_paths` setting, path traversal approval gate
  - OWASP Top 10 guidelines, constant-time password comparison, `follow_symlinks` option
- **Project trust system**: 3-level trust (Full/Read-only/Untrusted) per project
- **Vision API**: Image paste with fallback chain for non-vision models
- **Global rules**: `~/.collet/rules.md` loading with organization standards
- **Setup wizard**: Commented config.toml generation, LiteLLM registry scoring
  - Quick and advanced wizard modes, role-based model assignment
- **CLI**: `collet mcp` subcommand, `collet update`, `--version`, `--dir/-d`, `--web`
  - `--continue`/`-c`, `--resume`/`-r` session flags
- **Daily log rotation**: 7-day retention for runtime and remote logs
- **CI/CD**: Multi-platform release workflow, split CI/release/publish pipelines
  - Vendored OpenSSL for musl, `cfg(unix)` guard for Windows compatibility
- **Proxy headers**: Support for proxy headers in API requests

### Changed

- **Storage relocated**: `<project>/.agents/` → `~/.local/share/collet/projects/<blake3-hash>/`
- **File path unification**: All OS use `~/.local/share/collet/` (XDG style)
- **Log file consolidation**: Daily rolling → single `collet.log` with auto-cleanup
- **Provider structure separation**: `ProviderEntry` credentials only; overrides in `AgentDef`/`ModelOverride`
- **Provider name rename**: `"Ollama (local)"` → `"Ollama"`, `"LM Studio (local)"` → `"LM Studio"`
- **Ollama default models**: `qwen2.5-coder`, `llama3.2`, `deepseek-coder-v2`
- **Config module split**: Monolithic `config.rs` → `config/` directory module
- **Swarm module rename**: `hive` → `swarm`
- **Large file refactoring**: 15 files split into directory modules
- **License**: MIT → Apache-2.0
- **Tool output display**: Show only stdout (max 8 lines) instead of raw JSON
- **`/resume` command**: Session selection popup with recency sort

### Fixed

- **TUI freeze (input blocked)**: WordWrapper grapheme scan on padding fill → direct buffer bg manipulation
- **Multiline input rendering**: ratatui Span `\n` handling → `Vec<Line>` conversion
- **Shift+Enter line break**: Fixed `supports_keyboard_enhancement` import path
- **Multiline cursor up/down**: Added line discrimination methods for HistoryUp/Down
- **Theme change not saved**: Added `save_ui_theme()` with 3 call sites
- **Changed Files sidebar not updating**: Fixed tool name, JSON field, and args parsing
- **`context.clear()` token cache**: Reset `cached_msg_tokens` on clear
- **Session resume UI stale tokens**: Refresh status bar after `resume_from_snapshot()`
- **Cache hit rate always 0**: Complete `cached_tokens` pipeline through StreamEvent → AgentEvent
- **Architect → Code duplicate exploration**: `extract_arch_files()` deduplication
- **Swarm strategy-mode mismatch**: Warning on Fork + plan_review_execute
- **Config collaboration mode ignored**: Fix when `session_collab_mode` unset
- **LSP binary validation**: `which` check before returning, failed server caching
- **Network error retry**: Extended detection (502, 503, reset), max retries 3→5→8
- **Model regression**: System prompt injection moved to `build_prompt_with_agent()`
- **Default theme invisible text**: Fixed fg_muted == bg_surface
- **Cursor navigation panic**: Safe multi-byte boundary handling for CJK
- **Non-ASCII query routing**: Fixed wrong agent selection for Korean/CJK
- **Streaming channel freeze**: Reverted to unbounded channel
- **Config silent reset**: Prevented TOML autosplit from resetting providers
- **Infinite text-only loop**: Stopped completion message repetition
- **Blocking I/O in async**: `std::fs` → `tokio::fs` across 4 modules
- **Race conditions**: Atomic operations and file locking
- **Path traversal TOCTOU**: Lexical path normalization
- **Popup scroll overflow**: Clamped to content height
- **Autocomplete issues**: Argument preservation, busy-state navigation

### Performance

- **Arc<Config> + Arc<SkillRegistry>**: Eliminated per-tool-call deep clones via Arc pointer copies
- **`estimate_total_tokens()` O(1)**: Cached `cached_msg_tokens` replaces per-call Vec traversal
- **Pre-aggregated changed files**: One-time path extraction at event, not per render frame
- **TUI input lag elimination**: Filesystem autocomplete with thread-local 2s TTL cache
- **Render pipeline**: Cached per-line visual heights in `MessagesRenderCache`
- **Repo map caching**: `to_map_string()` via `Mutex<Option<String>>`
- **Context clone reduction**: Soul reflection receives only last 10 messages
- **Worker stream memory cap**: `full_stream` ring-buffered at 64KB
- **Swarm JoinSet**: Replace polling `wait_for_any` with JoinSet + DashMap
- **Startup parallelization**: Repo map build parallelized, lazy-load after TUI start
- **Prompt compression**: ~47% reduction with injection defense
- **Swarm resource injection**: Pre-built MCP/skills/tool_index via `with_shared_resources()`
- **Widget background fill**: `ratatui::widgets::Block` replaces per-cell O(w×h) loop
- **Streaming buffer pre-allocation**: SSE buffer (4KB), response accumulator (2KB)
- **Async diff rendering**: Delta caching and stream throttle
