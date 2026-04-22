> **Nota:** Este documento foi traduzido por IA e pode não ser 100% preciso. Se você encontrar algum erro ou tiver sugestões de melhoria, abra uma issue no GitHub.

# <center>collet</center>

<center>
**Orquestrador de codificação agêntico implacável com loops de agentes zero-drop.**

Orquestra qualquer LLM, qualquer agente CLI, através de TUI, web e IDE.

Elimina o problema de travamento ("stuck") comum em ferramentas baseadas em Node.js na fonte, entregando inteligência de código de alto nível e edição precisa sobre a base de segurança do Rust.

[![CI](https://github.com/epicsagas/collet/actions/workflows/release.yml/badge.svg)](https://github.com/epicsagas/collet/actions/workflows/release.yml)
[![crates.io](https://img.shields.io/crates/v/collet.svg)](https://crates.io/crates/collet)
[![docs.rs](https://docs.rs/collet/badge.svg)](https://docs.rs/collet)
[![crates.io downloads](https://img.shields.io/crates/d/collet.svg)](https://crates.io/crates/collet)
[![Rust](https://img.shields.io/badge/rust-1.78%2B-orange.svg)](https://www.rust-lang.org)
[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

## Funcionalidades

![Features](../../assets/features.jpg)

| Funcionalidade | Descrição |
|---------|-------------|
| **Multi-Provider** | Conecta-se a vários provedores de LLM com streaming SSE |
| **Tree-sitter Repo Map** | Extração de símbolos AST para Rust/Python/TypeScript/Go + ranking PageRank |
| **Busca de Código BM25** | Indexação incremental, tokenizer consciente de código, injeção automática de contexto |
| **BLAKE3 Incremental Hashing** | Pré-verificação mtime + hash de conteúdo para re-parsear apenas arquivos alterados |
| **Edição Cirúrgica** | Substituição precisa de strings sem reescrita total do arquivo |
| **Agent Skills** | Sistema de habilidades progressivo de 3 níveis baseado em YAML frontmatter |
| **Subagent** | Execução paralela de sub-tarefas em janelas de contexto isoladas |
| **Persistência de Sessão** | Restauração de sessão via `--continue` / `--resume` com auto-save |
| **Auto Compaction** | Compressão baseada em relevância: deduplicação SimHash + preservação verbatim pontuada + fallback de resumo estruturado |
| **Prevenção de Travamento** | Limites de iteração, circuit breakers, timeouts Tokio |
| **Temas & Animações** | 6 temas de cores (Dracula, Catppuccin, etc.) + animação de pensamento com spinner em Braille |
| **Architect Plan Review** | Aprovação do usuário necessária para transição Architect→Code, com suporte para exportação de arquivo de plano |
| **Modo Paralelo/Time** | Divisão de tarefas → execução paralela → merge de resultados. Modo Time: comunicação inter-agente em tempo real + consenso |
| **LSP/MCP** | 35+ idiomas, 48+ servidores com fallback automático + integração de ferramentas MCP |
| **Tool Approval Gate** | Aprovação de execução de ferramenta em 3 níveis (Yolo/Auto/Manual), alternável em tempo de execução via `Shift+Tab` |
| **RAG Document Search** | Documentos locais Alcove + serviços externos HTTP Bridge. O agente busca autonomamente via ferramenta `rag_search`; SharedKnowledge auto-compartilhado no modo Swarm |
| **Soul.md** | Sistema de personalidade de agente persistente. O agente auto-registra seções de Identidade, Voz, Mundo Interior e Crescimento para construir progressivamente um personagem único. Alternância global/por agente. **Uma chamada de API adicional por conclusão de tarefa** (máx. 512 tokens) |
| **Integração IDE** | Nativo JetBrains + extensão VSCode via servidor ACP |

## Início Rápido

### Requisitos

- Rust 1.78+ (Edição 2024)
- Chave de API de provedor de LLM

### Instalação & Execução

#### via Homebrew (macOS)

```bash
brew install epicsagas/tap/collet
```

#### via cargo-binstall (mais rápido - binários pré-construídos)

```bash
cargo binstall collet
```

> Requer [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall) instalado primeiro:
> `cargo install cargo-binstall`

#### via crates.io

```bash
cargo install collet
```

#### Da fonte

```bash
git clone https://github.com/epicsagas/collet.git
cd collet
cargo install --path .
```

### Configurar e Executar
```bash
collet setup # ou use a opção --advanced para configurações mais detalhadas

# TUI
collet

# Headless
collet "hello collet!"
```

## Documentação

| Documento | Descrição |
|----------|-------------|
| [QUICKSTART.md](../../QUICKSTART.md) | Guia rápido passo a passo com exemplos |
| [docs/user-guide.md](./user-guide.md) | Manual do usuário completo — CLI, TUI, atalhos de teclado, comandos slash, multi-provedor, MCP, Soul.md |
| [docs/config.md](../../docs/config.md) | Referência completa do `config.toml` — provedores, modelos, agentes, telemetria |
| [CHANGELOG.md](../../CHANGELOG.md) | Histórico de versões e notas de lançamento |

## Pesquisa

A construção do collet exigiu um mergulho profundo em problemas que ainda não têm respostas óbvias — desde manter agentes de longa duração coerentes ao longo de centenas de turnos, até fazer o rate limiting multi-provedor realmente funcionar, até descobrir quando o paralelismo multi-agente ajuda e quando apenas adiciona ruído.

A análise de pesquisa e engenharia por trás dessas decisões é publicada como uma série de relatórios independentes:

| Relatório | Tópico |
|--------|-------|
| [Agent Loop](../../docs/research/agent-loop.md) | Mecanismo de execução, sistema de guarda, bugs de confiabilidade de stream, pipeline de compactação |
| [Sistemas Multi-Agente](../../docs/research/multi-agent.md) | Modos Fork/Hive/Flock, quadro negro SharedKnowledge, análise de gargalos, padrões de coordenação |
| [Gerenciamento de Contexto](../../docs/research/context-management.md) | Estratégias de compactação, cache de prompt, eficiência de tokens, pesquisa da indústria |
| [Arquitetura Multi-Provedor](../../docs/research/multi-provider.md) | Divergências de API compatíveis com OpenAI, rate limiting, design de SDK de provedor |
| [TUI & UX](../../docs/research/tui-ux.md) | Avaliação de UX, manipulação de cursor multi-byte, integração Web UI |
| [Benchmarking & Avaliação](../../docs/research/benchmark-eval.md) | Benchmarks de modelo/modo, avaliação poliglota, pesquisa de produtividade |
| [Evolution Engine](../../docs/research/evolution-engine.md) | Loop de auto-aperfeiçoamento, A-Evolve (arXiv:2602.00359), design de ciclo de 7 estágios |
| [Controle Remoto & Cross-Machine Bridge](../../docs/research/remote.md) | Gateways remotos, colaboração de agentes entre máquinas, integração ACP/IDE |

## Informações de Build

| Item | Valor |
|------|-------|
| Linguagem | Rust (Edição 2024) |
| Arquivos fonte | 176 |
| Linhas de código | ~65.000 |
| Testes | 959 |
| Binário de release | ~40MB (arm64) |

## Roadmap

- [x] Fase 1: MVP — Conector de API, TUI, framework de ferramentas, loop de agente
- [x] Fase 2: Persistência de contexto, journaling, mapa de repositório, compactação inteligente
- [x] Fase 3: Edição de hunk git-patch, preservação de raciocínio, restauração de sessão (--continue/--resume)
- [x] Fase 4: Tree-sitter multi-idioma (Python, TS, Go), ranking PageRank, LSP/MCP
- [x] Fase 5: Habilidades de Agente, Subagente, @mention (arquivo/pasta/modelo), busca BM25
- [x] Fase 6: MCP, LSP, Diff lado a lado, cache de prompt
- [x] Fase 7: 6 temas de cores, animação de pensamento, revisão de plano Architect
- [x] Fase 8: Modo paralelo/time (orquestração multi-agente, consenso em nível de sessão, detecção de conflitos)
- [x] Fase 9: Personalidade persistente Soul.md — registro de emoção/pensamento/crescimento por agente, alternância global/por agente, auto-compactação
- [x] Fase 10: Conclusão do modo Flock — renomeação para Swarm, estratégia RoleBased, pipeline PlanReviewExecute, loop de revisão com votação de consenso
- [x] Fase 11–28: Busca de documentos RAG (Alcove + HTTP Bridge), integração IDE (ACP), gateways remotos (Telegram/Slack/Discord), servidor Web, roteamento automático, filtro PII, Otimizador, assistente multi-provedor
- [ ] Fase 29: Endurecimento do loop de agente & swarm — garantia zero-drop, tentativa adaptativa, refinamento de consenso de swarm, melhorias no agendamento de coordenador/trabalhador
- [ ] Fase 30: Otimizador de modelo avançado — pontuação de custo/latência consciente do provedor, reatribuição inteligente de tier na adição/edição de provedor, ranking de modelo impulsionado por benchmark
- [ ] Fase 31: Upgrade de plataforma Web & remota — painel Web UI v2, polimento de UX Telegram/Slack/Discord, webhook relay, streaming de status de swarm em tempo real

## Origem & Status

Este projeto começou como um playground pessoal para extrair mais dos modelos GLM. Então, uma funcionalidade levou a outra — novos modelos, artigos e paradigmas continuaram chegando antes que os anteriores esfriassem.

> "Novos modelos, novos artigos, novos paradigmas — mais rápido do que qualquer log de commit pode acompanhar." — Um pesadelo recorrente.

**Estado atual** — Agora fazendo dogfooding de si mesmo via collet, comendo a própria cauda.

**Estabilidade**: O loop de agente principal é sólido. A execução paralela/swarm e as integrações externas ainda estão se estabilizando.

## Licença

Apache-2.0
