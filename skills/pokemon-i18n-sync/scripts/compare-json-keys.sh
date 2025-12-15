#!/bin/bash
# Compare JSON keys between two files
# Usage: ./compare-json-keys.sh <file1.json> <file2.json>

file1="$1"
file2="$2"

if [[ -z "$file1" || -z "$file2" ]]; then
    echo "Usage: $0 <file1.json> <file2.json>"
    echo "Example: $0 pokemon-green-ko/data/pokemon/species.json pokemon-green-en/data/pokemon/species.json"
    exit 1
fi

if [[ ! -f "$file1" ]]; then
    echo "Error: File not found: $file1"
    exit 1
fi

if [[ ! -f "$file2" ]]; then
    echo "Error: File not found: $file2"
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== JSON Key Comparison ==="
echo "File 1: $file1"
echo "File 2: $file2"
echo ""

# Extract keys
keys1=$(jq -r '[paths(scalars) | join(".")] | sort | .[]' "$file1" 2>/dev/null)
keys2=$(jq -r '[paths(scalars) | join(".")] | sort | .[]' "$file2" 2>/dev/null)

if [[ -z "$keys1" ]]; then
    echo -e "${RED}Error: Could not parse $file1${NC}"
    exit 1
fi

if [[ -z "$keys2" ]]; then
    echo -e "${RED}Error: Could not parse $file2${NC}"
    exit 1
fi

count1=$(echo "$keys1" | wc -l | tr -d ' ')
count2=$(echo "$keys2" | wc -l | tr -d ' ')

echo "File 1 keys: $count1"
echo "File 2 keys: $count2"
echo ""

# Find differences
only_in_1=$(comm -23 <(echo "$keys1") <(echo "$keys2"))
only_in_2=$(comm -13 <(echo "$keys1") <(echo "$keys2"))

if [[ -n "$only_in_1" ]]; then
    count_only_1=$(echo "$only_in_1" | wc -l | tr -d ' ')
    echo -e "${YELLOW}Keys only in File 1 ($count_only_1):${NC}"
    echo "$only_in_1" | head -20 | sed 's/^/  /'
    if [[ $count_only_1 -gt 20 ]]; then
        echo "  ... and $((count_only_1 - 20)) more"
    fi
    echo ""
fi

if [[ -n "$only_in_2" ]]; then
    count_only_2=$(echo "$only_in_2" | wc -l | tr -d ' ')
    echo -e "${YELLOW}Keys only in File 2 ($count_only_2):${NC}"
    echo "$only_in_2" | head -20 | sed 's/^/  /'
    if [[ $count_only_2 -gt 20 ]]; then
        echo "  ... and $((count_only_2 - 20)) more"
    fi
    echo ""
fi

if [[ -z "$only_in_1" && -z "$only_in_2" ]]; then
    echo -e "${GREEN}Keys are identical!${NC}"
fi
