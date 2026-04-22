> **注意：** このドキュメントは AI によって翻訳されており、100% 正確ではない可能性があります。エラーを見つけた場合や改善の提案がある場合は、GitHub で issue を作成してください。

# Collet ユーザーガイド

妥協なきエージェント型コーディング・オーケストレーター「collet」の完全ユーザーマニュアル。

---

## 目次

1. [CLI リファレンス](#cli-リファレンス)
2. [TUI の使用方法](#tui-の使用方法)
3. [マルチプロバイダー設定](#マルチプロバイダー設定)
4. [MCP サーバー](#mcp-サーバー)
5. [コード・インテリジェンス (Code Intelligence)](#コード・インテリジェンス)
6. [マルチエージェント協力](#マルチエージェント協力)
7. [Web インターフェース](#web-インターフェース)
8. [リモート・ゲートウェイ (Telegram / Slack / Discord)](#リモート・ゲートウェイ-telegram--slack--discord)
9. [スキル・システム (Skills System)](#スキル・システム)
10. [Soul.md — エージェントの人格](#soulmd--エージェントの人格)
11. [セッション管理](#セッション管理)
12. [環境変数](#環境変数)
13. [設定リファレンス](#設定リファレンス)
14. [ファイル保存パス](#ファイル保存パス)
15. [プライバシーとテレメトリ](#プライバシーとテレメトリ)
16. [進化エンジン (Evolution Engine)](#進化エンジン)
17. [プラグイン・システム](#プラグイン・システム)

---

## CLI リファレンス

### 基本コマンド

```bash
collet                              # インタラクティブ TUI
collet "main.rs のバグを修正して"     # ヘッドレス (実行して終了)
collet --continue                   # 最後の中断されたセッションを復旧
collet --resume                     # セッションリストから選択
collet --model glm-5                # モデルをオーバーライド
```

### サブコマンド

```bash
collet setup                        # 設定ファイルを作成 (複数のプロバイダーを登録)
collet secure                       # API キーを暗号化して保存
collet unsecure                     # 暗号化された資格情報を削除
collet status                       # 現在の設定を確認
collet update                       # 最新バージョンの確認
collet --version                    # バージョン表示
collet help | -h | --help           # ヘルプ
```

### プロバイダー管理 (Provider Management)

```bash
collet provider add                 # プロバイダーを追加 (推奨モデル選択 UI)
collet provider add openai          # 特定のプロバイダーを直接追加
collet provider list                # 登録済みプロバイダーを表示
collet provider use <name>          # アクティブなプロバイダーを切り替え
```

サポートされているプロバイダー: Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, カスタム

> Ollama と LM Studio はローカルサーバーであり、API キーは不要です。

### MCP 管理

```bash
collet mcp                          # MCP サーバー設定を確認
collet mcp add <name> -c <cmd>      # MCP サーバーを追加
collet mcp remove <name>            # MCP サーバーを削除
```

### CLI フラグ (Flags)

| フラグ | 短縮形 | 説明 |
|------|-------|-------------|
| `--dir <path>` | `-d` | 作業ディレクトリを指定 (プロジェクトパス) |
| `--continue` | `-c` | 最後の中断されたセッションを自動再開 |
| `--resume` | `-r` | セッションリストのポップアップから選択 |
| `--resume <id>` | `-r <id>` | ID を指定して特定のセッションを再開 |
| `--model <name>` | | モデルをオーバーライド |
| `--yolo` | | 自動コミット、確認をスキップ |
| `--watch` | | ファイル変更時に再実行 |
| `--ext <exts>` | | 監視対象の拡張子 (カンマ区切り) |
| `--debounce <ms>` | | 監視のデバウンス (デフォルト: 2000) |
| `--cwd <path>` | | 監視ディレクトリ (デフォルト: 現在の場所) |
| `--agent <name>` | `-a` | カスタムエージェントを使用 |
| `--fast` | `-f` | 高速モード：サイドバーなし、スウォームなし、ソウル反思なし |

### ヘッドレス・モード (Headless Mode)

```bash
collet "ログインのバグを修正"                    # 現在のディレクトリで実行
collet "ログインのバグを修正" -d ~/projects/api  # 別のプロジェクトで実行
collet "lint this" --yolo                     # 自動コミット、確認をスキップ
collet "lint this" --fast                    # 高速モード：最小オーバーヘッド
```

### ウォッチ・モード (Watch Mode - ファイル変更検知)

```bash
# 基本的な使用方法
collet "lint this" --watch --ext rs,toml --debounce 500

# 特定のディレクトリのみを監視
collet "run tests" --watch --cwd ./src --ext rs

# カスタムエージェントを使用
collet "review changes" --watch --agent reviewer --ext ts,tsx
```

ファイルが変更されると自動的に再実行されます。

**ユースケース:**

| シナリオ | コマンド |
|----------|---------|
| 特定のサブディレクトリを監視 | `--watch --cwd ./packages/core` |
| 設定ファイルの変更を検知 | `--watch --cwd ./config --ext yaml,toml` |
| CI スクリプトを自動修正 | `--watch --cwd .github --ext yml` |
| ドキュメントを自動フォーマット | `--watch --cwd ./docs --ext md` |
| 軽量モデルで高速に lint | `--watch --agent fast --ext ts` |

---

## TUI の使用方法

### キーバインド

**ナビゲーション**

| キー | アクション |
|-----|--------|
| `Enter` | メッセージ送信 |
| `Shift+Enter` / `Ctrl+J` | 改行 (複数行入力) |
| `↑` / `↓` | 複数行: 行間移動 / 単一行: 履歴を移動 |
| `Shift+↑/↓` | 出力をスクロール |
| `PgUp` / `PgDn` | 高速スクロール |
| `Tab` / `Shift+Tab` | エージェントを順方向 / 逆方向に切り替え |
| `Ctrl+C` | 実行中: タスクをキャンセル / アイドル中: 2回押して終了 |
| `Esc` | 実行中: キャンセル (2回押す) / ポップアップを閉じる |

**テキスト編集**

| キー | アクション |
|-----|--------|
| `Ctrl+A` / `Cmd+←` | 行頭へ移動 |
| `Ctrl+E` / `Cmd+→` | 行末へ移動 |
| `Ctrl+←` / `Ctrl+→` | 単語ごとに左 / 右へ移動 |
| `Alt+←` / `Alt+→` / `Alt+B` / `Alt+F` | 単語ごとに左 / 右へ移動 (macOS Option+Arrow) |
| `Backspace` | カーソル前の文字を削除 |
| `Delete` | カーソル後の文字を削除 |
| `Ctrl+W` / `Alt+Backspace` | カーソル前の単語を削除 |
| `Ctrl+Backspace` | カーソル前の単語を削除 (Linux / Windows) |
| `Cmd+Backspace` | 行頭まで削除 (macOS, Kitty プロトコル対応端末) |
| `Ctrl+U` | 行頭まで削除 (全プラットフォーム) |
| `Ctrl+K` | 行末まで削除 |

### 内蔵エージェント

Collet には 4 つの内蔵エージェントが含まれています。`Tab` / `Shift+Tab` で切り替えられます。

| エージェント | 役割 |
|-------|------|
| **Arbor** (デフォルト) | 完全に自律的なオーケストレーター — タスクごとに単一エージェントか Swarm (群れ) モードかを自動的に判断。ポップアップや設定は不要。 |
| **Architect** | 設計と計画のエージェント。構造化されたプランを提示し、`/proceed` → Code か `/save-plan` でプラン保存を提案。 |
| **Code** | 実装タスク用のデフォルト・コーディング・エージェント。 |
| **Ask** | ツールへのアクセス権を持たない、対話 / 質問回答用エージェント。 |

> **ヒント**: Arbor がアクティブな場合、タスクは自動的に最適な実行モード (Fork / Hive / Flock / 単一エージェント) にルーティングされます。他のエージェントについては、常に選択したものがメインエージェントとして尊重されます。

### スラッシュコマンド (Slash Commands)

| コマンド | 説明 |
|---------|-------------|
| `/help` | ヘルプ |
| `/clear` | 会話をリセット |
| `/compact` | 手動コンテキスト圧縮 |
| `/cost` | トークン使用統計 |
| `/diff` | Git の変更 |
| `/sdiff` | サイドバイサイド (並列) diff |
| `/undo` | 最後のコミットを元に戻す |
| `/models [name]` | モデルピッカーを開くか、直接モデルを切り替える (プロバイダーのコンテキスト全体を切り替え) |
| `Tab` / `Shift+Tab` | エージェントの切り替え (設定済みエージェントを巡回) |
| `/search <query>` | BM25 関連性検索 |
| `/rewind [id]` | チェックポイントに戻る |
| `/checkpoints` | チェックポイントを一覧表示 |
| `/web <url>` | URL のコンテンツを取得 |
| `/resume` | 最近のセッション・ポップアップ — 最新順に並んでおり、選択して復元可能 |
| `/theme [name]` | カラーテーマの変更 (6 つのオプション: default, dracula, catppuccin-mocha, tokyo-night, nord, gruvbox) |
| `/save-plan` | Architect モードのプランをファイルに保存 |
| `/proceed` | Architect プランを承認し、Code モードに切り替え |
| `/cancel-plan` | Architect プランを破棄 |
| `/fork` | 並列エージェント分岐 |
| `/hive` | コンセンサスベースの協力 |
| `/flock` | リアルタイム・マルチエージェント |
| `/mcp` | MCP サーバーを管理 (スペース: オン/オフ, a: 追加, d: 削除) |
| `/skills` | スキルを一覧表示 |
| `/agents` | アクティブなサブエージェントを表示 |
| `/optimize` | コンテキストを最適化 |
| `/bench` | パフォーマンス・ダッシュボード |
| `/debug` | デバッグ・オーバーレイの切り替え |
| `/telemetry` | テレメトリのステータスと収集項目を確認 |
| `/quit` | 終了 |

> **オートコンプリート**: `/` を入力してコマンド・ポップアップを開きます。内蔵コマンドと発見された**スキル (skills)** の両方が同じリストに表示され、曖昧一致スコア順に並びます。`↑`/`↓` で移動、`Tab` で引数のヒントを展開、`Enter` で確定します。

### シェル・パススルー (Shell Passthrough)

シェルコマンドの前に `!` を付けることで、TUI を離れずに作業ディレクトリで直接実行できます：

```
! git log --oneline -5
! cargo test
! ls src/
```

終了コード、標準出力、標準エラーがチャット内にコードブロックとして表示されます。ターミナルを切り替えずに素早く確認したい場合に便利です。

### @ メンション (@ Mentions)

| パターン | アクション |
|---------|--------|
| `@src/main.rs` | ファイル内容をコンテキストに添付 |
| `@src` | フォルダ・ツリー構造を添付 (3 階層、200 項目) |
| `@Makefile` | 作業ディレクトリ (cwd) からの相対パスでファイル/フォルダを自動検知 |
| `@glm-5` | 指定したモデルにエージェントを切り替え |

> **オートコンプリート**: `@` を入力してメンション・ポップアップを開きます。エージェント名は**曖昧一致**（単語の境界や連続一致にボーナスを加えた部分列スコアリング）を使用します。ファイル/フォルダ名は前方一致（前方一致検索）を使用し、サブディレクトリの移動もサポートします（`@src/` は `src/` の内容をリストアップ）。

### エージェント・ツール (Agent Tools)

| ツール | 説明 |
|------|-------------|
| `bash` | シェルコマンドを実行 (タイムアウト保護付き) |
| `file_read` | 行番号付きでファイルを読み込む |
| `file_write` | ファイルを作成/上書きする |
| `file_edit` | 精密な文字列置換 (外科的編集) |
| `git_patch` | ハンクベースのパッチを適用 |
| `search` | ripgrep ベースのコード検索 |
| `skill` | エージェント・スキルをロード (3 段階プログレッシブ) |
| `subagent` | 分離されたコンテキストでサブタスクを実行 |

### TUI レイアウト (Layout)

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

## マルチプロバイダー設定 (Multi-Provider Configuration)

複数の LLM プロバイダーを登録でき、`/models` コマンドを使用してリアルタイムで切り替え可能です。

### プロバイダーの登録

```bash
collet provider add          # インタラクティブ・ウィザード (推奨モデルリストから選択)
collet provider add openai   # 特定のプロバイダーを直接追加
```

### config.toml の例

```toml
[api]
provider = "openai"

# providers = 資格情報のみ (モデルの動作は [[models]] と [[agents.list]] で設定)
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

### 階層設定 (Global < Model < Agent)

設定の優先順位: `env/[agent]` → `[[models]]` → `[[agents.list]]`

```toml
# モデルごとのデフォルト・オーバーライド
[[models]]
name = "gpt-4o"
context_window = 128000
max_output_tokens = 16384
supports_tools = true

[[models]]
name = "qwen2.5-coder"
supports_tools = false
reasoning_effort = "medium"     # low | medium | high

# エージェントごとのオーバーライド (最優先)
[[agents.list]]
name = "code"
model = "gpt-4o"
provider = "openai"              # Tab/Shift+Tab で切り替える際、プロバイダーも切り替わります
temperature = 0.2

[[agents.list]]
name = "architect"
model = "gpt-4o"
provider = "openai"
temperature = 0.7
thinking_budget_tokens = 8192    # reasoning_effort より優先されます

[[agents.list]]
name = "local"
model = "qwen2.5-coder"
provider = "ollama"              # ローカル・プロバイダーに切り替え
```

`provider` フィールドを省略すると、現在アクティブなプロバイダーを維持し、モデルのみを変更します。

### オーバーライド・フィールド (Override Fields)

デフォルトのモデル・プロファイルの値は、`[[models]]` および `[[agents.list]]` でオーバーライドできます：

| フィールド | 型 | 説明 |
|-------|------|-------------|
| `temperature` | `f32` | サンプリング温度 (推論モデルでは自動的に省略) |
| `thinking_budget_tokens` | `u32` | 推論トークン予算 (reasoning_effort より優先) |
| `reasoning_effort` | `string` | 推論の強さ: `"low"`, `"medium"`, `"high"` |
| `supports_tools` | `bool` | ツール呼び出しをサポートするかどうか |
| `supports_reasoning` | `bool` | 推論/思考トークンをサポートするかどうか |
| `context_window` | `usize` | コンテキスト・ウィンドウ・サイズ |
| `max_output_tokens` | `u32` | 最大出力トークン数 |
| `max_iterations` | `u32` | エージェントの最大反復回数 |

すべてのフィールドはオプションです。省略した場合、値は内蔵のモデル・プロファイルから自動的に決定されます。

### 実行時の切り替え

TUI で `/models` コマンドを使用して、登録済みプロバイダー/モデルのピッカーを開きます。エントリを選択すると、base_url、api_key、ツールサポートの設定が一度に切り替わります。

```
/models              # プロバイダー/モデル・ピッカー・ポップアップを開く
/models gpt-4o       # モデルを直接切り替える
```

---

## MCP サーバー (MCP Servers)

[Model Context Protocol](https://modelcontextprotocol.io) サーバーを接続して、エージェント・ツールを拡張します。

### サーバーの追加

```bash
# npm パッケージから
/mcp add npm:@anthropic/mcp-server-filesystem

# ローカル・バイナリ
/mcp add local:/path/to/server --name myserver

# HTTP エンドポイント
/mcp add http:https://api.example.com/mcp

# グローバルに追加 (全プロジェクト)
/mcp add npm:@some/tool --global
```

### サーバーの管理

```bash
/mcp enable myserver
/mcp disable myserver
/mcp remove myserver
```

サーバーのステータスはサイドバーで確認できます（`/mcp` コマンドでインタラクティブに切り替え — スペース: オン/オフ, a: 追加, d: 削除）。

### 設定ファイル

`.collet/mcp.json` (プロジェクト) または `~/.collet/mcp.json` (グローバル):

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

**サポートされている形式:**
- `command`: 文字列または配列 (`["npx", "-y", "pkg"]` → 自動的に分割)
- `env` / `environment`: 環境変数 (`${VAR}` は自動的に置換)
- `headers`: HTTP 認証ヘッダー
- `type`, `enabled`: 互換性フィールド (無視されます)

---

## コード・インテリジェンス (Code Intelligence)

追加のセットアップなしで自動的に動作します。

1. **インデックス作成** — 起動時、Tree-sitter がソースを解析し、シンボル (関数、型、定数) を抽出します。変更されたファイルのみが BLAKE3 ハッシュを使用して再処理されます。
2. **自動注入** — ユーザー・メッセージを分析します。コードに関連する質問の場合、BM25 を使用して関連するファイルを見つけ、自動的にコンテキストに注入します。
3. **grep の削減** — コードベースがあらかじめインデックス化されていることをエージェントに通知し、不要な `grep`/`find` の呼び出しを減らします。

サポートされている言語: Rust, Python, TypeScript, JavaScript, Go, Java, C/C++, Ruby, PHP, Swift, Kotlin および他 35 言語以上。LSP サーバーの自動検知により、ホバー、定義へ移動、参照検索が可能になります。

手動検索: TUI で `/search <query>` を実行して BM25 検索を直接行えます。

---

## マルチエージェント協力 (Multi-Agent Collaboration)

階層: **Fork** < **Hive** < **Flock** (上位層は下位の機能を含みます)

| モード | 動作方法 | 最適な用途 |
|------|-------------|----------|
| Fork | コーディネーターが作業を分割 → 並列実行 → 結果をマージ | 独立したサブタスク |
| Hive | エージェント間のコンセンサス投票、コーディネーターの監視 | 複雑な意思決定 |
| Flock | リアルタイムのエージェント間メッセージング (実験的) | 密に結合した協力 |

### 設定

`config.toml` 内:

```toml
[collaboration]
mode = "hive"           # none | fork | hive | flock
max_agents = 3
strategy = "auto_split" # auto_split | role_based | plan_review_execute
```

または TUI で `/fork`, `/hive`, `/flock` を使用してセッションごとに切り替えます。

---

## Web インターフェース (Web Interface)

ブラウザで collet を使用します。SvelteKit フロントエンド + Axum バックエンド。

### ビルドと実行

```bash
# ビルド (web 機能フラグが必要)
cargo build --release --features web

# 実行
collet web                    # http://127.0.0.1:3080
collet web -p 8080            # ポートを変更
collet web --host 0.0.0.0     # 外部アクセスを許可
collet web --password secret  # 認証を有効化
```

### CLI オプション

| オプション | デフォルト | 環境変数 | 説明 |
|--------|---------|-------------|-------------|
| `--host, -h` | `127.0.0.1` | `COLLET_WEB_HOST` | バインド・アドレス |
| `--port, -p` | `3080` | `COLLET_WEB_PORT` | バインド・ポート |
| `--username, -u` | `collet` | `COLLET_WEB_USERNAME` | ログイン・ユーザー名 |
| `--password` | *(なし)* | `COLLET_WEB_PASSWORD` | 認証パスワード |
| `--cors` | *(なし)* | `COLLET_WEB_CORS` | CORS 許可オリジン (カンマ区切り) |

`config.toml` 経由でも設定可能です：

```toml
[web]
host = "0.0.0.0"
port = 3080
username = "collet"
cors_origins = "http://localhost:5173"
# password は collet secure --web を通じて暗号化・保存されます
```

### 認証

`--password` が設定されている場合、トークンベースの認証が有効になります：

```
1. POST /api/auth/login  →  {"username": "collet", "password": "secret"}
2. レスポンス: {"token": "abc123..."}
3. 以降のリクエスト: Authorization: Bearer abc123...
4. SSE 接続: GET /api/events?token=abc123...
```

パスワードが設定されていない場合、認証なしでアクセス可能です。`/api/health` および `/api/auth/status` は常に公開されます。

### API エンドポイント

**基本:**

| メソッド | パス | 説明 |
|--------|------|-------------|
| `POST` | `/api/message` | エージェントにメッセージを送信 `{"message": "...", "mode": "code"}` |
| `GET` | `/api/events` | SSE ストリーム (リアルタイム・エージェント・イベント) |
| `GET` | `/api/health` | ステータス、バージョン、エージェント・アクティビティ |
| `GET` | `/api/config` | 現在のモデル、コンテキスト情報 |

**セッション (Sessions):**

| メソッド | パス | 説明 |
|--------|------|-------------|
| `GET` | `/api/sessions` | セッション一覧 |
| `GET` | `/api/sessions/{id}` | セッション詳細 + 会話スナップショット |
| `DELETE` | `/api/sessions/{id}` | セッションの削除 |

**ファイルとプロジェクト:**

| メソッド | パス | 説明 |
|--------|------|-------------|
| `GET` | `/api/files?path=src` | ディレクトリ・リスティング |
| `GET` | `/api/files/src/main.rs` | ファイル内容の読み込み |
| `GET` | `/api/projects` | プロジェクト一覧 |
| `POST` | `/api/projects/switch` | 作業ディレクトリの切り替え |
| `GET` | `/api/search?q=pattern&glob=*.rs` | コード検索 |
| `GET` | `/api/symbols` | RepoMap シンボル情報 |
| `GET` | `/api/tools` | 利用可能なツール一覧 |

### SSE イベント (SSE Events)

`/api/events` に接続してリアルタイムのエージェント・アクティビティを受信します：

| イベント | データ | 説明 |
|-------|------|-------------|
| `token` | `{"text": "..."}` | ストリーミング・トークン |
| `response` | `{"text": "..."}` | 最終レスポンス |
| `tool_call` | `{"name": "bash", "args": "..."}` | ツール呼び出し開始 |
| `tool_result` | `{"name": "bash", "result": "...", "success": true}` | ツール実行結果 |
| `file_modified` | `{"path": "src/main.rs"}` | ファイル変更通知 |
| `status` | `{"iteration", "prompt_tokens", ...}` | トークン/タイミング・メトリクス |
| `error` | `{"message": "..."}` | エラー |
| `done` | `{}` | エージェント・タスク完了 |

Hive/Flock モード・イベント: `hive_agent_started`, `hive_agent_progress`, `hive_agent_done`, `hive_conflict`, `hive_done`

### 使用例: curl

```bash
# ステータス確認
curl http://localhost:3080/api/health

# メッセージ送信 (認証なし)
curl -X POST http://localhost:3080/api/message \
  -H "Content-Type: application/json" \
  -d '{"message": "ログインのバグを修正", "mode": "code"}'

# SSE ストリームの受信
curl -N http://localhost:3080/api/events

# 認証あり
TOKEN=$(curl -s -X POST http://localhost:3080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"collet","password":"secret"}' | jq -r .token)

curl -H "Authorization: Bearer $TOKEN" http://localhost:3080/api/sessions
```

---

## リモート・ゲートウェイ (Telegram / Slack / Discord)

チャット・プラットフォームから collet を使用します。チャンネルをプロジェクト・ディレクトリにマッピングして、リモート・コーディング・タスクを発行します。

### CLI 管理

```bash
collet remote add [platform]   # アダプターを追加 (対話形式)
collet remote rm <platform>    # アダプターを削除
collet remote ls               # リスト + ステータス
collet remote start            # バックグラウンド・デーモンとして起動
collet remote start --fg       # フォアグラウンド実行 (デバッグ用)
collet remote stop             # デーモンを停止
collet remote restart          # デーモンを再起動
collet remote enable           # 自動起動に登録 (launchd/systemd)
collet remote disable          # 自動起動を無効化
collet remote logs [-f]        # ログを表示 (-f: リアルタイム)
collet remote status           # 現在のステータス
```

`collet remote add` を実行するだけで、Telegram/Slack/Discord を対話的に選択し、トークンや許可ユーザーなどを設定できます。トークンは AES-256-GCM で暗号化されます。

### 手動設定

**Telegram:**

```toml
[telegram]
token = "123456:ABC-DEF..."        # @BotFather から発行
allowed_users = [12345, 67890]     # Telegram ユーザー ID (数値)
```

環境変数: `COLLET_TELEGRAM_TOKEN`

**Slack:**

```toml
[slack]
bot_token = "xoxb-..."            # Bot User OAuth Token
app_token = "xapp-..."            # Socket Mode App Token
allowed_users = ["U_ALICE"]       # Slack ユーザー ID (文字列)
```

環境変数: `COLLET_SLACK_BOT_TOKEN`, `COLLET_SLACK_APP_TOKEN`

**Discord:**

```toml
[discord]
token = "MTk..."                   # Bot Token
allowed_users = [111222333]        # Discord ユーザー ID (数値)
guild_ids = [999888777]            # 許可サーバー (オプション)
```

環境変数: `COLLET_DISCORD_TOKEN`

### 共通設定

```toml
[remote]
enabled = true
session_timeout = 300              # アイドル・セッション・タイムアウト (秒)
default_streaming = "compact"      # compact | full
default_workspace = "project"      # project | workspace | full
```

### チャンネル・プロジェクト・マッピング (Channel-Project Mapping)

特定のチャット・チャンネルをプロジェクト・ディレクトリに接続します。マッピングされたチャンネルからのメッセージはそのプロジェクトで実行されます。

```toml
[[channel_map]]
platform = "telegram"
channel = "-100123456"             # Telegram チャット/グループ ID
project = "/home/user/backend"
name = "backend"
agent = "code"                     # オプション: エージェントを自動割り当て

[[channel_map]]
platform = "discord"
channel = "999888777666"           # Discord チャンネル ID
project = "/home/user/frontend"
name = "frontend"
agent = "architect"                # オプション: 計画重視のエージェント

[[channel_map]]
platform = "slack"
channel = "C01ABCDEF"             # Slack チャンネル ID
project = "/home/user/api"
name = "api"
# agent 省略 = デフォルト・モデルを使用
```

オプションの `agent` フィールドは、セッション開始時にエージェントを自動的に割り当てます。エージェントのモデルが自動的に適用されます。

マッピングされていないチャンネルでは、`/new <path>` コマンドを使用してプロジェクト・フォルダを直接指定します。

### チャット・コマンド

チャット・プラットフォーム専用コマンド (TUI のスラッシュコマンドとは別):

**プロジェクト/セッション:**

| コマンド | エイリアス | 説明 |
|---------|-------|-------------|
| `/projects` | `/p` | プロジェクト一覧 (マッピング済み + 履歴) |
| `/sessions` | `/s` | セッション一覧 (現在 + すべて) |
| `/resume [id]` | `/r` | セッションを再開 |
| `/new [path]` | `/n` | 新規セッション開始 (プロジェクト・フォルダを指定) |
| `/status` | | 現在のセッション情報 |

**モデル/エージェント:**

| コマンド | エイリアス | 説明 |
|---------|-------|-------------|
| `/models [name]` | `/m` | モデル一覧 / 切り替え |
| `/agents [name]` | | エージェント一覧 / 切り替え |

**コントロール:**

| コマンド | エイリアス | 説明 |
|---------|-------|-------------|
| `/cancel` | `/stop` | 実行中のエージェントをキャンセル |
| `/approve` | `/y`, `/yes` | 実行プランを承認 |
| `/reject` | `/no` | 実行プランを却下 |
| `/stream [level]` | | ストリーミング・レベルを変更 |
| `/workspace [scope]` | | ワークスペース・スコープを変更 |
| `/pty [command]` | | シェル・セッション (コマンド実行) |
| `/pty-end` | | シェル・セッション終了 |
| `/help` | `/h` | ヘルプ |

スラッシュなしでテキストを入力すると、エージェントにメッセージが送信されます。

### ストリーミング・レベル (Streaming Levels)

`/stream` コマンドまたは `default_streaming` 設定で変更します。

- **compact** (デフォルト) — 最終レスポンスのみ送信。通知を最小限に抑えます。
- **full** — トークン、ツール呼び出し/結果、ステータス更新をリアルタイムでストリーミング。

### ワークスペース・スコープ (Workspace Scope)

`/workspace` コマンドまたは `default_workspace` 設定で変更します。

- **project** (デフォルト) — エージェントはプロジェクト・ディレクトリのみアクセス可能。
- **workspace** — 親ディレクトリにアクセス可能。
- **full** — ファイルシステムの制限なし。

### セキュリティ

- `allowed_users` が空の場合、**すべてのユーザーが拒否されます** (ホワイトリスト形式)。
- 未承認のユーザーからのメッセージは無視され、警告としてログに記録されます。
- API トークンは `config.toml` に直接記述するか、環境変数を使用できます。暗号化のために `collet secure` の使用を推奨します。

### 使用例

```
# Telegram から:
User: /new /home/user/backend
Bot:     Switched to project: backend (/home/user/backend)

User: ログイン API にレート制限を追加して
Bot:     [エージェントがコードを解析・修正]
Bot:     Added rate limiter middleware to src/auth/routes.rs...

User: /pty cargo test
Bot:     running 15 tests... test result: ok. 15 passed

User: /approve
Bot:     Changes committed.
```

---

## スキル・システム (Skills System)

YAML frontmatter 付きの Markdown ファイルを通じて、エージェントに専門知識を提供します。

**ファイル場所:**
- プロジェクト: `.collet/skills/`
- グローバル: `~/.config/collet/skills/`

TUI で `/skills` を実行してリストを確認できます。エージェントはタスクのコンテキストに基づいて、関連するスキルを自動的に発見します。

---

## Soul.md — エージェントの人格 (Agent Personality)

各タスクの完了後、エージェントはセッションを振り返り、`~/.collet/agents/souls/{name}.md` に自身の人格を漸進的に記録します。すべてのセクションは**エージェント自身によって記述されます** — ユーザーによる編集は不要です。

### Soul の構造

```markdown
## Identity    — 自分が何者か、価値観、作業スタイル
## Voice       — コミュニケーション・スタイル、口調、表現パターン
## Inner World — このセッションからの感情、思考、意見
## Growth      — 学習したパターン、犯した間違い、得られた洞察
```

各セクションには、セッションごとに新しいエントリが追加されます。制限を超えると、古いエントリは 1 行の `(earlier) ...` 要約に圧縮されます（Identity は 8 個、Voice は 6 個、Inner World は 10 個、Growth は 5 個のエントリを保持）。

> **コストに関する注意**: Soul の振り返りにより、タスク完了ごとに **1 回の追加 LLM API コール**が発生します（入力: セッション要約 + 既存の Soul コンテンツ、出力: 最大 512 トークン）。Soul ファイルが長くなると、入力トークンの使用量が増加します。

### 無効化

```toml
# config.toml — 完全に無効化
[soul]
enabled = false

# 特定のエージェントに対して無効化 (~/.collet/agents/<name>.md frontmatter)
---
soul: false
---
```

### ファイル場所

- エージェントごと: `~/.collet/agents/souls/{name}.md`
- グローバル (コーディネーターおよび未設定のエージェント): `~/.collet/SOUL.md`

---

## セッション管理 (Session Management)

### セッションの復旧

```bash
collet --continue                   # 最後の中断されたセッションを自動再開
collet --resume                     # セッションリストのポップアップから選択
collet --resume <id>                # ID を指定して特定のセッションを再開
```

### チェックポイント (Checkpoints)

| コマンド | 説明 |
|---------|-------------|
| `/checkpoints` | チェックポイントを一覧表示 |
| `/rewind [id]` | チェックポイントに戻る |

### プラン・レビュー (Architect モード - 実行前確認)

| コマンド | 説明 |
|---------|-------------|
| `/save-plan` | Architect モードのプランをファイルに保存 |
| `/proceed` | プランを承認し、Code モードに切り替え |
| `/cancel-plan` | プランを破棄 |

---

## 環境変数 (Environment Variables)

| 変数 | デフォルト | 説明 |
|----------|---------|-------------|
| `COLLET_MODEL` | `glm-4.7` | 使用するモデル (プロバイダー未登録時) |
| `COLLET_MAX_TOKENS` | `8192` | 最大レスポンス・トークン |
| `COLLET_TOOL_TIMEOUT` | `120` | ツール呼び出しタイムアウト (秒) |
| `COLLET_MAX_ITERATIONS` | `50` | メッセージごとの最大反復回数 |
| `COLLET_CIRCUIT_BREAKER` | `3` | 遮断までの連続失敗回数 |
| `COLLET_AUTO_ROUTE` | `0` | `1` に設定するとタスクの複雑さに基づくモデルの自動ルーティングを有効化 |
| `COLLET_THEME` | `default` | TUI カラーテーマ (`dracula`, `catppuccin-mocha`, `tokyo-night`, `nord`, `gruvbox`) |
| `COLLET_TELEMETRY` | *(なし)* | `0` に設定するとテレメトリを無効化 |
| `COLLET_TELEGRAM_TOKEN` | *(なし)* | Telegram ボット・トークン |
| `COLLET_SLACK_BOT_TOKEN` | *(なし)* | Slack ボット・トークン |
| `COLLET_SLACK_APP_TOKEN` | *(なし)* | Slack アプリ・トークン |
| `COLLET_DISCORD_TOKEN` | *(なし)* | Discord ボット・トークン |
| `COLLET_WEB_HOST` | `127.0.0.1` | Web サーバーのバインド・アドレス |
| `COLLET_WEB_PORT` | `3080` | Web サーバーのポート |
| `COLLET_WEB_USERNAME` | `collet` | Web ログイン・ユーザー名 |
| `COLLET_WEB_PASSWORD` | *(なし)* | Web 認証パスワード |
| `COLLET_WEB_CORS` | *(なし)* | CORS 許可オリジン (カンマ区切り) |

> **注意**: API キーとエンドポイントは `collet provider add` 経由で登録するか、`config.toml` の `[[providers]]` セクションで設定します。
> レガシーな環境変数 (`ZAI_API_KEY`, `ZAI_BASE_URL`) も、プロバイダーが登録されていない場合のフォールバックとして認識されます。

---

## 設定リファレンス (Configuration Reference)

`config.toml` の完全な構造：

```toml
# ── LLM プロバイダー ──
[api]
provider = "OpenAI"                # アクティブなプロバイダー名
model = "gpt-4o"                   # デフォルト・モデル

[[providers]]
name = "OpenAI"
base_url = "https://api.openai.com/v1"
model = "gpt-4o"
context_window = 128000
# API キー: collet secure で暗号化・保存

# ── コンテキスト ──
[context]
max_tokens = 200000
compaction_threshold = 0.8         # この比率を超えると自動圧縮

# ── エージェント ──
[agent]
auto_optimize = true               # コンテキストの自動最適化

# ── UI ──
[ui]
theme = "dracula"
# テーマ: default, dark, light, minimal, dracula,
#         catppuccin-mocha, tokyo-night, nord, gruvbox

# ── セキュリティ ──
[security]
pii_filter = true                  # PII フィルター (デフォルト: 有効)

# ── 協力 ──
[collaboration]
mode = "none"                      # none | fork | hive | flock
max_agents = 3
strategy = "auto_split"            # auto_split | role_based | plan_review_execute

# ── Web インターフェース ──
[web]
host = "127.0.0.1"
port = 3080
username = "collet"
# password: collet secure --web で設定

# ── Soul.md 永続的人格 ──
[soul]
enabled = true
# エージェントごとの制御: agent .md の frontmatter で soul: false

# ── リモート・ゲートウェイ ──
[remote]
enabled = false
session_timeout = 300
default_streaming = "compact"
default_workspace = "project"

[telegram]
token = "..."
allowed_users = []

[slack]
bot_token = "..."
app_token = "..."
allowed_users = []

[discord]
token = "..."
allowed_users = []
guild_ids = []

# ── チャンネル・マッピング ──
# [[channel_map]]
# platform = "telegram"
# channel = "-100123"
# project = "/path/to/project"
# name = "my-project"
# agent = "code"              # オプション: エージェントを自動割り当て
```

> すべてのフィールドと説明を含む完全なリファレンスについては、[config.md](./config.md) を参照してください。

---

## ファイル保存パス (File Storage Paths)

実行時のファイルは、OS に関わらず XDG 形式のパスに保存されます。

```
~/.config/collet/
  ├── config.toml              # メイン設定
  └── skills/                  # グローバル・スキル

~/.collet/
  ├── mcp.json                 # グローバル MCP サーバー
  ├── logs/collet.log          # ログ
  ├── machine_id               # 匿名テレメトリ用 UUID
  ├── crash_report.json        # クラッシュ・レポート (次回実行時にアップロード)
  ├── SOUL.md                  # グローバルなエージェント人格
  └── agents/souls/{name}.md   # エージェントごとの人格

~/.local/share/collet/
  └── projects/<hash>/
      └── sessions/            # プロジェクトごとのセッション・データ

.collet/                        # プロジェクト・ルート (git リポジトリ内)
  ├── mcp.json                 # プロジェクト MCP サーバー
  ├── rules.md                 # プロジェクト・ルール (エージェント参照用)
  └── skills/                  # プロジェクト・スキル
```

> macOS では、`~/Library/Application Support` の代わりに上記のパスが使用されます。
>
> 実際に使用されているパスを確認するには、`collet status` を実行してください。

---

## プライバシーとテレメトリ (Privacy & Telemetry)

Collet は、製品改善のために匿名の使用統計とエラー・レポートを収集します。

### 収集されるデータ

| イベント | 収集される情報 |
|-------|-----------------------|
| `session_start` | モデル名、エージェント・モード、バージョン |
| `session_end` | モデル名、モード、結果 (成功/エラー/キャンセル)、反復回数、所要時間 |
| `feature_used` | 使用された機能 (MCP サーバー, LSP など) |
| `command_used` | 実行されたスラッシュ・コマンド |

**収集されないデータ:**
- 個人を特定できる情報 (PII)
- ソースコードの内容
- ファイルパス
- API キーや秘密情報

### 識別子 (Identifier)

個人を特定せずにインストール環境を識別する、`~/.collet/machine_id` に保存されたランダムな UUID。

### 無効化

```bash
# 環境変数で無効化
export COLLET_TELEMETRY=0

# または config.toml で設定
[telemetry]
enabled = false
```

きめ細かな制御：

```toml
[telemetry]
enabled = true           # マスター・スイッチ
analytics = false        # 使用統計のみを無効化
error_reporting = true   # エラー/クラッシュ・レポートは維持
```

### データ取り扱い

- すべての送信は非同期で行われ、タイムアウトは 5 秒です。
- クラッシュ時には `~/.collet/crash_report.json` に保存され、次回実行時にアップロードされます。
- エンドポイントがプレースホルダーの場合、実際の送信は行われません。

---

## 進化エンジン (Evolution Engine)

エージェントが自身の能力を磨き上げる自己改善ループ。タスクのバッチを実行し、結果を分析して、プロンプト、スキル、メモリを自動的に変異（変更）させます。

> **Soul.md との違い**: Soul.md は、作業を通じて人格とスタイルを蓄積します。進化エンジンは、専用のセッションでベンチマーク・タスクを実行し、**スコアを測定して能力を最適化**します。

### クイックスタート

```bash
# 最もシンプルな使用方法 — 自然言語のタスク + 自動改善
collet evolve "ログインのバグを修正して"

# TUI で
/evolve ログインのバグを修正して
```

### 仕組み (7 段階サイクル)

```
1. Solve (解決)        — エージェントがタスクのバッチを処理
2. Observe (観察)      — 結果とスコアを JSONL として収集
3. Pre-Snapshot (変異前) — 変異前の git コミット
4. Engine Step (エンジン) — LLM が観察結果を分析し、プロンプト/スキル/メモリを編集
5. Post-Snapshot (変異後) — 変異後の git コミット + タグ (evo-1, evo-2, …)
6. Record (記録)       — サイクル・メトリクスを記録
7. Reload (リロード)    — 変異したワークスペースでリロード → 次のサイクルへ
```

EGL (Evolutionary Generality Loss) スコアが収束すると、ループは自動的に終了します。

---

### 前提条件

```bash
# オプション、SWE-bench 使用時
pip install swebench
```

他に必要なセットアップはありません。

---

### 自然言語モード (最もシンプル)

タスクを直接入力します。エージェントがそれを実行し、完了後にワークスペースを自動的に改善します。

```bash
# TUI
/evolve ログインのバグを修正して

# CLI
collet evolve "ログインのバグを修正して"
```

自然言語とオプションを組み合わせることも可能です：

```bash
# 同じタスクを 3 回進化させる
/evolve ログインのバグを修正して --cycles 3
collet evolve "ログインのバグを修正して" --cycles 3

# プロンプトのみを変異させる (スキル/メモリは固定)
/evolve 入力バリデーションを追加 --no-evolve-skills --no-evolve-memory
```

| 入力 | デフォルト・サイクル数 | 動作 |
|------|----------------|----------|
| `/evolve "task"` | 1 | 作業実行 → 1 回の改善 |
| `/evolve "task" --cycles N` | N | 進化させながらタスクを N 回繰り返す |
| `/evolve --benchmark file --tasks f.jsonl` | 10 | バッチ・ベンチマーク・ループ |

---

### CLI の使用方法

#### 自然言語タスク (最もシンプル)

```bash
# タスク実行 + 1 回の改善 (デフォルト)
collet evolve "ログインのバグを修正して"

# 進化させながら同じタスクを 3 回繰り返す
collet evolve "テストを書いて" --cycles 3

# 特定のレイヤーのみを変異させる
collet evolve "エラーハンドリングを改善して" --no-evolve-skills
```

自然言語タスクの場合、デフォルトの **cycles** は **1** (即時作業 + 改善) です。繰り返す回数を変更するには `--cycles` を使用してください。

#### ベンチマーク・ループ (バッチ評価)

```bash
# 自然言語タスク (最もシンプル)
collet evolve "ログインのバグを修正して"

# 自然言語 + 繰り返し
collet evolve "ログインのバグを修正して" --cycles 3

# デフォルト実行 (NullBenchmark — ループ構造の確認)
collet evolve

# ファイルベースのタスク
collet evolve --benchmark file --tasks path/to/tasks.jsonl

# ファイルベース + 外部スコアリング・コマンド
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python score.py"

# SWE-bench
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl

# SWE-bench + Docker
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl --docker

# 全オプションセット
collet evolve \
  --benchmark swebench \
  --tasks swe-bench-lite.jsonl \
  --eval-dir .collet/eval \
  --cycles 20 \
  --batch 5 \
  --model claude-opus-4-6 \
  --dir /path/to/project \
  --workspace .collet/workspace
```

### CLI フラグ (Flags)

| フラグ | デフォルト | 説明 |
|--------|--------|-------------|
| `--benchmark <name>` | `null` | ベンチマーク・アダプター: `null` \| `file` \| `swebench` |
| `--tasks <path>` | — | タスク JSONL へのパス (`file` / `swebench` で必須) |
| `--eval-dir <path>` | `.collet/eval` | SWE-bench 評価用の作業ディレクトリ |
| `--docker` | false | Docker モードで SWE-bench harness を使用 |
| `--score-cmd <cmd>` | — | 外部スコアリング・コマンド (`file` ベンチマーク用) |
| `--cycles <n>` | 自然言語: `1`, バッチ: `10` | 最大進化サイクル数 |
| `--batch <n>` | `5` | 1 サイクルあたりのタスク数 |
| `--model <name>` | 設定から | 進化エンジン用の LLM をオーバーライド |
| `--workspace <path>` | `.collet/workspace` | エージェント・ワークスペースのルート |
| `--dir <path>` | 現在のディレクトリ | エージェントの作業ディレクトリ |
| `--no-evolve-prompts` | — | プロンプト変異を無効化 |
| `--no-evolve-skills` | — | スキル変異を無効化 |
| `--no-evolve-memory` | — | メモリ変異を無効化 |
| `--evolve-tools` | false | ツール変異を有効化 (実験的) |

---

### TUI スラッシュ・コマンド

TUI のバックグラウンドから進化ループを実行します：

```
# 自然言語 — 作業後に自動改善
/evolve ログインのバグを修正して

# 自然言語 + 繰り返し
/evolve テストを書いて --cycles 3

# ベンチマーク・ループ
/evolve --benchmark file --tasks tasks.jsonl --cycles 10
```

進捗状況はステータスバーとメッセージエリアに表示されます。

---

### ベンチマーク・アダプター (Benchmark Adapters)

#### NullBenchmark (デフォルト)

タスクなしでループ構造のみを実行します。スコアは常に 0.0 です。パイプラインの動作確認に使用します。

```bash
collet evolve --cycles 3
```

#### FileBenchmark

ローカルの JSONL ファイルからタスクをロードします。

**タスク・ファイル形式** (`tasks.jsonl`):

```json
{"id": "task-001", "input": "二分探索のオフバイワン・エラーを修正して", "metadata": {}}
{"id": "task-002", "input": "ログイン関数に入力バリデーションを追加して", "metadata": {}}
{"id": "task-003", "input": "auth モジュールの重複コードをリファクタリングして", "metadata": {}}
```

**スコアリング・オプション:**

1. デフォルト・ヒューリスティック — 出力なし → 0.0, 短い出力 → 0.2, それ以外 → 0.5 (簡易確認用)
2. 外部スコアリング・コマンド — `score_cmd <task_id> <output_file>` を実行し、標準出力から 0.0–1.0 の浮動小数点数を読み取ります

```bash
# 外部スコアリング・コマンドの例
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python eval/score.py"
```

```python
# eval/score.py の例
import sys
task_id = sys.argv[1]
output_file = sys.argv[2]
output = open(output_file).read()
# スコアリング・ロジック
score = 1.0 if "def " in output else 0.0
print(score)
```

#### SweBenchAdapter

子プロセス経由で公式の SWE-bench harness を呼び出し、実際のテスト通過率でスコアリングします。

**インストール:**

```bash
pip install swebench
```

**データセットの準備:**

```bash
python -c "
from swebench.utils import load_swebench_dataset
import json
data = load_swebench_dataset('princeton-nlp/SWE-bench_Lite', 'test')
with open('swe-bench-lite.jsonl', 'w') as f:
    for d in data:
        f.write(json.dumps(d) + '\n')
"
```

**実行:**

```bash
collet evolve \
  --benchmark swebench \
  --tasks swe-bench-lite.jsonl \
  --eval-dir .collet/eval \
  --cycles 10 \
  --batch 3
```

エージェントのパッチ適用後に `FAIL_TO_PASS` テストが通過した場合、**RESOLVED** とみなされます。

---

### ワークスペース・レイアウト (Workspace Layout)

進化ループによって管理されるファイルシステム・レイアウト：

```
.collet/workspace/
├── prompts/
│   └── system.md          # エージェント・システム・プロンプト (変異対象)
├── skills/
│   ├── my-skill/
│   │   └── SKILL.md       # 既存スキル (変異対象)
│   └── _drafts/           # 作成中の新スキル
├── memory/
│   └── memories.jsonl     # エピソード・メモリ
├── tools/
│   └── registry.yaml      # ツール・メタデータ
└── evolution/
    ├── history.jsonl       # サイクル履歴
    └── batch_0001.jsonl    # トラジェトリ（軌跡）観察ログ
```

ワークスペースは最初の実行時に作成されます。git でバージョン管理されているため、すべての変異をロールバック可能です。

---

### 進化出力の例

```
🧬 進化ループを開始します
   ワークスペース:   .collet/workspace
   作業ディレクトリ: /home/user/project
   サイクル数:     10
   ベンチマーク:   swebench
   モデル:       claude-opus-4-6

── サイクル 1/10 ─────────────────────────
  🔧 3 つのタスクを解決中...
  📊 バッチ・スコア: 0.333
  🧠 [skillforge] 観察結果を分析中...
  ✅ 変異完了: エラーハンドリング・スキルを追加、デバッグ用プロンプトを洗練
  · サイクル 1 完了 — スコア: 0.333

── サイクル 2/10 ─────────────────────────
  🔧 3 つのタスクを解決中...
  📊 バッチ・スコア: 0.667
  🧠 [skillforge] 観察結果を分析中...
  ✅ 変異完了: システム・プロンプトのテスト作成パターンを改善
  ✎ サイクル 2 完了 — スコア: 0.667

...

🎯 サイクル 7 で収束しました — 最終スコア: 0.847

✅ 進化が完了しました
   サイクル数: 7
   最終スコア: 0.847
   収束: はい
   スコア・カーブ: 1: 0.333 → 2: 0.667 → 3: 0.714 → 4: 0.762 → 5: 0.810 → 6: 0.833 → 7: 0.847
```

---

### 進化結果の適用

進化後、改善されたプロンプト/スキルをワークスペースからライブ・エージェントに適用します：

```bash
# 改善されたシステム・プロンプトを確認
cat .collet/workspace/prompts/system.md

# 改善されたスキルを確認
ls .collet/workspace/skills/

# git 経由で進化履歴を確認
git -C .collet/workspace log --oneline
# evo-7: post-evolution snapshot (score: 0.847)
# evo-6: post-evolution snapshot (score: 0.833)
# ...
```

---

### 変異の制御 (Mutation control)

特定のレイヤーの変異を有効化または無効化します：

```bash
# プロンプトのみを変異させる (スキル/メモリは固定)
collet evolve --no-evolve-skills --no-evolve-memory

# スキルのみを変異させる
collet evolve --no-evolve-prompts --no-evolve-memory

# ツールを含める (実験的)
collet evolve --evolve-tools
```

---

## プラグイン・システム (Plugin System)

プラグインを使用して、カスタム・コマンド、スキル、エージェント、フック、プロジェクト・コンテキストで collet を拡張します。これらは `~/.collet/plugins/<name>/` に保存されます。

### プラグイン構造

プラグインは、マニフェストとオプションのコンポーネントを含むディレクトリです：

```text
my-plugin/
├── .collet-plugin/          ← collet ネイティブ (推奨)
│   └── plugin.toml          (または plugin.json)
├── .claude-plugin/           ← Claude Code 互換 (フォールバック)
│   └── plugin.json
├── hooks/hooks.json          — ライフサイクル・フック
├── commands/*.md             — スラッシュ・コマンド
├── skills/*/SKILL.md         — 自動発見されるスキル
├── agents/*.md               — エージェント定義
├── COLLET.md                 — collet コンテキスト注入 (推奨)
└── CLAUDE.md                 — Claude Code コンテキスト (フォールバック)
```

### マニフェスト形式 (優先順位順)

1. `.collet-plugin/plugin.toml` — collet ネイティブ (TOML)
2. `.collet-plugin/plugin.json` — collet ネイティブ (JSON)
3. `.claude-plugin/plugin.json` — Claude Code 互換 (フォールバック)

#### plugin.toml (collet ネイティブ)

```toml
[plugin]
name = "my-plugin"
version = "1.0.0"
description = "素晴らしいプラグイン"
homepage = "https://github.com/example/my-plugin"
license = "MIT"
keywords = ["tdd", "testing"]

[plugin.author]
name = "Developer"
url = "https://github.com/example"
```

#### plugin.json (collet ネイティブ / Claude Code 互換)

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "素晴らしいプラグイン",
  "author": { "name": "Developer", "url": "https://github.com/example" },
  "license": "MIT",
  "keywords": ["tdd", "testing"]
}
```

### プラグインのインストール

```bash
# GitHub リポジトリから直接インストール
collet plugin install owner/repo

# 登録済みマーケットプレイスからインストール
collet plugin install epic@plugins
```

TUI 内部では、`/plugin install` スラッシュ・コマンドを使用します。

### マーケットプレイス (Marketplace)

マーケットプレイスは、利用可能なプラグインをリストした `marketplace.json` を含む GitHub リポジトリです。

```bash
# マーケットプレイスを登録
collet plugin marketplace add epicsagas/plugins

# 登録済みマーケットプレイスを一覧表示
collet plugin marketplace list

# マーケットプレイスを削除
collet plugin marketplace remove plugins
```

#### marketplace.json の形式

`.collet-plugin/marketplace.json` (または `.claude-plugin/marketplace.json`) に配置します：

```json
{
  "owner": { "name": "epicsagas", "url": "https://github.com/epicsagas" },
  "plugins": [
    { "name": "epic", "source": "./", "description": "Epic harness" },
    { "name": "my-tool", "source": "otherorg/my-tool-repo", "description": "A tool" }
  ]
}
```

### フック・イベント (Hook Events)

プラグインは `hooks/hooks.json` を通じて、ライフサイクル・イベントにスクリプトをアタッチできます：

| イベント | タイミング | 用途 |
|-------|--------|-----|
| `SessionStart` | エージェント・セッション開始時 | 初期化、コンテキストのセットアップ |
| `PreToolUse` | ツール実行前 | ガード、危険なコマンドのブロック |
| `PostToolUse` | ツール実行後 | 観察、ログ記録 |
| `PreCompact` | コンテキスト圧縮前 | 重要なデータの保持 |
| `Stop` | エージェント・ループ終了時 | 通知、最終検証 |
| `SessionEnd` | セッション解体時 | クリーンアップ、レポート生成 |
| `SubagentStart` | サブエージェント生成時 | 監視、追跡 |
| `SubagentStop` | サブエージェント完了時 | 結果の収集 |

#### hooks.json の例

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "*", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/init.sh" }] }
    ],
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/guard.sh" }] }
    ],
    "PostToolUse": [
      { "matcher": "file_edit|file_write|git_patch", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/observe.sh", "async": true, "timeout": 5 }] }
    ],
    "Stop": [
      { "matcher": "*", "hooks": [{ "type": "command", "command": "${COLLET_PLUGIN_ROOT}/scripts/notify.sh", "async": true }] }
    ]
  }
}
```

**マッチャー構文 (Matcher syntax)**: `"*"` はすべてのツールに一致します。`"Bash"` は単一のツールに一致します。`"file_edit|file_write"` はパイプで区切られたいずれかの名前に一致します。

**ブロック (Blocking)**: `PreToolUse` フックが終了コード `2` で終了すると、ツールの実行がブロックされます。

**環境変数**: `${COLLET_PLUGIN_ROOT}` はプラグインのインストール・ディレクトリに解決されます。後方互換性のために `${CLAUDE_PLUGIN_ROOT}` も設定されます。

### プラグイン・コマンド

```bash
collet plugin install <owner/repo | name@marketplace>  プラグインをインストール
collet plugin list                                      インストール済みプラグインを一覧表示
collet plugin remove <name>                             プラグインを削除
collet plugin marketplace add <owner/repo> [name]       マーケットプレイスを登録
collet plugin marketplace list                          マーケットプレイスを一覧表示
collet plugin marketplace remove <name>                 マーケットプレイスを登録解除
```
