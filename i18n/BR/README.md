> **Nota:** Este documento foi traduzido por IA e pode não ser 100% preciso. Se você encontrar algum erro ou tiver sugestões de melhoria, abra uma issue no GitHub.

# <center>collet</center>

<center>
**Orquestrador de codificação agêntico implacável com loops de agentes zero-drop.**

Orquestra qualquer LLM, qualquer agente CLI, através de TUI, web e IDE.

Elimina o problema de travamento ("stuck") comum em ferramentas baseadas em Node.js na fonte, entregando inteligência de código de alto nível e edição precisa sobre a base de segurança do Rust.

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

- Chave de API de provedor de LLM

### Instalação & Execução

#### Baixar binário

Baixe o binário mais recente em [GitHub Releases](https://github.com/epicsagas/collet/releases).

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
