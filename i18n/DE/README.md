> **Hinweis:** Dieses Dokument wurde von einer KI übersetzt und ist möglicherweise nicht zu 100 % genau. Wenn Sie Fehler finden oder Verbesserungsvorschläge haben, eröffnen Sie bitte ein Issue auf GitHub.

# <center>collet</center>

<center>
**Unnachgiebiger agentischer Coding-Orchestrator mit Zero-Drop-Agent-Loops.**

Orchestriert jedes LLM, jeden CLI-Agenten, über TUI, Web und IDE.

Eliminiert das in Node.js-basierten Tools übliche "Stuck"-Problem an der Quelle und liefert hochgradige Code-Intelligenz und präzise Bearbeitung auf dem Sicherheitsfundament von Rust.

[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

## Features

![Features](../../assets/features.jpg)

| Feature | Beschreibung |
|---------|-------------|
| **Multi-Provider** | Verbindung zu verschiedenen LLM-Providern mit SSE-Streaming |
| **Tree-sitter Repo Map** | AST-Symbol-Extraktion für Rust/Python/TypeScript/Go + PageRank-Ranking |
| **BM25 Code Search** | Inkrementelle Indizierung, Code-bewusster Tokenizer, automatische Kontext-Injektion |
| **BLAKE3 Incremental Hashing** | mtime-Vorprüfung + Inhalts-Hash, um nur geänderte Dateien neu zu parsen |
| **Chirurgisches Editieren** | Präzises Ersetzen von Zeichenketten ohne vollständiges Umschreiben der Datei |
| **Agent Skills** | 3-stufiges progressives Skill-System basierend auf YAML-Frontmatter |
| **Subagent** | Parallele Ausführung von Unteraufgaben in isolierten Kontextfenstern |
| **Sitzungspersistenz** | Sitzungswiederherstellung über `--continue` / `--resume` mit automatischer Speicherung |
| **Auto Compaction** | Relevanzbasierte Komprimierung: SimHash-Deduplizierung + bewertete wortgetreue Erhaltung + strukturiertes Summary-Fallback |
| **Stuck-Prävention** | Iterationslimits, Circuit Breaker, Tokio-Timeouts |
| **Themes & Animationen** | 6 Farbthemen (Dracula, Catppuccin, etc.) + Braille-Spinner-Denkanimation |
| **Architect Plan Review** | Benutzergenehmigung für Architect→Code-Übergang erforderlich, mit Unterstützung für den Export von Plandateien |
| **Parallel/Team-Modus** | Aufteilung der Aufgaben → parallele Ausführung → Zusammenführung der Ergebnisse. Team-Modus: Echtzeit-Kommunikation zwischen Agenten + Konsens |
| **LSP/MCP** | 35+ Sprachen, 48+ Server mit automatischem Fallback + MCP-Tool-Integration |
| **Tool Approval Gate** | 3-stufige Genehmigung der Tool-Ausführung (Yolo/Auto/Manual), zur Laufzeit umschaltbar über `Shift+Tab` |
| **RAG-Dokumentsuche** | Lokale Alcove-Dokumente + HTTP Bridge für externe Dienste. Der Agent sucht autonom über das Tool `rag_search`; SharedKnowledge wird im Swarm-Modus automatisch geteilt |
| **Soul.md** | Persistentes Agenten-Persönlichkeitssystem. Der Agent zeichnet Identität, Stimme, Innenwelt und Wachstum selbst auf, um schrittweise einen einzigartigen Charakter aufzubauen. Globaler/pro Agent-Umschalter. **Ein zusätzlicher API-Aufruf pro Aufgabenabschluss** (max. 512 Token) |
| **IDE-Integration** | JetBrains-nativ + VSCode-Erweiterung über ACP-Server |

## Schnellstart

### Anforderungen

- API-Key eines LLM-Providers

### Installation & Ausführung

#### über Homebrew (macOS)

```bash
brew install epicsagas/tap/collet
```

#### über cargo-binstall (am schnellsten - vorkompilierte Binaries)

```bash
cargo binstall collet
```

> Erfordert die vorherige Installation von [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall):
> `cargo install cargo-binstall`

#### Binary herunterladen

Laden Sie die neueste Version von [GitHub Releases](https://github.com/epicsagas/collet/releases) herunter.

### Einrichtung und Ausführung
```bash
collet setup # oder verwenden Sie die Option --advanced für detailliertere Einstellungen

# TUI
collet

# Headless
collet "hallo collet!"
```

## Dokumentation

| Dokument | Beschreibung |
|----------|-------------|
| [QUICKSTART.md](../../QUICKSTART.md) | Schritt-für-Schritt-Schnellstart mit Beispielen |
| [docs/user-guide.md](./user-guide.md) | Vollständiges Benutzerhandbuch — CLI, TUI, Tastenkombinationen, Slash-Befehle, Multi-Provider, MCP, Soul.md |
| [docs/config.md](../../docs/config.md) | `config.toml` vollständige Referenz — Provider, Modelle, Agenten, Telemetrie |
| [CHANGELOG.md](../../CHANGELOG.md) | Versionshistorie und Release-Notes |

## Roadmap

- [x] Phase 1: MVP — API-Connector, TUI, Tool-Framework, Agent-Loop
- [x] Phase 2: Kontext-Persistenz, Journaling, Repo-Map, Smart Compaction
- [x] Phase 3: git-patch Hunk-Editing, Reasoning-Erhaltung, Sitzungswiederherstellung (--continue/--resume)
- [x] Phase 4: Multi-Language Tree-sitter (Python, TS, Go), PageRank-Ranking, LSP/MCP
- [x] Phase 5: Agent Skills, Subagent, @mention (Datei/Ordner/Modell), BM25-Suche
- [x] Phase 6: MCP, LSP, Side-by-side Diff, Prompt-Caching
- [x] Phase 7: 6 Farbthemen, Denkanimation, Architect Plan Review
- [x] Phase 8: Parallel/Team-Modus (Multi-Agent-Orchestrierung, Konsens auf Sitzungsebene, Konflikterkennung)
- [x] Phase 9: Soul.md persistente Persönlichkeit — Aufnahme von Emotionen/Gedanken/Wachstum pro Agent, globaler/pro Agent-Umschalter, Auto-Compaction
- [x] Phase 10: Abschluss des Flock-Modus — Umbenennung in Swarm, RoleBased-Strategie, PlanReviewExecute-Pipeline, Revisionsschleife mit Konsensabstimmung
- [x] Phase 11–28: RAG-Dokumentsuche (Alcove + HTTP Bridge), IDE-Integration (ACP), Remote-Gateways (Telegram/Slack/Discord), Webserver, Auto-Routing, PII-Filter, Optimizer, Multi-Provider-Wizard
- [ ] Phase 29: Härtung von Agent-Loop & Swarm — Zero-Drop-Garantie, adaptive Wiederholung, Verfeinerung des Swarm-Konsenses, Verbesserungen bei der Koordinator/Worker-Planung
- [ ] Phase 30: Modell-Optimizer fortgeschritten — providerbewusstes Kosten/Latenz-Scoring, intelligente Tier-Neuzuweisung beim Hinzufügen/Bearbeiten von Providern, Benchmark-getriebenes Modell-Ranking
- [ ] Phase 31: Web- & Remote-Plattform-Upgrade — Web UI Dashboard v2, Telegram/Slack/Discord UX-Feinschliff, Webhook-Relay, Echtzeit-Swarm-Status-Streaming

## Herkunft & Status

Dieses Projekt begann als persönlicher Spielplatz, um mehr aus GLM-Modellen herauszuholen. Dann führte ein Feature zum nächsten — neue Modelle, Paper und Paradigmen tauchten auf, bevor die vorherigen kalt waren.

> "Neue Modelle, neue Paper, neue Paradigmen — schneller als jedes Commit-Log mithalten kann." — Ein wiederkehrender Albtraum.

**Aktueller Status** — Nutzt sich nun selbst über collet (Dogfooding), frisst seinen eigenen Schwanz.

**Stabilität**: Der Kern des Agent-Loops ist solide. Parallel/Swarm-Ausführung und externe Integrationen stabilisieren sich noch.

## Lizenz

Apache-2.0
