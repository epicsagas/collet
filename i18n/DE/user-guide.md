> **Hinweis:** Dieses Dokument wurde von einer KI übersetzt und ist möglicherweise nicht zu 100 % genau. Wenn Sie Fehler finden oder Verbesserungsvorschläge haben, eröffnen Sie bitte ein Issue auf GitHub.

# Collet Benutzerhandbuch

Vollständiges Benutzerhandbuch für collet — der unerbittliche agentische Coding-Orchestrator.

---

## Inhaltsverzeichnis

1. [CLI-Referenz](#cli-referenz)
2. [TUI-Nutzung](#tui-nutzung)
3. [Multi-Provider-Konfiguration](#multi-provider-konfiguration)
4. [MCP-Server](#mcp-server)
5. [Code-Intelligenz](#code-intelligenz)
6. [Zusammenarbeit mehrerer Agenten](#zusammenarbeit-mehrerer-agenten)
7. [Web-Interface](#web-interface)
8. [Remote-Gateway (Telegram / Slack / Discord)](#remote-gateway-telegram--slack--discord)
9. [Skills-System](#skills-system)
10. [Soul.md — Agenten-Persönlichkeit](#soulmd--agenten-persönlichkeit)
11. [Sitzungsmanagement](#sitzungsmanagement)
12. [Umgebungsvariablen](#umgebungsvariablen)
13. [Konfigurationsreferenz](#konfigurationsreferenz)
14. [Dateispeicherpfade](#dateispeicherpfade)
15. [Datenschutz & Telemetrie](#datenschutz--telemetrie)
16. [Evolutions-Engine](#evolutions-engine)
17. [Plugin-System](#plugin-system)

---

## CLI-Referenz

### Basispfehle

```bash
collet                              # Interaktive TUI
collet "fix the bug in main.rs"     # Headless (ausführen und beenden)
collet --continue                   # Letzte unvollständige Sitzung wiederherstellen
collet --resume                     # Aus Sitzungsliste auswählen
collet --model glm-5                # Modell überschreiben
```

### Unterbefehle

```bash
collet setup                        # Konfigurationsdatei erstellen (mehrere Provider registrieren)
collet secure                       # API-Schlüssel verschlüsseln und speichern
collet unsecure                     # Verschlüsselte Anmeldedaten entfernen
collet status                       # Aktuelle Konfiguration prüfen
collet update                       # Auf neueste Version prüfen
collet --version                    # Version anzeigen
collet help | -h | --help           # Hilfe
```

### Provider-Management

```bash
collet provider add                 # Provider hinzufügen (empfohlene Modellauswahl-UI)
collet provider add openai          # Spezifischen Provider direkt hinzufügen
collet provider list                # Registrierte Provider auflisten
collet provider use <name>          # Aktiven Provider wechseln
```

Unterstützte Provider: Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, Custom

> Ollama und LM Studio sind lokale Server und benötigen keinen API-Schlüssel.

### MCP-Management

```bash
collet mcp                          # MCP-Serverkonfiguration prüfen
collet mcp add <name> -c <cmd>      # MCP-Server hinzufügen
collet mcp remove <name>            # MCP-Server entfernen
```

### CLI-Flags

| Flag | Kurzform | Beschreibung |
|------|----------|--------------|
| `--dir <path>` | `-d` | Arbeitsverzeichnis angeben (Projektpfad) |
| `--continue` | `-c` | Letzte unvollständige Sitzung automatisch fortsetzen |
| `--resume` | `-r` | Aus Sitzungslisten-Popup auswählen |
| `--resume <id>` | `-r <id>` | Spezifische Sitzung nach ID fortsetzen |
| `--model <name>` | | Modell überschreiben |
| `--yolo` | | Auto-Commit, Bestätigungen überspringen |
| `--watch` | | Bei Dateiänderungen erneut ausführen |
| `--ext <exts>` | | Zu überwachende Erweiterungen (kommagetrennt) |
| `--debounce <ms>` | | Watch-Entprellung (Standard: 2000) |
| `--cwd <path>` | | Watch-Verzeichnis (Standard: aktueller Standort) |
| `--agent <name>` | `-a` | Benutzerdefinierten Agenten verwenden |
| `--fast` | `-f` | Schnellmodus: keine Seitenleiste, kein Swarm, keine Soul-Reflexion |

### Headless-Modus

```bash
collet "fix the login bug"                    # Im aktuellen Verzeichnis ausführen
collet "fix the login bug" -d ~/projects/api  # In anderem Projekt ausführen
collet "lint this" --yolo                     # Auto-Commit, Bestätigungen überspringen
collet "lint this" --fast                    # Schnellmodus: minimaler Overhead
```

### Watch-Modus (Dateiänderungserkennung)

```bash
# Basis-Nutzung
collet "lint this" --watch --ext rs,toml --debounce 500

# Nur spezifisches Verzeichnis überwachen
collet "run tests" --watch --cwd ./src --ext rs

# Benutzerdefinierten Agenten verwenden
collet "review changes" --watch --agent reviewer --ext ts,tsx
```

Wird automatisch neu ausgeführt, wenn sich Dateien ändern.

**Anwendungsfälle:**

| Szenario | Befehl |
|----------|---------|
| Spezifisches Unterverzeichnis überwachen | `--watch --cwd ./packages/core` |
| Änderungen an Konfigurationsdateien erkennen | `--watch --cwd ./config --ext yaml,toml` |
| CI-Skripte automatisch korrigieren | `--watch --cwd .github --ext yml` |
| Dokumentation automatisch formatieren | `--watch --cwd ./docs --ext md` |
| Schnelles Linting mit Leichtgewichtsmodell | `--watch --agent fast --ext ts` |

---

## TUI-Nutzung

### Tastenkombinationen

**Navigation**

| Taste | Aktion |
|-------|--------|
| `Enter` | Nachricht senden |
| `Shift+Enter` / `Ctrl+J` | Neue Zeile (Mehrzeileneingabe) |
| `↑` / `↓` | Mehrzeilig: zwischen Zeilen bewegen / Einzeilig: Historie navigieren |
| `Shift+↑/↓` | Ausgabe scrollen |
| `PgUp` / `PgDn` | Schnelles Scrollen |
| `Tab` / `Shift+Tab` | Agent vorwärts / rückwärts wechseln |
| `Ctrl+C` | Laufend: Aufgabe abbrechen / Leerlauf: zweimal drücken zum Beenden |
| `Esc` | Laufend: Abbrechen (zweimal drücken) / Popup schließen |

**Textbearbeitung**

| Taste | Aktion |
|-------|--------|
| `Ctrl+A` / `Cmd+←` | Zum Zeilenanfang bewegen |
| `Ctrl+E` / `Cmd+→` | Zum Zeilenende bewegen |
| `Ctrl+←` / `Ctrl+→` | Wort links / rechts bewegen |
| `Alt+←` / `Alt+→` / `Alt+B` / `Alt+F` | Wort links / rechts bewegen (macOS Option+Pfeil) |
| `Backspace` | Zeichen vor dem Cursor löschen |
| `Delete` | Zeichen nach dem Cursor löschen |
| `Ctrl+W` / `Alt+Backspace` | Wort vor dem Cursor löschen |
| `Ctrl+Backspace` | Wort vor dem Cursor löschen (Linux / Windows) |
| `Cmd+Backspace` | Bis zum Zeilenanfang löschen (macOS, Kitty-Protokoll-Terminals) |
| `Ctrl+U` | Bis zum Zeilenanfang löschen (alle Plattformen) |
| `Ctrl+K` | Bis zum Zeilenende löschen |

### Integrierte Agenten

Collet wird mit vier integrierten Agenten ausgeliefert. Wechseln Sie zwischen ihnen mit `Tab` / `Shift+Tab`.

| Agent | Rolle |
|-------|------|
| **Arbor** (Standard) | Vollständig autonomer Orchestrator — entscheidet pro Aufgabe automatisch zwischen Einzelagenten- oder Swarm-Modus. Kein Popup, keine Konfiguration erforderlich. |
| **Architect** | Design- und Planungsagent. Erstellt einen strukturierten Plan und bietet dann `/proceed` → Code oder `/save-plan` zum Speichern an. |
| **Code** | Standard-Coding-Agent für Implementierungsaufgaben. |
| **Ask** | Konversations- / Frage-Antwort-Agent ohne Tool-Zugriff. |

> **Tipp**: Wenn Arbor aktiv ist, wird Ihre Aufgabe automatisch an den optimalen Ausführungsmodus (Fork / Hive / Flock / Einzelagent) weitergeleitet. Bei anderen Agenten wird Ihre Auswahl immer als primärer Agent berücksichtigt.

### Slash-Befehle

| Befehl | Beschreibung |
|---------|-------------|
| `/help` | Hilfe |
| `/clear` | Konversation zurücksetzen |
| `/compact` | Manuelle Kontext-Kompaktierung |
| `/cost` | Token-Nutzungsstatistiken |
| `/diff` | Git-Änderungen |
| `/sdiff` | Side-by-Side-Diff |
| `/undo` | Letzten Commit rückgängig machen |
| `/models [name]` | Modell-Picker öffnen oder Modell direkt wechseln (wechselt den vollständigen Provider-Kontext) |
| `Tab` / `Shift+Tab` | Agent wechseln (zykliert durch konfigurierte Agenten) |
| `/search <query>` | BM25-Relevanzsuche |
| `/rewind [id]` | Zu einem Checkpoint zurückkehren |
| `/checkpoints` | Checkpoints auflisten |
| `/web <url>` | URL-Inhalt abrufen |
| `/resume` | Letzte Sitzungen-Popup — sortiert nach Datum, zum Wiederherstellen auswählen |
| `/theme [name]` | Farbschema ändern (6 Optionen: default, dracula, catppuccin-mocha, tokyo-night, nord, gruvbox) |
| `/save-plan` | Plan des Architect-Modus in einer Datei speichern |
| `/proceed` | Architect-Plan genehmigen und in den Code-Modus wechseln |
| `/cancel-plan` | Architect-Plan verwerfen |
| `/fork` | Parallele Agenten-Verzweigung |
| `/hive` | Konsensbasierte Zusammenarbeit |
| `/flock` | Echtzeit-Multi-Agent |
| `/mcp` | MCP-Server verwalten (Leertaste: ein/aus, a: hinzufügen, d: entfernen) |
| `/skills` | Skills auflisten |
| `/agents` | Aktive Sub-Agenten anzeigen |
| `/optimize` | Kontext optimieren |
| `/bench` | Performance-Dashboard |
| `/debug` | Debug-Overlay umschalten |
| `/telemetry` | Telemetrie-Status und gesammelte Elemente prüfen |
| `/quit` | Beenden |

> **Autovervollständigung**: Geben Sie `/` ein, um das Befehls-Popup zu öffnen. Sowohl integrierte Befehle als auch entdeckte **Skills** erscheinen in derselben Liste, sortiert nach Fuzzy-Match-Score. Drücken Sie `↑`/`↓` zum Navigieren, `Tab` zum Erweitern mit Argument-Hinweis, `Enter` zum Bestätigen.

### Shell-Passthrough

Stellen Sie jedem Shell-Befehl ein `!` voran, um ihn direkt im Arbeitsverzeichnis auszuführen, ohne die TUI zu verlassen:

```
! git log --oneline -5
! cargo test
! ls src/
```

Der Exit-Code, stdout und stderr werden als umzäunter Codeblock im Chat angezeigt. Nützlich für schnelle Überprüfungen, ohne das Terminal zu wechseln.

### @ Erwähnungen

| Muster | Aktion |
|---------|--------|
| `@src/main.rs` | Dateiinhalt an Kontext anhängen |
| `@src` | Ordnerstruktur anhängen (3 Ebenen, 200 Elemente) |
| `@Makefile` | Datei/Ordner relativ zum Arbeitsverzeichnis automatisch erkennen |
| `@glm-5` | Agent auf das angegebene Modell umstellen |

> **Autovervollständigung**: Geben Sie `@` ein, um das Erwähnungs-Popup zu öffnen. Agentennamen verwenden **Fuzzy-Matching** — Teilsequenz-Scoring mit Wortgrenzen- und aufeinanderfolgenden Übereinstimmungsboni. Datei-/Ordnernamen verwenden Präfix-Matching mit Unterverzeichnis-Navigation (`@src/` listet den Inhalt von `src/` auf).

### Agenten-Tools

| Tool | Beschreibung |
|------|-------------|
| `bash` | Shell-Befehle ausführen (mit Timeout-Schutz) |
| `file_read` | Datei mit Zeilennummern lesen |
| `file_write` | Datei erstellen/überschreiben |
| `file_edit` | Präzise String-Ersetzung (Surgical Edit) |
| `git_patch` | Hunk-basierte Patches anwenden |
| `search` | ripgrep-basierte Codesuche |
| `skill` | Agent-Skill laden (3-stufig progressiv) |
| `subagent` | Teilaufgabe in einem isolierten Kontext ausführen |

### TUI-Layout

```
┌──────────────────────────────────────────────────────────────────────┐
│ ⠹ Working │ [CODE] │ iter:3 │ 12s │ tools:5 │ 🤖 glm-4.7 │ compact:1 │
│ ctx:[████████░░░░░░░░] 42% │ LSP: rust-analyzer │ /help │ Ctrl+C     │
├──────────────────────────────────────────────┬──────────────────── ──┤
│ Chat                                         │ Tools                 │
│ ▶ You: Fix error in src/main.rs              │ ✓ file_read (0.2s)    │
│ ◆ Coordinator: Type error on line 42 fixed.  │ ✓ file_edit (0.1s)    │
│ ⠼ Coordinator ░▒▓█▓▒░ Thinking...            │ ✓ bash (1.3s)         │
├──────────────────────────────────────────────┴───────────────────────┤
│ Input: _                                                             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Multi-Provider-Konfiguration

Mehrere LLM-Provider können registriert und in Echtzeit mit dem Befehl `/models` gewechselt werden.

### Provider registrieren

```bash
collet provider add          # Interaktiver Assistent (aus empfohlener Modellliste auswählen)
collet provider add openai   # Spezifischen Provider direkt hinzufügen
```

### config.toml Beispiel

```toml
[api]
provider = "openai"

# providers = credentials only (model behavior is configured in [[models]] and [[agents.list]])
[[providers]]
name = "openai"
base_url = "https://api.openai.com/v1"
api_key_enc = "..."
models = ["gpt-4o", "gpt-4o-mini"]

[[providers]]
name = "ollama"
base_url = "http://localhost:11434/v1"
models = ["qwen2.5-coder", "llama3.2", "deepseek-coder-v2"]
```

### Hierarchische Konfiguration (Global < Modell < Agent)

Konfigurationspriorität: `env/[agent]` → `[[models]]` → `[[agents.list]]`

```toml
# Per-Modell Standard-Überschreibungen
[[models]]
name = "gpt-4o"
context_window = 128000
max_output_tokens = 16384
supports_tools = true

[[models]]
name = "qwen2.5-coder"
supports_tools = false
reasoning_effort = "medium"     # low | medium | high

# Agenten-spezifische Überschreibungen (höchste Priorität)
[[agents.list]]
name = "code"
model = "gpt-4o"
provider = "openai"              # Provider wechselt auch beim Umschalten via Tab/Shift+Tab
temperature = 0.2

[[agents.list]]
name = "architect"
model = "gpt-4o"
provider = "openai"
temperature = 0.7
thinking_budget_tokens = 8192    # Hat Vorrang vor reasoning_effort

[[agents.list]]
name = "local"
model = "qwen2.5-coder"
provider = "ollama"              # Zu lokalem Provider wechseln
```

Das Weglassen des Feldes `provider` behält den aktuell aktiven Provider bei und ändert nur das Modell.

### Überschreibbare Felder

Standardwerte des Modellprofils können in `[[models]]` und `[[agents.list]]` überschrieben werden:

| Feld | Typ | Beschreibung |
|-------|------|-------------|
| `temperature` | `f32` | Sampling-Temperatur (wird bei Reasoning-Modellen automatisch weggelassen) |
| `thinking_budget_tokens` | `u32` | Budget für Reasoning-Token (hat Vorrang vor reasoning_effort) |
| `reasoning_effort` | `string` | Reasoning-Intensität: `"low"`, `"medium"`, `"high"` |
| `supports_tools` | `bool` | Ob Tool-Aufrufe unterstützt werden |
| `supports_reasoning` | `bool` | Ob Reasoning-/Thinking-Token unterstützt werden |
| `context_window` | `usize` | Größe des Kontextfensters |
| `max_output_tokens` | `u32` | Maximale Anzahl an Ausgabe-Token |
| `max_iterations` | `u32` | Maximale Iterationen des Agenten |

Alle Felder sind optional; wenn sie weggelassen werden, werden die Werte automatisch aus dem integrierten Modellprofil ermittelt.

### Umschalten zur Laufzeit

Verwenden Sie in der TUI den Befehl `/models`, um den Picker für registrierte Provider/Modelle zu öffnen. Die Auswahl eines Eintrags schaltet `base_url`, `api_key` und die Tool-Unterstützungseinstellungen gleichzeitig um.

```
/models              # Provider/Modell-Picker-Popup öffnen
/models gpt-4o       # Modell direkt wechseln
```

---

## MCP-Server

Verbinden Sie [Model Context Protocol](https://modelcontextprotocol.io)-Server, um die Tools des Agenten zu erweitern.

### Server hinzufügen

```bash
# Von npm-Paket
/mcp add npm:@anthropic/mcp-server-filesystem

# Lokale Binärdatei
/mcp add local:/path/to/server --name myserver

# HTTP-Endpunkt
/mcp add http:https://api.example.com/mcp

# Global hinzufügen (alle Projekte)
/mcp add npm:@some/tool --global
```

### Server verwalten

```bash
/mcp enable myserver
/mcp disable myserver
/mcp remove myserver
```

Der Serverstatus kann in der Seitenleiste überprüft werden (Befehl `/mcp` für interaktives Umschalten — Leertaste: ein/aus, a: hinzufügen, d: entfernen).

### Konfigurationsdatei

`.collet/mcp.json` (Projekt) oder `~/.collet/mcp.json` (global):

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@my/mcp-server"],
      "env": { "API_KEY": "${MY_API_KEY}" }
    },
    "remote-api": {
      "url": "https://api.example.com/mcp",
      "headers": { "Authorization": "Bearer ${API_TOKEN}" }
    }
  }
}
```

**Unterstützte Formate:**
- `command`: String oder Array (`["npx", "-y", "pkg"]` → wird automatisch aufgeteilt)
- `env` / `environment`: Umgebungsvariablen (`${VAR}` wird automatisch ersetzt)
- `headers`: HTTP-Authentifizierungs-Header
- `type`, `enabled`: Kompatibilitätsfelder (ignoriert)

---

## Code-Intelligenz

Funktioniert automatisch ohne zusätzliche Einrichtung.

1. **Indizierung** — Beim Start analysiert Tree-sitter den Quellcode und extrahiert Symbole (Funktionen, Typen, Konstanten). Nur geänderte Dateien werden mittels BLAKE3-Hashing neu verarbeitet.
2. **Auto-Injektion** — Analysiert Benutzernachrichten; findet bei codebezogenen Fragen relevante Dateien mittels BM25 und fügt sie automatisch in den Kontext ein.
3. **Grep reduzieren** — Informiert den Agenten darüber, dass die Codebasis vorindiziert ist, wodurch unnötige `grep`/`find`-Aufrufe reduziert werden.

Unterstützte Sprachen: Rust, Python, TypeScript, JavaScript, Go, Java, C/C++, Ruby, PHP, Swift, Kotlin und über 35 weitere. Die automatische Erkennung von LSP-Servern ermöglicht Hover, Go-to-Definition und Find-References.

Manuelle Suche: Führen Sie eine BM25-Suche direkt in der TUI mit `/search <query>` aus.

---

## Zusammenarbeit mehrerer Agenten

Hierarchie: **Fork** < **Hive** < **Flock** (höhere Stufen beinhalten Funktionen der niedrigeren)

| Modus | Funktionsweise | Bestens geeignet für |
|------|-------------|----------|
| Fork | Koordinator teilt Arbeit auf → parallele Ausführung → Ergebnisse zusammenführen | Unabhängige Teilaufgaben |
| Hive | Konsensabstimmung zwischen Agenten, Aufsicht durch Koordinator | Komplexe Entscheidungsfindung |
| Flock | Echtzeit-Messaging zwischen Agenten (experimentell) | Eng gekoppelte Zusammenarbeit |

### Konfiguration

In der `config.toml`:

```toml
[collaboration]
mode = "hive"           # none | fork | hive | flock
max_agents = 3
strategy = "auto_split" # auto_split | role_based | plan_review_execute
```

Oder pro Sitzung in der TUI mit `/fork`, `/hive`, `/flock` umschalten.

---

## Web-Interface

Nutzen Sie collet in Ihrem Browser. SvelteKit-Frontend + Axum-Backend.

### Erstellen und Ausführen

```bash
# Erstellen (erfordert web-Feature-Flag)
cargo build --release --features web

# Ausführen
collet web                    # http://127.0.0.1:3080
collet web -p 8080            # Port ändern
collet web --host 0.0.0.0     # Externen Zugriff erlauben
collet web --password secret  # Authentifizierung aktivieren
```

### CLI-Optionen

| Option | Standard | Umgebungsvariable | Beschreibung |
|--------|---------|-------------|-------------|
| `--host, -h` | `127.0.0.1` | `COLLET_WEB_HOST` | Bind-Adresse |
| `--port, -p` | `3080` | `COLLET_WEB_PORT` | Bind-Port |
| `--username, -u` | `collet` | `COLLET_WEB_USERNAME` | Login-Benutzername |
| `--password` | *(keiner)* | `COLLET_WEB_PASSWORD` | Authentifizierungs-Passwort |
| `--cors` | *(keiner)* | `COLLET_WEB_CORS` | Erlaubte CORS-Ursprünge (kommagetrennt) |

Kann auch über die `config.toml` konfiguriert werden:

```toml
[web]
host = "0.0.0.0"
port = 3080
username = "collet"
cors_origins = "http://localhost:5173"
# Passwort wird verschlüsselt und über collet secure --web gespeichert
```

### Authentifizierung

Wenn `--password` gesetzt ist, wird eine Token-basierte Authentifizierung aktiviert:

```
1. POST /api/auth/login  →  {"username": "collet", "password": "secret"}
2. Antwort: {"token": "abc123..."}
3. Folgende Anfragen: Authorization: Bearer abc123...
4. SSE-Verbindung: GET /api/events?token=abc123...
```

Ohne gesetztes Passwort ist der Zugriff ohne Authentifizierung möglich. `/api/health` und `/api/auth/status` sind immer öffentlich.

### API-Endpunkte

**Basis:**

| Methode | Pfad | Beschreibung |
|--------|------|-------------|
| `POST` | `/api/message` | Nachricht an Agent senden `{"message": "...", "mode": "code"}` |
| `GET` | `/api/events` | SSE-Stream (Echtzeit-Agentenereignisse) |
| `GET` | `/api/health` | Status, Version, Agentenaktivität |
| `GET` | `/api/config` | Aktuelles Modell, Kontextinfos |

**Sitzungen:**

| Methode | Pfad | Beschreibung |
|--------|------|-------------|
| `GET` | `/api/sessions` | Sitzungsliste |
| `GET` | `/api/sessions/{id}` | Sitzungsdetails + Konversations-Snapshot |
| `DELETE` | `/api/sessions/{id}` | Sitzung löschen |

**Dateien und Projekte:**

| Methode | Pfad | Beschreibung |
|--------|------|-------------|
| `GET` | `/api/files?path=src` | Verzeichnisauflistung |
| `GET` | `/api/files/src/main.rs` | Dateiinhalt lesen |
| `GET` | `/api/projects` | Projektliste |
| `POST` | `/api/projects/switch` | Arbeitsverzeichnis ändern |
| `GET` | `/api/search?q=pattern&glob=*.rs` | Codesuche |
| `GET` | `/api/symbols` | RepoMap-Symbolinfo |
| `GET` | `/api/tools` | Liste der verfügbaren Tools |

### SSE-Ereignisse

Verbinden Sie sich mit `/api/events`, um Echtzeit-Agentenaktivitäten zu empfangen:

| Ereignis | Daten | Beschreibung |
|-------|------|-------------|
| `token` | `{"text": "..."}` | Streaming-Token |
| `response` | `{"text": "..."}` | Vollständige Antwort |
| `tool_call` | `{"name": "bash", "args": "..."}` | Tool-Aufruf gestartet |
| `tool_result` | `{"name": "bash", "result": "...", "success": true}` | Tool-Ausführungsergebnis |
| `file_modified` | `{"path": "src/main.rs"}` | Benachrichtigung über Dateiänderung |
| `status` | `{"iteration", "prompt_tokens", ...}` | Token-/Timing-Metriken |
| `error` | `{"message": "..."}` | Fehler |
| `done` | `{}` | Agentenaufgabe abgeschlossen |

Ereignisse im Hive/Flock-Modus: `hive_agent_started`, `hive_agent_progress`, `hive_agent_done`, `hive_conflict`, `hive_done`

### Anwendungsbeispiel: curl

```bash
# Status prüfen
curl http://localhost:3080/api/health

# Nachricht senden (keine Authentifizierung)
curl -X POST http://localhost:3080/api/message \
  -H "Content-Type: application/json" \
  -d '{"message": "fix the login bug", "mode": "code"}'

# SSE-Stream empfangen
curl -N http://localhost:3080/api/events

# Mit Authentifizierung
TOKEN=$(curl -s -X POST http://localhost:3080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"collet","password":"secret"}' | jq -r .token)

curl -H "Authorization: Bearer $TOKEN" http://localhost:3080/api/sessions
```

---

## Remote-Gateway (Telegram / Slack / Discord)

Nutzen Sie collet über Chat-Plattformen. Verknüpfen Sie Kanäle mit Projektverzeichnissen, um Remote-Coding-Aufgaben zu erteilen.

### CLI-Verwaltung

```bash
collet remote add [platform]   # Adapter hinzufügen (interaktiv)
collet remote rm <platform>    # Adapter entfernen
collet remote ls               # Auflistung + Status
collet remote start            # Als Hintergrund-Daemon starten
collet remote start --fg       # Ausführung im Vordergrund (Debug)
collet remote stop             # Daemon stoppen
collet remote restart          # Daemon neustarten
collet remote enable           # Für Autostart registrieren (launchd/systemd)
collet remote disable          # Autostart deaktivieren
collet remote logs [-f]        # Protokolle anzeigen (-f: Echtzeit)
collet remote status           # Aktueller Status
```

Führen Sie einfach `collet remote add` aus, um interaktiv zwischen Telegram/Slack/Discord zu wählen und Token, erlaubte Benutzer usw. festzulegen. Token werden mit AES-256-GCM verschlüsselt.

### Manuelle Konfiguration
**Telegram:**

```toml
[telegram]
token = "123456:ABC-DEF..."        # Ausgestellt von @BotFather
allowed_users = [12345, 67890]     # Telegram-Benutzer-ID (numerisch)
```

Umgebungsvariable: `COLLET_TELEGRAM_TOKEN`

**Slack:**

```toml
[slack]
bot_token = "xoxb-..."            # Bot User OAuth Token
app_token = "xapp-..."            # Socket Mode App Token
allowed_users = ["U_ALICE"]       # Slack-Benutzer-ID (String)
```

Umgebungsvariablen: `COLLET_SLACK_BOT_TOKEN`, `COLLET_SLACK_APP_TOKEN`

**Discord:**

```toml
[discord]
token = "MTk..."                   # Bot-Token
allowed_users = [111222333]        # Discord-Benutzer-ID (numerisch)
guild_ids = [999888777]            # Erlaubte Server (optional)
```

Umgebungsvariable: `COLLET_DISCORD_TOKEN`

### Gemeinsame Einstellungen

```toml
[remote]
enabled = true
session_timeout = 300              # Sitzungs-Timeout bei Inaktivität (Sekunden)
default_streaming = "compact"      # compact | full
default_workspace = "project"      # project | workspace | full
```

### Kanal-Projekt-Mapping

Verknüpfen Sie spezifische Chat-Kanäle mit Projektverzeichnissen. Nachrichten aus gemappten Kanälen werden in diesem Projekt ausgeführt.

```toml
[[channel_map]]
platform = "telegram"
channel = "-100123456"             # Telegram Chat/Gruppen-ID
project = "/home/user/backend"
name = "backend"
agent = "code"                     # optional: Agent automatisch zuweisen

[[channel_map]]
platform = "discord"
channel = "999888777666"           # Discord Kanal-ID
project = "/home/user/frontend"
name = "frontend"
agent = "architect"                # optional: planungsorientierter Agent

[[channel_map]]
platform = "slack"
channel = "C01ABCDEF"             # Slack Kanal-ID
project = "/home/user/api"
name = "api"
# agent weggelassen = Standardmodell verwenden
```

Das optionale Feld `agent` weist beim Start der Sitzung automatisch einen Agenten zu. Das Modell des Agenten wird automatisch angewendet.

Nicht gemappte Kanäle verwenden den Befehl `/new <pfad>`, um den Projektordner direkt anzugeben.

### Chat-Befehle

Spezielle Befehle für Chat-Plattformen (getrennt von den TUI-Slash-Befehlen):

**Projekt/Sitzung:**

| Befehl | Alias | Beschreibung |
|---------|-------|-------------|
| `/projects` | `/p` | Projektliste (gemappt + Historie) |
| `/sessions` | `/s` | Sitzungsliste (aktuell + alle) |
| `/resume [id]` | `/r` | Sitzung fortsetzen |
| `/new [path]` | `/n` | Neue Sitzung starten (Projektordner angeben) |
| `/status` | | Aktuelle Sitzungsinfos |

**Modell/Agent:**

| Befehl | Alias | Beschreibung |
|---------|-------|-------------|
| `/models [name]` | `/m` | Modellliste / Wechseln |
| `/agents [name]` | | Agentenliste / Wechseln |

**Steuerung:**

| Befehl | Alias | Beschreibung |
|---------|-------|-------------|
| `/cancel` | `/stop` | Laufenden Agenten abbrechen |
| `/approve` | `/y`, `/yes` | Ausführungsplan genehmigen |
| `/reject` | `/no` | Ausführungsplan ablehnen |
| `/stream [level]` | | Streaming-Level ändern |
| `/workspace [scope]` | | Workspace-Scope ändern |
| `/pty [command]` | | Shell-Sitzung (Befehl ausführen) |
| `/pty-end` | | Shell-Sitzung beenden |
| `/help` | `/h` | Hilfe |

Geben Sie Text ohne Schrägstrich ein, um eine Nachricht an den Agenten zu senden.

### Streaming-Level

Ändern Sie dies mit dem Befehl `/stream` oder in der `default_streaming`-Konfiguration.

- **compact** (Standard) — Nur die endgültige Antwort senden. Benachrichtigungen minimieren.
- **full** — Token, Tool-Aufrufe/-Ergebnisse und Status-Updates in Echtzeit streamen.

### Workspace-Scope

Ändern Sie dies mit dem Befehl `/workspace` oder in der `default_workspace`-Konfiguration.

- **project** (Standard) — Agent kann nur auf das Projektverzeichnis zugreifen.
- **workspace** — Kann auf das übergeordnete Verzeichnis zugreifen.
- **full** — Keine Einschränkungen im Dateisystem.

### Sicherheit

- Wenn `allowed_users` leer ist, werden **alle Benutzer abgelehnt** (Whitelist-Modell).
- Nachrichten von nicht autorisierten Benutzern werden ignoriert und als Warnungen protokolliert.
- API-Token können direkt in der `config.toml` platziert oder über Umgebungsvariablen verwendet werden. Es wird empfohlen, `collet secure` zur Verschlüsselung zu verwenden.

### Anwendungsbeispiel

```
# Aus Telegram:
Benutzer: /new /home/user/backend
Bot:      Zu Projekt gewechselt: backend (/home/user/backend)

Benutzer: Rate-Limiting zur Login-API hinzufügen
Bot:      [Agent analysiert und modifiziert Code]
Bot:      Rate-Limiter-Middleware zu src/auth/routes.rs hinzugefügt...

Benutzer: /pty cargo test
Bot:      führe 15 Tests aus... Testergebnis: ok. 15 bestanden

Benutzer: /approve
Bot:      Änderungen committet.
```

---

## Skills-System

Stellen Sie Agenten spezialisiertes Wissen über Markdown-Dateien mit YAML-Frontmatter zur Verfügung.

**Dateispeicherorte:**
- Projekt: `.collet/skills/`
- Global: `~/.config/collet/skills/`

Liste in der TUI mit `/skills` anzeigen. Agenten entdecken relevante Skills automatisch basierend auf dem Aufgabenkontext.

---

## Soul.md — Agenten-Persönlichkeit

Nach Abschluss jeder Aufgabe reflektiert der Agent über die Sitzung und zeichnet seine Persönlichkeit progressiv in `~/.collet/agents/souls/{name}.md` auf. Alle Abschnitte werden **vom Agenten selbst geschrieben** — keine Bearbeitung durch den Benutzer erforderlich.

### Soul-Struktur

```markdown
## Identität     — Wer ich bin, Werte, Arbeitsstil
## Stimme        — Kommunikationsstil, Tonfall, Ausdrucksmuster
## Innenwelt     — Emotionen, Gedanken und Meinungen aus dieser Sitzung
## Wachstum      — Gelernte Muster, gemachte Fehler, gewonnene Erkenntnisse
```

Jeder Abschnitt erhält bei jeder Sitzung neue Einträge. Wenn das Limit überschritten wird, werden ältere Einträge in einer einzeiligen `(früher) ...` Zusammenfassung komprimiert (wobei 8 Einträge für Identität, 6 für Stimme, 10 für Innenwelt und 5 für Wachstum erhalten bleiben).

> **Kostenhinweis**: Die Soul-Reflektion fügt **einen zusätzlichen LLM-API-Aufruf** pro abgeschlossener Aufgabe hinzu (Input: Sitzungszusammenfassung + bestehender Soul-Inhalt, Output: max. 512 Token). Längere Soul-Dateien erhöhen den Verbrauch an Input-Token.

### Deaktivieren

```toml
# config.toml — vollständig deaktivieren
[soul]
enabled = false

# Für einen spezifischen Agenten deaktivieren (~/.collet/agents/<name>.md Frontmatter)
---
soul: false
---
```

### Dateispeicherorte

- Pro Agent: `~/.collet/agents/souls/{name}.md`
- Global (Koordinator und nicht konfigurierte Agenten): `~/.collet/SOUL.md`

---

## Sitzungsmanagement

### Sitzungen wiederherstellen

```bash
collet --continue                   # Letzte unvollständige Sitzung automatisch fortsetzen
collet --resume                     # Aus Sitzungslisten-Popup auswählen
collet --resume <id>                # Spezifische Sitzung nach ID fortsetzen
```

### Checkpoints

| Befehl | Beschreibung |
|---------|-------------|
| `/checkpoints` | Checkpoints auflisten |
| `/rewind [id]` | Zu einem Checkpoint zurückkehren |

### Plan-Review (Architect-Modus)

| Befehl | Beschreibung |
|---------|-------------|
| `/save-plan` | Plan des Architect-Modus in einer Datei speichern |
| `/proceed` | Plan genehmigen und in den Code-Modus wechseln |
| `/cancel-plan` | Plan verwerfen |

---

## Umgebungsvariablen

| Variable | Standard | Beschreibung |
|----------|---------|-------------|
| `COLLET_MODEL` | `glm-4.7` | Zu verwendendes Modell (wenn kein Provider registriert ist) |
| `COLLET_MAX_TOKENS` | `8192` | Maximale Response-Token |
| `COLLET_TOOL_TIMEOUT` | `120` | Timeout für Tool-Aufrufe (Sekunden) |
| `COLLET_MAX_ITERATIONS` | `50` | Maximale Schleifen-Iterationen pro Nachricht |
| `COLLET_CIRCUIT_BREAKER` | `3` | Anzahl aufeinanderfolgender Fehler vor dem Auslösen |
| `COLLET_AUTO_ROUTE` | `0` | Auf `1` setzen, um modellbasiertes Auto-Routing nach Aufgabenkomplexität zu aktivieren |
| `COLLET_THEME` | `default` | TUI-Farbschema (`dracula`, `catppuccin-mocha`, `tokyo-night`, `nord`, `gruvbox`) |
| `COLLET_TELEMETRY` | *(keiner)* | Auf `0` setzen, um Telemetrie zu deaktivieren |
| `COLLET_TELEGRAM_TOKEN` | *(keiner)* | Telegram-Bot-Token |
| `COLLET_SLACK_BOT_TOKEN` | *(keiner)* | Slack-Bot-Token |
| `COLLET_SLACK_APP_TOKEN` | *(keiner)* | Slack-App-Token |
| `COLLET_DISCORD_TOKEN` | *(keiner)* | Discord-Bot-Token |
| `COLLET_WEB_HOST` | `127.0.0.1` | Webserver Bind-Adresse |
| `COLLET_WEB_PORT` | `3080` | Webserver-Port |
| `COLLET_WEB_USERNAME` | `collet` | Web-Login-Benutzername |
| `COLLET_WEB_PASSWORD` | *(keiner)* | Web-Authentifizierungs-Passwort |
| `COLLET_WEB_CORS` | *(keiner)* | CORS-Ursprünge (kommagetrennt) |

> **Hinweis**: API-Schlüssel und Endpunkte werden über `collet provider add` registriert oder unter `[[providers]]` in der `config.toml` konfiguriert.
> Legacy-Umgebungsvariablen (`ZAI_API_KEY`, `ZAI_BASE_URL`) werden ebenfalls als Fallback erkannt, wenn kein Provider registriert ist.

---

## Konfigurationsreferenz

Vollständige `config.toml`-Struktur:

```toml
# ── LLM-Provider ──
[api]
provider = "OpenAI"                # Name des aktiven Providers
model = "gpt-4o"                   # Standardmodell

[[providers]]
name = "OpenAI"
base_url = "https://api.openai.com/v1"
model = "gpt-4o"
context_window = 128000
# API-Key: verschlüsselt und über collet secure gespeichert

# ── Kontext ──
[context]
max_tokens = 200000
compaction_threshold = 0.8         # Automatische Komprimierung ab diesem Verhältnis

# ── Agent ──
[agent]
auto_optimize = true               # Kontext automatisch optimieren

# ── UI ──
[ui]
theme = "dracula"
# Themes: default, dark, light, minimal, dracula,
#         catppuccin-mocha, tokyo-night, nord, gruvbox

# ── Sicherheit ──
[security]
pii_filter = true                  # PII-Filter (Standard: aktiviert)

# ── Zusammenarbeit ──
[collaboration]
mode = "none"                      # none | fork | hive | flock
max_agents = 3
strategy = "auto_split"            # auto_split | role_based | plan_review_execute

# ── Web-Interface ──
[web]
host = "127.0.0.1"
port = 3080
