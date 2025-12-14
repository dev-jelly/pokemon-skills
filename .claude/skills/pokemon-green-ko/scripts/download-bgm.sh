#!/bin/bash
#
# 포켓몬 1세대 BGM 다운로드 스크립트
# 소스: Internet Archive (pkmn-rgby-soundtrack)
#
# 사용법:
#   chmod +x download-bgm.sh
#   ./download-bgm.sh
#

set -e

# 스크립트 디렉토리 기준으로 경로 설정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
BGM_DIR="$SKILL_DIR/data/audio/bgm"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Internet Archive 베이스 URL
BASE_URL="https://archive.org/download/pkmn-rgby-soundtrack/Disc%201"

# BGM 트랙 배열
# 형식: "스킬파일명:archive파일명:한글명"
BGM_TRACKS=(
    # 징글/팡파르
    "pokemon_healed:18%20-%20Pok%C3%A9mon%20Healed.mp3:포켓몬 치료 완료"
    "item_obtained:12%20-%20Obtained%20an%20Item%21.mp3:아이템 획득"
    "key_item_obtained:06%20-%20Obtained%20a%20Key%20Item%21.mp3:중요한 물건 획득"
    "badge_obtained:26%20-%20Victory%21%20%28Gym%20Leader%29.mp3:뱃지 획득"
    "pokemon_obtained:07%20-%20Pok%C3%A9mon%20Obtained.mp3:포켓몬 획득"

    # 메인 테마
    "title_screen:02%20-%20Title%20Screen.mp3:타이틀 화면"
    "opening:01%20-%20Opening%20Movie.mp3:오프닝"

    # 도시/장소 테마
    "pewter_city:15%20-%20Pewter%20City.mp3:회색시티"
    "vermilion_city:35%20-%20Vermilion%20City.mp3:황토시티"
    "cinnabar_island:47%20-%20Cinnabar%20Island.mp3:홍련섬"
    "viridian_forest:19%20-%20Viridian%20Forest.mp3:상록숲"
    "ss_anne:36%20-%20S.S.%20Anne.mp3:상트안느호"
    "pokemon_mansion:48%20-%20Pok%C3%A9mon%20Mansion.mp3:포켓몬 저택"
    "game_corner:42%20-%20Game%20Corner.mp3:게임코너"

    # 특수 효과음
    "jigglypuff_song:22%20-%20Jigglypuff%27s%20Song.mp3:푸린의 노래"
    "professor_oak:04%20-%20Professor%20Oak.mp3:오박사"
    "trainer_appears:20%20-%20Trainer%20Appears%20%28Boy%29.mp3:트레이너 등장"

    # 엔딩
    "ending:52%20-%20Ending.mp3:엔딩"
)

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     포켓몬 1세대 BGM 다운로드 스크립트                     ║${NC}"
echo -e "${BLUE}║     소스: archive.org/details/pkmn-rgby-soundtrack         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# BGM 디렉토리 확인
if [ ! -d "$BGM_DIR" ]; then
    echo -e "${YELLOW}▶ 디렉토리 생성: $BGM_DIR${NC}"
    mkdir -p "$BGM_DIR"
fi

# 다운로드 카운터
downloaded=0
skipped=0
failed=0
failed_list=()

echo -e "${GREEN}▶ 다운로드 시작...${NC}"
echo ""

for track_info in "${BGM_TRACKS[@]}"; do
    # 정보 파싱
    IFS=':' read -r skill_name archive_name ko_name <<< "$track_info"

    # 출력 파일명
    output_file="$BGM_DIR/${skill_name}.mp3"

    # 이미 다운로드된 경우 스킵
    if [ -f "$output_file" ]; then
        file_size=$(stat -f%z "$output_file" 2>/dev/null || stat --format=%s "$output_file" 2>/dev/null || echo "0")
        if [ "$file_size" -gt 1024 ]; then
            echo -e "${YELLOW}[SKIP] ${ko_name} (${skill_name}.mp3) - 이미 존재 ($(($file_size / 1024))KB)${NC}"
            ((skipped++))
            continue
        fi
    fi

    echo -ne "${BLUE}[DL] ${ko_name}${NC} 다운로드 중..."

    # Internet Archive에서 다운로드
    url="${BASE_URL}/${archive_name}"

    if curl -s -f -L --connect-timeout 15 --max-time 120 -o "$output_file" "$url" 2>/dev/null; then
        file_size=$(stat -f%z "$output_file" 2>/dev/null || stat --format=%s "$output_file" 2>/dev/null || echo "0")
        if [ "$file_size" -gt 1024 ]; then
            echo -e " ${GREEN}완료! ($(($file_size / 1024))KB)${NC}"
            ((downloaded++))
        else
            echo -e " ${RED}실패 (파일 크기 이상)${NC}"
            rm -f "$output_file" 2>/dev/null
            ((failed++))
            failed_list+=("$ko_name ($skill_name.mp3)")
        fi
    else
        echo -e " ${RED}실패${NC}"
        rm -f "$output_file" 2>/dev/null
        ((failed++))
        failed_list+=("$ko_name ($skill_name.mp3)")
    fi

    # 서버 부하 방지를 위한 딜레이
    sleep 0.5
done

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      다운로드 완료                         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}다운로드: ${downloaded}개${NC}"
echo -e "  ${YELLOW}스킵: ${skipped}개${NC}"
echo -e "  ${RED}실패: ${failed}개${NC}"
echo ""

# 실패한 파일 목록 출력
if [ ${#failed_list[@]} -gt 0 ]; then
    echo -e "${RED}▶ 다운로드 실패 목록:${NC}"
    for item in "${failed_list[@]}"; do
        echo -e "  - $item"
    done
    echo ""
fi

echo -e "  저장 위치: ${BGM_DIR}"
echo ""

# 현재 BGM 파일 수 확인
total_bgm=$(find "$BGM_DIR" -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')
echo -e "  현재 총 BGM 파일: ${total_bgm}개"
echo ""

# 테스트 재생 옵션
if [ -f "$BGM_DIR/pokemon_healed.mp3" ]; then
    echo -e "${YELLOW}▶ 포켓몬 치료 완료 BGM을 테스트하시겠습니까? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo -e "${GREEN}🔊 포켓몬 치료 완료 BGM 재생 중...${NC}"
        afplay "$BGM_DIR/pokemon_healed.mp3" 2>/dev/null || echo -e "${RED}재생 실패 (afplay 없음)${NC}"
    fi
fi

echo ""
echo -e "${GREEN}완료!${NC}"
