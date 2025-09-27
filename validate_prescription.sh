#!/bin/bash

if [ "$(whoami)" != "pharmtech" ]; then
    echo "Error: Invalid User"
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_directory>"
    exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' not found"
    exit 1
fi

VERIFIED_DIR="$DIR/verified"
mkdir -p "$VERIFIED_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
AUDIT_FILE="$DIR/audit_$TIMESTAMP.log"

verified_count=0
skipped_count=0

for file in "$DIR"/*.txt; do
    [ -e "$file" ] || continue  # Skip if no .txt files

    filename=$(basename "$file")

    if grep -q "VALID" "$file"; then
        mv "$file" "$VERIFIED_DIR/"
        echo "$filename : VALID" >> "$AUDIT_FILE"
        ((verified_count++))
    else
        echo "$filename : INVALID" >> "$AUDIT_FILE"
        ((skipped_count++))
    fi
done

echo "Validation complete."
echo "Verified files: $verified_count"
echo "Skipped files: $skipped_count"
echo "Audit log saved to: $AUDIT_FILE"

