#!/bin/bash
#
# 포켓몬 1세대 울음소리 다운로드 스크립트
# 소스: Pokémon Showdown (play.pokemonshowdown.com/audio/cries/)
#
# 사용법:
#   chmod +x download-cries.sh
#   ./download-cries.sh
#

set -e

# 스크립트 디렉토리 기준으로 경로 설정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CRIES_DIR="$SKILL_DIR/data/audio/cries"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Pokémon Showdown 베이스 URL
BASE_URL="https://play.pokemonshowdown.com/audio/cries"

# 1세대 포켓몬 영문명 배열 (도감 번호 순서)
POKEMON_NAMES=(
    "bulbasaur"     # 001
    "ivysaur"       # 002
    "venusaur"      # 003
    "charmander"    # 004
    "charmeleon"    # 005
    "charizard"     # 006
    "squirtle"      # 007
    "wartortle"     # 008
    "blastoise"     # 009
    "caterpie"      # 010
    "metapod"       # 011
    "butterfree"    # 012
    "weedle"        # 013
    "kakuna"        # 014
    "beedrill"      # 015
    "pidgey"        # 016
    "pidgeotto"     # 017
    "pidgeot"       # 018
    "rattata"       # 019
    "raticate"      # 020
    "spearow"       # 021
    "fearow"        # 022
    "ekans"         # 023
    "arbok"         # 024
    "pikachu"       # 025
    "raichu"        # 026
    "sandshrew"     # 027
    "sandslash"     # 028
    "nidoranf"      # 029
    "nidorina"      # 030
    "nidoqueen"     # 031
    "nidoranm"      # 032
    "nidorino"      # 033
    "nidoking"      # 034
    "clefairy"      # 035
    "clefable"      # 036
    "vulpix"        # 037
    "ninetales"     # 038
    "jigglypuff"    # 039
    "wigglytuff"    # 040
    "zubat"         # 041
    "golbat"        # 042
    "oddish"        # 043
    "gloom"         # 044
    "vileplume"     # 045
    "paras"         # 046
    "parasect"      # 047
    "venonat"       # 048
    "venomoth"      # 049
    "diglett"       # 050
    "dugtrio"       # 051
    "meowth"        # 052
    "persian"       # 053
    "psyduck"       # 054
    "golduck"       # 055
    "mankey"        # 056
    "primeape"      # 057
    "growlithe"     # 058
    "arcanine"      # 059
    "poliwag"       # 060
    "poliwhirl"     # 061
    "poliwrath"     # 062
    "abra"          # 063
    "kadabra"       # 064
    "alakazam"      # 065
    "machop"        # 066
    "machoke"       # 067
    "machamp"       # 068
    "bellsprout"    # 069
    "weepinbell"    # 070
    "victreebel"    # 071
    "tentacool"     # 072
    "tentacruel"    # 073
    "geodude"       # 074
    "graveler"      # 075
    "golem"         # 076
    "ponyta"        # 077
    "rapidash"      # 078
    "slowpoke"      # 079
    "slowbro"       # 080
    "magnemite"     # 081
    "magneton"      # 082
    "farfetchd"     # 083
    "doduo"         # 084
    "dodrio"        # 085
    "seel"          # 086
    "dewgong"       # 087
    "grimer"        # 088
    "muk"           # 089
    "shellder"      # 090
    "cloyster"      # 091
    "gastly"        # 092
    "haunter"       # 093
    "gengar"        # 094
    "onix"          # 095
    "drowzee"       # 096
    "hypno"         # 097
    "krabby"        # 098
    "kingler"       # 099
    "voltorb"       # 100
    "electrode"     # 101
    "exeggcute"     # 102
    "exeggutor"     # 103
    "cubone"        # 104
    "marowak"       # 105
    "hitmonlee"     # 106
    "hitmonchan"    # 107
    "lickitung"     # 108
    "koffing"       # 109
    "weezing"       # 110
    "rhyhorn"       # 111
    "rhydon"        # 112
    "chansey"       # 113
    "tangela"       # 114
    "kangaskhan"    # 115
    "horsea"        # 116
    "seadra"        # 117
    "goldeen"       # 118
    "seaking"       # 119
    "staryu"        # 120
    "starmie"       # 121
    "mrmime"        # 122
    "scyther"       # 123
    "jynx"          # 124
    "electabuzz"    # 125
    "magmar"        # 126
    "pinsir"        # 127
    "tauros"        # 128
    "magikarp"      # 129
    "gyarados"      # 130
    "lapras"        # 131
    "ditto"         # 132
    "eevee"         # 133
    "vaporeon"      # 134
    "jolteon"       # 135
    "flareon"       # 136
    "porygon"       # 137
    "omanyte"       # 138
    "omastar"       # 139
    "kabuto"        # 140
    "kabutops"      # 141
    "aerodactyl"    # 142
    "snorlax"       # 143
    "articuno"      # 144
    "zapdos"        # 145
    "moltres"       # 146
    "dratini"       # 147
    "dragonair"     # 148
    "dragonite"     # 149
    "mewtwo"        # 150
    "mew"           # 151
)

# 한국어 이름 배열 (로깅용)
POKEMON_NAMES_KO=(
    "이상해씨" "이상해풀" "이상해꽃" "파이리" "리자드" "리자몽"
    "꼬부기" "어니부기" "거북왕" "캐터피" "단데기" "버터플"
    "뿔충이" "딱충이" "독침붕" "구구" "피죤" "피죤투"
    "꼬렛" "레트라" "깨비참" "깨비드릴조" "아보" "아보크"
    "피카츄" "라이츄" "모래두지" "고지" "니드런♀" "니드리나"
    "니드퀸" "니드런♂" "니드리노" "니드킹" "삐삐" "픽시"
    "식스테일" "나인테일" "푸린" "푸크린" "주뱃" "골뱃"
    "뚜벅쵸" "냄새꼬" "라플레시아" "파라스" "파라섹트" "콘팡"
    "도나리" "디그다" "닥트리오" "나옹" "페르시온" "고라파덕"
    "골덕" "망키" "성원숭" "가디" "윈디" "발챙이"
    "슈륙챙이" "강챙이" "캐이시" "윤겔라" "후딘" "알통몬"
    "근육몬" "괴력몬" "모다피" "우츠동" "우츠보트" "왕눈해"
    "독파리" "꼬마돌" "데구리" "딱구리" "포니타" "날쌩마"
    "야돈" "야도란" "코일" "레어코일" "파오리" "두두"
    "두트리오" "쥬쥬" "쥬레곤" "질퍽이" "질뻐기" "셀러"
    "파르셀" "고오스" "고우스트" "팬텀" "롱스톤" "슬리프"
    "슬리퍼" "크랩" "킹크랩" "찌리리공" "붐볼" "아라리"
    "나시" "탕구리" "텅구리" "시라소몬" "홍수몬" "내루미"
    "또가스" "또도가스" "뿔카노" "코뿌리" "럭키" "덩쿠리"
    "캥카" "쏘드라" "시드라" "콘치" "왕콘치" "별가사리"
    "아쿠스타" "마임맨" "스라크" "루주라" "에레브" "마그마"
    "쁘사이저" "켄타로스" "잉어킹" "갸라도스" "라프라스" "메타몽"
    "이브이" "샤미드" "쥬피썬더" "부스터" "폴리곤" "암나이트"
    "암스타" "투구" "투구푸스" "프테라" "잠만보" "프리져"
    "썬더" "파이어" "미뇽" "신뇽" "망나뇽" "뮤츠" "뮤"
)

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     포켓몬 1세대 울음소리 다운로드 스크립트 (151마리)      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# cries 디렉토리 생성
if [ ! -d "$CRIES_DIR" ]; then
    echo -e "${YELLOW}▶ 디렉토리 생성: $CRIES_DIR${NC}"
    mkdir -p "$CRIES_DIR"
fi

# 다운로드 카운터
downloaded=0
skipped=0
failed=0

echo -e "${GREEN}▶ 다운로드 시작...${NC}"
echo ""

for i in "${!POKEMON_NAMES[@]}"; do
    # 도감 번호 (001 ~ 151)
    dex_num=$(printf "%03d" $((i + 1)))
    pokemon_name="${POKEMON_NAMES[$i]}"
    pokemon_name_ko="${POKEMON_NAMES_KO[$i]}"

    # 출력 파일명
    output_file="$CRIES_DIR/${dex_num}.mp3"

    # 이미 다운로드된 경우 스킵
    if [ -f "$output_file" ]; then
        echo -e "${YELLOW}[${dex_num}] ${pokemon_name_ko} (${pokemon_name}) - 이미 존재, 스킵${NC}"
        ((skipped++))
        continue
    fi

    # Pokémon Showdown URL (MP3)
    url="${BASE_URL}/${pokemon_name}.mp3"

    echo -ne "${BLUE}[${dex_num}] ${pokemon_name_ko} (${pokemon_name})${NC} 다운로드 중..."

    # curl로 다운로드 (최대 10초 타임아웃)
    if curl -s -f -L --connect-timeout 10 --max-time 30 -o "$output_file" "$url" 2>/dev/null; then
        echo -e " ${GREEN}완료!${NC}"
        ((downloaded++))
    else
        echo -e " ${RED}실패${NC}"
        rm -f "$output_file" 2>/dev/null
        ((failed++))

        # OGG 형식 시도
        url_ogg="${BASE_URL}/${pokemon_name}.ogg"
        echo -ne "  └─ ${YELLOW}OGG 형식 시도 중...${NC}"

        if curl -s -f -L --connect-timeout 10 --max-time 30 -o "${output_file%.mp3}.ogg" "$url_ogg" 2>/dev/null; then
            # OGG를 MP3로 변환 (ffmpeg 필요)
            if command -v ffmpeg &> /dev/null; then
                ffmpeg -i "${output_file%.mp3}.ogg" -y -q:a 2 "$output_file" 2>/dev/null
                rm -f "${output_file%.mp3}.ogg"
                echo -e " ${GREEN}변환 완료!${NC}"
                ((downloaded++))
                ((failed--))
            else
                mv "${output_file%.mp3}.ogg" "$output_file"
                echo -e " ${YELLOW}OGG로 저장 (ffmpeg 없음)${NC}"
                ((downloaded++))
                ((failed--))
            fi
        else
            echo -e " ${RED}실패${NC}"
            rm -f "${output_file%.mp3}.ogg" 2>/dev/null
        fi
    fi

    # 서버 부하 방지를 위한 짧은 딜레이
    sleep 0.1
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
echo -e "  저장 위치: ${CRIES_DIR}"
echo ""

# 테스트 재생 옵션
if [ $downloaded -gt 0 ] || [ $skipped -gt 0 ]; then
    echo -e "${YELLOW}▶ 피카츄 울음소리를 테스트하시겠습니까? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        if [ -f "$CRIES_DIR/025.mp3" ]; then
            echo -e "${GREEN}🔊 피카츄 울음소리 재생 중...${NC}"
            afplay "$CRIES_DIR/025.mp3" 2>/dev/null || echo -e "${RED}재생 실패 (afplay 없음)${NC}"
        else
            echo -e "${RED}025.mp3 파일이 없습니다.${NC}"
        fi
    fi
fi

echo ""
echo -e "${GREEN}완료!${NC}"
