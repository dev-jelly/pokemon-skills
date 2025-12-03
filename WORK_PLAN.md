# 포켓몬 그린 스킬 개선 작업 계획서

**작성일**: 2025-12-03
**프로젝트**: `/Users/jelly/personal/pukiman`

---

## 1. 작업 개요

포켓몬 그린 텍스트 RPG 스킬의 성능 최적화 및 신규 기능 추가

### 작업 목표
1. 데이터 구조 최적화 (파일 통합, 인덱싱)
2. BGM 시스템 추가 (맵 이동 시 배경음악 자동 재생)
3. ASCII 아트 시스템 추가 (151마리 포켓몬 아스키 아트)

---

## 2. 현재 파일 구조

```
.claude/skills/pokemon-green/
├── SKILL.md                          # 메인 스킬 정의
├── templates/
│   ├── pokemon-instance.json         # 포켓몬 인스턴스 스키마
│   └── save-template.json            # 세이브 파일 템플릿
├── engine/
│   ├── battle-system.md              # 전투 시스템 문서
│   ├── damage-formula.md             # 데미지 계산 공식
│   └── capture-formula.md            # 포획률 계산 공식
└── data/
    ├── pokemon/
    │   ├── species-001-050.json      # ⚠️ 삭제 예정 (통합)
    │   ├── species-051-100.json      # ⚠️ 삭제 예정 (통합)
    │   ├── species-101-151.json      # ⚠️ 삭제 예정 (통합)
    │   ├── learnsets.json
    │   └── evolutions.json
    ├── moves/
    │   ├── moves-001-055.json        # ⚠️ 삭제 예정 (통합)
    │   ├── moves-056-110.json        # ⚠️ 삭제 예정 (통합)
    │   └── moves-111-165.json        # ⚠️ 삭제 예정 (통합)
    ├── types/chart.json
    ├── world/
    │   ├── locations.json
    │   ├── encounters.json
    │   ├── trainers.json
    │   └── shops.json
    ├── items/items.json
    ├── messages/battle-kr.json
    └── story/events.json
```

---

## 3. 작업 내용 상세

### 3.1 데이터 구조 최적화

#### 파일 통합
| 기존 파일 | 새 파일 | 설명 |
|-----------|---------|------|
| species-001-050.json | species.json | 151마리 전체 통합 |
| species-051-100.json | (삭제) | |
| species-101-151.json | (삭제) | |
| moves-001-055.json | moves.json | 165개 기술 통합 |
| moves-056-110.json | (삭제) | |
| moves-111-165.json | (삭제) | |

#### 인덱스 파일 추가
```
data/pokemon/species-index.json    # 이름/타입별 빠른 검색
data/moves/moves-index.json        # 기술 빠른 검색
```

**인덱스 구조 예시**:
```json
{
  "byId": { "1": { "name": "이상해씨", "types": ["grass", "poison"] } },
  "byName": { "이상해씨": 1, "bulbasaur": 1 },
  "byType": { "electric": [25, 26, 81, 82, 100, 101, 125, 135, 145] }
}
```

#### 전투 캐싱 템플릿 추가
```
templates/battle-context.json      # 능력치 캐싱용
```

---

### 3.2 BGM 시스템

#### 재생 방식
- macOS `afplay` 명령어로 자동 재생
- 맵 이동 / 전투 시작 시 BGM 전환

#### 파일 구조
```
data/audio/
├── bgm-mapping.json               # BGM 매핑 데이터
└── bgm/                           # MP3 파일 저장 위치
    ├── pallet_town.mp3
    ├── route_theme.mp3
    ├── wild_battle.mp3
    ├── trainer_battle.mp3
    ├── gym_leader.mp3
    ├── pokemon_center.mp3
    ├── lavender_town.mp3
    ├── elite_four.mp3
    ├── champion.mp3
    └── ... (27곡)
```

#### 주요 BGM 목록 (27곡)
| ID | 한국어 | 파일명 | 사용 위치 |
|----|--------|--------|----------|
| bgm_001 | 태초마을 | pallet_town.mp3 | 태초마을 |
| bgm_002 | 오박사 연구소 | oak_lab.mp3 | 연구소 |
| bgm_003 | 라이벌 등장 | rival_appears.mp3 | 라이벌 이벤트 |
| bgm_004 | 도로 테마 | route_theme.mp3 | 일반 도로/도시 |
| bgm_005 | 야생 전투 | wild_battle.mp3 | 야생 포켓몬 전투 |
| bgm_006 | 야생 승리 | victory_wild.mp3 | 야생 전투 승리 |
| bgm_007 | 포켓몬 센터 | pokemon_center.mp3 | 포켓몬 센터 |
| bgm_008 | 체육관 | gym.mp3 | 체육관 |
| bgm_009 | 트레이너 전투 | trainer_battle.mp3 | 트레이너 전투 |
| bgm_010 | 트레이너 승리 | victory_trainer.mp3 | 트레이너 승리 |
| bgm_011 | 체육관장 전투 | gym_leader.mp3 | 관장 전투 |
| bgm_012 | 보라타운 | lavender_town.mp3 | 보라타운 |
| bgm_013 | 포켓몬 타워 | pokemon_tower.mp3 | 포켓몬 타워 |
| bgm_014 | 무지개시티 | celadon_city.mp3 | 무지개시티 |
| bgm_015 | 황금시티 | saffron_city.mp3 | 황금시티 |
| bgm_016 | 로켓단 아지트 | rocket_hideout.mp3 | 로켓단 아지트 |
| bgm_017 | 실프주식회사 | silph_co.mp3 | 실프주식회사 |
| bgm_018 | 사이클링 로드 | cycling.mp3 | 17번 도로 |
| bgm_019 | 바다 | sea.mp3 | 수로 |
| bgm_020 | 동굴 | cave.mp3 | 동굴 지역 |
| bgm_021 | 챔피언로드 | victory_road.mp3 | 챔피언로드 |
| bgm_022 | 사천왕 | elite_four.mp3 | 사천왕 전투 |
| bgm_023 | 챔피언 전투 | champion.mp3 | 챔피언 전투 |
| bgm_024 | 명예의 전당 | hall_of_fame.mp3 | 엔딩 |
| bgm_025 | 진화 | evolution.mp3 | 진화 |
| bgm_026 | 레벨업 | level_up.mp3 | 레벨업 |
| bgm_027 | 포획 성공 | capture.mp3 | 포획 성공 |

#### 재생 명령어
```bash
# BGM 재생
pkill -f "afplay.*pokemon-green.*bgm" 2>/dev/null
afplay [skillPath]/data/audio/bgm/[track].mp3 &

# BGM 중지
pkill -f "afplay.*pokemon-green.*bgm"
```

---

### 3.3 ASCII 아트 시스템

#### 생성 방식
- Claude AI가 직접 생성 (일관된 스타일)
- 12-16자 폭, 8-14줄 높이
- 1세대 게임보이 느낌의 단순한 실루엣

#### 파일 구조
```
data/sprites/
├── sprites-index.json             # 스프라이트 메타데이터
└── gen1-front/
    ├── 001-050.json               # 이상해씨 ~ 다그트리오
    ├── 051-100.json               # 닥트리오 ~ 찌리리공
    └── 101-151.json               # 붐볼 ~ 뮤
```

#### 저장 형식
```json
{
  "1": {
    "name": "이상해씨",
    "width": 16,
    "height": 10,
    "art": [
      "      _.-^^-._      ",
      "    .'   __   '.    ",
      "   /   .'  '.   \\   ",
      "  |   /  @@  \\   |  ",
      "  |  |   ..   |  |  ",
      "   \\  \\      /  /   ",
      "    '. '-..-' .'    ",
      "  ,-'\\_`--'_/'-,    ",
      " /    `----'    \\   ",
      "'-.____________.-'  "
    ]
  }
}
```

#### 구현 우선순위

**1단계 - 핵심 30마리**:
- 스타터 라인: 1-3 (이상해씨), 4-6 (파이리), 7-9 (꼬부기)
- 피카츄 라인: 25-26
- 전설: 144 (프리져), 145 (썬더), 146 (파이어), 150 (뮤츠), 151 (뮤)
- 인기: 94 (팬텀), 130 (갸라도스), 149 (망나뇽)

**2단계**: 001-050 완성
**3단계**: 051-100 완성
**4단계**: 101-151 완성

---

## 4. 파일 변경 요약

### 신규 생성 파일
| 파일 | 설명 |
|------|------|
| `data/pokemon/species.json` | 151마리 통합 데이터 |
| `data/pokemon/species-index.json` | 검색용 인덱스 |
| `data/moves/moves.json` | 165개 기술 통합 |
| `data/moves/moves-index.json` | 기술 검색 인덱스 |
| `data/audio/bgm-mapping.json` | BGM 매핑 |
| `data/sprites/sprites-index.json` | 스프라이트 메타 |
| `data/sprites/gen1-front/001-050.json` | ASCII 아트 1-50 |
| `data/sprites/gen1-front/051-100.json` | ASCII 아트 51-100 |
| `data/sprites/gen1-front/101-151.json` | ASCII 아트 101-151 |
| `templates/battle-context.json` | 전투 캐싱 템플릿 |

### 수정 파일
| 파일 | 변경 내용 |
|------|----------|
| `SKILL.md` | BGM 섹션, ASCII 아트 섹션 추가 |
| `templates/save-template.json` | BGM 옵션 추가 |

### 삭제 파일
| 파일 | 사유 |
|------|------|
| `data/pokemon/species-001-050.json` | species.json으로 통합 |
| `data/pokemon/species-051-100.json` | species.json으로 통합 |
| `data/pokemon/species-101-151.json` | species.json으로 통합 |
| `data/moves/moves-001-055.json` | moves.json으로 통합 |
| `data/moves/moves-056-110.json` | moves.json으로 통합 |
| `data/moves/moves-111-165.json` | moves.json으로 통합 |

---

## 5. 작업 순서

### Phase 1: 데이터 통합 (우선순위 높음)
1. [x] species-*.json 3개 파일 → species.json 통합
2. [x] moves-*.json 3개 파일 → moves.json 통합
3. [x] species-index.json 생성
4. [x] moves-index.json 생성
5. [x] 기존 분할 파일 삭제
6. [x] templates/battle-context.json 생성

### Phase 2: BGM 시스템
1. [x] ~/Music/pokemon-bgm/ 디렉토리 생성
2. [x] data/audio/bgm-mapping.json 생성 (27곡 매핑)
3. [x] SKILL.md에 BGM 섹션 추가
4. [x] save-template.json에 BGM 옵션 추가
5. [x] YouTube 링크 목록 준비 (MP3 다운로드용)

### Phase 3: ASCII 아트
1. [x] data/sprites/sprites-index.json 생성
2. [x] 001-050.json 생성 (50마리)
3. [x] 051-100.json 생성 (50마리)
4. [x] 101-151.json 생성 (51마리)
5. [x] SKILL.md에 ASCII 표시 섹션 추가

### Phase 4: 마무리
1. [x] SKILL.md 최종 업데이트
2. [x] 테스트 플레이
3. [x] 문서 정리
4. [x] README.md 작성

---

## 6. 사용자 선택 사항

| 항목 | 선택 | 비고 |
|------|------|------|
| ASCII 생성 방식 | AI 생성 | Claude가 직접 생성 |
| BGM 재생 방식 | afplay 자동재생 | macOS 전용 |
| 기존 분할 파일 | 통합 후 삭제 | 깔끔한 구조 유지 |

---

## 7. 예상 결과물

### 게임 플레이 예시 (BGM + ASCII)

```
♪ Now Playing: 야생 전투 (Wild Battle)

========================================
      ,__,
     (o  o)    야생 피카츄 Lv.5
     (____),   HP: ████████████░░░░ 28/35
      |  |     상태: 정상
      '--'
========================================

  VS

      _.-^^-._
    .'   __   '.     이상해씨 Lv.7
   /   .'  '.   \    HP: ████████████████ 32/32
  |   /  @@  \   |   상태: 정상
   \  \      /  /
    '. '-..-' .'
----------------------------------------
  [1] 싸운다     [2] 가방
  [3] 포켓몬     [4] 도망
========================================
```

---

*이 문서는 작업 시작 전 계획 정리용입니다.*
