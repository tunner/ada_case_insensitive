#!/bin/bash

# Directory to start the search (can be passed as an argument or defaults to the current directory)
ROOT_DIR="${1:-.}"

# Output file for the Naming package
OUTPUT_FILE="naming_package.gpr"

# Start the Naming package
echo "   package Naming is" > "$OUTPUT_FILE"

# Function to convert file name to Ada package name
file_to_package_name() {
    local file_name="$1"
    # Remove file extension
    base_name=$(basename "$file_name" .ads)
    base_name=$(basename "$base_name" .adb)
    # Replace '-' with '.'
    echo "$base_name" | sed 's/-/./g'
}

# Find all .ads and .adb files with uppercase characters in their names
find "$ROOT_DIR" -type f \( -name "*.ads" -o -name "*.adb" \) | grep -E '[A-Z]' | while read -r file; do
    # Get the full package name
    package_name=$(file_to_package_name "$file")
    # Get the file name relative to the ROOT_DIR
    relative_file=$(basename "$file")

    # Determine if it is a spec or body file
    if [[ "$file" == *.ads ]]; then
        echo "      for Spec (\"$package_name\") use \"$relative_file\";" >> "$OUTPUT_FILE"
    elif [[ "$file" == *.adb ]]; then
        echo "      for Body (\"$package_name\") use \"$relative_file\";" >> "$OUTPUT_FILE"
    fi
done

# Close the Naming package
echo "   end Naming;" >> "$OUTPUT_FILE"

echo "Naming package generated in $OUTPUT_FILE"
