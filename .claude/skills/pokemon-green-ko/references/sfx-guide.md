# 기술 효과음(SFX) 시스템 가이드

전투 중 기술 사용 시 1세대 포켓몬 효과음이 자동으로 재생됩니다.

## 효과음 재생 규칙 (필수 준수)

### 기술 사용 시 효과음 재생

**⚠️ 중요: 모든 기술 사용 시 효과음을 재생해야 합니다!**

```
# 기술 사용 순서
1. 기술 사용 메시지 표시 ("이상해씨의 몸통박치기!")
2. 기술 효과음 재생 (run_in_background: true)
3. 데미지 계산 및 결과 표시
4. (선택) 히트 효과음 재생 (효과 굉장함/별로 등)
```

### 효과음 재생 방법

```bash
# 기술 효과음 재생 (run_in_background: true 필수!)
afplay [skillPath]/data/audio/sfx/[기술파일].mp3
```

### 기술별 효과음 매핑

`data/audio/sfx-mapping.json`에서 기술명으로 파일명 조회:

```json
{
  "몸통박치기": { "file": "tackle.mp3" },
  "울음소리": { "file": "growl.mp3" },
  "실뿜기": { "file": "stringshot.mp3" }
}
```

### 효과음 없는 기술 처리

매핑에 없는 기술은 카테고리별 기본 효과음 사용:
- 물리 공격: `tackle.mp3`
- 특수 공격: `psychic.mp3`
- 상태 변화: `growl.mp3`

## 전투 효과음

| 상황 | 파일 | 설명 |
|------|------|------|
| 일반 히트 | `hit_normal.mp3` | 기본 데미지 |
| 효과 굉장함 | `hit_super.mp3` | 2배 이상 데미지 |
| 효과 별로 | `hit_weak.mp3` | 0.5배 이하 데미지 |
| 급소 | `critical.mp3` | 급소 명중 |
| 빗나감 | `miss.mp3` | 기술 실패 |
| 기절 | `faint.mp3` | HP 0 |

## 효과음 파일 다운로드

효과음 파일이 없는 경우, 아래 사이트에서 다운로드:

### 1. KHInsider (권장)
- URL: https://downloads.khinsider.com/game-soundtracks/album/pokemon-sfx-gen-1-attack-moves-rby
- 328개 파일, MP3 형식
- 무료 다운로드

### 2. The Sounds Resource
- URL: https://www.sounds-resource.com/game_boy_gbc/pokemonredblueyellow/sound/17240/
- 개별 파일 다운로드 가능

### 3. Internet Archive
- URL: https://archive.org/details/pokemon-red-green-and-blue-pokemon-sound-effect-collection
- 전체 컬렉션

## 다운로드 스크립트

```bash
# sfx 디렉토리 생성
mkdir -p data/audio/sfx

# KHInsider에서 다운로드 후 sfx 폴더에 저장
# 파일명을 소문자로 변환 (tackle.mp3, growl.mp3 등)
```

## 데이터 파일

- `data/audio/sfx-mapping.json`: 기술-효과음 매핑
- `data/audio/sfx/`: 효과음 파일 디렉토리
