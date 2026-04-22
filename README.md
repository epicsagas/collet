# <center>collet</center>

<center>
**Relentless agentic coding orchestrator with zero-drop agent loops.**

Orchestrates any LLM, any CLI agent, across TUI, web, and IDE.

Eliminates the stuck problem common in Node.js-based tools at the source, delivering high-level code intelligence and precise editing on the safety foundation of Rust.

[![CI](https://github.com/epicsagas/collet/actions/workflows/release.yml/badge.svg)](https://github.com/epicsagas/collet/actions/workflows/release.yml)
[![crates.io](https://img.shields.io/crates/v/collet.svg)](https://crates.io/crates/collet)
[![docs.rs](https://docs.rs/collet/badge.svg)](https://docs.rs/collet)
[![crates.io downloads](https://img.shields.io/crates/d/collet.svg)](https://crates.io/crates/collet)
[![Rust](https://img.shields.io/badge/rust-1.78%2B-orange.svg)](https://www.rust-lang.org)
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

- Rust 1.78+ (Edition 2024)
- LLM provider API key

### Installation & Running

#### via Homebrew (macOS)

```bash
brew install epicsagas/tap/collet
```

#### via cargo-binstall (fastest - pre-built binaries)

```bash
cargo binstall collet
```

> Requires [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall) installed first:
> `cargo install cargo-binstall`

#### via crates.io

```bash
cargo install collet
```

#### From source

```bash
git clone https://github.com/epicsagas/collet.git
cd collet
cargo install --path .
```

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
| [QUICKSTART.md](QUICKSTART.md) | Step-by-step quickstart with examples |
| [docs/user-guide.md](docs/user-guide.md) | Complete user manual — CLI, TUI, key bindings, slash commands, multi-provider, MCP, Soul.md |
| [docs/config.md](docs/config.md) | `config.toml` complete reference — providers, models, agents, telemetry |
| [CHANGELOG.md](CHANGELOG.md) | Version history and release notes |

## Research

Building collet required going deep on problems that don't have obvious answers yet — from keeping long-running agents coherent across hundreds of turns, to making multi-provider rate limiting actually work, to figuring out when multi-agent parallelism helps and when it just adds noise.

The research and engineering analysis behind these decisions is published as a series of standalone reports:

| Report | Topic |
|--------|-------|
| [Agent Loop](docs/research/agent-loop.md) | Execution engine, guard system, stream reliability bugs, compaction pipeline |
| [Multi-Agent Systems](docs/research/multi-agent.md) | Fork/Hive/Flock modes, SharedKnowledge blackboard, bottleneck analysis, coordination patterns |
| [Context Management](docs/research/context-management.md) | Compaction strategies, prompt caching, token efficiency, industry survey |
| [Multi-Provider Architecture](docs/research/multi-provider.md) | OpenAI-compatible API divergences, rate limiting, provider SDK design |
| [TUI & UX](docs/research/tui-ux.md) | UX evaluation, multi-byte cursor handling, Web UI integration |
| [Benchmarking & Evaluation](docs/research/benchmark-eval.md) | Model/mode benchmarks, polyglot evaluation, productivity research |
| [Evolution Engine](docs/research/evolution-engine.md) | Self-improvement loop, A-Evolve (arXiv:2602.00359), 7-stage cycle design |
| [Remote Control & Cross-Machine Bridge](docs/research/remote.md) | Remote gateways, cross-machine agent collaboration, ACP/IDE integration |

## Build Info

| Item | Value |
|------|-------|
| Language | Rust (Edition 2024) |
| Source files | 176 |
| Lines of code | ~65,000 |
| Tests | 959 |
| Release binary | ~40MB (arm64) |

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
- [ ] Phase 29: Agent loop & swarm hardening — zero-drop guarantee, adaptive retry, swarm consensus refinement, coordinator/worker scheduling improvements
- [ ] Phase 30: Model optimizer advanced — provider-aware cost/latency scoring, smart tier reassignment on provider add/edit, benchmark-driven model ranking
- [ ] Phase 31: Web & remote platform upgrade — Web UI dashboard v2, Telegram/Slack/Discord UX polish, webhook relay, real-time swarm status streaming

## Origin & Status

This project began as a personal playground to squeeze more out of GLM models. Then one feature led to another — new models, papers, and paradigms kept arriving before the previous ones were cold.

> "New models, new papers, new paradigms — faster than any commit log can keep up." — A recurring nightmare.

**Current state** — Now dogfooding itself via collet, eating its own tail.

**Stability**: The core agent loop is solid. Parallel/swarm execution and external integrations are still settling.

## License

Apache-2.0
