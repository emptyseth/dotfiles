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

# Get list of installed packages (trimmed of versions)
INSTALLED_PACKAGES="$(mktemp)"
xbps-query -m | sed 's/-[0-9r][0-9._]*_[0-9]*$//' > "$INSTALLED_PACKAGES"

# Create header
echo "Package,Musl Support,Description" > "$TEMP_FILE"

# Process all installed packages
while read -r installed_pkg; do
    # Check if package exists in CSV with existing info
    existing_entry=$(grep "^$installed_pkg," "$CSV_FILE" 2>/dev/null | head -n 1)
    
    if [ -n "$existing_entry" ]; then
        # Use existing entry from CSV
        echo "$existing_entry" >> "$TEMP_FILE"
    else
        # Add new package with description lookup
        desc=$(xbps-query -R "$installed_pkg" 2>/dev/null | grep '^short_desc:' | sed 's/^short_desc: *//' | sed 's/"/\\"/g')
        if [ -z "$desc" ]; then
            desc="Package auto-added from system"
        fi
        echo "$installed_pkg,Unknown,\"$desc\"" >> "$TEMP_FILE"
    fi
done < "$INSTALLED_PACKAGES"

# Clean up
rm -f "$INSTALLED_PACKAGES"

# Sort the entries by package name (excluding header)
SORTED_FILE="$(mktemp)"
head -n 1 "$TEMP_FILE" > "$SORTED_FILE"
tail -n +2 "$TEMP_FILE" | sort >> "$SORTED_FILE"

# Replace original file
mv "$SORTED_FILE" "$CSV_FILE"

echo "Updated $CSV_FILE with new packages"