#!/bin/sh

# Script to update void-packages.csv with currently installed packages
# Usage: ./update-void-packages.sh [csv_file]

# Determine CSV file path
if [ $# -eq 1 ]; then
    CSV_FILE="$1"
else
    CSV_FILE="$HOME/.local/share/void-packages.csv"
fi

TEMP_FILE="$(mktemp)"

# Check if CSV file exists, if not create with header only
if [ ! -f "$CSV_FILE" ]; then
    echo "Package,Musl Support,Description" > "$CSV_FILE"
    echo "Created new CSV file: $CSV_FILE"
fi

# Check if xbps-query is available
if ! command -v xbps-query >/dev/null 2>&1; then
    echo "Error: xbps-query command not found"
    exit 1
fi

# Create header
echo "Package,Musl Support,Description" > "$TEMP_FILE"

# Read CSV file line by line, skip header
tail -n +2 "$CSV_FILE" > "${TEMP_FILE}.input"
while IFS=',' read -r package musl_support description; do
    # Remove quotes from package name if present
    package=$(echo "$package" | sed 's/^"//;s/"$//')
    
    # Write to temp file (no installation status)
    echo "$package,$musl_support,$description" >> "$TEMP_FILE"
done < "${TEMP_FILE}.input"

# Clean up
rm -f "${TEMP_FILE}.input"

# Replace original file
mv "$TEMP_FILE" "$CSV_FILE"

echo "Updated $CSV_FILE with installation status"