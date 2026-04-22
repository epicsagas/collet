> **Nota:** Este documento ha sido traducido por IA y puede no ser 100 % exacto. Si encuentra algún error o tiene sugerencias de mejora, abra un problema en GitHub.

# <center>collet</center>

<center>
**Orquestrador de codificación agéntico implacable con bucles de agentes de caída cero.**

Orquestra cualquier LLM, cualquier agente CLI, a través de TUI, web e IDE.

Elimina el problema de bloqueo ("stuck") común en las herramientas basadas en Node.js desde la raíz, ofreciendo inteligencia de código de alto nivel y edición precisa sobre la base de seguridad de Rust.

[![CI](https://github.com/epicsagas/collet/actions/workflows/release.yml/badge.svg)](https://github.com/epicsagas/collet/actions/workflows/release.yml)
[![crates.io](https://img.shields.io/crates/v/collet.svg)](https://crates.io/crates/collet)
[![docs.rs](https://docs.rs/collet/badge.svg)](https://docs.rs/collet)
[![crates.io downloads](https://img.shields.io/crates/d/collet.svg)](https://crates.io/crates/collet)
[![Rust](https://img.shields.io/badge/rust-1.78%2B-orange.svg)](https://www.rust-lang.org)
[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

## Características

![Features](../../assets/features.jpg)

| Característica | Descripción |
|---------|-------------|
| **Multi-Provider** | Se conecta a varios proveedores de LLM con streaming SSE |
| **Tree-sitter Repo Map** | Extracción de símbolos AST para Rust/Python/TypeScript/Go + ranking PageRank |
| **Búsqueda de código BM25** | Indexación incremental, tokenizador consciente del código, inyección automática de contexto |
| **BLAKE3 Incremental Hashing** | Pre-verificación mtime + hash de contenido para re-parsear solo archivos cambiados |
| **Edición quirúrgica** | Reemplazo preciso de cadenas sin reescritura total del archivo |
| **Agent Skills** | Sistema de habilidades progresivo de 3 niveles basado en YAML frontmatter |
| **Subagent** | Ejecución paralela de subtareas en ventanas de contexto aisladas |
| **Persistencia de sesión** | Restauración de sesión vía `--continue` / `--resume` con guardado automático |
| **Auto Compaction** | Compresión basada en relevancia: deduplicación SimHash + preservación textual puntuada + fallback de resumen estructurado |
| **Prevención de bloqueos** | Límites de iteración, interruptores automáticos (circuit breakers), timeouts de Tokio |
| **Temas y animaciones** | 6 temas de colores (Dracula, Catppuccin, etc.) + animación de pensamiento con spinner en Braille |
| **Architect Plan Review** | Se requiere aprobación del usuario para la transición Architect→Code, con soporte para exportación de archivos de plan |
| **Modo Paralelo/Equipo** | División de tareas → ejecución paralela → fusión de resultados. Modo Equipo: comunicación entre agentes en tiempo real + consenso |
| **LSP/MCP** | Más de 35 idiomas, más de 48 servidores con fallback automático + integración de herramientas MCP |
| **Tool Approval Gate** | Aprobación de ejecución de herramientas en 3 niveles (Yolo/Auto/Manual), conmutable en tiempo de ejecución mediante `Shift+Tab` |
| **Búsqueda de documentos RAG** | Documentos locales de Alcove + servicios externos de HTTP Bridge. El agente busca de forma autónoma mediante la herramienta `rag_search`; SharedKnowledge se comparte automáticamente en modo Swarm |
| **Soul.md** | Sistema de personalidad de agente persistente. El agente autorregistra las secciones de Identidad, Voz, Mundo Interior y Crecimiento para construir progresivamente un carácter único. Interruptor global/por agente. **Una llamada adicional a la API por finalización de tarea** (máx. 512 tokens) |
| **Integración con IDE** | Nativo de JetBrains + extensión de VSCode a través del servidor ACP |

## Inicio rápido

### Requisitos

- Rust 1.78+ (Edición 2024)
- Clave de API del proveedor de LLM

### Instalación y ejecución

#### a través de Homebrew (macOS)

```bash
brew install epicsagas/tap/collet
```

#### a través de cargo-binstall (más rápido - binarios precompilados)

```bash
cargo binstall collet
```

> Requiere tener instalado primero [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall):
> `cargo install cargo-binstall`

#### a través de crates.io

```bash
cargo install collet
```

#### Desde el código fuente

```bash
git clone https://github.com/epicsagas/collet.git
cd collet
cargo install --path .
```

### Configuración y ejecución
```bash
collet setup # o use la opción --advanced para configuraciones más detalladas

# TUI
collet

# Headless
collet "hello collet!"
```

## Documentación

| Documento | Descripción |
|----------|-------------|
| [QUICKSTART.md](../../QUICKSTART.md) | Inicio rápido paso a paso con ejemplos |
| [docs/user-guide.md](./user-guide.md) | Manual de usuario completo — CLI, TUI, atajos de teclado, comandos slash, multiproveedor, MCP, Soul.md |
| [docs/config.md](../../docs/config.md) | Referencia completa de `config.toml` — proveedores, modelos, agentes, telemetría |
| [CHANGELOG.md](../../CHANGELOG.md) | Historial de versiones y notas de lanzamiento |

## Investigación

La creación de collet requirió profundizar en problemas que aún no tienen respuestas obvias: desde mantener agentes de larga duración coherentes a lo largo de cientos de turnos, hasta lograr que el límite de velocidad multiproveedor funcione realmente, pasando por descubrir cuándo ayuda el paralelismo multiagente y cuándo solo añade ruido.

El análisis de investigación e ingeniería detrás de estas decisiones se publica como una serie de informes independientes:

| Informe | Tema |
|--------|-------|
| [Agent Loop](../../docs/research/agent-loop.md) | Motor de ejecución, sistema de guardia, errores de fiabilidad del flujo, pipeline de compactación |
| [Sistemas Multi-Agente](../../docs/research/multi-agent.md) | Modos Fork/Hive/Flock, pizarra de SharedKnowledge, análisis de cuellos de botella, patrones de coordinación |
| [Gestión del contexto](../../docs/research/context-management.md) | Estrategias de compactación, almacenamiento en caché de prompts, eficiencia de tokens, encuesta de la industria |
| [Arquitectura multiproveedor](../../docs/research/multi-provider.md) | Divergencias de API compatibles con OpenAI, límite de velocidad, diseño de SDK del proveedor |
| [TUI y UX](../../docs/research/tui-ux.md) | Evaluación de UX, manejo de cursor multibyte, integración de interfaz web |
| [Benchmarking y evaluación](../../docs/research/benchmark-eval.md) | Benchmarks de modelos/modos, evaluación políglota, investigación de productividad |
| [Evolution Engine](../../docs/research/evolution-engine.md) | Bucle de automejora, A-Evolve (arXiv:2602.00359), diseño de ciclo de 7 etapas |
| [Control remoto y puente entre máquinas](../../docs/research/remote.md) | Pasarelas remotas, colaboración de agentes entre máquinas, integración ACP/IDE |

## Información de compilación

| Elemento | Valor |
|------|-------|
| Lenguaje | Rust (Edición 2024) |
| Archivos fuente | 176 |
| Líneas de código | ~65,000 |
| Pruebas | 959 |
| Binario de lanzamiento | ~40MB (arm64) |

## Hoja de ruta

- [x] Fase 1: MVP — Conector de API, TUI, marco de herramientas, bucle de agente
- [x] Fase 2: Persistencia del contexto, registro, mapa del repositorio, compactación inteligente
- [x] Fase 3: Edición de fragmentos git-patch, preservación del razonamiento, restauración de sesión (--continue/--resume)
- [x] Fase 4: Tree-sitter multiidioma (Python, TS, Go), ranking PageRank, LSP/MCP
- [x] Fase 5: Habilidades de agente, subagente, @mention (archivo/carpeta/modelo), búsqueda BM25
- [x] Fase 6: MCP, LSP, Diff lado a lado, almacenamiento en caché de prompts
- [x] Fase 7: 6 temas de colores, animación de pensamiento, revisión del plan Architect
- [x] Fase 8: Modo paralelo/equipo (orquestación multiagente, consenso a nivel de sesión, detección de conflictos)
- [x] Fase 9: Personalidad persistente Soul.md — registro de emoción/pensamiento/crecimiento por agente, interruptor global/por agente, autocompactación
- [x] Fase 10: Finalización del modo Flock — cambio de nombre a Swarm, estrategia RoleBased, pipeline PlanReviewExecute, bucle de revisión con votación de consenso
- [x] Fase 11–28: Búsqueda de documentos RAG (Alcove + HTTP Bridge), integración de IDE (ACP), pasarelas remotas (Telegram/Slack/Discord), servidor web, enrutamiento automático, filtro de PII, optimizador, asistente multiproveedor
- [ ] Fase 29: Reforzamiento del bucle de agente y Swarm — garantía de caída cero, reintento adaptativo, refinamiento del consenso de Swarm, mejoras en la programación del coordinador/trabajador
- [ ] Fase 30: Optimizador de modelos avanzado — puntuación de coste/latencia consciente del proveedor, reasignación inteligente de niveles al añadir/editar proveedores, clasificación de modelos basada en benchmarks
- [ ] Phase 31: Actualización de la plataforma web y remota — Panel de control de interfaz web v2, pulido de UX de Telegram/Slack/Discord, relé de webhook, streaming del estado de Swarm en tiempo real

## Origen y estado

Este proyecto comenzó como un campo de pruebas personal para exprimir más los modelos GLM. Luego, una característica llevó a otra: nuevos modelos, artículos y paradigmas seguían llegando antes de que los anteriores se enfriaran.

> "Nuevos modelos, nuevos artículos, nuevos paradigmas — más rápido de lo que cualquier registro de commit puede seguir". — Una pesadilla recurrente.

**Estado actual** — Ahora se aplica dogfooding a sí mismo a través de collet, comiendo su propia cola.

**Estabilidad**: El bucle del agente central es sólido. La ejecución paralela/en enjambre y las integraciones externas aún se están estabilizando.

## Licencia

Apache-2.0
