> **Remarque :** Ce document a été traduit par une IA et peut ne pas être précis à 100 %. Si vous constatez des erreurs ou si vous avez des suggestions d'amélioration, veuillez ouvrir un ticket sur GitHub.

# <center>collet</center>

<center>
**Orchestrateur de codage agentique implacable avec des boucles d'agents sans perte.**

Orchestre n'importe quel LLM, n'importe quel agent CLI, à travers le TUI, le web et l'IDE.

Élimine à la source le problème de blocage ("stuck") courant dans les outils basés sur Node.js, offrant une intelligence de code de haut niveau et une édition précise sur la base sécurisée de Rust.

[![CI](https://github.com/epicsagas/collet/actions/workflows/release.yml/badge.svg)](https://github.com/epicsagas/collet/actions/workflows/release.yml)
[![crates.io](https://img.shields.io/crates/v/collet.svg)](https://crates.io/crates/collet)
[![docs.rs](https://docs.rs/collet/badge.svg)](https://docs.rs/collet)
[![crates.io downloads](https://img.shields.io/crates/d/collet.svg)](https://crates.io/crates/collet)
[![Rust](https://img.shields.io/badge/rust-1.78%2B-orange.svg)](https://www.rust-lang.org)
[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

## Fonctionnalités

![Features](../../assets/features.jpg)

| Fonctionnalité | Description |
|---------|-------------|
| **Multi-Provider** | Connecte à divers fournisseurs de LLM avec streaming SSE |
| **Tree-sitter Repo Map** | Extraction de symboles AST pour Rust/Python/TypeScript/Go + classement PageRank |
| **Recherche de code BM25** | Indexation incrémentielle, tokenizer sensible au code, injection automatique de contexte |
| **BLAKE3 Incremental Hashing** | Pré-vérification mtime + hash du contenu pour ne re-parser que les fichiers modifiés |
| **Édition chirurgicale** | Remplacement précis de chaînes de caractères sans réécriture complète du fichier |
| **Compétences d'agent** | Système de compétences progressif à 3 niveaux basé sur le frontmatter YAML |
| **Sous-agent** | Exécution parallèle de sous-tâches dans des fenêtres de contexte isolées |
| **Persistance de session** | Restauration de session via `--continue` / `--resume` avec sauvegarde automatique |
| **Compactage automatique** | Compression basée sur la pertinence : déduplication SimHash + préservation textuelle scorée + repli sur résumé structuré |
| **Prévention du blocage** | Limites d'itération, disjoncteurs (circuit breakers), timeouts Tokio |
| **Thèmes & Animations** | 6 thèmes de couleurs (Dracula, Catppuccin, etc.) + animation de réflexion en Braille |
| **Révision de plan Architect** | Approbation de l'utilisateur requise pour la transition Architect→Code, avec support d'exportation de fichier de plan |
| **Mode Parallèle/Équipe** | Division des tâches → exécution parallèle → fusion des résultats. Mode Équipe : communication inter-agents en temps réel + consensus |
| **LSP/MCP** | Plus de 35 langues, plus de 48 serveurs avec repli automatique + intégration d'outils MCP |
| **Barrière d'approbation d'outils** | Approbation d'exécution d'outils à 3 niveaux (Yolo/Auto/Manuel), commutable à l'exécution via `Shift+Tab` |
| **Recherche de documents RAG** | Documents locaux Alcove + services externes HTTP Bridge. L'agent cherche de manière autonome via l'outil `rag_search` ; SharedKnowledge partagé automatiquement en mode Swarm |
| **Soul.md** | Système de personnalité d'agent persistant. L'agent enregistre lui-même les sections Identité, Voix, Monde Intérieur et Croissance pour construire progressivement un caractère unique. Commutateur global/par agent. **Un appel API supplémentaire par achèvement de tâche** (max 512 tokens) |
| **Intégration IDE** | Natif JetBrains + extension VSCode via le serveur ACP |

## Démarrage Rapide

### Prérequis

- Rust 1.78+ (Edition 2024)
- Clé API d'un fournisseur de LLM

### Installation & Exécution

#### via Homebrew (macOS)

```bash
brew install epicsagas/tap/collet
```

#### via cargo-binstall (le plus rapide - binaires pré-construits)

```bash
cargo binstall collet
```

> Nécessite l'installation préalable de [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall) :
> `cargo install cargo-binstall`

#### via crates.io

```bash
cargo install collet
```

#### À partir des sources

```bash
git clone https://github.com/epicsagas/collet.git
cd collet
cargo install --path .
```

### Configuration et Exécution
```bash
collet setup # ou utilisez l'option --advanced pour des réglages plus détaillés

# TUI
collet

# Headless
collet "hello collet!"
```

## Documentation

| Document | Description |
|----------|-------------|
| [QUICKSTART.md](../../QUICKSTART.md) | Démarrage rapide étape par étape avec des exemples |
| [docs/user-guide.md](./user-guide.md) | Manuel d'utilisation complet — CLI, TUI, raccourcis clavier, commandes slash, multi-fournisseur, MCP, Soul.md |
| [docs/config.md](../../docs/config.md) | Référence complète de `config.toml` — fournisseurs, modèles, agents, télémétrie |
| [CHANGELOG.md](../../CHANGELOG.md) | Historique des versions et notes de mise à jour |

## Recherche

La construction de collet a nécessité d'approfondir des problèmes qui n'ont pas encore de réponses évidentes — de la cohérence des agents à longue durée d'exécution sur des centaines de tours, au fonctionnement réel de la limitation de débit multi-fournisseur, en passant par le moment où le parallélisme multi-agents aide et celui où il ne fait qu'ajouter du bruit.

Les analyses de recherche et d'ingénierie derrière ces décisions sont publiées sous la forme d'une série de rapports autonomes :

| Rapport | Sujet |
|--------|-------|
| [Agent Loop](../../docs/research/agent-loop.md) | Moteur d'exécution, système de garde, bugs de fiabilité des flux, pipeline de compactage |
| [Systèmes Multi-Agents](../../docs/research/multi-agent.md) | Modes Fork/Hive/Flock, tableau de bord SharedKnowledge, analyse des goulots d'étranglement, modèles de coordination |
| [Gestion du Contexte](../../docs/research/context-management.md) | Stratégies de compactage, mise en cache des prompts, efficacité des tokens, enquête sur l'industrie |
| [Architecture Multi-Fournisseur](../../docs/research/multi-provider.md) | Divergences d'API compatibles OpenAI, limitation de débit, conception de SDK de fournisseur |
| [TUI & UX](../../docs/research/tui-ux.md) | Évaluation de l'UX, gestion du curseur multi-octets, intégration de l'interface Web |
| [Analyse comparative & Évaluation](../../docs/research/benchmark-eval.md) | Benchmarks de modèles/modes, évaluation polyglotte, recherche sur la productivité |
| [Moteur d'Évolution](../../docs/research/evolution-engine.md) | Boucle d'auto-amélioration, A-Evolve (arXiv:2602.00359), conception de cycle en 7 étapes |
| [Contrôle à distance & Pont multi-machines](../../docs/research/remote.md) | Passerelles distantes, collaboration d'agents multi-machines, intégration ACP/IDE |

## Infos de Build

| Élément | Valeur |
|------|-------|
| Langage | Rust (Edition 2024) |
| Fichiers sources | 176 |
| Lignes de code | ~65 000 |
| Tests | 959 |
| Binaire de release | ~40 Mo (arm64) |

## Feuille de route

- [x] Phase 1 : MVP — Connecteur API, TUI, framework d'outils, boucle d'agent
- [x] Phase 2 : Persistance du contexte, journalisation, carte du dépôt, compactage intelligent
- [x] Phase 3 : Édition de morceaux git-patch, préservation du raisonnement, restauration de session (--continue/--resume)
- [x] Phase 4 : Tree-sitter multi-langues (Python, TS, Go), classement PageRank, LSP/MCP
- [x] Phase 5 : Compétences d'agent, Sous-agent, @mention (fichier/dossier/modèle), recherche BM25
- [x] Phase 6 : MCP, LSP, Diff côte à côte, mise en cache des prompts
- [x] Phase 7 : 6 thèmes de couleurs, animation de réflexion, révision du plan Architect
- [x] Phase 8 : Mode parallèle/équipe (orchestration multi-agents, consensus au niveau de la session, détection de conflits)
- [x] Phase 9 : Personnalité persistante Soul.md — enregistrement de l'émotion/pensée/croissance par agent, bascule globale/par agent, auto-compactage
- [x] Phase 10 : Finalisation du mode Flock — renommage en Swarm, stratégie RoleBased, pipeline PlanReviewExecute, boucle de révision avec vote par consensus
- [x] Phase 11–28 : Recherche de documents RAG (Alcove + HTTP Bridge), intégration IDE (ACP), passerelles distantes (Telegram/Slack/Discord), serveur Web, routage automatique, filtre PII, Optimiseur, assistant multi-fournisseur
- [ ] Phase 29 : Renforcement de la boucle d'agent & du swarm — garantie de perte zéro, tentative adaptative, affinement du consensus du swarm, améliorations de la planification coordinateur/travailleur
- [ ] Phase 30 : Optimiseur de modèle avancé — notation du coût/latence par fournisseur, réaffectation intelligente des niveaux lors de l'ajout/modification d'un fournisseur, classement des modèles basé sur les benchmarks
- [ ] Phase 31 : Mise à niveau de la plateforme Web & distante — tableau de bord Web UI v2, peaufinage de l'UX Telegram/Slack/Discord, relais de webhook, streaming du statut du swarm en temps réel

## Origine & Statut

Ce projet a commencé comme un terrain de jeu personnel pour tirer davantage parti des modèles GLM. Puis une fonctionnalité en a entraîné une autre — de nouveaux modèles, articles et paradigmes n'ont cessé d'arriver avant que les précédents ne soient froids.

> "Nouveaux modèles, nouveaux articles, nouveaux paradigmes — plus vite que n'importe quel journal de commit ne peut suivre." — Un cauchemar récurrent.

**État actuel** — Se nourrit désormais de lui-même via collet, mange sa propre queue.

**Stabilité** : La boucle d'agent centrale est solide. L'exécution parallèle/en essaim et les intégrations externes sont encore en cours de stabilisation.

## Licence

Apache-2.0
