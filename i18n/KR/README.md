# <center>collet</center>

<center>
**에이전트 루프 드롭 제로를 지향하는 집요한 에이전트 코딩 오케스트레이터.**

TUI, 웹, IDE 전반에서 모든 LLM과 CLI 에이전트를 조율합니다.

Node.js 기반 도구에서 흔히 발생하는 '중단(stuck)' 문제를 근본적으로 해결하며, Rust의 안전한 기반 위에서 수준 높은 코드 인텔리전스와 정밀한 편집을 제공합니다.

[![CI](https://github.com/epicsagas/collet/actions/workflows/release.yml/badge.svg)](https://github.com/epicsagas/collet/actions/workflows/release.yml)
[![crates.io](https://img.shields.io/crates/v/collet.svg)](https://crates.io/crates/collet)
[![docs.rs](https://docs.rs/collet/badge.svg)](https://docs.rs/collet)
[![crates.io downloads](https://img.shields.io/crates/d/collet.svg)](https://crates.io/crates/collet)
[![Rust](https://img.shields.io/badge/rust-1.78%2B-orange.svg)](https://www.rust-lang.org)
[![License](https://img.shields.io/crates/l/collet.svg)](LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/epicsaga)
</center>

## 주요 기능

![Features](../../assets/features.jpg)

| 기능 | 설명 |
|---------|-------------|
| **멀티 프로바이더** | SSE 스트리밍을 지원하는 다양한 LLM 프로바이더 연결 |
| **Tree-sitter 레포 맵** | Rust/Python/TypeScript/Go를 위한 AST 심볼 추출 + PageRank 랭킹 |
| **BM25 코드 검색** | 증분 인덱싱, 코드 인식 토크나이저, 자동 컨텍스트 주입 |
| **BLAKE3 증분 해싱** | mtime 사전 체크 + 콘텐츠 해시를 통해 변경된 파일만 재분석 |
| **외과적 편집** | 전체 파일을 다시 쓰지 않는 정밀한 문자열 교체 |
| **에이전트 스킬** | YAML 프론트매터 기반의 3단계 점진적 스킬 시스템 |
| **서브 에이전트** | 격리된 컨텍스트 창에서 하위 작업 병렬 실행 |
| **세션 유지** | `--continue` / `--resume`을 통한 세션 복구 및 자동 저장 |
| **자동 압축** | 관련성 기반 압축: SimHash 중복 제거 + 점수 기반 축자 보존 + 구조화된 요약 폴백 |
| **중단 방지** | 반복 제한, 서킷 브레이커, Tokio 타임아웃 |
| **테마 및 애니메이션** | 6가지 컬러 테마(Dracula, Catppuccin 등) + 점자 스피너 생각 애니메이션 |
| **아키텍트 플랜 리뷰** | Architect→Code 전환 시 사용자 승인 필요, 플랜 파일 내보내기 지원 |
| **병렬/팀 모드** | 작업 분할 → 병렬 실행 → 결과 병합. 팀 모드: 에이전트 간 실시간 통신 + 합의 |
| **LSP/MCP** | 35개 이상의 언어, 48개 이상의 서버 지원, 자동 폴백 + MCP 도구 통합 |
| **도구 승인 게이트** | 3단계 도구 실행 승인(Yolo/자동/수동), 런타임 중 `Shift+Tab`으로 전환 가능 |
| **RAG 문서 검색** | Alcove 로컬 문서 + HTTP Bridge 외부 서비스. 에이전트가 `rag_search` 도구로 자율 검색. Swarm 모드에서 SharedKnowledge 자동 공유 |
| **Soul.md** | 영구적 에이전트 페르소나 시스템. Identity, Voice, Inner World, Growth 섹션을 자가 기록하여 고유한 캐릭터 구축. 글로벌/에이전트별 토글. **작업 완료 시 추가 API 호출 1회** (최대 512 토큰) |
| **IDE 통합** | ACP 서버를 통한 JetBrains 네이티브 + VSCode 확장 프로그램 지원 |

## 빠른 시작

### 요구 사항

- Rust 1.78+ (Edition 2024)
- LLM 프로바이더 API 키

### 설치 및 실행

#### Homebrew (macOS) 이용

```bash
brew install epicsagas/tap/collet
```

#### cargo-binstall 이용 (가장 빠름 - 빌드된 바이너리)

```bash
cargo binstall collet
```

> [`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall)이 먼저 설치되어 있어야 합니다:
> `cargo install cargo-binstall`

#### crates.io 이용

```bash
cargo install collet
```

#### 소스에서 설치

```bash
git clone https://github.com/epicsagas/collet.git
cd collet
cargo install --path .
```

### 설정 및 실행
```bash
collet setup # 또는 더 상세한 설정을 위해 --advanced 옵션 사용

# TUI 실행
collet

# 헤드리스 실행
collet "hello collet!"
```

## 문서

| 문서 | 설명 |
|----------|-------------|
| [QUICKSTART.md](../../QUICKSTART.md) | 예제를 포함한 단계별 빠른 시작 가이드 |
| [docs/user-guide.md](./user-guide.md) | 전체 사용자 매뉴얼 — CLI, TUI, 키 바인딩, 슬래시 명령어, 멀티 프로바이더, MCP, Soul.md |
| [docs/config.md](../../docs/config.md) | `config.toml` 전체 참조 — 프로바이더, 모델, 에이전트, 원격 분석 |
| [CHANGELOG.md](../../CHANGELOG.md) | 버전 기록 및 릴리스 노트 |

## 연구

collet을 구축하기 위해서는 수백 번의 턴 동안 장시간 실행되는 에이전트의 일관성을 유지하는 방법부터, 멀티 프로바이더의 속도 제한을 실제로 작동하게 만드는 방법, 그리고 멀티 에이전트 병렬화가 언제 도움이 되고 언제 노이즈만 더하는지 파악하는 것까지, 아직 명확한 답이 없는 문제들을 깊이 파고들어야 했습니다.

이러한 결정 뒤에 숨겨진 연구 및 엔지니어링 분석은 일련의 독립적인 보고서로 게시되었습니다.

| 보고서 | 주제 |
|--------|-------|
| [에이전트 루프](../../docs/research/agent-loop.md) | 실행 엔진, 보호 시스템, 스트림 안정성 버그, 압축 파이프라인 |
| [멀티 에이전트 시스템](../../docs/research/multi-agent.md) | Fork/Hive/Flock 모드, SharedKnowledge 블랙보드, 병목 현상 분석, 조정 패턴 |
| [컨텍스트 관리](../../docs/research/context-management.md) | 압축 전략, 프롬프트 캐싱, 토큰 효율성, 업계 조사 |
| [멀티 프로바이더 아키텍처](../../docs/research/multi-provider.md) | OpenAI 호환 API 차이점, 속도 제한, 프로바이더 SDK 설계 |
| [TUI & UX](../../docs/research/tui-ux.md) | UX 평가, 멀티바이트 커서 처리, 웹 UI 통합 |
| [벤치마킹 및 평가](../../docs/research/benchmark-eval.md) | 모델/모드 벤치마크, 다국어 평가, 생산성 연구 |
| [진화 엔진](../../docs/research/evolution-engine.md) | 자기 개선 루프, A-Evolve (arXiv:2602.00359), 7단계 사이클 설계 |
| [원격 제어 및 머신 간 브릿지](../../docs/research/remote.md) | 원격 게이트웨이, 머신 간 에이전트 협업, ACP/IDE 통합 |

## 빌드 정보

| 항목 | 값 |
|------|-------|
| 언어 | Rust (Edition 2024) |
| 소스 파일 수 | 176 |
| 코드 라인 수 | 약 65,000 |
| 테스트 수 | 959 |
| 릴리스 바이너리 크기 | 약 40MB (arm64) |

## 로드맵

- [x] 1단계: MVP — API 커넥터, TUI, 도구 프레임워크, 에이전트 루프
- [x] 2단계: 컨텍스트 유지, 저널링, 레포 맵, 스마트 압축
- [x] 3단계: git-patch 헝크 편집, 추론 보존, 세션 복구 (--continue/--resume)
- [x] 4단계: 다국어 tree-sitter (Python, TS, Go), PageRank 랭킹, LSP/MCP
- [x] 5단계: 에이전트 스킬, 서브 에이전트, @mention (파일/폴더/모델), BM25 검색
- [x] 6단계: MCP, LSP, Side-by-side Diff, 프롬프트 캐싱
- [x] 7단계: 6가지 컬러 테마, 생각 애니메이션, 아키텍트 플랜 리뷰
- [x] 8단계: 병렬/팀 모드 (멀티 에이전트 조율, 세션 레벨 합의, 충돌 감지)
- [x] 9단계: Soul.md 영구적 페르소나 — 에이전트별 감정/생각/성장 기록, 글로벌/에이전트별 토글, 자동 압축
- [x] 10단계: Flock 모드 완료 — Swarm으로 명칭 변경, RoleBased 전략, PlanReviewExecute 파이프라인, 합의 투표를 포함한 수정 루프
- [x] 11~28단계: RAG 문서 검색 (Alcove + HTTP Bridge), IDE 통합 (ACP), 원격 게이트웨이 (Telegram/Slack/Discord), 웹 서버, 자동 라우팅, PII 필터, 옵티마이저, 멀티 프로바이더 마법사
- [ ] 29단계: 에이전트 루프 및 스웜 강화 — 드롭 제로 보장, 적응형 재시도, 스웜 합의 정교화, 코디네이터/워커 스케줄링 개선
- [ ] 30단계: 고급 모델 옵티마이저 — 프로바이더별 비용/지연 시간 점수화, 프로바이더 추가/편집 시 스마트 티어 재할당, 벤치마크 기반 모델 랭킹
- [ ] 31단계: 웹 및 원격 플랫폼 업그레이드 — 웹 UI 대시보드 v2, Telegram/Slack/Discord UX 개선, 웹훅 릴레이, 실시간 스웜 상태 스트리밍

## 기원 및 상태

이 프로젝트는 GLM 모델에서 더 많은 것을 이끌어내기 위한 개인적인 실험장으로 시작되었습니다. 그러다 한 기능이 다른 기능으로 이어졌고, 이전 모델이나 논문, 패러다임이 식기도 전에 새로운 것들이 계속해서 쏟아져 나왔습니다.

> "새로운 모델, 새로운 논문, 새로운 패러다임 — 어떤 커밋 로그가 따라잡을 수 있는 것보다 빠르게." — 반복되는 악몽.

**현재 상태** — 현재 collet을 통해 자체적으로 개발 중(dogfooding)이며, 자신의 꼬리를 물고 있는 상태입니다.

**안정성**: 핵심 에이전트 루프는 견고합니다. 병렬/스웜 실행 및 외부 통합은 아직 안정화 단계에 있습니다.

## 라이선스

Apache-2.0
