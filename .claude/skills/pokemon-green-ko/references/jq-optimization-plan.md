# jq 기반 JSON 부분 로딩 최적화 계획

## 현재 문제점

SKILL.md에서 데이터를 읽을 때 Read 도구로 전체 파일을 로드하면:
- `species.json` (40KB) → 피카츄 1마리만 필요해도 40KB 소비
- `pokemon-ascii.json` (345KB) → 1마리 스프라이트에 345KB 소비
- 컨텍스트 토큰 낭비

## 해결책: jq를 통한 부분 로딩

### 핵심 원칙

**SKILL.md에서 JSON 데이터 필요 시 Read 도구 대신 Bash + jq 사용**

```bash
# 전체 파일 로드 (비효율적)
Read: data/pokemon/species.json  # 40KB 전체 로드

# 필요한 부분만 로드 (효율적)
Bash: jq '.["25"]' data/pokemon/species.json  # ~200 bytes만 로드
```

---

## 사용 시나리오별 jq 명령어

### 1. 포켓몬 종족값 조회

```bash
# 단일 포켓몬 (도감번호)
jq '.["25"]' data/pokemon/species.json

# 이름으로 검색 (한글)
jq 'to_entries | map(select(.value.n.ko == "피카츄")) | .[0]' data/pokemon/species.json

# 여러 포켓몬 한번에
jq '.["25","26","27"]' data/pokemon/species.json

# 이름만 추출
jq '.["25"].n' data/pokemon/species.json
```

### 2. 기술 정보 조회

```bash
# 기술명으로 조회
jq '.thunderbolt' data/moves/moves.json

# 타입별 기술 목록
jq 'to_entries | map(select(.value.t == "E")) | .[].key' data/moves/moves.json

# 위력 50 이상 기술
jq 'to_entries | map(select(.value.p >= 50)) | .[].key' data/moves/moves.json
```

### 3. 레벨업 기술 조회

```bash
# 포켓몬별 레벨업 기술
jq '.d["25"].lv' data/pokemon/learnsets.json

# 특정 레벨에서 배우는 기술
jq '.d["25"].lv | map(select(.[0] <= 20))' data/pokemon/learnsets.json

# TM/HM 호환 여부
jq '.d["25"].tm' data/pokemon/learnsets.json
```

### 4. 야생 출현 정보

```bash
# 특정 지역 출현 포켓몬
jq '.e.viridian_forest' data/world/encounters.json

# 특정 포켓몬 출현 지역 찾기
jq '.e | to_entries | map(select(.value.g[]? | .[0] == 25)) | .[].key' data/world/encounters.json
```

### 5. 트레이너 정보

```bash
# 체육관 관장
jq '.gl.brock' data/world/trainers.json

# 사천왕 전체
jq '.e4' data/world/trainers.json

# 특정 지역 트레이너
jq '.rt.viridian_forest' data/world/trainers.json
```

### 6. 아이템 정보

```bash
# 포션류
jq '.pt' data/items/items.json

# 특정 아이템 (ID)
jq '.pt["10"]' data/items/items.json

# 가격별 필터
jq '.pt | to_entries | map(select(.value.p <= 500))' data/items/items.json
```

### 7. ASCII 스프라이트 (가장 중요!)

```bash
# 단일 포켓몬 스프라이트
jq '.["25"]' data/sprites/pokemon-ascii.json

# 축소 스프라이트
jq '.["25"]' data/sprites/pokemon-ascii-mini.json

# NPC 스프라이트 (개별 파일 - jq 불필요)
cat data/sprites/npc_ascii/Nurse_Joy.json
```

---

## SKILL.md 업데이트 제안

### 데이터 로딩 규칙 섹션 추가

```markdown
## 데이터 로딩 규칙 (필수)

**⚠️ JSON 데이터 로드 시 반드시 jq를 사용하여 필요한 부분만 추출합니다!**

### 기본 원칙
1. Read 도구로 전체 JSON 파일 로드 금지
2. Bash + jq로 필요한 키만 추출
3. 대용량 파일(스프라이트)은 특히 엄격히 준수

### 사용 예시

| 상황 | 올바른 방법 | 잘못된 방법 |
|------|------------|------------|
| 피카츄 정보 | `jq '.["25"]' species.json` | `Read species.json` |
| 10만볼트 정보 | `jq '.thunderbolt' moves.json` | `Read moves.json` |
| 피카츄 스프라이트 | `jq '.["25"]' pokemon-ascii.json` | `Read pokemon-ascii.json` |

### 복합 쿼리 예시

# 전투 시작 시 필요한 모든 정보 한번에
jq '{
  pokemon: .["25"],
  moves: [.thunderbolt, .quick_attack]
}' --slurpfile m data/moves/moves.json \
   data/pokemon/species.json
```

---

## 예상 효과

### 토큰 절약 비교

| 상황 | 현재 (Read) | jq 사용 | 절약 |
|------|------------|---------|------|
| 피카츄 종족값 | 40KB | ~200B | **99.5%** |
| 10만볼트 정보 | 35KB | ~150B | **99.6%** |
| 피카츄 스프라이트 | 345KB | ~2KB | **99.4%** |
| 상록숲 출현정보 | 4.4KB | ~300B | **93%** |

### 총 예상 효과
- 평균 쿼리당 토큰 절약: **95%+**
- 전투 1회 컨텍스트 절약: **~400KB → ~10KB**

---

## 구현 우선순위

### Phase 1: SKILL.md 규칙 추가 (즉시)
- 데이터 로딩 규칙 섹션 추가
- jq 사용 예시 문서화

### Phase 2: 자주 사용되는 jq 패턴 정리
- 전투 시 필요한 데이터 쿼리
- 도감 조회 쿼리
- 상점 아이템 쿼리

### Phase 3: 복합 쿼리 최적화
- 여러 파일에서 관련 데이터 한번에 추출
- 배치 쿼리 패턴

---

## 주의사항

1. **jq 설치 필요**: macOS는 기본 설치됨, 없으면 `brew install jq`
2. **경로 주의**: SKILL.md 기준 상대경로 사용
3. **에러 처리**: 존재하지 않는 키 조회 시 null 반환
4. **인코딩**: UTF-8 한글 정상 지원
