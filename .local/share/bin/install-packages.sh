#!/bin/sh

# install-packages.sh - Script to install packages from a CSV file
# Usage: ./install-packages.sh /path/to/csv [musl_only]
# musl_only options: "yes" (default) or "all"

# Check if a CSV file path was provided
if [ -z "$1" ]; then
    echo "Error: No CSV file path provided."
    echo "Usage: $0 <path-to-csv-file> [musl_only]"
    echo ""
    echo "Parameters:"
    echo "  path-to-csv-file  - Path to the CSV file containing package information"
    echo "  musl_only         - Whether to install only musl-compatible packages"
    echo "                      'yes' - Only install packages with full musl support (default)"
    echo "                      'all' - Install all packages regardless of musl support"
    echo ""
    echo "Example: $0 /path/to/void-packages.csv"
    echo "Example: $0 /path/to/void-packages.csv all"
    exit 1
fi

CSV_FILE="$1"
MUSL_ONLY="$2"

# Default to 'yes' if no option provided
if [ -z "$MUSL_ONLY" ]; then
    MUSL_ONLY="yes"
fi

# Check if the CSV file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: CSV file not found at '$CSV_FILE'"
    exit 1
fi

# Validate the musl_only parameter
if [ "$MUSL_ONLY" != "yes" ] && [ "$MUSL_ONLY" != "all" ]; then
    echo "Error: Invalid value for musl_only parameter: '$MUSL_ONLY'"
    echo "Valid options are 'yes' or 'all'"
    exit 1
fi

# Function to install packages
install_packages() {
    # Count packages
    PACKAGE_COUNT=$(echo "$1" | wc -w)
    
    # Show installation plan
    echo "Will install $PACKAGE_COUNT packages."
    echo "Packages to install:"
    echo "$1" | tr ' ' '\n' | sort
    
    # Confirm installation
    echo ""
    echo "Do you want to proceed with installation? (y/N): "
    read -r CONFIRM
    
    if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
        echo "Installing packages..."
        # Use xargs to handle potential command line length limitations
        echo "$1" | xargs -n 20 xbps-install -S
        
        # Check exit status
        if [ $? -eq 0 ]; then
            echo "Installation completed successfully."
        else
            echo "Installation encountered errors. Check output above."
            exit 1
        fi
    else
        echo "Installation cancelled."
        exit 0
    fi
}

# Get packages based on the selected option
if [ "$MUSL_ONLY" = "yes" ]; then
    echo "Getting only packages with full musl support..."
    PACKAGES=$(awk -F ',' 'NR>1 && $2=="Yes" {printf "%s ", $1}' "$CSV_FILE")
else
    echo "Getting all packages regardless of musl support..."
    PACKAGES=$(awk -F ',' 'NR>1 {printf "%s ", $1}' "$CSV_FILE")
fi

# Check if we found any packages
if [ -z "$PACKAGES" ]; then
    echo "No packages found that match the criteria."
    exit 1
fi

# Install the packages
install_packages "$PACKAGES"

exit 0
