# <center>collet</center>

<center>
**Relentless agentic coding orchestrator with zero-drop agent loops.**

Orchestrates any LLM, any CLI agent, across TUI, web, and IDE.

Eliminates the stuck problem common in Node.js-based tools at the source, delivering high-level code intelligence and precise editing on the safety foundation of Rust.

[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

<p align="center">
  <a href="i18n/KR/README.md">🇰🇷 한국어</a> |
  <a href="i18n/CN/README.md">🇨🇳 简体中文</a> |
  <a href="i18n/JP/README.md">🇯🇵 日本語</a> |
  <a href="i18n/DE/README.md">🇩🇪 Deutsch</a> |
  <a href="i18n/FR/README.md">🇫🇷 Français</a> |
  <a href="i18n/ES/README.md">🇪🇸 Español</a> |
  <a href="i18n/BR/README.md">🇧🇷 Português</a> |
  <a href="i18n/RU/README.md">🇷🇺 Русский</a> |
  <a href="i18n/IN/README.md">🇮🇳 हिन्दी</a> |
  <a href="i18n/AE/README.md">🇦🇪 العربية</a>
</p>

## Features

![Features](assets/features.jpg)

| Feature | Description |
|---------|-------------|
| **Multi-Provider** | Connects to various LLM providers with SSE streaming |
| **Tree-sitter Repo Map** | AST symbol extraction for Rust/Python/TypeScript/Go + PageRank ranking |
| **BM25 Code Search** | Incremental indexing, code-aware tokenizer, automatic context injection |
| **BLAKE3 Incremental Hashing** | mtime pre-check + content hash to re-parse only changed files |
| **Surgical Edit** | Precise string replacement without full file rewrites |
| **Agent Skills** | 3-tier progressive skill system based on YAML frontmatter |
| **Subagent** | Parallel subtask execution in isolated context windows |
| **Session Persistence** | Session restore via `--continue` / `--resume` with auto-save |
| **Auto Compaction** | Relevance-based compression: SimHash deduplication + scored verbatim preservation + structured summary fallback |
| **Stuck Prevention** | Iteration limits, circuit breakers, Tokio timeouts |
| **Themes & Animations** | 6 color themes (Dracula, Catppuccin, etc.) + Braille spinner thinking animation |
| **Architect Plan Review** | User approval required for Architect→Code transition, with plan file export support |
| **Parallel/Team Mode** | Task split → parallel execution → result merge. Team mode: real-time inter-agent communication + consensus |
| **LSP/MCP** | 35+ languages, 48+ servers with automatic fallback + MCP tool integration |
| **Tool Approval Gate** | 3-tier tool execution approval (Yolo/Auto/Manual), switchable at runtime via `Shift+Tab` |
| **RAG Document Search** | Alcove local docs + HTTP Bridge external services. Agent autonomously searches via `rag_search` tool; SharedKnowledge auto-shared in Swarm mode |
| **Soul.md** | Persistent agent personality system. The agent self-records Identity, Voice, Inner World, and Growth sections to progressively build a unique character. Global/per-agent toggle. **One additional API call per task completion** (max 512 tokens) |
| **IDE Integration** | JetBrains native + VSCode extension via ACP server |

## Quick Start

### Requirements

- LLM provider API key

### Installation & Running

#### via Homebrew (macOS)

```bash
brew install epicsagas/tap/collet
```

#### via cargo-binstall (fastest — pre-built binaries)

```bash
cargo binstall collet
```

> Requires [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall) installed first:
> `cargo install cargo-binstall`

#### Download Binary

Download the latest release for your platform from the [Releases page](https://github.com/epicsagas/collet/releases).

### Setup and Run
```bash
collet setup # or use --advanced option for more detailed settings

# TUI
collet

# Headless
collet "hello collet!"
```

## Documentation

| Document | Description |
|----------|-------------|
| [docs/user-guide.md](docs/user-guide.md) | Complete user manual — CLI, TUI, key bindings, slash commands, multi-provider, MCP, Soul.md |
| [docs/config.md](docs/config.md) | `config.toml` complete reference — providers, models, agents, telemetry |
| [CHANGELOG.md](CHANGELOG.md) | Version history and release notes |

## Roadmap

- [x] Phase 1: MVP — API connector, TUI, tool framework, agent loop
- [x] Phase 2: Context persistence, journaling, repo map, smart compaction
- [x] Phase 3: git-patch hunk editing, reasoning preservation, session restore (--continue/--resume)
- [x] Phase 4: Multi-language tree-sitter (Python, TS, Go), PageRank ranking, LSP/MCP
- [x] Phase 5: Agent Skills, Subagent, @mention (file/folder/model), BM25 search
- [x] Phase 6: MCP, LSP, Side-by-side Diff, prompt caching
- [x] Phase 7: 6 color themes, thinking animation, Architect plan review
- [x] Phase 8: Parallel/team mode (multi-agent orchestration, session-level consensus, conflict detection)
- [x] Phase 9: Soul.md persistent personality — per-agent emotion/thought/growth recording, global/per-agent toggle, auto-compaction
- [x] Phase 10: Flock mode completion — Swarm renaming, RoleBased strategy, PlanReviewExecute pipeline, revision loop with consensus voting
- [x] Phase 11–28: RAG document search (Alcove + HTTP Bridge), IDE integration (ACP), Remote gateways (Telegram/Slack/Discord), Web server, Auto-routing, PII filter, Optimizer, Multi-provider wizard
- [ ] Phase 29: Agent loop & swarm hardening — zero-drop guarantee, adaptive retry, swarm consensus refinement
- [ ] Phase 30: Model optimizer advanced — provider-aware cost/latency scoring, benchmark-driven model ranking
- [ ] Phase 31: Web & remote platform upgrade — Web UI dashboard v2, webhook relay, real-time swarm status streaming

## Origin & Status

This project began as a personal playground to squeeze more out of GLM models. Then one feature led to another — new models, papers, and paradigms kept arriving before the previous ones were cold.

> "New models, new papers, new paradigms — faster than any commit log can keep up." — A recurring nightmare.

**Current state** — Now dogfooding itself via collet, eating its own tail.

**Stability**: The core agent loop is solid. Parallel/swarm execution and external integrations are still settling.

## License

Apache-2.0
