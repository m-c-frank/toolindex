#!/bin/bash
# Takes CSV input and formats it into a human-readable table.

echo "PROJECT,ABSTRACT" | column -t -s,  # Print header
while IFS=, read -r project abstract; do
    # Truncate abstract to fit one line and add ellipsis if needed
    DISPLAY_ABSTRACT=$(echo "$abstract" | cut -c 1-50)
    if [ "${#abstract}" -gt 50 ]; then
        DISPLAY_ABSTRACT="${DISPLAY_ABSTRACT}..."
    fi
    printf "%-40s | %-50s\n" "$project" "$DISPLAY_ABSTRACT"
done | column -t -s '|'  # Format as a table
