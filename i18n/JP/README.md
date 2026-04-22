> **注意：** このドキュメントは AI によって翻訳されており、100% 正確ではない可能性があります。エラーを見つけた場合や改善の提案がある場合は、GitHub で issue を作成してください。

# <center>collet</center>

<center>
**エージェントループのドロップゼロを実現する、執拗なエージェント型コーディングオーケストレーター。**

TUI、Web、IDEにわたって、あらゆるLLM、あらゆるCLIエージェントをオーケストレートします。

Node.jsベースのツールでよく見られる「スタック」問題を根本から解消し、Rustの安全な基盤の上で高度なコードインテリジェンスと精密な編集を提供します。

[![CI](https://github.com/epicsagas/collet/actions/workflows/release.yml/badge.svg)](https://github.com/epicsagas/collet/actions/workflows/release.yml)
[![crates.io](https://img.shields.io/crates/v/collet.svg)](https://crates.io/crates/collet)
[![docs.rs](https://docs.rs/collet/badge.svg)](https://docs.rs/collet)
[![crates.io downloads](https://img.shields.io/crates/d/collet.svg)](https://crates.io/crates/collet)
[![Rust](https://img.shields.io/badge/rust-1.78%2B-orange.svg)](https://www.rust-lang.org)
[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

## 特徴

![Features](../../assets/features.jpg)

| 特徴 | 説明 |
|---------|-------------|
| **マルチプロバイダー** | SSEストリーミングを備えた様々なLLMプロバイダーに接続 |
| **Tree-sitterリポジトリマップ** | Rust/Python/TypeScript/GoのASTシンボル抽出 + PageRankランキング |
| **BM25コード検索** | 増分インデックス、コード認識トークナイザー、自動コンテキスト注入 |
| **BLAKE3増分ハッシュ** | mtimeプリチェック + コンテンツハッシュにより、変更されたファイルのみを再解析 |
| **外科的編集** | ファイル全体の書き換えを行わない、精密な文字列置換 |
| **エージェントスキル** | YAMLフロントマターに基づく3層のプログレッシブスキルシステム |
| **サブエージェント** | 隔離されたコンテキストウィンドウでのサブタスクの並列実行 |
| **セッションの永続化** | `--continue` / `--resume` によるセッション復元と自動保存 |
| **自動圧縮** | 関連性ベースの圧縮: SimHashデデュープ + スコア付き逐語保存 + 構造化サマリーフォールバック |
| **スタック防止** | 反復制限、サーキットブレーカー、Tokioタイムアウト |
| **テーマとアニメーション** | 6色のカラーテーマ（Dracula, Catppuccinなど） + 点字スピナー思考アニメーション |
| **アーキテクトプランレビュー** | Architect→Code遷移にはユーザーの承認が必要、プランファイルの書き出しをサポート |
| **パラレル/チームモード** | タスク分割 → 並列実行 → 結果マージ。チームモード: エージェント間のリアルタイム通信 + コンセンサス |
| **LSP/MCP** | 35以上の言語、48以上のサーバーと自動フォールバック + MCPツール統合 |
| **ツール承認ゲート** | 3段階のツール実行承認（Yolo/Auto/Manual）、実行中に `Shift+Tab` で切り替え可能 |
| **RAGドキュメント検索** | Alcoveローカルドキュメント + HTTP Bridge外部サービス。エージェントは `rag_search` ツールで自律的に検索。SwarmモードではSharedKnowledgeが自動共有 |
| **Soul.md** | 永続的なエージェント人格システム。Identity, Voice, Inner World, Growthセクションを自己記録し、独自のキャラクターを構築。グローバル/エージェントごとの切り替え。**タスク完了ごとに1回の追加APIコール**（最大512トークン） |
| **IDE統合** | ACPサーバー経由のJetBrainsネイティブ統合 + VSCode拡張機能 |

## クイックスタート

### 要件

- Rust 1.78+ (Edition 2024)
- LLMプロバイダーのAPIキー

### インストールと実行

#### Homebrew (macOS) 経由

```bash
brew install epicsagas/tap/collet
```

#### cargo-binstall (最速 - ビルド済みバイナリ) 経由

```bash
cargo binstall collet
```

> 事前に [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall) のインストールが必要です:
> `cargo install cargo-binstall`

#### crates.io 経由

```bash
cargo install collet
```

#### ソースから

```bash
git clone https://github.com/epicsagas/collet.git
cd collet
cargo install --path .
```

### セットアップと実行
```bash
collet setup # または --advanced オプションで詳細設定

# TUI
collet

# ヘッドレス
collet "hello collet!"
```

## ドキュメント

| ドキュメント | 説明 |
|----------|-------------|
| [QUICKSTART.md](../../QUICKSTART.md) | ステップバイステップのクイックスタートと例 |
| [docs/user-guide.md](./user-guide.md) | 完全なユーザーマニュアル — CLI, TUI, キーバインド, スラッシュコマンド, マルチプロバイダー, MCP, Soul.md |
| [docs/config.md](../../docs/config.md) | `config.toml` 完全リファレンス — プロバイダー, モデル, エージェント, テレメトリ |
| [CHANGELOG.md](../../CHANGELOG.md) | バージョン履歴とリリースノート |

## 研究

colletの構築には、まだ明確な答えのない問題への深い探求が必要でした。何百回ものターンにわたって長時間実行されるエージェントの一貫性を維持することから、マルチプロバイダーのレート制限を実際に機能させること、マルチエージェントの並列化がいつ役立ち、いつ単なるノイズになるかを見極めることまで多岐にわたります。

これらの決定の背後にある研究とエンジニアリングの分析は、一連の独立したレポートとして公開されています。

| レポート | トピック |
|--------|-------|
| [エージェントループ](../../docs/research/agent-loop.md) | 実行エンジン、ガードシステム、ストリーム信頼性バグ、圧縮パイプライン |
| [マルチエージェントシステム](../../docs/research/multi-agent.md) | Fork/Hive/Flockモード、SharedKnowledgeブラックボード、ボトルネック分析、調整パターン |
| [コンテキスト管理](../../docs/research/context-management.md) | 圧縮戦略、プロンプトキャッシュ、トークン効率、業界調査 |
| [マルチプロバイダーアーキテクチャ](../../docs/research/multi-provider.md) | OpenAI互換APIの差異、レート制限、プロバイダーSDK設計 |
| [TUI & UX](../../docs/research/tui-ux.md) | UX評価、マルチバイトカーソル処理、Web UI統合 |
| [ベンチマークと評価](../../docs/research/benchmark-eval.md) | モデル/モードのベンチマーク、多言語評価、生産性調査 |
| [進化エンジン](../../docs/research/evolution-engine.md) | 自己改善ループ、A-Evolve (arXiv:2602.00359)、7段階サイクル設計 |
| [リモートコントロールとマシン間ブリッジ](../../docs/research/remote.md) | リモートゲートウェイ、マシン間エージェントコラボレーション、ACP/IDE統合 |

## ビルド情報

| 項目 | 値 |
|------|-------|
| 言語 | Rust (Edition 2024) |
| ソースファイル数 | 176 |
| コード行数 | 約65,000 |
| テスト数 | 959 |
| リリースバイナリサイズ | 約40MB (arm64) |

## ロードマップ

- [x] フェーズ 1: MVP — APIコネクタ, TUI, ツールフレームワーク, エージェントループ
- [x] フェーズ 2: コンテキストの永続化, ジャーナリング, リポジトリマップ, スマート圧縮
- [x] フェーズ 3: git-patch ハンク編集, 推論の保存, セッション復元 (--continue/--resume)
- [x] フェーズ 4: 多言語 tree-sitter (Python, TS, Go), PageRankランキング, LSP/MCP
- [x] フェーズ 5: エージェントスキル, サブエージェント, @mention (ファイル/フォルダ/モデル), BM25検索
- [x] フェーズ 6: MCP, LSP, サイドバイサイドDiff, プロンプトキャッシュ
- [x] フェーズ 7: 6色のカラーテーマ, 思考アニメーション, アーキテクトプランレビュー
- [x] フェーズ 8: パラレル/チームモード (マルチエージェントオーケストレーション, セッションレベルのコンセンサス, 競合検出)
- [x] フェーズ 9: Soul.md 永続的な人格 — エージェントごとの感情/思考/成長の記録, グローバル/エージェントごとの切り替え, 自動圧縮
- [x] フェーズ 10: Flockモード完成 — Swarmへの改名, RoleBased戦略, PlanReviewExecuteパイプライン, コンセンサス投票による修正ループ
- [x] フェーズ 11–28: RAGドキュメント検索 (Alcove + HTTP Bridge), IDE統合 (ACP), リモートゲートウェイ (Telegram/Slack/Discord), Webサーバー, 自動ルーティング, PIIフィルタ, オプティマイザー, マルチプロバイダーウィザード
- [ ] フェーズ 29: エージェントループとスウォームの堅牢化 — ドロップゼロの保証, 適応型リトライ, スウォームコンセンサスの洗練, コーディネーター/ワーカーのスケジューリング改善
- [ ] フェーズ 30: 高度なモデルオプティマイザー — プロバイダーを考慮したコスト/レイテンシスコアリング, プロバイダー追加/編集時のスマートなティア再割り当て, ベンチマーク駆動のモデルランキング
- [ ] フェーズ 31: Webおよびリモートプラットフォームのアップグレード — Web UIダッシュボード v2, Telegram/Slack/Discord UXの磨き込み, Webhookリレー, リアルタイムのスウォームステータスストリーミング

## 起源とステータス

このプロジェクトは、GLMモデルからより多くの可能性を引き出すための個人的な遊び場として始まりました。その後、一つの機能が次の機能を呼び、前の機能が冷めないうちに新しいモデル、論文、パラダイムが次々と現れました。

> 「新しいモデル、新しい論文、新しいパラダイム。コミットログが追いつくよりも速く。」 — 繰り返される悪夢。

**現在の状態** — collet自身を使って開発中（ドッグフーディング）、自分の尻尾を食べている状態。

**安定性**: コアエージェントループは堅牢です。パラレル/スウォーム実行および外部統合は現在整備中です。

## ライセンス

Apache-2.0
