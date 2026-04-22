> **注意：** 本文档由人工智能翻译，可能不 100% 准确。如果您发现任何错误或有改进建议，请在 GitHub 上提出 issue。

# <center>collet</center>

<center>
**具有零丢失代理循环的无情代理编码编排器。**

编排任何 LLM、任何 CLI 代理，跨越 TUI、Web 和 IDE。

从源头上消除了基于 Node.js 的工具中常见的卡顿问题，在 Rust 的安全基础上提供高级代码智能和精确编辑。

[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

## 功能特性

![Features](../../assets/features.jpg)

| 功能 | 描述 |
|---------|-------------|
| **多提供商** | 连接到各种支持 SSE 流的 LLM 提供商 |
| **Tree-sitter 仓库地图** | 针对 Rust/Python/TypeScript/Go 的 AST 符号提取 + PageRank 排名 |
| **BM25 代码搜索** | 增量索引、代码感知分词器、自动上下文注入 |
| **BLAKE3 增量哈希** | mtime 预检查 + 内容哈希，仅重新解析更改的文件 |
| **外科手术式编辑** | 精确的字符串替换，无需重写整个文件 |
| **代理技能** | 基于 YAML frontmatter 的三级渐进式技能系统 |
| **子代理** | 在隔离的上下文窗口中并行执行子任务 |
| **会话持久化** | 通过 `--continue` / `--resume` 恢复会话，支持自动保存 |
| **自动压缩** | 基于相关性的压缩：SimHash 去重 + 评分逐字保留 + 结构化摘要回退 |
| **防卡死机制** | 迭代限制、断路器、Tokio 超时 |
| **主题与动画** | 6 种配色方案（Dracula, Catppuccin 等）+ 盲文加载动画 |
| **架构师计划评审** | 架构师→代码转换需要用户批准，支持计划文件导出 |
| **并行/团队模式** | 任务拆分 → 并行执行 → 结果合并。团队模式：代理间实时通信 + 共识 |
| **LSP/MCP** | 支持 35+ 种语言、48+ 个服务器，具有自动回退 + MCP 工具集成 |
| **工具批准门控** | 三级工具执行批准（Yolo/自动/手动），运行时可通过 `Shift+Tab` 切换 |
| **RAG 文档搜索** | Alcove 本地文档 + HTTP Bridge 外部服务。代理通过 `rag_search` 工具自主搜索；集群模式下自动共享 SharedKnowledge |
| **Soul.md** | 持久化代理人格系统。代理自记录身份、声音、内心世界和成长章节，逐步构建独特角色。全局/每个代理开关。**每次任务完成额外调用一次 API**（最大 512 字节） |
| **IDE 集成** | 通过 ACP 服务器支持 JetBrains 原生集成 + VSCode 扩展 |

## 快速入门

### 核心要求

- LLM 提供商 API 密钥

### 安装与运行

#### 通过 Homebrew (macOS)

```bash
brew install epicsagas/tap/collet
```

#### 通过 cargo-binstall (最快 - 预编译二进制文件)

```bash
cargo binstall collet
```

> 需要先安装 [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall)：
> `cargo install cargo-binstall`

#### 下载二进制文件

从 [GitHub Releases](https://github.com/epicsagas/collet/releases) 下载适合您平台的预编译二进制文件。

### 配置与运行
```bash
collet setup # 或使用 --advanced 选项进行更详细的设置

# TUI 界面
collet

# 无头模式
collet "hello collet!"
```

## 文档说明

| 文档 | 描述 |
|----------|-------------|
| [QUICKSTART.md](../../QUICKSTART.md) | 包含示例的逐步快速入门指南 |
| [docs/user-guide.md](./user-guide.md) | 完整的用户手册 —— CLI、TUI、按键绑定、斜杠命令、多提供商、MCP、Soul.md |
| [docs/config.md](../../docs/config.md) | `config.toml` 完整参考手册 —— 提供商、模型、代理、遥测 |
| [CHANGELOG.md](../../CHANGELOG.md) | 版本历史和发行说明 |

## 路线图

- [x] 阶段 1：MVP — API 连接器、TUI、工具框架、代理循环
- [x] 阶段 2：上下文持久化、日志记录、仓库地图、智能压缩
- [x] 阶段 3：git-patch hunk 编辑、推理保留、会话恢复 (--continue/--resume)
- [x] 阶段 4：多语言 tree-sitter (Python, TS, Go)、PageRank 排名、LSP/MCP
- [x] 阶段 5：代理技能、子代理、@提及（文件/文件夹/模型）、BM25 搜索
- [x] 阶段 6：MCP、LSP、并排 Diff、提示词缓存
- [x] 阶段 7：6 种颜色主题、思考动画、架构师计划评审
- [x] 阶段 8：并行/团队模式（多代理编排、会话级共识、冲突检测）
- [x] 阶段 9：Soul.md 持久化人格 —— 每个代理的情感/思维/成长记录、全局/每个代理开关、自动压缩
- [x] 阶段 10：Flock 模式完成 —— Swarm 重命名、RoleBased 策略、PlanReviewExecute 流水线、带共识投票的修订循环
- [x] 阶段 11–28：RAG 文档搜索 (Alcove + HTTP Bridge)、IDE 集成 (ACP)、远程网关 (Telegram/Slack/Discord)、Web 服务器、自动路由、PII 过滤器、优化器、多提供商向导
- [ ] 阶段 29：代理循环与集群加固 —— 零丢失保证、自适应重试、集群共识细化、协调器/工作器调度改进
- [ ] 阶段 30：高级模型优化器 —— 感知提供商的成本/延迟评分、添加/编辑提供商时的智能层级重新分配、基准驱动的模型排名
- [ ] 阶段 31：Web 与远程平台升级 —— Web UI 控制台 v2、Telegram/Slack/Discord UX 优化、Webhook 中继、实时集群状态流

## 起源与状态

这个项目最初是一个个人游乐场，旨在从 GLM 模型中压榨出更多性能。然后一个功能引出了另一个功能 —— 新的模型、论文和范式在旧的还没凉透之前就不断涌现。

> “新的模型，新的论文，新的范式 —— 比任何提交日志更新得都快。” —— 一个反复出现的噩梦。

**当前状态** —— 现正通过 collet 进行自举（dogfooding）。

**稳定性**：核心代理循环稳固。并行/集群执行和外部集成仍在完善中。

## 许可证

Apache-2.0
