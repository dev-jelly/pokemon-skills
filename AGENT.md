# AI Agent Instructions

포켓몬 그린 버전 텍스트 RPG 프로젝트 작업 가이드

## Project Type

Claude Code 스킬 - 텍스트 기반 RPG 게임

## Tech Stack

- **Runtime**: Claude Code (Anthropic CLI)
- **Language**: Korean (한국어)
- **Data Format**: JSON
- **Audio**: macOS `afplay` (BGM/SFX/Cries)
- **Display**: Terminal ASCII art

## Architecture

### Core Components

1. **Game Data** (`data/`)
   - Pokemon species, moves, types
   - World locations, encounters, trainers
   - Audio mappings, ASCII sprites

2. **Game Engine** (`engine/`)
   - Battle system state machine
   - Damage calculation (Gen 1 formula)
   - Capture rate calculation

3. **Templates** (`templates/`)
   - Save file structure
   - Battle context
   - Pokemon instance

### Data Files

| Category | Path | Description |
|----------|------|-------------|
| Pokemon | `data/pokemon/species.json` | 151 species data |
| Moves | `data/moves/moves.json` | 165 moves data |
| Types | `data/types/chart.json` | 15 type matchup |
| World | `data/world/locations.json` | Kanto region map |
| Sprites | `data/sprites/pokemon-ascii.json` | Full ASCII art |
| Sprites | `data/sprites/pokemon-ascii-mini.json` | Mini ASCII art (13 lines) |

## Coding Guidelines

### JSON Data

```json
{
  "key": "value",
  "numbers": 123,
  "arrays": ["item1", "item2"]
}
```

### File Naming

- 소문자 + 하이픈: `pokemon-ascii-mini.json`
- 도감번호: 3자리 제로패딩 `"001"`, `"025"`, `"151"`

### Korean Text

- 포켓몬명: 한글 (이상해씨, 피카츄)
- 기술명: 한글 (몸통박치기, 전광석화)
- 타입명: 한글 (노말, 불꽃, 물, 풀)

## System Requirements

### BGM Playback

```bash
# Loop BGM in background (REQUIRED: run_in_background: true)
while true; do afplay path/to/bgm.mp3; done

# Stop BGM
pkill -f 'pokemon-green.*bgm'
```

### ASCII Art Display

**전체 아트** (battle start, pokedex):
- Height: 19-69 lines
- Width: max 101 chars
- File: `pokemon-ascii.json`

**축소 아트** (battle progress, party):
- Height: 13 lines (fixed)
- Width: 28 chars
- Characters: `. : - = + * # % @`
- File: `pokemon-ascii-mini.json`

## Gen 1 Mechanics

### Damage Formula

```
Base = ((2 × Level ÷ 5 + 2) × Power × Atk ÷ Def ÷ 50 + 2)
Final = Base × STAB × TypeEffectiveness × Critical × Random(0.85-1.0)
```

### Type Chart Bugs

- Psychic vs Ghost: 0x (should be 2x)
- Poison vs Bug: 2x (should be 1x)
- Focus Energy: reduces crit rate (should increase)

### Status Effects

| Status | Effect |
|--------|--------|
| Poison | 1/16 HP per turn |
| Burn | 1/16 HP + 1/2 Attack |
| Paralysis | 1/4 Speed, 25% skip turn |
| Sleep | 1-3 turns immobile |
| Freeze | Immobile until 10% thaw |

## Important Notes

1. **세이브 관리**: 중요 이벤트 전 자동저장
2. **BGM 규칙**: 항상 백그라운드 실행
3. **ASCII 규칙**: 전투 시작 시 전체 아트 필수
4. **1세대 재현**: 버그 포함 원작 충실 재현

## References

- `engine/battle-system.md` - 전투 흐름 상태 머신
- `engine/damage-formula.md` - 데미지 계산 상세
- `engine/capture-formula.md` - 포획률 공식
- `references/bgm-guide.md` - BGM 시스템 가이드
- `references/ascii-guide.md` - ASCII 아트 가이드
