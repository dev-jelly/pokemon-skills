# Claude Code Instructions

포켓몬 그린 버전 텍스트 RPG - Claude Code 스킬 프로젝트

## Project Overview

이 프로젝트는 1세대 포켓몬 그린을 텍스트 RPG로 재현한 Claude Code 스킬입니다.

## Directory Structure

```
.claude/skills/pokemon-green/
├── SKILL.md              # 스킬 정의 (메인 문서)
├── README.md             # 프로젝트 소개
├── data/                 # 게임 데이터
│   ├── pokemon/          # 포켓몬 데이터 (species, learnsets, evolutions)
│   ├── moves/            # 기술 데이터 (165개)
│   ├── types/            # 타입 상성표
│   ├── world/            # 월드 데이터 (locations, encounters, trainers)
│   ├── audio/            # 오디오 매핑 (bgm, sfx, cries)
│   ├── sprites/          # ASCII 아트 (전체/축소)
│   ├── items/            # 아이템 데이터
│   └── messages/         # 한글 메시지
├── engine/               # 시스템 문서
│   ├── battle-system.md  # 전투 시스템
│   ├── damage-formula.md # 데미지 공식
│   └── capture-formula.md# 포획률 공식
├── references/           # 참조 가이드
│   ├── bgm-guide.md      # BGM 시스템
│   ├── sfx-guide.md      # 효과음 시스템
│   ├── cries-guide.md    # 울음소리 시스템
│   └── ascii-guide.md    # ASCII 아트 시스템
├── templates/            # 데이터 템플릿
│   ├── save-template.json
│   ├── pokemon-instance.json
│   └── battle-context.json
└── saves/                # 세이브 파일

saves/                    # 프로젝트 루트 세이브
├── current_game.json     # 현재 게임
└── slot1.json            # 수동 세이브
```

## Key Files

| 파일 | 용도 |
|------|------|
| `data/pokemon/species.json` | 151마리 종족값 |
| `data/moves/moves.json` | 165개 기술 데이터 |
| `data/types/chart.json` | 15타입 상성표 |
| `data/sprites/pokemon-ascii.json` | 전체 ASCII 아트 |
| `data/sprites/pokemon-ascii-mini.json` | 축소 ASCII 아트 |

## Important Rules

### BGM/Audio

```bash
# BGM 재생 시 반드시 백그라운드 실행
command: "while true; do afplay [path]/bgm/track.mp3; done"
run_in_background: true  # 필수!

# BGM 중지
pkill -f 'pokemon-green.*bgm'
```

### ASCII Art

| 상황 | 파일 |
|------|------|
| 전투 시작 | `pokemon-ascii.json` (전체) |
| 전투 진행 중 | `pokemon-ascii-mini.json` (축소) |
| 도감 확인 | `pokemon-ascii.json` (전체) |

### 1st Gen Bugs

재현해야 할 1세대 버그:
- 에스퍼 vs 고스트: 0배 (원래 2배)
- 포커스 에너지: 급소율 감소 (원래 증가)
- 독 vs 벌레: 2배 (원래 1배)

### Damage Formula

```
기본 = ((2 × Level ÷ 5 + 2) × Power × A ÷ D ÷ 50 + 2)
최종 = 기본 × STAB × 타입상성 × 급소 × 난수(0.85~1.0)
```

## Data Format

### Pokemon Species (species.json)

```json
{
  "001": {
    "name": "이상해씨",
    "types": ["풀", "독"],
    "baseStats": { "hp": 45, "attack": 49, ... }
  }
}
```

### Moves (moves.json)

```json
{
  "몸통박치기": {
    "type": "노말",
    "category": "물리",
    "power": 40,
    "accuracy": 100,
    "pp": 35
  }
}
```

## Language

- 게임 내 텍스트: 한국어
- 코드 주석/문서: 한국어 허용
- 포켓몬/기술명: 한글명 사용

## Save System

- 10개 수동 슬롯 + 자동저장
- 자동저장 시점: 포켓몬센터, 도시 진입, 전투 후
- 경로: `saves/` 또는 `.claude/skills/pokemon-green/saves/`
