> **Remarque :** Ce document a été traduit par une IA et peut ne pas être précis à 100 %. Si vous constatez des erreurs ou si vous avez des suggestions d'amélioration, veuillez ouvrir un ticket sur GitHub.

# Guide de l'utilisateur Collet

Manuel d'utilisation complet pour collet — l'orchestrateur de codage agentique acharné.

---

## Table des matières

1. [Référence CLI](#référence-cli)
2. [Utilisation de la TUI](#utilisation-de-la-tui)
3. [Configuration multi-fournisseurs](#configuration-multi-fournisseurs)
4. [Serveurs MCP](#serveurs-mcp)
5. [Intelligence du code](#intelligence-du-code)
6. [Collaboration multi-agents](#collaboration-multi-agents)
7. [Interface Web](#interface-web)
8. [Passerelle distante (Telegram / Slack / Discord)](#passerelle-distante-telegram--slack--discord)
9. [Système de compétences (Skills System)](#système-de-compétences)
10. [Soul.md — Personnalité de l'agent](#soulmd--personnalité-de-lagent)
11. [Gestion des sessions](#gestion-des-sessions)
12. [Variables d'environnement](#variables-denvironnement)
13. [Référence de configuration](#référence-de-configuration)
14. [Chemins de stockage des fichiers](#chemins-de-stockage-des-fichiers)
15. [Confidentialité et télémétrie](#confidentialité-et-télémétrie)
16. [Moteur d'évolution](#moteur-dévolution)
17. [Système de plugins](#système-de-plugins)

---

## Référence CLI

### Commandes de base

```bash
collet                              # TUI interactive
collet "fix the bug in main.rs"     # Mode sans tête (s'exécute puis s'arrête)
collet --continue                   # Restaurer la dernière session incomplète
collet --resume                     # Sélectionner dans la liste des sessions
collet --model glm-5                # Outrepasser le modèle
```

### Sous-commandes

```bash
collet setup                        # Créer le fichier de configuration (enregistrer plusieurs fournisseurs)
collet secure                       # Chiffrer et stocker la clé API
collet unsecure                     # Supprimer les identifiants chiffrés
collet status                       # Vérifier la configuration actuelle
collet update                       # Vérifier la dernière version
collet --version                    # Afficher la version
collet help | -h | --help           # Aide
```

### Gestion des fournisseurs

```bash
collet provider add                 # Ajouter un fournisseur (UI de sélection de modèle recommandée)
collet provider add openai          # Ajouter un fournisseur spécifique directement
collet provider list                # Lister les fournisseurs enregistrés
collet provider use <name>          # Changer de fournisseur actif
```

Fournisseurs pris en charge : Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, Custom

> Ollama et LM Studio sont des serveurs locaux et ne nécessitent pas de clé API.

### Gestion MCP

```bash
collet mcp                          # Vérifier la configuration du serveur MCP
collet mcp add <name> -c <cmd>      # Ajouter un serveur MCP
collet mcp remove <name>            # Supprimer un serveur MCP
```

### Drapeaux CLI (Flags)

| Drapeau | Court | Description |
|---------|-------|-------------|
| `--dir <path>` | `-d` | Spécifier le répertoire de travail (chemin du projet) |
| `--continue` | `-c` | Reprise automatique de la dernière session incomplète |
| `--resume` | `-r` | Sélectionner dans la fenêtre contextuelle de la liste des sessions |
| `--resume <id>` | `-r <id>` | Reprendre une session spécifique par ID |
| `--model <name>` | | Outrepasser le modèle |
| `--yolo` | | Validation automatique, ignorer les confirmations |
| `--watch` | | Réexécuter lors des modifications de fichiers |
| `--ext <exts>` | | Extensions cibles à surveiller (séparées par des virgules) |
| `--debounce <ms>` | | Délai de surveillance (par défaut : 2000) |
| `--cwd <path>` | | Répertoire de surveillance (par défaut : emplacement actuel) |
| `--agent <name>` | `-a` | Utiliser un agent personnalisé |
| `--fast` | `-f` | Mode rapide : pas de barre latérale, pas de swarm, pas de réflexion âme |

### Mode sans tête (Headless Mode)

```bash
collet "fix the login bug"                    # Exécuter dans le répertoire actuel
collet "fix the login bug" -d ~/projects/api  # Exécuter dans un projet différent
collet "lint this" --yolo                     # Validation automatique, ignorer les confirmations
collet "lint this" --fast                    # Mode rapide : surcharge minimale
```

### Mode Surveillance (Détection des modifications de fichiers)

```bash
# Utilisation de base
collet "lint this" --watch --ext rs,toml --debounce 500

# Surveiller uniquement un répertoire spécifique
collet "run tests" --watch --cwd ./src --ext rs

# Utiliser un agent personnalisé
collet "review changes" --watch --agent reviewer --ext ts,tsx
```

Se réexécute automatiquement lorsque les fichiers changent.

**Cas d'utilisation :**

| Scénario | Commande |
|----------|---------|
| Surveiller un sous-répertoire spécifique | `--watch --cwd ./packages/core` |
| Détecter les modifications des fichiers de config | `--watch --cwd ./config --ext yaml,toml` |
| Corriger automatiquement les scripts CI | `--watch --cwd .github --ext yml` |
| Formater automatiquement la documentation | `--watch --cwd ./docs --ext md` |
| Linting rapide avec un modèle léger | `--watch --agent fast --ext ts` |

---

## Utilisation de la TUI

### Raccourcis clavier

**Navigation**

| Touche | Action |
|--------|--------|
| `Entrée` | Envoyer le message |
| `Maj+Entrée` / `Ctrl+J` | Nouvelle ligne (saisie multiligne) |
| `↑` / `↓` | Multiligne : se déplacer entre les lignes / Ligne unique : naviguer dans l'historique |
| `Maj+↑/↓` | Faire défiler la sortie |
| `PgUp` / `PgDn` | Défilement rapide |
| `Tab` / `Maj+Tab` | Changer d'agent vers l'avant / l'arrière |
| `Ctrl+C` | En cours : annuler la tâche / Inactif : appuyer deux fois pour quitter |
| `Esc` | En cours : annuler (appuyer deux fois) / Fermer la fenêtre contextuelle |

**Édition de texte**

| Touche | Action |
|--------|--------|
| `Ctrl+A` / `Cmd+←` | Aller au début de la ligne |
| `Ctrl+E` / `Cmd+→` | Aller à la fin de la ligne |
| `Ctrl+←` / `Ctrl+→` | Déplacer le mot vers la gauche / la droite |
| `Alt+←` / `Alt+→` / `Alt+B` / `Alt+F` | Déplacer le mot vers la gauche / la droite (macOS Option+Flèche) |
| `Retour arrière` | Supprimer le caractère avant le curseur |
| `Suppr` | Supprimer le caractère après le curseur |
| `Ctrl+W` / `Alt+Retour arrière` | Supprimer le mot avant le curseur |
| `Ctrl+Retour arrière` | Supprimer le mot avant le curseur (Linux / Windows) |
| `Cmd+Retour arrière` | Supprimer jusqu'au début de la ligne (terminaux macOS, protocole Kitty) |
| `Ctrl+U` | Supprimer jusqu'au début de la ligne (toutes plateformes) |
| `Ctrl+K` | Supprimer jusqu'à la fin de la ligne |

### Agents intégrés

Collet est livré avec quatre agents intégrés. Basculez entre eux avec `Tab` / `Maj+Tab`.

| Agent | Rôle |
|-------|------|
| **Arbor** (par défaut) | Orchestrateur entièrement autonome — décide automatiquement du mode agent unique ou essaim par tâche. Pas de fenêtre contextuelle, aucune configuration requise. |
| **Architect** | Agent de conception et de planification. Produit un plan structuré, puis propose `/proceed` → Code ou `/save-plan` pour enregistrer. |
| **Code** | Agent de codage par défaut pour les tâches d'implémentation. |
| **Ask** | Agent de conversation / questions-réponses sans accès aux outils. |

> **Astuce** : Lorsque Arbor est actif, votre tâche est automatiquement routée vers le mode d'exécution optimal (Fork / Hive / Flock / agent unique). Pour les autres agents, votre sélection est toujours honorée comme agent principal.

### Commandes Slash (/)

| Commande | Description |
|----------|-------------|
| `/help` | Aide |
| `/clear` | Réinitialiser la conversation |
| `/compact` | Compactage manuel du contexte |
| `/cost` | Statistiques d'utilisation des jetons |
| `/diff` | Modifications Git |
| `/sdiff` | Diff côte à côte |
| `/undo` | Annuler le dernier commit |
| `/models [name]` | Ouvrir le sélecteur de modèle ou changer de modèle directement (change tout le contexte du fournisseur) |
| `Tab` / `Maj+Tab` | Changer d'agent (cycle parmi les agents configurés) |
| `/search <query>` | Recherche par pertinence BM25 |
| `/rewind [id]` | Revenir à un point de contrôle (checkpoint) |
| `/checkpoints` | Lister les points de contrôle |
| `/web <url>` | Récupérer le contenu de l'URL |
| `/resume` | Fenêtre contextuelle des sessions récentes — triées par date, sélectionner pour restaurer |
| `/theme [name]` | Changer le thème de couleur (6 options : default, dracula, catppuccin-mocha, tokyo-night, nord, gruvbox) |
| `/save-plan` | Enregistrer le plan du mode Architect dans un fichier |
| `/proceed` | Approuver le plan Architect et passer en mode Code |
| `/cancel-plan` | Abandonner le plan Architect |
| `/fork` | Branchement d'agents parallèles |
| `/hive` | Collaboration basée sur le consensus |
| `/flock` | Multi-agent en temps réel |
| `/mcp` | Gérer les serveurs MCP (espace : on/off, a : ajouter, d : supprimer) |
| `/skills` | Lister les compétences (skills) |
| `/agents` | Afficher les sous-agents actifs |
| `/optimize` | Optimiser le contexte |
| `/bench` | Tableau de bord des performances |
| `/debug` | Activer/désactiver l'overlay de débogage |
| `/telemetry` | Vérifier l'état de la télémétrie et les éléments collectés |
| `/quit` | Quitter |

> **Saisie semi-automatique** : Tapez `/` pour ouvrir la fenêtre contextuelle de commande. Les commandes intégrées et les **compétences** découvertes apparaissent dans la même liste, classées par score de correspondance floue. Appuyez sur `↑`/`↓` pour naviguer, `Tab` pour développer avec l'indice d'argument, `Entrée` pour confirmer.

### Passage de commandes shell

Préfixez toute commande shell par `!` pour l'exécuter directement dans le répertoire de travail sans quitter la TUI :

```
! git log --oneline -5
! cargo test
! ls src/
```

Le code de sortie, stdout et stderr sont affichés sous forme de bloc de code dans le chat. Utile pour des vérifications rapides sans changer de terminal.

### Mentions @

| Motif | Action |
|-------|--------|
| `@src/main.rs` | Joindre le contenu du fichier au contexte |
| `@src` | Joindre la structure de l'arborescence des dossiers (3 niveaux, 200 éléments) |
| `@Makefile` | Détection automatique du fichier/dossier par rapport au répertoire actuel |
| `@glm-5` | Changer l'agent pour le modèle spécifié |

> **Saisie semi-automatique** : Tapez `@` pour ouvrir la fenêtre contextuelle de mention. Les noms d'agents utilisent la **correspondance floue** — notation de sous-séquence avec des bonus pour les limites de mots et les correspondances consécutives. Les noms de fichiers/dossiers utilisent la correspondance de préfixe avec navigation dans les sous-répertoires (`@src/` liste le contenu de `src/`).

### Outils de l'agent

| Outil | Description |
|-------|-------------|
| `bash` | Exécuter des commandes shell (avec protection contre les délais d'attente) |
| `file_read` | Lire un fichier avec les numéros de ligne |
| `file_write` | Créer/écraser un fichier |
| `file_edit` | Remplacement précis de chaîne (Édition chirurgicale) |
| `git_patch` | Appliquer des correctifs basés sur des fragments (hunks) |
| `search` | Recherche de code basée sur ripgrep |
| `skill` | Charger une compétence d'agent (progressive à 3 niveaux) |
| `subagent` | Exécuter une sous-tâche dans un contexte isolé |

### Disposition de la TUI (Layout)

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

## Configuration multi-fournisseurs

Plusieurs fournisseurs de LLM peuvent être enregistrés et permutés en temps réel à l'aide de la commande `/models`.

### Enregistrement des fournisseurs

```bash
collet provider add          # Assistant interactif (sélectionner dans la liste de modèles recommandés)
collet provider add openai   # Ajouter un fournisseur spécifique directement
```

### Exemple config.toml

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

### Configuration hiérarchique (Global < Modèle < Agent)

Priorité de configuration : `env/[agent]` → `[[models]]` → `[[agents.list]]`

```toml
# Surcharges par défaut par modèle
[[models]]
name = "gpt-4o"
context_window = 128000
max_output_tokens = 16384
supports_tools = true

[[models]]
name = "qwen2.5-coder"
supports_tools = false
reasoning_effort = "medium"     # low | medium | high

# Surcharges par agent (priorité la plus élevée)
[[agents.list]]
name = "code"
model = "gpt-4o"
provider = "openai"              # Le fournisseur change également lors de la bascule via Tab/Maj+Tab
temperature = 0.2

[[agents.list]]
name = "architect"
model = "gpt-4o"
provider = "openai"
temperature = 0.7
thinking_budget_tokens = 8192    # Prime sur reasoning_effort

[[agents.list]]
name = "local"
model = "qwen2.5-coder"
provider = "ollama"              # Passer au fournisseur local
```

L'omission du champ `provider` conserve le fournisseur actuellement actif et ne change que le modèle.

### Champs de surcharge

Les valeurs par défaut du profil de modèle peuvent être surchargées dans `[[models]]` et `[[agents.list]]` :

| Champ | Type | Description |
|-------|------|-------------|
| `temperature` | `f32` | Température d'échantillonnage (automatiquement omise pour les modèles de raisonnement) |
| `thinking_budget_tokens` | `u32` | Budget de jetons de raisonnement (prime sur reasoning_effort) |
| `reasoning_effort` | `string` | Intensité du raisonnement : `"low"`, `"medium"`, `"high"` |
| `supports_tools` | `bool` | Si l'appel d'outils est pris en charge |
| `supports_reasoning` | `bool` | Si les jetons de raisonnement/pensée sont pris en charge |
| `context_window` | `usize` | Taille de la fenêtre de contexte |
| `max_output_tokens` | `u32` | Jetons de sortie maximum |
| `max_iterations` | `u32` | Itérations maximales de l'agent |

Tous les champs sont facultatifs ; lorsqu'ils sont omis, les valeurs sont déterminées automatiquement à partir du profil de modèle intégré.

### Basculement à l'exécution

Dans la TUI, utilisez la commande `/models` pour ouvrir le sélecteur de fournisseur/modèle enregistré. La sélection d'une entrée change simultanément les paramètres `base_url`, `api_key` et la prise en charge des outils.

```
/models              # Ouvrir la fenêtre contextuelle du sélecteur de fournisseur/modèle
/models gpt-4o       # Changer de modèle directement
```

---

## Serveurs MCP

Connectez des serveurs [Model Context Protocol](https://modelcontextprotocol.io) pour étendre les outils de l'agent.

### Ajout de serveurs

```bash
# Depuis un paquet npm
/mcp add npm:@anthropic/mcp-server-filesystem

# Binaire local
/mcp add local:/path/to/server --name myserver

# Point de terminaison HTTP
/mcp add http:https://api.example.com/mcp

# Ajouter globalement (tous les projets)
/mcp add npm:@some/tool --global
```

### Gestion des serveurs

```bash
/mcp enable myserver
/mcp disable myserver
/mcp remove myserver
```

L'état du serveur peut être vérifié dans la barre latérale (commande `/mcp` pour bascule interactive — espace : on/off, a : ajouter, d : supprimer).

### Fichier de configuration

`.collet/mcp.json` (projet) ou `~/.collet/mcp.json` (global) :

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

**Formats pris en charge :**
- `command` : chaîne ou tableau (`["npx", "-y", "pkg"]` → divisé automatiquement)
- `env` / `environment` : variables d'environnement (`${VAR}` substitué automatiquement)
- `headers` : en-têtes d'authentification HTTP
- `type`, `enabled` : champs de compatibilité (ignorés)

---

## Intelligence du code

Fonctionne automatiquement sans configuration supplémentaire.

1. **Indexation** — Au démarrage, Tree-sitter analyse les sources et extrait les symboles (fonctions, types, constantes). Seuls les fichiers modifiés sont retraités à l'aide du hachage BLAKE3.
2. **Auto-injection** — Analyse les messages de l'utilisateur ; pour les questions liées au code, trouve les fichiers pertinents à l'aide de BM25 et les injecte automatiquement dans le contexte.
3. **Réduction de grep** — Informe l'agent que la base de code est pré-indexée, réduisant ainsi les appels inutiles à `grep`/`find`.

Langages pris en charge : Rust, Python, TypeScript, JavaScript, Go, Java, C/C++, Ruby, PHP, Swift, Kotlin, et plus de 35 autres. La détection automatique des serveurs LSP active le survol, l'accès à la définition et la recherche de références.

Recherche manuelle : Exécutez une recherche BM25 directement dans la TUI avec `/search <query>`.

---

## Collaboration multi-agents

Hiérarchie : **Fork** < **Hive** < **Flock** (les niveaux supérieurs incluent les fonctionnalités des niveaux inférieurs)

| Mode | Fonctionnement | Idéal pour |
|------|-------------|----------|
| Fork | Le coordinateur divise le travail → exécution parallèle → fusion des résultats | Sous-tâches indépendantes |
| Hive | Vote de consensus entre les agents, supervision du coordinateur | Prise de décision complexe |
| Flock | Messagerie en temps réel d'agent à agent (expérimental) | Collaboration étroitement couplée |

### Configuration

Dans `config.toml` :

```toml
[collaboration]
mode = "hive"           # none | fork | hive | flock
max_agents = 3
strategy = "auto_split" # auto_split | role_based | plan_review_execute
```

Ou basculez par session dans la TUI via `/fork`, `/hive`, `/flock`.

---

## Interface Web

Utilisez collet dans votre navigateur. Frontend SvelteKit + backend Axum.

### Construction et exécution

```bash
# Construire (nécessite le flag de fonctionnalité web)
cargo build --release --features web

# Exécuter
collet web                    # http://127.0.0.1:3080
collet web -p 8080            # Changer le port
collet web --host 0.0.0.0     # Autoriser l'accès externe
collet web --password secret  # Activer l'authentification
```

### Options CLI

| Option | Par défaut | Environnement | Description |
|--------|---------|-------------|-------------|
| `--host, -h` | `127.0.0.1` | `COLLET_WEB_HOST` | Adresse de liaison |
| `--port, -p` | `3080` | `COLLET_WEB_PORT` | Port de liaison |
| `--username, -u` | `collet` | `COLLET_WEB_USERNAME` | Nom d'utilisateur de connexion |
| `--password` | *(aucun)* | `COLLET_WEB_PASSWORD` | Mot de passe d'authentification |
| `--cors` | *(aucun)* | `COLLET_WEB_CORS` | Origines CORS autorisées (séparées par des virgules) |

Peut également être configuré via `config.toml` :

```toml
[web]
host = "0.0.0.0"
port = 3080
username = "collet"
cors_origins = "http://localhost:5173"
# le mot de passe est chiffré et enregistré via collet secure --web
```

### Authentification

Lorsque `--password` est défini, l'authentification basée sur des jetons est activée :

```
1. POST /api/auth/login  →  {"username": "collet", "password": "secret"}
2. Réponse : {"token": "abc123..."}
3. Requêtes suivantes : Authorization: Bearer abc123...
4. Connexion SSE : GET /api/events?token=abc123...
```

Sans mot de passe défini, l'accès est disponible sans authentification. `/api/health` et `/api/auth/status` sont toujours publics.

### Points de terminaison de l'API (Endpoints)

**Base :**

| Méthode | Chemin | Description |
|--------|------|-------------|
| `POST` | `/api/message` | Envoyer un message à l'agent `{"message": "...", "mode": "code"}` |
| `GET` | `/api/events` | Flux SSE (événements de l'agent en temps réel) |
| `GET` | `/api/health` | État, version, activité de l'agent |
| `GET` | `/api/config` | Modèle actuel, infos de contexte |

**Sessions :**

| Méthode | Chemin | Description |
|--------|------|-------------|
| `GET` | `/api/sessions` | Liste des sessions |
| `GET` | `/api/sessions/{id}` | Détails de la session + instantané de la conversation |
| `DELETE` | `/api/sessions/{id}` | Supprimer la session |

**Fichiers et projets :**

| Méthode | Chemin | Description |
|--------|------|-------------|
| `GET` | `/api/files?path=src` | Liste des répertoires |
| `GET` | `/api/files/src/main.rs` | Lire le contenu d'un fichier |
| `GET` | `/api/projects` | Liste des projets |
| `POST` | `/api/projects/switch` | Changer le répertoire de travail |
| `GET` | `/api/search?q=pattern&glob=*.rs` | Recherche de code |
| `GET` | `/api/symbols` | Infos sur les symboles RepoMap |
| `GET` | `/api/tools` | Liste des outils disponibles |

### Événements SSE

Connectez-vous à `/api/events` pour recevoir l'activité de l'agent en temps réel :

| Événement | Données | Description |
|-----------|---------|-------------|
| `token` | `{"text": "..."}` | Jeton de flux (streaming token) |
| `response` | `{"text": "..."}` | Réponse complète |
| `tool_call` | `{"name": "bash", "args": "..."}` | Appel d'outil démarré |
| `tool_result` | `{"name": "bash", "result": "...", "success": true}` | Résultat de l'exécution de l'outil |
| `file_modified` | `{"path": "src/main.rs"}` | Notification de modification de fichier |
| `status` | `{"iteration", "prompt_tokens", ...}` | Métriques de jetons/temps |
| `error` | `{"message": "..."}` | Erreur |
| `done` | `{}` | Tâche de l'agent terminée |

Événements du mode Hive/Flock : `hive_agent_started`, `hive_agent_progress`, `hive_agent_done`, `hive_conflict`, `hive_done`

### Exemple d'utilisation : curl

```bash
# Vérifier l'état
curl http://localhost:3080/api/health

# Envoyer un message (sans authentification)
curl -X POST http://localhost:3080/api/message \
  -H "Content-Type: application/json" \
  -d '{"message": "fix the login bug", "mode": "code"}'

# Recevoir le flux SSE
curl -N http://localhost:3080/api/events

# Avec authentification
TOKEN=$(curl -s -X POST http://localhost:3080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"collet","password":"secret"}' | jq -r .token)

curl -H "Authorization: Bearer $TOKEN" http://localhost:3080/api/sessions
```

---

## Passerelle distante (Telegram / Slack / Discord)

Utilisez collet à partir des plateformes de messagerie. Associez des canaux à des répertoires de projet pour émettre des tâches de codage à distance.

### Gestion CLI

```bash
collet remote add [platform]   # Ajouter un adaptateur (interactif)
collet remote rm <platform>    # Supprimer l'adaptateur
collet remote ls               # Liste + état
collet remote start            # Démarrer en tant que démon d'arrière-plan
collet remote start --fg       # Exécution au premier plan (débogage)
collet remote stop             # Arrêter le démon
collet remote restart          # Redémarrer le démon
collet remote enable           # Enregistrer pour le démarrage auto (launchd/systemd)
collet remote disable          # Désactiver le démarrage auto
collet remote logs [-f]        # Voir les journaux (-f : temps réel)
collet remote status           # État actuel
```

Exécutez simplement `collet remote add` pour choisir interactivement entre Telegram/Slack/Discord et définir le jeton, les utilisateurs autorisés, etc. Les jetons sont chiffrés avec AES-256-GCM.

### Configuration manuelle
**Telegram :**

```toml
[telegram]
token = "123456:ABC-DEF..."        # Délivré par @BotFather
allowed_users = [12345, 67890]     # ID utilisateur Telegram (numérique)
```

Variable d'environnement : `COLLET_TELEGRAM_TOKEN`

**Slack :**

```toml
[slack]
bot_token = "xoxb-..."            # Bot User OAuth Token
app_token = "xapp-..."            # Socket Mode App Token
allowed_users = ["U_ALICE"]       # ID utilisateur Slack (chaîne)
```

Variables d'environnement : `COLLET_SLACK_BOT_TOKEN`, `COLLET_SLACK_APP_TOKEN`

**Discord :**

```toml
[discord]
token = "MTk..."                   # Bot Token
allowed_users = [111222333]        # ID utilisateur Discord (numérique)
guild_ids = [999888777]            # Serveurs autorisés (optionnel)
```

Variable d'environnement : `COLLET_DISCORD_TOKEN`

### Paramètres communs

```toml
[remote]
enabled = true
session_timeout = 300              # Délai d'expiration de session inactive (secondes)
default_streaming = "compact"      # compact | full
default_workspace = "project"      # project | workspace | full
```

### Mappage canal-projet

Connectez des canaux de discussion spécifiques à des répertoires de projet. Les messages provenant de canaux mappés s'exécutent dans ce projet.

```toml
[[channel_map]]
platform = "telegram"
channel = "-100123456"             # ID chat/groupe Telegram
project = "/home/user/backend"
name = "backend"
agent = "code"                     # optionnel : assigner automatiquement l'agent

[[channel_map]]
platform = "discord"
channel = "999888777666"           # ID canal Discord
project = "/home/user/frontend"
name = "frontend"
agent = "architect"                # optionnel : agent axé sur la planification

[[channel_map]]
platform = "slack"
channel = "C01ABCDEF"             # ID canal Slack
project = "/home/user/api"
name = "api"
# agent omis = utiliser le modèle par défaut
```

Le champ optionnel `agent` assigne automatiquement un agent au démarrage de la session. Le modèle de l'agent est appliqué automatiquement.

Les canaux non mappés utilisent la commande `/new <path>` pour spécifier directement le dossier du projet.

### Commandes de chat

Commandes dédiées aux plateformes de chat (distinctes des commandes slash de la TUI) :

**Projet/Session :**

| Commande | Alias | Description |
|----------|-------|-------------|
| `/projects` | `/p` | Liste des projets (mappés + historique) |
| `/sessions` | `/s` | Liste des sessions (actuelle + toutes) |
| `/resume [id]` | `/r` | Reprendre une session |
| `/new [path]` | `/n` | Démarrer une nouvelle session (spécifier le dossier du projet) |
| `/status` | | Infos sur la session actuelle |

**Modèle/Agent :**

| Commande | Alias | Description |
|----------|-------|-------------|
| `/models [name]` | `/m` | Liste des modèles / changer |
| `/agents [name]` | | Liste des agents / changer |

**Contrôle :**

| Commande | Alias | Description |
|----------|-------|-------------|
| `/cancel` | `/stop` | Annuler l'agent en cours |
| `/approve` | `/y`, `/yes` | Approuver le plan d'exécution |
| `/reject` | `/no` | Rejeter le plan d'exécution |
| `/stream [level]` | | Changer le niveau de flux (streaming) |
| `/workspace [scope]` | | Changer la portée de l'espace de travail |
| `/pty [command]` | | Session shell (exécuter une commande) |
| `/pty-end` | | Terminer la session shell |
| `/help` | `/h` | Aide |

Tapez du texte sans slash pour envoyer un message à l'agent.

### Niveaux de flux (Streaming)

Modifiez avec la commande `/stream` ou la configuration `default_streaming`.

- **compact** (par défaut) — Envoie uniquement la réponse finale. Minimise les notifications.
- **full** — Diffuse les jetons, les appels/résultats d'outils, les mises à jour d'état en temps réel.

### Portée de l'espace de travail (Workspace Scope)

Modifiez avec la commande `/workspace` ou la configuration `default_workspace`.

- **project** (par défaut) — L'agent ne peut accéder qu'au répertoire du projet.
- **workspace** — Peut accéder au répertoire parent.
- **full** — Aucune restriction sur le système de fichiers.

### Sécurité

- Si `allowed_users` est vide, **tous les utilisateurs sont refusés** (modèle de liste blanche).
- Les messages d'utilisateurs non autorisés sont ignorés et enregistrés comme avertissements.
- Les jetons API peuvent être placés directement dans `config.toml` ou utiliser des variables d'environnement. Il est recommandé d'utiliser `collet secure` pour le chiffrement.

### Exemple d'utilisation

```
# Depuis Telegram :
Utilisateur : /new /home/user/backend
Bot :         Passé au projet : backend (/home/user/backend)

Utilisateur : Ajouter la limitation de débit à l'API de connexion
Bot :         [L'agent analyse et modifie le code]
Bot :         Ajout du middleware de limitation de débit à src/auth/routes.rs...

Utilisateur : /pty cargo test
Bot :         exécution de 15 tests... résultat du test : ok. 15 réussis

Utilisateur : /approve
Bot :         Modifications validées (committed).
```

---

## Système de compétences (Skills System)

Fournissez des connaissances spécialisées aux agents via des fichiers markdown avec un frontmatter YAML.

**Emplacements des fichiers :**
- Projet : `.collet/skills/`
- Global : `~/.config/collet/skills/`

Affichez la liste dans la TUI avec `/skills`. Les agents découvrent automatiquement les compétences pertinentes en fonction du contexte de la tâche.

---

## Soul.md — Personnalité de l'agent

Une fois chaque tâche terminée, l'agent réfléchit à la session et enregistre progressivement sa personnalité dans `~/.collet/agents/souls/{name}.md`. Toutes les sections sont **écrites par l'agent lui-même** — aucune modification par l'utilisateur n'est requise.

### Structure de l'âme (Soul)

```markdown
## Identité    — Qui je suis, valeurs, style de travail
## Voix        — Style de communication, ton, motifs d'expression
## Monde intérieur — Émotions, pensées et opinions de cette session
## Croissance  — Modèles appris, erreurs commises, enseignements tirés
```

Chaque section reçoit de nouvelles entrées ajoutées à chaque session. Lorsque la limite est dépassée, les entrées plus anciennes sont compressées dans un résumé sur une seule ligne `(plus tôt) ...` (en conservant 8 entrées pour l'Identité, 6 pour la Voix, 10 pour le Monde intérieur et 5 pour la Croissance).

> **Note sur le coût** : La réflexion de l'âme ajoute **un appel d'API LLM supplémentaire** par achèvement de tâche (entrée : résumé de session + contenu de l'âme existant, sortie : max 512 jetons). Des fichiers d'âme plus longs augmenteront l'utilisation des jetons d'entrée.

### Désactivation

```toml
# config.toml — désactiver entièrement
[soul]
enabled = false

# Désactiver pour un agent spécifique (frontmatter de ~/.collet/agents/<name>.md)
---
soul: false
---
```

### Emplacements des fichiers

- Par agent : `~/.collet/agents/souls/{name}.md`
- Global (coordinateur et agents non configurés) : `~/.collet/SOUL.md`

---

## Gestion des sessions

### Restauration des sessions

```bash
collet --continue                   # Reprise automatique de la dernière session incomplète
collet --resume                     # Sélectionner dans la fenêtre contextuelle de la liste des sessions
collet --resume <id>                # Reprendre une session spécifique par ID
```

### Points de contrôle (Checkpoints)

| Commande | Description |
|----------|-------------|
| `/checkpoints` | Lister les points de contrôle |
| `/rewind [id]` | Revenir à un point de contrôle |

### Révision du plan (Mode Architect)

| Commande | Description |
|----------|-------------|
| `/save-plan` | Enregistrer le plan du mode Architect dans un fichier |
| `/proceed` | Approuver le plan et passer en mode Code |
| `/cancel-plan` | Abandonner le plan |

---

## Variables d'environnement

| Variable | Par défaut | Description |
|----------|------------|-------------|
| `COLLET_MODEL` | `glm-4.7` | Modèle à utiliser (lorsqu'aucun fournisseur n'est enregistré) |
| `COLLET_MAX_TOKENS` | `8192` | Jetons de réponse maximum |
| `COLLET_TOOL_TIMEOUT` | `120` | Délai d'expiration des appels d'outils (secondes) |
| `COLLET_MAX_ITERATIONS` | `50` | Itérations de boucle maximales par message |
| `COLLET_CIRCUIT_BREAKER` | `3` | Nombre d'échecs consécutifs avant déclenchement |
| `COLLET_AUTO_ROUTE` | `0` | Définir à `1` pour activer le routage automatique du modèle basé sur la complexité de la tâche |
| `COLLET_THEME` | `default` | Thème de couleur TUI (`dracula`, `catppuccin-mocha`, `tokyo-night`, `nord`, `gruvbox`) |
| `COLLET_TELEMETRY` | *(aucun)* | Définir à `0` pour désactiver la télémétrie |
| `COLLET_TELEGRAM_TOKEN` | *(aucun)* | Jeton de bot Telegram |
| `COLLET_SLACK_BOT_TOKEN` | *(aucun)* | Jeton de bot Slack |
| `COLLET_SLACK_APP_TOKEN` | *(aucun)* | Jeton d'application Slack |
| `COLLET_DISCORD_TOKEN` | *(aucun)* | Jeton de bot Discord |
| `COLLET_WEB_HOST` | `127.0.0.1` | Adresse de liaison du serveur Web |
| `COLLET_WEB_PORT` | `3080` | Port du serveur Web |
| `COLLET_WEB_USERNAME` | `collet` | Nom d'utilisateur pour la connexion Web |
| `COLLET_WEB_PASSWORD` | *(aucun)* | Mot de passe d'authentification Web |
| `COLLET_WEB_CORS` | *(aucun)* | Origines CORS (séparées par des virgules) |

> **Note** : Les clés API et les points de terminaison sont enregistrés via `collet provider add` ou configurés sous `[[providers]]` dans `config.toml`.
> Les variables d'environnement héritées (`ZAI_API_KEY`, `ZAI_BASE_URL`) sont également reconnues comme solution de repli lorsqu'aucun fournisseur n'est enregistré.

---

## Référence de configuration

Structure complète du `config.toml` :

```toml
# ── Fournisseur de LLM ──
[api]
provider = "OpenAI"                # Nom du fournisseur actif
model = "gpt-4o"                   # Modèle par défaut

[[providers]]
name = "OpenAI"
base_url = "https://api.openai.com/v1"
model = "gpt-4o"
context_window = 128000
# Clé API : chiffrée et enregistrée via collet secure

# ── Contexte ──
[context]
max_tokens = 200000
compaction_threshold = 0.8         # Compactage automatique au-dessus de ce ratio

# ── Agent ──
[agent]
auto_optimize = true               # Optimisation automatique du contexte

# ── UI ──
[ui]
theme = "dracula"
# Thèmes : default, dark, light, minimal, dracula,
#         catppuccin-mocha, tokyo-night, nord, gruvbox

# ── Sécurité ──
[security]
pii_filter = true                  # Filtre PII (par défaut : activé)

# ── Collaboration ──
[collaboration]
mode = "none"                      # none | fork | hive | flock
max_agents = 3
strategy = "auto_split"            # auto_split | role_based | plan_review_execute

# ── Interface Web ──
[web]
host = "127.0.0.1"
port = 3080
