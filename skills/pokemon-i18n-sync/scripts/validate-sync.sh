#!/bin/bash
# Pokemon Green i18n Sync Validation Script
# Usage: ./validate-sync.sh [target_lang]
# Default: compares ko vs en

set -e

# Configuration
PROJECT_DIR="${PROJECT_DIR:-/Users/jelly/personal/pukiman}"
SKILLS_DIR="$PROJECT_DIR/.claude/skills"
BASE_LANG="${1:-ko}"
TARGET_LANG="${2:-en}"

BASE_DIR="$SKILLS_DIR/pokemon-green-$BASE_LANG"
TARGET_DIR="$SKILLS_DIR/pokemon-green-$TARGET_LANG"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

errors=0
warnings=0

echo "=== Pokemon Skill i18n Sync Report ==="
echo -e "Base: ${BLUE}pokemon-green-$BASE_LANG${NC}"
echo -e "Target: ${BLUE}pokemon-green-$TARGET_LANG${NC}"
echo ""

# Check directories exist
if [[ ! -d "$BASE_DIR" ]]; then
    echo -e "${RED}ERROR: Base directory not found: $BASE_DIR${NC}"
    exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}ERROR: Target directory not found: $TARGET_DIR${NC}"
    exit 1
fi

# ==== File Existence Check ====
echo "[파일 검사 / File Check]"

# Key data files to check
DATA_FILES=(
    "data/pokemon/species.json"
    "data/pokemon/learnsets.json"
    "data/pokemon/evolutions.json"
    "data/moves/moves.json"
    "data/world/locations.json"
    "data/world/trainers.json"
    "data/world/encounters.json"
    "data/messages/battle.json"
    "data/types/chart.json"
    "data/sprites/pokemon-ascii.json"
    "data/sprites/pokemon-ascii-mini.json"
    "data/audio/bgm-mapping.json"
    "data/audio/cries-mapping.json"
)

for file in "${DATA_FILES[@]}"; do
    base_file="$BASE_DIR/$file"
    target_file="$TARGET_DIR/$file"

    if [[ -f "$base_file" && -f "$target_file" ]]; then
        echo -e "${GREEN}✓${NC} $file - 양쪽 존재"
    elif [[ -f "$base_file" && ! -f "$target_file" ]]; then
        echo -e "${RED}✗${NC} $file - $TARGET_LANG에 누락"
        ((errors++))
    elif [[ ! -f "$base_file" && -f "$target_file" ]]; then
        echo -e "${YELLOW}!${NC} $file - $BASE_LANG에 누락 (extra in $TARGET_LANG)"
        ((warnings++))
    fi
done

echo ""

# ==== JSON Key Structure Check ====
echo "[구조 검사 / Structure Check]"

compare_json_keys() {
    local base_file="$1"
    local target_file="$2"
    local name="$3"

    if [[ ! -f "$base_file" || ! -f "$target_file" ]]; then
        return
    fi

    # Extract keys
    base_keys=$(jq -r '[paths(scalars) | join(".")] | sort | .[]' "$base_file" 2>/dev/null || echo "")
    target_keys=$(jq -r '[paths(scalars) | join(".")] | sort | .[]' "$target_file" 2>/dev/null || echo "")

    if [[ -z "$base_keys" || -z "$target_keys" ]]; then
        echo -e "${YELLOW}!${NC} $name - JSON 파싱 실패"
        ((warnings++))
        return
    fi

    base_count=$(echo "$base_keys" | wc -l | tr -d ' ')
    target_count=$(echo "$target_keys" | wc -l | tr -d ' ')

    # Find differences
    missing=$(comm -23 <(echo "$base_keys") <(echo "$target_keys") 2>/dev/null || true)
    extra=$(comm -13 <(echo "$base_keys") <(echo "$target_keys") 2>/dev/null || true)

    if [[ -z "$missing" && -z "$extra" ]]; then
        echo -e "${GREEN}✓${NC} $name - 키 일치 ($base_count개)"
    else
        if [[ -n "$missing" ]]; then
            missing_count=$(echo "$missing" | wc -l | tr -d ' ')
            echo -e "${RED}✗${NC} $name - $TARGET_LANG에 ${missing_count}개 키 누락"
            echo "$missing" | head -3 | sed 's/^/    /'
            if [[ $missing_count -gt 3 ]]; then
                echo "    ... and $((missing_count - 3)) more"
            fi
            ((errors += missing_count))
        fi

        if [[ -n "$extra" ]]; then
            extra_count=$(echo "$extra" | wc -l | tr -d ' ')
            echo -e "${YELLOW}!${NC} $name - $TARGET_LANG에 ${extra_count}개 추가 키"
            ((warnings += extra_count))
        fi
    fi
}

# Check key JSON files
compare_json_keys "$BASE_DIR/data/pokemon/species.json" "$TARGET_DIR/data/pokemon/species.json" "species.json"
compare_json_keys "$BASE_DIR/data/moves/moves.json" "$TARGET_DIR/data/moves/moves.json" "moves.json"
compare_json_keys "$BASE_DIR/data/world/locations.json" "$TARGET_DIR/data/world/locations.json" "locations.json"
compare_json_keys "$BASE_DIR/data/messages/battle.json" "$TARGET_DIR/data/messages/battle.json" "battle.json"

echo ""

# ==== SKILL.md Check ====
echo "[SKILL.md 검사]"

base_skill="$BASE_DIR/SKILL.md"
target_skill="$TARGET_DIR/SKILL.md"

if [[ -f "$base_skill" && -f "$target_skill" ]]; then
    base_sections=$(grep -c '^## ' "$base_skill" || echo "0")
    target_sections=$(grep -c '^## ' "$target_skill" || echo "0")

    if [[ "$base_sections" == "$target_sections" ]]; then
        echo -e "${GREEN}✓${NC} SKILL.md 섹션 수 일치 (${base_sections}개)"
    else
        echo -e "${YELLOW}!${NC} SKILL.md 섹션 수 불일치 ($BASE_LANG: $base_sections, $TARGET_LANG: $target_sections)"
        ((warnings++))
    fi
else
    echo -e "${RED}✗${NC} SKILL.md 파일 누락"
    ((errors++))
fi

echo ""

# ==== Summary ====
echo "=== Summary ==="
echo -e "Errors: ${RED}$errors${NC}"
echo -e "Warnings: ${YELLOW}$warnings${NC}"

if [[ $errors -gt 0 ]]; then
    echo ""
    echo -e "${RED}동기화 필요! / Sync required!${NC}"
    exit 1
else
    echo ""
    echo -e "${GREEN}동기화 완료! / Sync OK!${NC}"
    exit 0
fi
