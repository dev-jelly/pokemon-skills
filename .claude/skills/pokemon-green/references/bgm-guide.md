# BGM 시스템 가이드

맵 이동, 전투 시작, 이벤트 발생 시 해당 BGM이 자동으로 재생됩니다.

## 스킬 시작 시 BGM 자동 재생 (필수)

**중요**: 스킬이 활성화되면 즉시 BGM을 백그라운드로 재생합니다.

### 자동 재생 프로세스
1. 기존 BGM 프로세스 종료:
   ```bash
   pkill -f 'afplay.*pokemon-green.*bgm' 2>/dev/null
   ```

2. 게임 상태에 따른 BGM 선택:
   - **새 게임**: `pallet_town.mp3` (태초마을)
   - **이어하기**: 저장된 위치의 BGM (`data/audio/bgm-mapping.json`의 `locationMapping` 참조)

3. 백그라운드 반복 재생 시작 (Bash 도구로 실행, `run_in_background: true` 필수):
   ```bash
   while true; do afplay [skillPath]/data/audio/bgm/[track].mp3; done
   ```

## BGM 재생 방식 (macOS afplay + 반복재생)

**중요: 모든 BGM 재생은 Bash 도구의 `run_in_background: true` 옵션을 사용하여 백그라운드로 실행해야 합니다.**
- 백그라운드 실행 없이는 음악이 끝날 때까지 채팅이 블로킹됩니다.
- BGM은 `while true` 루프로 반복 재생합니다.
- 음악 전환 패턴: `pkill` (일반 실행) → 새 음악 (`run_in_background: true`)

```bash
# 1단계: 기존 BGM 중지 (일반 실행)
pkill -f 'pokemon-green.*bgm' 2>/dev/null

# 2단계: 새 BGM 반복 재생 (반드시 run_in_background: true 사용)
while true; do afplay [skillPath]/data/audio/bgm/[track].mp3; done
```

## BGM 명령어

| 명령어 | 설명 | 실행 명령어 |
|--------|------|------------|
| bgm | 현재 재생 중인 BGM 표시 | - |
| bgm 끄기 / 음악 끄기 | BGM 재생 중지 | `pkill -f 'pokemon-green.*bgm'` |
| bgm 켜기 / 음악 켜기 | 현재 위치 BGM 반복 재생 | `while true; do afplay [track].mp3; done` |
| 볼륨 [0-100] | 볼륨 조절 | `afplay -v [vol]` |
| 음소거 | 모든 오디오 중지 | `pkill -f 'afplay'` |

## 주요 BGM 목록 (45곡)

| BGM | 사용 위치 |
|-----|----------|
| 태초마을 | 태초마을, 플레이어 집 |
| 도로 테마 | 일반 도로/도시 |
| 야생 전투 | 야생 포켓몬 전투 |
| 트레이너 전투 | 트레이너 전투 |
| 체육관장 전투 | 관장 전투 |
| 포켓몬 센터 | 포켓몬 센터 |
| 보라타운 | 보라타운, 포켓몬 타워 |
| 동굴 | 달맞이산, 바위터널 등 |
| 챔피언로드 | 챔피언로드, 포켓몬리그 |
| 사천왕/챔피언 | 사천왕, 챔피언 전투 |

## 오디오 자동 재생 규칙 (필수 준수)

### 위치 이동 시 BGM 전환
맵 이동 시 `data/audio/bgm-mapping.json`의 `locationMapping`을 참조하여 BGM 전환.

**주요 위치별 BGM:**
| 위치 | BGM | 파일 |
|------|-----|------|
| 태초마을/플레이어집 | 태초마을 | pallet_town.mp3 |
| 오박사 연구소 | 오박사 연구소 | oak_lab.mp3 |
| 일반 도로/도시 | 도로 테마 | route_theme.mp3 |
| 체육관 | 체육관 | gym.mp3 |
| 포켓몬 센터 | 포켓몬 센터 | pokemon_center.mp3 |
| 보라타운 | 보라타운 | lavender_town.mp3 |
| 동굴 (달맞이산 등) | 동굴 | cave.mp3 |
| 바다 루트 (19-21번) | 바다 | sea.mp3 |

### 전투 시작 시 BGM 전환 + 울음소리
전투 시작 시 `battleMapping`을 참조하여 다음 순서로 실행:

1. **기존 BGM 중지** (일반 Bash 실행)
2. **상대 포켓몬 울음소리 재생** (`run_in_background: true`)
3. **전투 BGM 반복 재생** (`run_in_background: true`)

**전투 유형별 BGM:**
| 전투 유형 | BGM | 파일 |
|----------|-----|------|
| 야생 전투 | 야생 전투 | wild_battle.mp3 |
| 트레이너 전투 | 트레이너 전투 | trainer_battle.mp3 |
| 체육관장 전투 | 체육관장 전투 | gym_leader.mp3 |
| 사천왕 전투 | 사천왕 | elite_four.mp3 |
| 챔피언 전투 | 챔피언 전투 | champion.mp3 |

### 전투 종료 시 BGM 전환
전투 승리 후 `eventMapping`을 참조:

1. 전투 BGM 중지 (일반 Bash 실행)
2. 승리 BGM 재생 (`run_in_background: true`) - 1회만
3. 승리 BGM 종료 후 원래 위치 BGM으로 복귀 (반복 재생)

### 이벤트 발생 시 BGM/효과음
`eventMapping`을 참조하여 이벤트 BGM 재생:

| 이벤트 | BGM | 파일 | 동작 |
|--------|-----|------|------|
| 진화 | 진화 | evolution.mp3 | BGM 중지 → 진화 BGM → 원래 BGM |
| 레벨업 | 레벨업 | level_up.mp3 | 현재 BGM 유지, 효과음만 재생 |
| 포획 성공 | 포획 성공 | capture.mp3 | 전투 BGM 중지 → 포획 BGM → 위치 BGM |
| 라이벌 등장 | 라이벌 등장 | rival_appears.mp3 | BGM 전환 |
| **치료 완료** | **치료 완료** | **pokemon_healed.mp3** | **BGM 유지, 효과음 오버레이** |
| 포켓몬 획득 | 포켓몬 획득 | pokemon_obtained.mp3 | BGM 중지 → 팡파르 → 원래 BGM |
| 아이템 획득 | 아이템 획득 | item_obtained.mp3 | BGM 유지, 효과음 오버레이 |
| 뱃지 획득 | 뱃지 획득 | badge_obtained.mp3 | BGM 중지 → 팡파르 → 원래 BGM |
| 트레이너 등장 | 트레이너 등장 | trainer_appears.mp3 | BGM 중지 → 등장 BGM → 전투 BGM |

### 포켓몬 센터 치료 효과음

포켓몬 센터에서 치료 완료 시 `healing` 이벤트 BGM 재생:

1. **포켓몬 센터 BGM 계속 재생** (중지하지 않음)
2. **치료 효과음 오버레이** (`run_in_background: true`) - 1회만 재생
3. **치료 완료 메시지 표시**

```bash
# 치료 효과음 재생 (BGM 위에 오버레이, run_in_background: true)
afplay [skillPath]/data/audio/bgm/pokemon_healed.mp3
```

## 데이터 파일

- `data/audio/bgm-mapping.json`: BGM 매핑 및 YouTube 링크 (45곡)
- `data/audio/bgm/`: BGM 파일 디렉토리
