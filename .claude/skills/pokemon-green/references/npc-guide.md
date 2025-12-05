# NPC 시스템 가이드

포켓몬 그린 버전의 NPC(Non-Player Character) 시스템 상세 가이드입니다.

## NPC 스프라이트 구조

### 파일 위치
- **개별 파일**: `data/sprites/npc_ascii/[Name].json`
- **이름 매핑**: `data/sprites/npc-mapping.json`
- **통합 미니**: `data/sprites/npc-ascii-mini.json`

### 스프라이트 방향
각 NPC JSON 파일에는 방향별 스프라이트가 포함됩니다:

| 키 | 설명 | 사용 시점 |
|----|------|----------|
| `down` | 아래 방향 (정면) | 기본 대화 |
| `down_walk` | 아래 걷기 | 이동 중 |
| `up` | 위 방향 (뒷모습) | 등 보일 때 |
| `left` | 왼쪽 방향 | 좌측 보기 |
| `right` | 오른쪽 방향 | 우측 보기 |

### 스프라이트 크기
- 높이: 약 14-16줄
- 너비: 약 28자
- 문자셋: `@`, `%`, `#`, `*`, `+`, `=`, `-`, `:`, `.`, 공백

---

## NPC 표시 규칙

### 언제 NPC 스프라이트를 표시해야 하나?

| 상황 | 표시 여부 | 방향 |
|------|----------|------|
| **NPC 대화 시작** | O (필수) | `down` (정면) |
| **트레이너 전투 시작** | O | `down` (정면) |
| **상점 이용** | O | `down` (정면) |
| **포켓몬센터 이용** | O | `down` (정면) |
| **전투 진행 중** | X | - |
| **필드 이동 중** | X | - |

### 대화 화면 형식

```
========================================
  [NPC 스프라이트 - down 방향]

  NPC 이름: [한글 이름]
----------------------------------------
  "대화 내용이 여기에 표시됩니다."
========================================
  [1] 네    [2] 아니오
========================================
```

---

## NPC 이름 매핑

### 한글 → 파일명 변환

`data/sprites/npc-mapping.json`을 사용하여 변환합니다.

```python
import json

with open("data/sprites/npc-mapping.json", "r") as f:
    mapping = json.load(f)

# 체육관 관장
brock_file = mapping["체육관 관장"]["웅"]  # "Brock"

# 트레이너 클래스
youngster_file = mapping["트레이너 클래스"]["꼬마"]  # "Youngster"
```

### 주요 NPC 매핑 예시

| 한글 | 파일명 | 역할 |
|------|--------|------|
| 오박사 | Professor_Oak | 포켓몬 박사 |
| 웅 | Brock | 회색시티 관장 |
| 이슬 | Misty | 블루시티 관장 |
| 간호순 | Nurse_Joy | 포켓몬센터 |
| 상점직원 | Clerk | 프렌들리숍 |
| 라이벌 | Rival | 경쟁자 |
| 로켓단원 | Rocket_Grunt | 적 조직 |

---

## 트레이너 전투 연동

### trainers.json과 NPC 스프라이트 연결

1. `data/world/trainers.json`에서 트레이너 정보 로드
2. 영문명(`name.en`)으로 NPC 스프라이트 파일 찾기
3. 전투 시작 시 스프라이트 표시

```python
# trainers.json 예시
{
  "brock": {
    "name": { "ko": "웅", "en": "Brock" },
    ...
  }
}

# NPC 스프라이트 로드
npc_file = f"data/sprites/npc_ascii/{trainer['name']['en']}.json"
```

### 트레이너 전투 시작 화면

```
========================================
  @@@@@@@@@@@       @@@@@@@@@@
  @@@@@@@              @@@@@@@
  @@@@@                  @@@@@
  @@@@   **          **    @@@
  @@  ********************* @@
  ...

  체육관 관장 웅이
  승부를 걸어왔다!
----------------------------------------
  "나는 웅! 회색시티 체육관의 관장이야!"
========================================
```

---

## 시설 NPC

### 포켓몬센터

```
# 간호순 (Nurse_Joy)
"어서오세요! 포켓몬센터입니다."
→ 간호순 스프라이트(down) 표시
→ HP/PP 회복 진행
```

### 프렌들리숍

```
# 상점직원 (Clerk)
"어서오세요!"
→ 상점직원 스프라이트(down) 표시
→ 상품 목록 표시
```

---

## NPC 스프라이트 로드 코드

### 기본 로드

```python
import json

def load_npc_sprite(npc_name_ko):
    """한글 이름으로 NPC 스프라이트 로드"""

    # 1. 매핑 파일 로드
    with open("data/sprites/npc-mapping.json", "r") as f:
        mapping = json.load(f)

    # 2. 한글 → 영문 변환 (모든 카테고리 검색)
    file_name = None
    for category in ["체육관 관장", "사천왕", "트레이너 클래스",
                     "스토리 NPC", "시설 NPC", "일반 NPC"]:
        if npc_name_ko in mapping.get(category, {}):
            file_name = mapping[category][npc_name_ko]
            break

    if not file_name:
        return None

    # 3. 스프라이트 파일 로드
    sprite_path = f"data/sprites/npc_ascii/{file_name}.json"
    with open(sprite_path, "r") as f:
        return json.load(f)

# 사용 예시
sprite = load_npc_sprite("웅")
for line in sprite["down"]:
    print(line)
```

### 방향별 스프라이트 선택

```python
def get_npc_art(sprite_data, direction="down"):
    """방향에 맞는 스프라이트 반환"""
    valid_directions = ["down", "down_walk", "up", "left", "right"]
    if direction not in valid_directions:
        direction = "down"
    return sprite_data.get(direction, sprite_data.get("down", []))
```

---

## 전체 NPC 목록

### 트레이너 클래스 (33종)
꼬마, 소녀, 버그잡이소년, 견습트레이너♂/♀, 등산가, 폭주족, 낚시꾼, 수영선수♂/♀, 선원, 피크니커, 캠퍼, 오타쿠, 로커, 저글러, 조련사, 새잡이, 검은띠, 무녀, 도박사, 엔지니어, 깡패, 초능력자, 도둑, 엘리트트레이너♂/♀, 신사, 아가씨, 연구원, 포켓몬광, 로켓단원

### 체육관 관장 (8명)
웅, 이슬, 마티스, 민화, 독수, 초련, 강연, 비주기

### 사천왕 + 챔피언 (5명)
칸나, 시바, 국화, 목호, 챔피언(라이벌)

### 스토리/시설 NPC (21종)
오박사, 라이벌, 엄마, 마사키, 후지노인, 간호순, 상점직원, 등

---

## 참고

- 스프라이트 출처: [pret/pokered](https://github.com/pret/pokered)
- 변환 스크립트: `data/sprites/generate_npc_ascii.py`
- ASCII 문자 밀도: `@` > `%` > `#` > `*` > `+` > `=` > `-` > `:` > `.`
