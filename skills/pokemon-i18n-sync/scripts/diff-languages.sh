#!/bin/bash
# Show differences between language versions of a specific file
# Usage: ./diff-languages.sh <relative_path> [base_lang] [target_lang]

RELATIVE_PATH="$1"
BASE_LANG="${2:-ko}"
TARGET_LANG="${3:-en}"

PROJECT_DIR="${PROJECT_DIR:-/Users/jelly/personal/pukiman}"
SKILLS_DIR="$PROJECT_DIR/.claude/skills"

if [[ -z "$RELATIVE_PATH" ]]; then
    echo "Usage: $0 <relative_path> [base_lang] [target_lang]"
    echo ""
    echo "Examples:"
    echo "  $0 data/pokemon/species.json"
    echo "  $0 data/moves/moves.json ko en"
    echo "  $0 SKILL.md"
    exit 1
fi

BASE_FILE="$SKILLS_DIR/pokemon-green-$BASE_LANG/$RELATIVE_PATH"
TARGET_FILE="$SKILLS_DIR/pokemon-green-$TARGET_LANG/$RELATIVE_PATH"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=== Language Diff ==="
echo -e "Base ($BASE_LANG): ${BLUE}$BASE_FILE${NC}"
echo -e "Target ($TARGET_LANG): ${BLUE}$TARGET_FILE${NC}"
echo ""

# Check files exist
if [[ ! -f "$BASE_FILE" ]]; then
    echo -e "${RED}Error: Base file not found${NC}"
    exit 1
fi

if [[ ! -f "$TARGET_FILE" ]]; then
    echo -e "${RED}Error: Target file not found${NC}"
    exit 1
fi

# Different diff strategies based on file type
case "$RELATIVE_PATH" in
    *.json)
        echo "[JSON Structure Diff]"
        echo ""

        # Compare key structure
        base_keys=$(jq -r '[paths(scalars) | join(".")] | sort | .[]' "$BASE_FILE" 2>/dev/null)
        target_keys=$(jq -r '[paths(scalars) | join(".")] | sort | .[]' "$TARGET_FILE" 2>/dev/null)

        diff_output=$(diff <(echo "$base_keys") <(echo "$target_keys") 2>/dev/null || true)

        if [[ -z "$diff_output" ]]; then
            echo -e "${GREEN}Key structures are identical${NC}"
        else
            echo "$diff_output" | head -50
            if [[ $(echo "$diff_output" | wc -l) -gt 50 ]]; then
                echo "... (truncated)"
            fi
        fi
        ;;

    *.md)
        echo "[Markdown Section Diff]"
        echo ""

        # Compare section headers
        base_sections=$(grep '^## ' "$BASE_FILE" | sort)
        target_sections=$(grep '^## ' "$TARGET_FILE" | sort)

        echo "--- $BASE_LANG sections ---"
        echo "$base_sections"
        echo ""
        echo "--- $TARGET_LANG sections ---"
        echo "$target_sections"
        echo ""

        diff_output=$(diff <(echo "$base_sections") <(echo "$target_sections") 2>/dev/null || true)
        if [[ -z "$diff_output" ]]; then
            echo -e "${GREEN}Section headers are identical${NC}"
        else
            echo "[Differences]"
            echo "$diff_output"
        fi
        ;;

    *)
        echo "[Raw Diff]"
        echo ""
        diff "$BASE_FILE" "$TARGET_FILE" | head -100
        ;;
esac
