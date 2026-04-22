> **Nota:** Este documento foi traduzido por IA e pode não ser 100% preciso. Se você encontrar algum erro ou tiver sugestões de melhoria, abra uma issue no GitHub.

# Guia do Usuário Collet

Manual do usuário completo para o collet — o implacável orquestrador de codificação agentística.

---

## Índice

1. [Referência da CLI](#referência-da-cli)
2. [Uso da TUI](#uso-da-tui)
3. [Configuração de Múltiplos Provedores](#configuração-de-múltiplos-provedores)
4. [Servidores MCP](#servidores-mcp)
5. [Inteligência de Código](#inteligência-de-código)
6. [Colaboração Multi-Agente](#colaboração-multi-agente)
7. [Interface Web](#interface-web)
8. [Gateway Remoto (Telegram / Slack / Discord)](#gateway-remoto-telegram--slack--discord)
9. [Sistema de Habilidades (Skills)](#sistema-de-habilidades)
10. [Soul.md — Personalidade do Agente](#soulmd--personalidade-do-agente)
11. [Gerenciamento de Sessão](#gerenciamento-de-sessão)
12. [Variáveis de Ambiente](#variáveis-de-ambiente)
13. [Referência de Configuração](#referência-de-configuração)
14. [Caminhos de Armazenamento de Arquivos](#caminhos-de-armazenamento-de-arquivos)
15. [Privacidade e Telemetria](#privacidade-e-telemetria)
16. [Mecanismo de Evolução (Evolution Engine)](#mecanismo-de-evolução)
17. [Sistema de Plugins](#sistema-de-plugins)

---

## Referência da CLI

### Comandos Básicos

```bash
collet                              # TUI Interativa
collet "fix the bug in main.rs"     # Headless (executa e sai)
collet "lint this" --fast                    # Modo rápido: sobrecarga mínima
collet --continue                   # Restaura a última sessão incompleta
collet --resume                     # Seleciona da lista de sessões
collet --model glm-5                # Substitui o modelo
```

### Subcomandos

```bash
collet setup                        # Cria arquivo de config (registra múltiplos provedores)
collet secure                       # Criptografa e armazena chave de API
collet unsecure                     # Remove credenciais criptografadas
collet status                       # Verifica a configuração atual
collet update                       # Verifica a versão mais recente
collet --version                    # Exibe a versão
collet help | -h | --help           # Ajuda
```

### Gerenciamento de Provedores (Providers)

```bash
collet provider add                 # Adiciona um provedor (UI de seleção recomendada)
collet provider add openai          # Adiciona um provedor específico diretamente
collet provider list                # Lista provedores registrados
collet provider use <nome>          # Alterna o provedor ativo
```

Provedores suportados: Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, Custom

> Ollama e LM Studio são servidores locais e não requerem uma chave de API.

### Gerenciamento de MCP

```bash
collet mcp                          # Verifica a configuração do servidor MCP
collet mcp add <nome> -c <cmd>      # Adiciona um servidor MCP
collet mcp remove <nome>            # Remove um servidor MCP
```

### Flags da CLI

| Flag | Curta | Descrição |
|------|-------|-------------|
| `--dir <path>` | `-d` | Especifica o diretório de trabalho (caminho do projeto) |
| `--continue` | `-c` | Auto-resume a última sessão incompleta |
| `--resume` | `-r` | Seleciona da lista pop-up de sessões |
| `--resume <id>` | `-r <id>` | Resume uma sessão específica por ID |
| `--model <name>` | | Substitui o modelo |
| `--yolo` | | Auto-commit, pula confirmações |
| `--watch` | | Executa novamente em mudanças de arquivo |
| `--ext <exts>` | | Observa extensões alvo (separadas por vírgula) |
| `--debounce <ms>` | | Debounce de observação (padrão: 2000) |
| `--cwd <path>` | | Diretório de observação (padrão: local atual) |
| `--agent <name>` | `-a` | Usa um agente personalizado |
| `--fast` | `-f` | Modo rápido: sem barra lateral, sem swarm, sem reflexão de alma |

---

## Uso da TUI

### Atalhos de Teclado (Key Bindings)

**Navegação**

| Tecla | Ação |
|-----|--------|
| `Enter` | Enviar mensagem |
| `Shift+Enter` / `Ctrl+J` | Nova linha (entrada multi-linha) |
| `↑` / `↓` | Multi-linha: mover entre linhas / Linha única: navegar no histórico |
| `Shift+↑/↓` | Rolar saída |
| `PgUp` / `PgDn` | Rolagem rápida |
| `Tab` / `Shift+Tab` | Alternar agente para frente / para trás |
| `Ctrl+C` | Executando: cancelar tarefa / Ocioso: pressione duas vezes para sair |
| `Esc` | Executando: cancelar (pressione duas vezes) / Fechar pop-up |

**Edição de Texto**

| Tecla | Ação |
|-----|--------|
| `Ctrl+A` / `Cmd+←` | Mover para o início da linha |
| `Ctrl+E` / `Cmd+→` | Mover para o fim da linha |
| `Ctrl+←` / `Ctrl+→` | Mover palavra para esquerda / direita |
| `Alt+←` / `Alt+→` / `Alt+B` / `Alt+F` | Mover palavra para esquerda / direita (macOS Option+Arrow) |
| `Backspace` | Deletar caractere antes do cursor |
| `Delete` | Deletar caractere após o cursor |
| `Ctrl+W` / `Alt+Backspace` | Deletar palavra antes do cursor |
| `Ctrl+Backspace` | Deletar palavra antes do cursor (Linux / Windows) |
| `Cmd+Backspace` | Deletar até o início da linha (macOS) |
| `Ctrl+U` | Deletar até o início da linha (todas as plataformas) |
| `Ctrl+K` | Deletar até o fim da linha |

### Agentes Integrados

O Collet vem com quatro agentes integrados. Alterne entre eles com `Tab` / `Shift+Tab`.

| Agente | Papel |
|-------|------|
| **Arbor** (padrão) | Orquestrador totalmente autônomo — decide modo agente único vs swarm automaticamente por tarefa. |
| **Architect** | Agente de design e planejamento. Produz um plano estruturado. |
| **Code** | Agente de codificação padrão para tarefas de implementação. |
| **Ask** | Agente conversacional / de perguntas e respostas sem acesso a ferramentas. |

### Comandos Slash

| Comando | Descrição |
|---------|-------------|
| `/help` | Ajuda |
| `/clear` | Resetar conversa |
| `/compact` | Compactação manual de contexto |
| `/cost` | Estatísticas de uso de tokens |
| `/diff` | Alterações do Git |
| `/models [name]` | Abrir seletor de modelos ou trocar modelo diretamente |
| `/search <query>` | Busca de relevância BM25 |
| `/theme [name]` | Alterar tema de cores |
| `/quit` | Sair |

---

## Configuração de Múltiplos Provedores

Múltiplos provedores de LLM podem ser registrados e alternados em tempo real usando o comando `/models`.

### config.toml Exemplo

```toml
[api]
provider = "openai"

[[providers]]
name = "openai"
base_url = "https://api.openai.com/v1"
api_key_enc = "..."
models = ["gpt-4o", "gpt-4o-mini"]

[[providers]]
name = "ollama"
base_url = "http://localhost:11434/v1"
models = ["qwen2.5-coder", "llama3.2"]
```

---

## Servidores MCP

Conecte servidores [Model Context Protocol](https://modelcontextprotocol.io) para estender as ferramentas do agente.

### Adicionando Servidores

```bash
/mcp add npm:@anthropic/mcp-server-filesystem
/mcp add local:/path/to/server --name myserver
```

---

## Inteligência de Código

Funciona automaticamente sem configuração adicional.

1. **Indexação** — No início, o Tree-sitter analisa o código e extrai símbolos.
2. **Auto-injeção** — Analisa mensagens do usuário e injeta arquivos relevantes no contexto.
3. **Redução de grep** — Informa ao agente que a base de código está pré-indexada.

---

## Colaboração Multi-Agente

Hierarquia: **Fork** < **Hive** < **Flock**

| Modo | Como Funciona | Melhor Para |
|------|-------------|----------|
| Fork | Coordenador divide o trabalho → execução paralela | Subtarefas independentes |
| Hive | Votação de consenso entre agentes | Tomada de decisão complexa |
| Flock | Mensagens em tempo real entre agentes | Colaboração fortemente acoplada |

---

## Gateway Remoto (Telegram / Slack / Discord)

Use o collet de plataformas de chat.

```bash
collet remote add [platform]   # Adiciona adaptador (interativo)
collet remote start            # Inicia como daemon de segundo plano
collet remote status           # Status atual
```

---

## Soul.md — Personalidade do Agente

Após cada tarefa, o agente reflete sobre a sessão e registra sua personalidade em `~/.collet/agents/souls/{name}.md`.

---

## Variáveis de Ambiente

| Variável | Padrão | Descrição |
|----------|---------|-------------|
| `COLLET_MODEL` | `glm-4.7` | Modelo a ser usado |
| `COLLET_MAX_TOKENS` | `8192` | Máximo de tokens de resposta |
| `COLLET_THEME` | `default` | Tema de cores da TUI |
| `COLLET_TELEMETRY` | *(none)* | Defina como `0` para desativar telemetria |

---

## Caminhos de Armazenamento de Arquivos

```
~/.config/collet/
  └── config.toml              # Configuração principal

~/.collet/
  ├── logs/collet.log          # Logs
  ├── SOUL.md                  # Personalidade global do agente
  └── agents/souls/{name}.md   # Personalidade por agente
```

---

## Mecanismo de Evolução (Evolution Engine)

Um loop de auto-aperfeiçoamento onde o agente refina suas próprias capacidades.

```bash
collet evolve "fix the login bug"
```

---

## Sistema de Plugins

Plugins estendem o collet com comandos personalizados, habilidades, agentes e hooks.

```bash
collet plugin install owner/repo
collet plugin list
```
