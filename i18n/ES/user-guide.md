> **Nota:** Este documento ha sido traducido por IA y puede no ser 100 % exacto. Si encuentra algún error o tiene sugerencias de mejora, abra un problema en GitHub.

# Guía de Usuario de Collet

Manual de usuario completo para collet — el implacable orquestador de codificación agentística.

---

## Índice

1. [Referencia de la CLI](#referencia-de-la-cli)
2. [Uso de la TUI](#uso-de-la-tui)
3. [Configuración Multi-Proveedor](#configuración-multi-proveedor)
4. [Servidores MCP](#servidores-mcp)
5. [Inteligencia de Código](#inteligencia-de-código)
6. [Colaboración Multi-Agente](#colaboración-multi-agente)
7. [Interfaz Web](#interfaz-web)
8. [Pasarela Remota (Telegram / Slack / Discord)](#pasarela-remota-telegram--slack--discord)
9. [Sistema de Habilidades (Skills)](#sistema-de-habilidades)
10. [Soul.md — Personalidad del Agente](#soulmd--personalidad-del-agente)
11. [Gestión de Sesiones](#gestión-de-sesiones)
12. [Variables de Entorno](#variables-de-entorno)
13. [Referencia de Configuración](#referencia-de-configuración)
14. [Rutas de Almacenamiento de Archivos](#rutas-de-almacenamiento-de-archivos)
15. [Privacidad y Telemetría](#privacidad-y-telemetría)
16. [Motor de Evolución (Evolution Engine)](#motor-de-evolución)
17. [Sistema de Complementos (Plugins)](#sistema-de-complementos)

---

## Referencia de la CLI

### Comandos Básicos

```bash
collet                              # TUI Interactiva
collet "fix the bug in main.rs"     # Headless (ejecuta y sale)
collet --continue                   # Restaurar última sesión incompleta
collet --resume                     # Seleccionar de la lista de sesiones
collet --model glm-5                # Sobrescribir modelo
collet -f "refactoriza el módulo"   # Modo rápido headless
```

### Subcomandos

```bash
collet setup                        # Crear archivo de config (registrar proveedores)
collet secure                       # Encriptar y guardar clave API
collet unsecure                     # Eliminar credenciales encriptadas
collet status                       # Verificar configuración actual
collet update                       # Buscar última versión
collet --version                    # Mostrar versión
collet help | -h | --help           # Ayuda
```

### Gestión de Proveedores (Providers)

```bash
collet provider add                 # Añadir un proveedor (UI recomendada)
collet provider add openai          # Añadir un proveedor específico directamente
collet provider list                # Listar proveedores registrados
collet provider use <nombre>          # Cambiar proveedor activo
```

Proveedores soportados: Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, Custom

> Ollama y LM Studio son servidores locales y no requieren clave API.

### Gestión de MCP

```bash
collet mcp                          # Verificar configuración de servidor MCP
collet mcp add <nombre> -c <cmd>      # Añadir un servidor MCP
collet mcp remove <nombre>            # Eliminar un servidor MCP
```

### Banderas (Flags) de la CLI

| Bandera | Corta | Descripción |
|------|-------|-------------|
| `--dir <path>` | `-d` | Especificar directorio de trabajo (ruta del proyecto) |
| `--continue` | `-c` | Auto-reanudar última sesión incompleta |
| `--resume` | `-r` | Seleccionar de la lista emergente de sesiones |
| `--resume <id>` | `-r <id>` | Reanudar sesión específica por ID |
| `--model <name>` | | Sobrescribir modelo |
| `--yolo` | | Auto-commit, saltar confirmaciones |
| `--watch` | | Volver a ejecutar al cambiar archivos |
| `--ext <exts>` | | Observar extensiones específicas (separadas por coma) |
| `--agent <name>` | `-a` | Usar agente personalizado |
| `--fast` | `-f` | Modo rápido: sin barra lateral, sin swarm, sin reflexión de alma |

---

## Uso de la TUI

### Atajos de Teclado (Key Bindings)

**Navegación**

| Tecla | Acción |
|-----|--------|
| `Enter` | Enviar mensaje |
| `Shift+Enter` / `Ctrl+J` | Nueva línea (entrada multilínea) |
| `↑` / `↓` | Multilínea: mover entre líneas / Línea única: navegar historial |
| `Shift+↑/↓` | Desplazar salida |
| `PgUp` / `PgDn` | Desplazamiento rápido |
| `Tab` / `Shift+Tab` | Cambiar agente adelante / atrás |
| `Ctrl+C` | Ejecutando: cancelar tarea / Inactivo: presionar dos veces para salir |
| `Esc` | Ejecutando: cancelar (presionar dos veces) / Cerrar ventana emergente |

---

## Configuración Multi-Proveedor

Se pueden registrar y cambiar múltiples proveedores de LLM en tiempo real usando el comando `/models`.

### Ejemplo de config.toml

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

Conecte servidores [Model Context Protocol](https://modelcontextprotocol.io) para extender las herramientas del agente.

### Añadir Servidores

```bash
/mcp add npm:@anthropic/mcp-server-filesystem
/mcp add local:/path/to/server --name miservidor
```

---

## Inteligencia de Código

Funciona automáticamente sin configuración adicional.

1. **Indexación** — Al inicio, Tree-sitter analiza el código y extrae símbolos.
2. **Auto-inyección** — Analiza mensajes del usuario e inyecta archivos relevantes.
3. **Reducción de grep** — Informa al agente que el código ya está indexado.

---

## Colaboración Multi-Agente

Jerarquía: **Fork** < **Hive** < **Flock**

| Modo | Cómo funciona | Ideal para |
|------|-------------|----------|
| Fork | El coordinador divide el trabajo → ejecución paralela | Subtareas independientes |
| Hive | Votación de consenso entre agentes | Toma de decisiones complejas |
| Flock | Mensajería en tiempo real entre agentes | Colaboración estrechamente acoplada |

---

## Pasarela Remota (Telegram / Slack / Discord)

Use collet desde plataformas de chat.

```bash
collet remote add [platform]   # Añadir adaptador (interactivo)
collet remote start            # Iniciar como demonio en segundo plano
collet remote status           # Estado actual
```

---

## Soul.md — Personalidad del Agente

Después de cada tarea, el agente reflexiona sobre la sesión y registra su personalidad en `~/.collet/agents/souls/{nombre}.md`.

---

## Variables de Entorno

| Variable | Por defecto | Descripción |
|----------|---------|-------------|
| `COLLET_MODEL` | `glm-4.7` | Modelo a usar |
| `COLLET_MAX_TOKENS` | `8192` | Máximo de tokens de respuesta |
| `COLLET_THEME` | `default` | Tema de color de la TUI |
| `COLLET_TELEMETRY` | *(ninguno)* | Establecer en `0` para desactivar telemetría |

---

## Rutas de Almacenamiento de Archivos

```
~/.config/collet/
  └── config.toml              # Configuración principal

~/.collet/
  ├── logs/collet.log          # Registros (Logs)
  ├── SOUL.md                  # Personalidad global del agente
  └── agents/souls/{nombre}.md # Personalidad por agente
```

---

## Motor de Evolución (Evolution Engine)

Un bucle de automejora donde el agente refina sus propias capacidades.

```bash
collet evolve "arregla el error de inicio de sesión"
```

---

## Sistema de Complementos (Plugins)

Los complementos extienden collet con comandos personalizados, habilidades, agentes y ganchos (hooks).

```bash
collet plugin install owner/repo
collet plugin list
```
