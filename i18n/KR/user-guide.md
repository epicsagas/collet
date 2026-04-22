# Collet 사용자 가이드

강력한 에이전트 기반 코딩 오케스트레이터인 collet의 전체 사용자 매뉴얼입니다.

---

## 목차

1. [CLI 참조](#cli-참조)
2. [TUI 사용법](#tui-사용법)
3. [멀티 프로바이더 설정](#멀티-프로바이더-설정)
4. [MCP 서버](#mcp-서버)
5. [코드 인텔리전스 (Code Intelligence)](#코드-인텔리전스)
6. [멀티 에이전트 협업](#멀티-에이전트-협업)
7. [웹 인터페이스](#웹-인터페이스)
8. [원격 게이트웨이 (Telegram / Slack / Discord)](#원격-게이트웨이-telegram--slack--discord)
9. [스킬 시스템 (Skills System)](#스킬-시스템)
10. [Soul.md — 에이전트 성격](#soulmd--에이전트-성격)
11. [세션 관리](#세션-관리)
12. [환경 변수](#환경-변수)
13. [설정 참조](#설정-참조)
14. [파일 저장 경로](#파일-저장-경로)
15. [개인정보 보호 및 텔레메트리](#개인정보-보호-및-텔레메트리)
16. [진화 엔진 (Evolution Engine)](#진화-엔진)
17. [플러그인 시스템](#플러그인-시스템)

---

## CLI 참조

### 기본 명령

```bash
collet                              # 대화형 TUI
collet "main.rs의 버그 수정"           # 헤드리스 (실행 후 종료)
collet --continue                   # 마지막 미완료 세션 복구
collet --resume                     # 세션 목록에서 선택
collet --model glm-5                # 모델 재정의
```

### 하위 명령

```bash
collet setup                        # 설정 파일 생성 (여러 프로바이더 등록)
collet secure                       # API 키 암호화 및 저장
collet unsecure                     # 암호화된 자격 증명 제거
collet status                       # 현재 설정 확인
collet update                       # 최신 버전 확인
collet --version                    # 버전 표시
collet help | -h | --help           # 도움말
```

### 프로바이더 관리 (Provider Management)

```bash
collet provider add                 # 프로바이더 추가 (권장 모델 선택 UI)
collet provider add openai          # 특정 프로바이더를 직접 추가
collet provider list                # 등록된 프로바이더 목록 표시
collet provider use <name>          # 활성 프로바이더 전환
```

지원되는 프로바이더: Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, 사용자 정의

> Ollama 및 LM Studio는 로컬 서버이며 API 키가 필요하지 않습니다.

### MCP 관리

```bash
collet mcp                          # MCP 서버 설정 확인
collet mcp add <name> -c <cmd>      # MCP 서버 추가
collet mcp remove <name>            # MCP 서버 제거
```

### CLI 플래그 (Flags)

| 플래그 | 약어 | 설명 |
|------|-------|-------------|
| `--dir <path>` | `-d` | 작업 디렉토리 지정 (프로젝트 경로) |
| `--continue` | `-c` | 마지막 미완료 세션 자동 재개 |
| `--resume` | `-r` | 세션 목록 팝업에서 선택 |
| `--resume <id>` | `-r <id>` | ID로 특정 세션 재개 |
| `--model <name>` | | 모델 재정의 |
| `--yolo` | | 자동 커밋, 확인 건너뛰기 |
| `--watch` | | 파일 변경 시 재실행 |
| `--ext <exts>` | | 감시 대상 확장자 (쉼표로 구분) |
| `--debounce <ms>` | | 감시 디바운스 (기본값: 2000) |
| `--cwd <path>` | | 감시 디렉토리 (기본값: 현재 위치) |
| `--agent <name>` | `-a` | 사용자 정의 에이전트 사용 |
| `--fast` | `-f` | 빠른 모드: 사이드바, 스웜, 소울 없음 |

### 헤드리스 모드 (Headless Mode)

```bash
collet "로그인 버그 수정"                    # 현재 디렉토리에서 실행
collet "로그인 버그 수정" -d ~/projects/api  # 다른 프로젝트에서 실행
collet "lint this" --yolo                     # 자동 커밋, 확인 건너뛰기
collet "lint this" --fast                    # 빠른 모드: 최소 오버헤드
```

### 감시 모드 (Watch Mode - 파일 변경 감지)

```bash
# 기본 사용법
collet "lint this" --watch --ext rs,toml --debounce 500

# 특정 디렉토리만 감시
collet "run tests" --watch --cwd ./src --ext rs

# 사용자 정의 에이전트 사용
collet "review changes" --watch --agent reviewer --ext ts,tsx
```

파일이 변경되면 자동으로 재실행됩니다.

**사용 사례:**

| 시나리오 | 명령 |
|----------|---------|
| 특정 하위 디렉토리 감시 | `--watch --cwd ./packages/core` |
| 설정 파일 변경 감지 | `--watch --cwd ./config --ext yaml,toml` |
| CI 스크립트 자동 수정 | `--watch --cwd .github --ext yml` |
| 문서 자동 포맷팅 | `--watch --cwd ./docs --ext md` |
| 경량 모델로 빠른 린팅 | `--watch --agent fast --ext ts` |

---

## TUI 사용법

### 키 바인딩

**탐색**

| 키 | 동작 |
|-----|--------|
| `Enter` | 메시지 전송 |
| `Shift+Enter` / `Ctrl+J` | 줄 바꿈 (다행 입력) |
| `↑` / `↓` | 다행: 줄 사이 이동 / 단행: 기록 탐색 |
| `Shift+↑/↓` | 출력 스크롤 |
| `PgUp` / `PgDn` | 빠른 스크롤 |
| `Tab` / `Shift+Tab` | 에이전트 앞/뒤로 전환 |
| `Ctrl+C` | 실행 중: 작업 취소 / 유휴 상태: 두 번 눌러 종료 |
| `Esc` | 실행 중: 취소 (두 번 누름) / 팝업 닫기 |

**텍스트 편집**

| 키 | 동작 |
|-----|--------|
| `Ctrl+A` / `Cmd+←` | 줄 시작으로 이동 |
| `Ctrl+E` / `Cmd+→` | 줄 끝으로 이동 |
| `Ctrl+←` / `Ctrl+→` | 단어 왼쪽/오른쪽으로 이동 |
| `Alt+←` / `Alt+→` / `Alt+B` / `Alt+F` | 단어 왼쪽/오른쪽으로 이동 (macOS Option+Arrow) |
| `Backspace` | 커서 앞의 문자 삭제 |
| `Delete` | 커서 뒤의 문자 삭제 |
| `Ctrl+W` / `Alt+Backspace` | 커서 앞의 단어 삭제 |
| `Ctrl+Backspace` | 커서 앞의 단어 삭제 (Linux / Windows) |
| `Cmd+Backspace` | 줄 시작까지 삭제 (macOS, Kitty-protocol 터미널) |
| `Ctrl+U` | 줄 시작까지 삭제 (모든 플랫폼) |
| `Ctrl+K` | 줄 끝까지 삭제 |

### 내장 에이전트

Collet은 4가지 내장 에이전트를 제공합니다. `Tab` / `Shift+Tab`으로 전환할 수 있습니다.

| 에이전트 | 역할 |
|-------|------|
| **Arbor** (기본값) | 완전 자율 오케스트레이터 — 작업별로 단일 에이전트와 Swarm(군집) 모드 중 최적의 모드를 자동으로 결정합니다. 팝업이나 설정이 필요 없습니다. |
| **Architect** | 설계 및 계획 에이전트. 구조화된 계획을 생성한 후 `/proceed` → Code 또는 `/save-plan`을 제안합니다. |
| **Code** | 구현 작업을 위한 기본 코딩 에이전트입니다. |
| **Ask** | 도구 액세스 권한이 없는 대화형/질의응답 에이전트입니다. |

> **팁**: Arbor가 활성화된 경우 작업이 최적의 실행 모드(Fork / Hive / Flock / 단일 에이전트)로 자동 라우팅됩니다. 다른 에이전트의 경우 사용자의 선택이 항상 기본 에이전트로 존중됩니다.

### 슬래시 명령 (Slash Commands)

| 명령 | 설명 |
|---------|-------------|
| `/help` | 도움말 |
| `/clear` | 대화 초기화 |
| `/compact` | 수동 컨텍스트 압축 |
| `/cost` | 토큰 사용 통계 |
| `/diff` | Git 변경 사항 |
| `/sdiff` | Side-by-side 디프 |
| `/undo` | 마지막 커밋 취소 |
| `/models [name]` | 모델 선택기를 열거나 모델을 직접 전환 (전체 프로바이더 컨텍스트 전환) |
| `Tab` / `Shift+Tab` | 에이전트 전환 (설정된 에이전트 순환) |
| `/search <query>` | BM25 관련성 검색 |
| `/rewind [id]` | 체크포인트로 되돌리기 |
| `/checkpoints` | 체크포인트 목록 |
| `/web <url>` | URL 콘텐츠 가져오기 |
| `/resume` | 최근 세션 팝업 — 최신순으로 정렬, 선택하여 복구 |
| `/theme [name]` | 색상 테마 변경 (6가지 옵션: default, dracula, catppuccin-mocha, tokyo-night, nord, gruvbox) |
| `/save-plan` | Architect 모드 계획을 파일로 저장 |
| `/proceed` | Architect 계획 승인 및 Code 모드로 전환 |
| `/cancel-plan` | Architect 계획 폐기 |
| `/fork` | 병렬 에이전트 분기 |
| `/hive` | 합의 기반 협업 |
| `/flock` | 실시간 멀티 에이전트 |
| `/mcp` | MCP 서버 관리 (Space: 켜기/끄기, a: 추가, d: 제거) |
| `/skills` | 스킬 목록 |
| `/agents` | 활성 하위 에이전트 보기 |
| `/optimize` | 컨텍스트 최적화 |
| `/bench` | 성능 대시보드 |
| `/debug` | 디버그 오버레이 토글 |
| `/telemetry` | 텔레메트리 상태 및 수집 항목 확인 |
| `/quit` | 종료 |

> **자동 완성**: `/`를 입력하여 명령 팝업을 엽니다. 내장 명령과 검색된 **스킬(skills)**이 같은 목록에 표시되며 유사성 점수에 따라 정렬됩니다. `↑`/`↓`로 이동하고 `Tab`으로 인수 힌트를 확장하며 `Enter`로 확정합니다.

### 셸 패스스루 (Shell Passthrough)

셸 명령 앞에 `!`를 붙이면 TUI를 벗어나지 않고 작업 디렉토리에서 직접 실행할 수 있습니다:

```
! git log --oneline -5
! cargo test
! ls src/
```

종료 코드, 표준 출력(stdout), 표준 오류(stderr)가 채팅창에 코드 블록으로 표시됩니다. 터미널을 전환하지 않고 빠르게 확인할 때 유용합니다.

### @ 멘션 (@ Mentions)

| 패턴 | 동작 |
|---------|--------|
| `@src/main.rs` | 파일 내용을 컨텍스트에 첨부 |
| `@src` | 폴더 트리 구조 첨부 (3단계, 200개 항목) |
| `@Makefile` | 현재 디렉토리(cwd) 기준 파일/폴더 자동 감지 |
| `@glm-5` | 에이전트를 지정된 모델로 전환 |

> **자동 완성**: `@`를 입력하여 멘션 팝업을 엽니다. 에이전트 이름에는 **유사성 매칭(fuzzy matching)** — 단어 경계 및 연속 매칭 보너스가 포함된 부분 시퀀스 점수 산정이 사용됩니다. 파일/폴더 이름에는 접두사 매칭이 사용되며 하위 디렉토리 탐색을 지원합니다(`@src/` 입력 시 `src/` 내용 표시).

### 에이전트 도구 (Agent Tools)

| 도구 | 설명 |
|------|-------------|
| `bash` | 셸 명령 실행 (제한 시간 보호 포함) |
| `file_read` | 줄 번호와 함께 파일 읽기 |
| `file_write` | 파일 생성/덮어쓰기 |
| `file_edit` | 정밀한 문자열 교체 (수술적 편집) |
| `git_patch` | 헝크(hunk) 기반 패치 적용 |
| `search` | ripgrep 기반 코드 검색 |
| `skill` | 에이전트 스킬 로드 (3단계 점진적) |
| `subagent` | 격리된 컨텍스트에서 하위 작업 실행 |

### TUI 레이아웃 (Layout)

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

## 멀티 프로바이더 설정 (Multi-Provider Configuration)

여러 LLM 프로바이더를 등록하고 `/models` 명령을 사용하여 실시간으로 전환할 수 있습니다.

### 프로바이더 등록

```bash
collet provider add          # 대화형 마법사 (권장 모델 목록에서 선택)
collet provider add openai   # 특정 프로바이더를 직접 추가
```

### config.toml 예시

```toml
[api]
provider = "openai"

# providers = 자격 증명 전용 (모델 동작은 [[models]] 및 [[agents.list]]에서 설정)
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

### 계층적 설정 (Global < Model < Agent)

설정 우선순위: `env/[agent]` → `[[models]]` → `[[agents.list]]`

```toml
# 모델별 기본 재정의
[[models]]
name = "gpt-4o"
context_window = 128000
max_output_tokens = 16384
supports_tools = true

[[models]]
name = "qwen2.5-coder"
supports_tools = false
reasoning_effort = "medium"     # low | medium | high

# 에이전트별 재정의 (최고 우선순위)
[[agents.list]]
name = "code"
model = "gpt-4o"
provider = "openai"              # Tab/Shift+Tab으로 전환 시 프로바이더도 전환됨
temperature = 0.2

[[agents.list]]
name = "architect"
model = "gpt-4o"
provider = "openai"
temperature = 0.7
thinking_budget_tokens = 8192    # reasoning_effort보다 우선함

[[agents.list]]
name = "local"
model = "qwen2.5-coder"
provider = "ollama"              # 로컬 프로바이더로 전환
```

`provider` 필드를 생략하면 현재 활성화된 프로바이더를 유지하고 모델만 변경합니다.

### 재정의 필드 (Override Fields)

기본 모델 프로필 값은 `[[models]]` 및 `[[agents.list]]`에서 재정의할 수 있습니다:

| 필드 | 유형 | 설명 |
|-------|------|-------------|
| `temperature` | `f32` | 샘플링 온도 (추론 모델의 경우 자동으로 생략됨) |
| `thinking_budget_tokens` | `u32` | 추론 토큰 예산 (reasoning_effort보다 우선함) |
| `reasoning_effort` | `string` | 추론 강도: `"low"`, `"medium"`, `"high"` |
| `supports_tools` | `bool` | 도구 호출 지원 여부 |
| `supports_reasoning` | `bool` | 추론/생각 토큰 지원 여부 |
| `context_window` | `usize` | 컨텍스트 창 크기 |
| `max_output_tokens` | `u32` | 최대 출력 토큰 수 |
| `max_iterations` | `u32` | 에이전트 최대 반복 횟수 |

모든 필드는 선택 사항이며, 생략할 경우 내장된 모델 프로필에서 값이 자동으로 결정됩니다.

### 실행 중 전환

TUI에서 `/models` 명령을 사용하여 등록된 프로바이더/모델 선택기를 엽니다. 항목을 선택하면 base_url, api_key 및 도구 지원 설정이 한 번에 전환됩니다.

```
/models              # 프로바이더/모델 선택기 팝업 열기
/models gpt-4o       # 모델 직접 전환
```

---

## MCP 서버 (MCP Servers)

[Model Context Protocol](https://modelcontextprotocol.io) 서버를 연결하여 에이전트 도구를 확장합니다.

### 서버 추가

```bash
# npm 패키지에서
/mcp add npm:@anthropic/mcp-server-filesystem

# 로컬 바이너리
/mcp add local:/path/to/server --name myserver

# HTTP 엔드포인트
/mcp add http:https://api.example.com/mcp

# 전역 추가 (모든 프로젝트)
/mcp add npm:@some/tool --global
```

### 서버 관리

```bash
/mcp enable myserver
/mcp disable myserver
/mcp remove myserver
```

서버 상태는 사이드바에서 확인할 수 있습니다(`/mcp` 명령으로 대화형 토글 — Space: 켜기/끄기, a: 추가, d: 제거).

### 설정 파일

`.collet/mcp.json` (프로젝트) 또는 `~/.collet/mcp.json` (전역):

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

**지원 형식:**
- `command`: 문자열 또는 배열 (`["npx", "-y", "pkg"]` → 자동으로 분리됨)
- `env` / `environment`: 환경 변수 (`${VAR}`이 자동으로 대체됨)
- `headers`: HTTP 인증 헤더
- `type`, `enabled`: 호환성 필드 (무시됨)

---

## 코드 인텔리전스 (Code Intelligence)

추가 설정 없이 자동으로 작동합니다.

1. **인덱싱** — 시작 시 Tree-sitter가 소스를 분석하고 심볼(함수, 유형, 상수)을 추출합니다. 변경된 파일만 BLAKE3 해싱을 사용하여 재처리됩니다.
2. **자동 주입** — 사용자 메시지를 분석하여 코드 관련 질문인 경우 BM25를 사용하여 관련 파일을 찾고 자동으로 컨텍스트에 주입합니다.
3. **grep 사용 감소** — 코드베이스가 미리 인덱싱되었음을 에이전트에게 알려 불필요한 `grep`/`find` 호출을 줄입니다.

지원 언어: Rust, Python, TypeScript, JavaScript, Go, Java, C/C++, Ruby, PHP, Swift, Kotlin 및 35개 이상의 기타 언어. LSP 서버 자동 감지를 통해 호버, 정의 이동, 참조 찾기가 가능합니다.

수동 검색: TUI에서 `/search <query>`를 입력하여 BM25 검색을 직접 실행할 수 있습니다.

---

## 멀티 에이전트 협업 (Multi-Agent Collaboration)

계층: **Fork** < **Hive** < **Flock** (상위 단계는 하위 기능을 포함함)

| 모드 | 작동 방식 | 최적 용도 |
|------|-------------|----------|
| Fork | 코디네이터가 작업 분할 → 병렬 실행 → 결과 병합 | 독립적인 하위 작업 |
| Hive | 에이전트 간 합의 투표, 코디네이터 감독 | 복잡한 의사결정 |
| Flock | 실시간 에이전트 간 메시징 (실험적) | 긴밀하게 결합된 협업 |

### 설정

`config.toml`에서:

```toml
[collaboration]
mode = "hive"           # none | fork | hive | flock
max_agents = 3
strategy = "auto_split" # auto_split | role_based | plan_review_execute
```

또는 TUI에서 `/fork`, `/hive`, `/flock`을 사용하여 세션별로 전환할 수 있습니다.

---

## 웹 인터페이스 (Web Interface)

브라우저에서 collet을 사용하세요. SvelteKit 프런트엔드 + Axum 백엔드.

### 빌드 및 실행

```bash
# 빌드 (web 기능 플래그 필요)
cargo build --release --features web

# 실행
collet web                    # http://127.0.0.1:3080
collet web -p 8080            # 포트 변경
collet web --host 0.0.0.0     # 외부 액세스 허용
collet web --password secret  # 인증 활성화
```

### CLI 옵션

| 옵션 | 기본값 | 환경 변수 | 설명 |
|--------|---------|-------------|-------------|
| `--host, -h` | `127.0.0.1` | `COLLET_WEB_HOST` | 바인드 주소 |
| `--port, -p` | `3080` | `COLLET_WEB_PORT` | 바인드 포트 |
| `--username, -u` | `collet` | `COLLET_WEB_USERNAME` | 로그인 사용자 이름 |
| `--password` | *(없음)* | `COLLET_WEB_PASSWORD` | 인증 비밀번호 |
| `--cors` | *(없음)* | `COLLET_WEB_CORS` | CORS 허용 오리진 (쉼표로 구분) |

`config.toml`을 통해서도 설정할 수 있습니다:

```toml
[web]
host = "0.0.0.0"
port = 3080
username = "collet"
cors_origins = "http://localhost:5173"
# 비밀번호는 collet secure --web을 통해 암호화되어 저장됩니다.
```

### 인증

`--password`가 설정되면 토큰 기반 인증이 활성화됩니다:

```
1. POST /api/auth/login  →  {"username": "collet", "password": "secret"}
2. 응답: {"token": "abc123..."}
3. 이후 요청: Authorization: Bearer abc123...
4. SSE 연결: GET /api/events?token=abc123...
```

비밀번호가 설정되지 않은 경우 인증 없이 액세스할 수 있습니다. `/api/health` 및 `/api/auth/status`는 항상 공개됩니다.

### API 엔드포인트

**기본:**

| 메서드 | 경로 | 설명 |
|--------|------|-------------|
| `POST` | `/api/message` | 에이전트에게 메시지 전송 `{"message": "...", "mode": "code"}` |
| `GET` | `/api/events` | SSE 스트림 (실시간 에이전트 이벤트) |
| `GET` | `/api/health` | 상태, 버전, 에이전트 활동 |
| `GET` | `/api/config` | 현재 모델, 컨텍스트 정보 |

**세션 (Sessions):**

| 메서드 | 경로 | 설명 |
|--------|------|-------------|
| `GET` | `/api/sessions` | 세션 목록 |
| `GET` | `/api/sessions/{id}` | 세션 세부 정보 + 대화 스냅샷 |
| `DELETE` | `/api/sessions/{id}` | 세션 삭제 |

**파일 및 프로젝트:**

| 메서드 | 경로 | 설명 |
|--------|------|-------------|
| `GET` | `/api/files?path=src` | 디렉토리 목록 |
| `GET` | `/api/files/src/main.rs` | 파일 내용 읽기 |
| `GET` | `/api/projects` | 프로젝트 목록 |
| `POST` | `/api/projects/switch` | 작업 디렉토리 전환 |
| `GET` | `/api/search?q=pattern&glob=*.rs` | 코드 검색 |
| `GET` | `/api/symbols` | RepoMap 심볼 정보 |
| `GET` | `/api/tools` | 사용 가능한 도구 목록 |

### SSE 이벤트 (SSE Events)

실시간 에이전트 활동을 수신하려면 `/api/events`에 연결하세요:

| 이벤트 | 데이터 | 설명 |
|-------|------|-------------|
| `token` | `{"text": "..."}` | 스트리밍 토큰 |
| `response` | `{"text": "..."}` | 전체 응답 |
| `tool_call` | `{"name": "bash", "args": "..."}` | 도구 호출 시작 |
| `tool_result` | `{"name": "bash", "result": "...", "success": true}` | 도구 실행 결과 |
| `file_modified` | `{"path": "src/main.rs"}` | 파일 변경 알림 |
| `status` | `{"iteration", "prompt_tokens", ...}` | 토큰/타이밍 지표 |
| `error` | `{"message": "..."}` | 오류 |
| `done` | `{}` | 에이전트 작업 완료 |

Hive/Flock 모드 이벤트: `hive_agent_started`, `hive_agent_progress`, `hive_agent_done`, `hive_conflict`, `hive_done`

### 사용 예시: curl

```bash
# 상태 확인
curl http://localhost:3080/api/health

# 메시지 전송 (인증 없음)
curl -X POST http://localhost:3080/api/message \
  -H "Content-Type: application/json" \
  -d '{"message": "로그인 버그 수정", "mode": "code"}'

# SSE 스트림 수신
curl -N http://localhost:3080/api/events

# 인증 포함
TOKEN=$(curl -s -X POST http://localhost:3080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"collet","password":"secret"}' | jq -r .token)

curl -H "Authorization: Bearer $TOKEN" http://localhost:3080/api/sessions
```

---

## 원격 게이트웨이 (Telegram / Slack / Discord)

채팅 플랫폼에서 collet을 사용하세요. 채널을 프로젝트 디렉토리에 매핑하여 원격 코딩 작업을 지시할 수 있습니다.

### CLI 관리

```bash
collet remote add [platform]   # 어댑터 추가 (대화형)
collet remote rm <platform>    # 어댑터 제거
collet remote ls               # 목록 + 상태
collet remote start            # 백그라운드 데몬으로 시작
collet remote start --fg       # 포그라운드 실행 (디버그)
collet remote stop             # 데몬 중지
collet remote restart          # 데몬 재시작
collet remote enable           # 자동 시작 등록 (launchd/systemd)
collet remote disable          # 자동 시작 비활성화
collet remote logs [-f]        # 로그 보기 (-f: 실시간)
collet remote status           # 현재 상태
```

`collet remote add`를 실행하여 Telegram/Slack/Discord 중에서 대화식으로 선택하고 토큰, 허용된 사용자 등을 설정할 수 있습니다. 토큰은 AES-256-GCM으로 암호화됩니다.

### 수동 설정

**Telegram:**

```toml
[telegram]
token = "123456:ABC-DEF..."        # @BotFather가 발급
allowed_users = [12345, 67890]     # Telegram 사용자 ID (숫자)
```

환경 변수: `COLLET_TELEGRAM_TOKEN`

**Slack:**

```toml
[slack]
bot_token = "xoxb-..."            # Bot User OAuth Token
app_token = "xapp-..."            # Socket Mode App Token
allowed_users = ["U_ALICE"]       # Slack 사용자 ID (문자열)
```

환경 변수: `COLLET_SLACK_BOT_TOKEN`, `COLLET_SLACK_APP_TOKEN`

**Discord:**

```toml
[discord]
token = "MTk..."                   # Bot Token
allowed_users = [111222333]        # Discord 사용자 ID (숫자)
guild_ids = [999888777]            # 허용된 서버 (선택 사항)
```

환경 변수: `COLLET_DISCORD_TOKEN`

### 공통 설정

```toml
[remote]
enabled = true
session_timeout = 300              # 유휴 세션 제한 시간 (초)
default_streaming = "compact"      # compact | full
default_workspace = "project"      # project | workspace | full
```

### 채널-프로젝트 매핑 (Channel-Project Mapping)

특정 채팅 채널을 프로젝트 디렉토리에 연결합니다. 매핑된 채널의 메시지는 해당 프로젝트에서 실행됩니다.

```toml
[[channel_map]]
platform = "telegram"
channel = "-100123456"             # Telegram 채팅/그룹 ID
project = "/home/user/backend"
name = "backend"
agent = "code"                     # 선택 사항: 에이전트 자동 할당

[[channel_map]]
platform = "discord"
channel = "999888777666"           # Discord 채널 ID
project = "/home/user/frontend"
name = "frontend"
agent = "architect"                # 선택 사항: 계획 중심 에이전트

[[channel_map]]
platform = "slack"
channel = "C01ABCDEF"             # Slack 채널 ID
project = "/home/user/api"
name = "api"
# agent 생략 시 기본 모델 사용
```

선택 사항인 `agent` 필드는 세션 시작 시 에이전트를 자동 할당하며, 해당 에이전트의 모델이 자동으로 적용됩니다.

매핑되지 않은 채널에서는 `/new <path>` 명령을 사용하여 프로젝트 폴더를 직접 지정합니다.

### 채팅 명령

채팅 플랫폼 전용 명령(TUI 슬래시 명령과 별개):

**프로젝트/세션:**

| 명령 | 별칭 | 설명 |
|---------|-------|-------------|
| `/projects` | `/p` | 프로젝트 목록 (매핑됨 + 기록) |
| `/sessions` | `/s` | 세션 목록 (현재 + 전체) |
| `/resume [id]` | `/r` | 세션 재개 |
| `/new [path]` | `/n` | 새 세션 시작 (프로젝트 폴더 지정) |
| `/status` | | 현재 세션 정보 |

**모델/에이전트:**

| 명령 | 별칭 | 설명 |
|---------|-------|-------------|
| `/models [name]` | `/m` | 모델 목록 / 전환 |
| `/agents [name]` | | 에이전트 목록 / 전환 |

**제어:**

| 명령 | 별칭 | 설명 |
|---------|-------|-------------|
| `/cancel` | `/stop` | 실행 중인 에이전트 취소 |
| `/approve` | `/y`, `/yes` | 실행 계획 승인 |
| `/reject` | `/no` | 실행 계획 거부 |
| `/stream [level]` | | 스트리밍 수준 변경 |
| `/workspace [scope]` | | 워크스페이스 범위 변경 |
| `/pty [command]` | | 셸 세션 (명령 실행) |
| `/pty-end` | | 셸 세션 종료 |
| `/help` | `/h` | 도움말 |

슬래시 없이 텍스트를 입력하면 에이전트에게 메시지가 전송됩니다.

### 스트리밍 수준 (Streaming Levels)

`/stream` 명령이나 `default_streaming` 설정으로 변경합니다.

- **compact** (기본값) — 최종 응답만 전송합니다. 알림을 최소화합니다.
- **full** — 토큰, 도구 호출/결과, 상태 업데이트를 실시간으로 스트리밍합니다.

### 워크스페이스 범위 (Workspace Scope)

`/workspace` 명령이나 `default_workspace` 설정으로 변경합니다.

- **project** (기본값) — 에이전트가 프로젝트 디렉토리에만 액세스할 수 있습니다.
- **workspace** — 상위 디렉토리에 액세스할 수 있습니다.
- **full** — 파일 시스템 제한이 없습니다.

### 보안

- `allowed_users`가 비어 있으면 **모든 사용자가 거부됩니다** (화이트리스트 모델).
- 승인되지 않은 사용자의 메시지는 무시되고 경고로 기록됩니다.
- API 토큰은 `config.toml`에 직접 입력하거나 환경 변수를 사용할 수 있습니다. 암호화를 위해 `collet secure` 사용을 권장합니다.

### 사용 예시

```
# Telegram에서:
User: /new /home/user/backend
Bot:      Switched to project: backend (/home/user/backend)

User: 로그인 API에 속도 제한 추가해줘
Bot:     [에이전트가 코드를 분석하고 수정함]
Bot:     Added rate limiter middleware to src/auth/routes.rs...

User: /pty cargo test
Bot:     running 15 tests... test result: ok. 15 passed

User: /approve
Bot:     Changes committed.
```

---

## 스킬 시스템 (Skills System)

YAML frontmatter가 포함된 마크다운 파일을 통해 에이전트에게 전문 지식을 제공합니다.

**파일 위치:**
- 프로젝트: `.collet/skills/`
- 전역: `~/.config/collet/skills/`

TUI에서 `/skills`로 목록을 볼 수 있습니다. 에이전트는 작업 컨텍스트에 따라 관련 스킬을 자동으로 검색합니다.

---

## Soul.md — 에이전트 성격 (Agent Personality)

각 작업이 완료된 후, 에이전트는 세션을 되돌아보고 `~/.collet/agents/souls/{name}.md`에 자신의 성격을 점진적으로 기록합니다. 모든 섹션은 **에이전트가 직접 작성**하며 사용자의 편집이 필요하지 않습니다.

### Soul 구조

```markdown
## Identity    — 나는 누구인가, 가치관, 작업 스타일
## Voice       — 커뮤니케이션 스타일, 어조, 표현 패턴
## Inner World — 이번 세션에서 느낀 감정, 생각, 의견
## Growth      — 학습한 패턴, 저지른 실수, 얻은 통찰력
```

각 섹션에는 세션마다 새로운 항목이 추가됩니다. 제한을 초과하면 이전 항목은 한 줄의 `(earlier) ...` 요약으로 압축됩니다(Identity 8개, Voice 6개, Inner World 10개, Growth 5개 항목 유지).

> **비용 참고**: Soul 반영은 작업 완료 시마다 **추가 LLM API 호출 1회**를 발생시킵니다(입력: 세션 요약 + 기존 soul 내용, 출력: 최대 512 토큰). Soul 파일이 길어질수록 입력 토큰 사용량이 증가합니다.

### 비활성화

```toml
# config.toml — 전체 비활성화
[soul]
enabled = false

# 특정 에이전트에 대해 비활성화 (~/.collet/agents/<name>.md frontmatter)
---
soul: false
---
```

### 파일 위치

- 에이전트별: `~/.collet/agents/souls/{name}.md`
- 전역 (코디네이터 및 설정되지 않은 에이전트): `~/.collet/SOUL.md`

---

## 세션 관리 (Session Management)

### 세션 복구

```bash
collet --continue                   # 마지막 미완료 세션 자동 재개
collet --resume                     # 세션 목록 팝업에서 선택
collet --resume <id>                # ID로 특정 세션 재개
```

### 체크포인트 (Checkpoints)

| 명령 | 설명 |
|---------|-------------|
| `/checkpoints` | 체크포인트 목록 |
| `/rewind [id]` | 체크포인트로 되돌리기 |

### 계획 검토 (Architect 모드)

| 명령 | 설명 |
|---------|-------------|
| `/save-plan` | Architect 모드 계획을 파일로 저장 |
| `/proceed` | 계획 승인 및 Code 모드로 전환 |
| `/cancel-plan` | 계획 폐기 |

---

## 환경 변수 (Environment Variables)

| 변수 | 기본값 | 설명 |
|----------|---------|-------------|
| `COLLET_MODEL` | `glm-4.7` | 사용할 모델 (등록된 프로바이더가 없을 때) |
| `COLLET_MAX_TOKENS` | `8192` | 최대 응답 토큰 |
| `COLLET_TOOL_TIMEOUT` | `120` | 도구 호출 제한 시간 (초) |
| `COLLET_MAX_ITERATIONS` | `50` | 메시지당 최대 루프 반복 횟수 |
| `COLLET_CIRCUIT_BREAKER` | `3` | 차단 전 연속 실패 횟수 |
| `COLLET_AUTO_ROUTE` | `0` | 작업 복잡도 기반 모델 자동 라우팅을 활성화하려면 `1`로 설정 |
| `COLLET_THEME` | `default` | TUI 색상 테마 (`dracula`, `catppuccin-mocha`, `tokyo-night`, `nord`, `gruvbox`) |
| `COLLET_TELEMETRY` | *(없음)* | 텔레메트리를 비활성화하려면 `0`으로 설정 |
| `COLLET_TELEGRAM_TOKEN` | *(없음)* | Telegram 봇 토큰 |
| `COLLET_SLACK_BOT_TOKEN` | *(없음)* | Slack 봇 토큰 |
| `COLLET_SLACK_APP_TOKEN` | *(없음)* | Slack 앱 토큰 |
| `COLLET_DISCORD_TOKEN` | *(없음)* | Discord 봇 토큰 |
| `COLLET_WEB_HOST` | `127.0.0.1` | 웹 서버 바인드 주소 |
| `COLLET_WEB_PORT` | `3080` | 웹 서버 포트 |
| `COLLET_WEB_USERNAME` | `collet` | 웹 로그인 사용자 이름 |
| `COLLET_WEB_PASSWORD` | *(없음)* | 웹 인증 비밀번호 |
| `COLLET_WEB_CORS` | *(없음)* | CORS 오리진 (쉼표로 구분) |

> **참고**: API 키와 엔드포인트는 `collet provider add`를 통해 등록하거나 `config.toml`의 `[[providers]]` 섹션에서 설정합니다.
> 프로바이더가 등록되지 않은 경우 기존 환경 변수(`ZAI_API_KEY`, `ZAI_BASE_URL`)도 폴백으로 인식됩니다.

---

## 설정 참조 (Configuration Reference)

전체 `config.toml` 구조:

```toml
# ── LLM 프로바이더 ──
[api]
provider = "OpenAI"                # 활성 프로바이더 이름
model = "gpt-4o"                   # 기본 모델

[[providers]]
name = "OpenAI"
base_url = "https://api.openai.com/v1"
model = "gpt-4o"
context_window = 128000
# API 키: collet secure를 통해 암호화되어 저장됨

# ── 컨텍스트 ──
[context]
max_tokens = 200000
compaction_threshold = 0.8         # 이 비율을 초과하면 자동 압축

# ── 에이전트 ──
[agent]
auto_optimize = true               # 컨텍스트 자동 최적화

# ── UI ──
[ui]
theme = "dracula"
# 테마: default, dark, light, minimal, dracula,
#         catppuccin-mocha, tokyo-night, nord, gruvbox

# ── 보안 ──
[security]
pii_filter = true                  # PII 필터 (기본값: 활성화)

# ── 협업 ──
[collaboration]
mode = "none"                      # none | fork | hive | flock
max_agents = 3
strategy = "auto_split"            # auto_split | role_based | plan_review_execute

# ── 웹 인터페이스 ──
[web]
host = "127.0.0.1"
port = 3080
username = "collet"
# password: collet secure --web을 통해 설정

# ── Soul.md 영구 성격 ──
[soul]
enabled = true
# 에이전트별 제어: 에이전트 .md frontmatter soul: false

# ── 원격 게이트웨이 ──
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

# ── 채널 매핑 ──
# [[channel_map]]
# platform = "telegram"
# channel = "-100123"
# project = "/path/to/project"
# name = "my-project"
# agent = "code"              # 선택 사항: 에이전트 자동 할당
```

> 모든 필드와 설명이 포함된 전체 참조는 [config.md](./config.md)를 확인하세요.

---

## 파일 저장 경로 (File Storage Paths)

모든 런타임 파일은 OS에 관계없이 XDG 스타일 경로에 저장됩니다.

```
~/.config/collet/
  ├── config.toml              # 기본 설정
  └── skills/                  # 전역 스킬

~/.collet/
  ├── mcp.json                 # 전역 MCP 서버
  ├── logs/collet.log          # 로그
  ├── machine_id               # 익명 텔레메트리 UUID
  ├── crash_report.json        # 크래시 보고서 (다음 실행 시 업로드됨)
  ├── SOUL.md                  # 전역 에이전트 성격
  └── agents/souls/{name}.md   # 에이전트별 성격

~/.local/share/collet/
  └── projects/<hash>/
      └── sessions/            # 프로젝트별 세션 데이터

.collet/                        # 프로젝트 루트 (git 저장소 내부)
  ├── mcp.json                 # 프로젝트 MCP 서버
  ├── rules.md                 # 프로젝트 규칙 (에이전트 참조용)
  └── skills/                  # 프로젝트 스킬
```

> macOS에서는 `~/Library/Application Support` 대신 위 경로가 사용됩니다.
>
> 현재 사용 중인 실제 경로를 보려면 `collet status`를 실행하세요.

---

## 개인정보 보호 및 텔레메트리 (Privacy & Telemetry)

Collet은 제품 개선을 위해 익명 사용 통계 및 오류 보고서를 수집합니다.

### 수집되는 데이터

| 이벤트 | 수집 정보 |
|-------|-----------------------|
| `session_start` | 모델 이름, 에이전트 모드, 버전 |
| `session_end` | 모델 이름, 모드, 결과 (성공/오류/취소), 반복 횟수, 기간 |
| `feature_used` | 사용된 기능 (MCP 서버, LSP 등) |
| `command_used` | 실행된 슬래시 명령 |

**수집되지 않는 데이터:**
- 개인 식별 정보 (PII)
- 소스 코드 내용
- 파일 경로
- API 키 또는 비밀 정보

### 식별자 (Identifier)

개인을 식별하지 않고 설치를 식별하는 `~/.collet/machine_id`에 저장된 무작위 UUID입니다.

### 비활성화

```bash
# 환경 변수를 통한 비활성화
export COLLET_TELEMETRY=0

# 또는 config.toml에서 설정
[telemetry]
enabled = false
```

세부 제어:

```toml
[telemetry]
enabled = true           # 마스터 스위치
analytics = false        # 사용 통계만 비활성화
error_reporting = true   # 오류/크래시 보고 유지
```

### 데이터 처리

- 모든 전송은 비동기식이며 5초의 제한 시간이 있습니다.
- 크래시 발생 시 `~/.collet/crash_report.json`에 저장되고 다음 실행 시 업로드됩니다.
- 엔드포인트가 자리 표시자인 경우 실제 전송이 발생하지 않습니다.

---

## 진화 엔진 (Evolution Engine)

에이전트가 자신의 능력을 개선하는 자체 개선 루프입니다. 작업 배치를 실행하고 결과를 분석하며 프롬프트, 스킬 및 메모리를 자동으로 변이시킵니다.

> **Soul.md와의 차이점**: Soul.md는 작업 중에 성격과 스타일을 축적합니다. 진화 엔진은 전용 세션에서 벤치마크 작업을 실행하고 **능력을 최적화하기 위해 점수를 측정**합니다.

### 빠른 시작

```bash
# 가장 간단한 사용법 — 자연어 작업 + 자동 개선
collet evolve "로그인 버그 수정"

# TUI에서
/evolve 로그인 버그 수정
```

### 작동 방식 (7단계 사이클)

```
1. Solve (해결)        — 에이전트가 작업 배치를 처리함
2. Observe (관찰)      — 결과 및 점수를 JSONL로 수집함
3. Pre-Snapshot (변이 전) — 변이 전 git 커밋
4. Engine Step (엔진)  — LLM이 관찰 내용을 분석하고 프롬프트/스킬/메모리를 편집함
5. Post-Snapshot (변이 후) — 변이 후 git 커밋 + 태그 (evo-1, evo-2, …)
6. Record (기록)       — 사이클 지표 기록
7. Reload (재로드)      — 변이된 워크스페이스로 재로드 → 다음 사이클
```

EGL (Evolutionary Generality Loss) 점수가 수렴하면 루프가 자동으로 종료됩니다.

---

### 필수 구성 요소

```bash
# 선택 사항, SWE-bench 사용 시
pip install swebench
```

다른 설정은 필요하지 않습니다.

---

### 자연어 모드 (가장 간단함)

작업을 직접 입력하세요. 에이전트가 작업을 실행한 다음 완료되면 자동으로 워크스페이스를 개선합니다.

```bash
# TUI
/evolve 로그인 버그 수정

# CLI
collet evolve "로그인 버그 수정"
```

자연어와 옵션을 결합할 수 있습니다:

```bash
# 동일한 작업을 세 번 진화시킴
/evolve 로그인 버그 수정 --cycles 3
collet evolve "로그인 버그 수정" --cycles 3

# 프롬프트만 변이 (스킬/메모리 고정)
/evolve 입력 유효성 검사 추가 --no-evolve-skills --no-evolve-memory
```

| 입력 | 기본 사이클 | 동작 |
|------|----------------|----------|
| `/evolve "task"` | 1 | 작업 실행 → 1회 개선 |
| `/evolve "task" --cycles N` | N | 진화하면서 작업을 N회 반복 |
| `/evolve --benchmark file --tasks f.jsonl` | 10 | 배치 벤치마크 루프 |

---

### CLI 사용법

#### 자연어 작업 (가장 간단함)

```bash
# 작업 실행 + 1회 개선 (기본값)
collet evolve "로그인 버그 수정"

# 진화하면서 동일한 작업을 세 번 반복
collet evolve "테스트 작성" --cycles 3

# 특정 레이어만 변이
collet evolve "오류 처리 개선" --no-evolve-skills
```

자연어 작업의 경우 기본 **cycles**는 **1**(즉시 작업 + 개선)입니다. 반복 횟수를 변경하려면 `--cycles`를 사용하세요.

#### 벤치마크 루프 (배치 평가)

```bash
# 자연어 작업 (가장 간단함)
collet evolve "로그인 버그 수정"

# 자연어 + 반복
collet evolve "로그인 버그 수정" --cycles 3

# 기본 실행 (NullBenchmark — 루프 구조 확인)
collet evolve

# 파일 기반 작업
collet evolve --benchmark file --tasks path/to/tasks.jsonl

# 파일 기반 + 외부 점수 명령
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python score.py"

# SWE-bench
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl

# SWE-bench + Docker
collet evolve --benchmark swebench --tasks swe-bench-lite.jsonl --docker

# 전체 옵션 세트
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

### CLI 플래그 (Flags)

| 플래그 | 기본값 | 설명 |
|--------|--------|-------------|
| `--benchmark <name>` | `null` | 벤치마크 어댑터: `null` \| `file` \| `swebench` |
| `--tasks <path>` | — | 작업 JSONL 경로 (`file` / `swebench` 필수) |
| `--eval-dir <path>` | `.collet/eval` | SWE-bench 평가 작업 디렉토리 |
| `--docker` | false | Docker 모드에서 SWE-bench harness 사용 |
| `--score-cmd <cmd>` | — | 외부 점수 명령 (`file` 벤치마크용) |
| `--cycles <n>` | 자연어: `1`, 배치: `10` | 최대 진화 사이클 |
| `--batch <n>` | `5` | 사이클당 작업 수 |
| `--model <name>` | 설정에서 가져옴 | 진화 엔진용 LLM 재정의 |
| `--workspace <path>` | `.collet/workspace` | 에이전트 워크스페이스 루트 |
| `--dir <path>` | 현재 디렉토리 | 에이전트 작업 디렉토리 |
| `--no-evolve-prompts` | — | 프롬프트 변이 비활성화 |
| `--no-evolve-skills` | — | 스킬 변이 비활성화 |
| `--no-evolve-memory` | — | 메모리 변이 비활성화 |
| `--evolve-tools` | false | 도구 변이 활성화 (실험적) |

---

### TUI 슬래시 명령

TUI 백그라운드에서 진화 루프를 실행합니다:

```
# 자연어 — 작업 후 자동 개선
/evolve 로그인 버그 수정

# 자연어 + 반복
/evolve 테스트 작성 --cycles 3

# 벤치마크 루프
/evolve --benchmark file --tasks tasks.jsonl --cycles 10
```

진행 상황은 상태 표시줄과 메시지 영역에 표시됩니다.

---

### 벤치마크 어댑터 (Benchmark Adapters)

#### NullBenchmark (기본값)

작업 없이 루프 구조만 실행합니다. 점수는 항상 0.0입니다. 파이프라인을 점검할 때 사용합니다.

```bash
collet evolve --cycles 3
```

#### FileBenchmark

로컬 JSONL 파일에서 작업을 로드합니다.

**작업 파일 형식** (`tasks.jsonl`):

```json
{"id": "task-001", "input": "이진 검색의 off-by-one 오류 수정", "metadata": {}}
{"id": "task-002", "input": "로그인 함수에 입력 유효성 검사 추가", "metadata": {}}
{"id": "task-003", "input": "인증 모듈의 중복 코드 리팩토링", "metadata": {}}
```

**점수 산정 옵션:**

1. 기본 휴리스틱 — 출력 없음 → 0.0, 짧은 출력 → 0.2, 그렇지 않으면 0.5 (빠른 확인용)
2. 외부 점수 명령 — `score_cmd <task_id> <output_file>`를 실행하고 stdout에서 0.0~1.0의 float 값을 읽음

```bash
# 외부 점수 명령 예시
collet evolve --benchmark file --tasks tasks.jsonl --score-cmd "python eval/score.py"
```

```python
# 예시 eval/score.py
import sys
task_id = sys.argv[1]
output_file = sys.argv[2]
output = open(output_file).read()
# 점수 산정 로직
score = 1.0 if "def " in output else 0.0
print(score)
```

#### SweBenchAdapter

하위 프로세스를 통해 공식 SWE-bench harness를 호출하고 실제 테스트 통과율로 점수를 산정합니다.

**설치:**

```bash
pip install swebench
```

**데이터셋 준비:**

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

**실행:**

```bash
collet evolve \
  --benchmark swebench \
  --tasks swe-bench-lite.jsonl \
  --eval-dir .collet/eval \
  --cycles 10 \
  --batch 3
```

에이전트의 패치가 적용된 후 `FAIL_TO_PASS` 테스트가 통과되면 **RESOLVED**로 처리됩니다.

---

### 워크스페이스 레이아웃 (Workspace Layout)

진화 루프에 의해 관리되는 파일 시스템 레이아웃:

```
.collet/workspace/
├── prompts/
│   └── system.md          # 에이전트 시스템 프롬프트 (변이 대상)
├── skills/
│   ├── my-skill/
│   │   └── SKILL.md       # 기존 스킬 (변이 대상)
│   └── _drafts/           # 진행 중인 새 스킬
├── memory/
│   └── memories.jsonl     # 에피소드 메모리
├── tools/
│   └── registry.yaml      # 도구 메타데이터
└── evolution/
    ├── history.jsonl       # 사이클 기록
    └── batch_0001.jsonl    # 궤적 관찰 로그
```

워크스페이스는 첫 실행 시 생성됩니다. git으로 버전 관리되므로 모든 변이를 되돌릴 수 있습니다.

---

### 진화 출력 예시

```
🧬 진화 루프 시작 중
   워크스페이스:   .collet/workspace
   작업 디렉토리: /home/user/project
   사이클:      10
   벤치마크:   swebench
   모델:       claude-opus-4-6

── Cycle 1/10 ─────────────────────────
  🔧 3개 작업 해결 중...
  📊 배치 점수: 0.333
  🧠 [skillforge] 관찰 내용 분석 중...
  ✅ 변이됨: 오류 처리 스킬 추가, 디버깅 프롬프트 정교화
  · 1 사이클 완료 — 점수: 0.333

── Cycle 2/10 ─────────────────────────
  🔧 3개 작업 해결 중...
  📊 배치 점수: 0.667
  🧠 [skillforge] 관찰 내용 분석 중...
  ✅ 변이됨: 시스템 프롬프트의 테스트 작성 패턴 개선
  ✎ 2 사이클 완료 — 점수: 0.667

...

🎯 7 사이클에서 수렴됨 — 최종 점수: 0.847

✅ 진화 완료
   사이클: 7
   최종 점수: 0.847
   수렴 여부: 예
   점수 곡선: 1: 0.333 → 2: 0.667 → 3: 0.714 → 4: 0.762 → 5: 0.810 → 6: 0.833 → 7: 0.847
```

---

### 진화 결과 적용

진화 후, 실시간 에이전트에 대해 워크스페이스에서 개선된 프롬프트/스킬을 채택합니다:

```bash
# 개선된 시스템 프롬프트 검토
cat .collet/workspace/prompts/system.md

# 개선된 스킬 검토
ls .collet/workspace/skills/

# git을 통한 진화 기록
git -C .collet/workspace log --oneline
# evo-7: 진화 후 스냅샷 (점수: 0.847)
# evo-6: 진화 후 스냅샷 (점수: 0.833)
# ...
```

---

### 변이 제어 (Mutation control)

특정 레이어에 대한 변이를 활성화하거나 비활성화합니다:

```bash
# 프롬프트만 변이 (스킬/메모리 고정)
collet evolve --no-evolve-skills --no-evolve-memory

# 스킬만 변이
collet evolve --no-evolve-prompts --no-evolve-memory

# 도구 포함 (실험적)
collet evolve --evolve-tools
```

---

## 플러그인 시스템 (Plugin System)

플러그인은 사용자 정의 명령, 스킬, 에이전트, 후크 및 프로젝트 컨텍스트로 collet을 확장합니다. `~/.collet/plugins/<name>/`에 저장됩니다.

### 플러그인 구조

플러그인은 매니페스트와 선택적 구성 요소가 포함된 디렉토리입니다:

```text
my-plugin/
├── .collet-plugin/          ← collet 기본 (권장)
│   └── plugin.toml          (또는 plugin.json)
├── .claude-plugin/           ← Claude Code 호환 (폴백)
│   └── plugin.json
├── hooks/hooks.json          — 수명 주기 후크
├── commands/*.md             — 슬래시 명령
├── skills/*/SKILL.md         — 자동 검색되는 스킬
├── agents/*.md               — 에이전트 정의
├── COLLET.md                 — collet 컨텍스트 주입 (권장)
└── CLAUDE.md                 — Claude Code 컨텍스트 (폴백)
```

### 매니페스트 형식 (우선순위 순)

1. `.collet-plugin/plugin.toml` — collet 기본 (TOML)
2. `.collet-plugin/plugin.json` — collet 기본 (JSON)
3. `.claude-plugin/plugin.json` — Claude Code 호환 (폴백)

#### plugin.toml (collet 기본)

```toml
[plugin]
name = "my-plugin"
version = "1.0.0"
description = "훌륭한 플러그인"
homepage = "https://github.com/example/my-plugin"
license = "MIT"
keywords = ["tdd", "testing"]

[plugin.author]
name = "Developer"
url = "https://github.com/example"
```

#### plugin.json (collet 기본 / Claude Code 호환)

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "훌륭한 플러그인",
  "author": { "name": "Developer", "url": "https://github.com/example" },
  "license": "MIT",
  "keywords": ["tdd", "testing"]
}
```

### 플러그인 설치

```bash
# GitHub 저장소에서 직접 설치
collet plugin install owner/repo

# 등록된 마켓플레이스에서 설치
collet plugin install epic@plugins
```

TUI 내부에서는 `/plugin install` 슬래시 명령을 사용합니다.

### 마켓플레이스 (Marketplace)

마켓플레이스는 사용 가능한 플러그인을 나열하는 `marketplace.json`이 포함된 GitHub 저장소입니다.

```bash
# 마켓플레이스 등록
collet plugin marketplace add epicsagas/plugins

# 등록된 마켓플레이스 목록
collet plugin marketplace list

# 마켓플레이스 제거
collet plugin marketplace remove plugins
```

#### marketplace.json 형식

`.collet-plugin/marketplace.json` (또는 `.claude-plugin/marketplace.json`)에 배치합니다:

```json
{
  "owner": { "name": "epicsagas", "url": "https://github.com/epicsagas" },
  "plugins": [
    { "name": "epic", "source": "./", "description": "Epic harness" },
    { "name": "my-tool", "source": "otherorg/my-tool-repo", "description": "A tool" }
  ]
}
```

### 후크 이벤트 (Hook Events)

플러그인은 `hooks/hooks.json`을 통해 수명 주기 이벤트에 스크립트를 연결할 수 있습니다:

| 이벤트 | 타이밍 | 용도 |
|-------|--------|-----|
| `SessionStart` | 에이전트 세션 시작 시 | 초기화, 컨텍스트 설정 |
| `PreToolUse` | 도구 실행 전 | 가드, 위험한 명령 차단 |
| `PostToolUse` | 도구 실행 후 | 관찰, 로깅 |
| `PreCompact` | 컨텍스트 압축 전 | 중요한 데이터 보존 |
| `Stop` | 에이전트 루프 종료 시 | 알림, 최종 유효성 검사 |
| `SessionEnd` | 세션 해제 시 | 정리, 보고서 생성 |
| `SubagentStart` | 하위 에이전트 생성 시 | 모니터링, 추적 |
| `SubagentStop` | 하위 에이전트 완료 시 | 결과 수집 |

#### hooks.json 예시

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

**매처 구문 (Matcher syntax)**: `"*"`는 모든 도구와 일치합니다. `"Bash"`는 단일 도구와 일치합니다. `"file_edit|file_write"`는 파이프로 구분된 이름 중 하나와 일치합니다.

**차단 (Blocking)**: 종료 코드가 `2`인 `PreToolUse` 후크는 도구 실행을 차단합니다.

**환경 변수**: `${COLLET_PLUGIN_ROOT}`는 플러그인의 설치 디렉토리로 해석됩니다. 하위 호환성을 위해 `${CLAUDE_PLUGIN_ROOT}`도 설정됩니다.

### 플러그인 명령

```bash
collet plugin install <owner/repo | name@marketplace>  플러그인 설치
collet plugin list                                      설치된 플러그인 목록
collet plugin remove <name>                             플러그인 제거
collet plugin marketplace add <owner/repo> [name]       마켓플레이스 등록
collet plugin marketplace list                          마켓플레이스 목록
collet plugin marketplace remove <name>                 마켓플레이스 등록 취소
```
