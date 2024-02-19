#!/bin/bash

# This script generates a Markdown file containing the contents of all files in the current directory and its subdirectories,
# with special handling for Markdown files to escape triple backticks. The output is formatted to be suitable for use as a GPT prompt.
# The script skips the script file itself to avoid recursion.
#
# Usage: ./mdcat.sh
#
# Output: A Markdown file with the contents of all files in the current directory and its subdirectories,
# with triple backticks escaped in Markdown files.
#
# Example usage:
# $ ./mdcat.sh > output.md
#
# This will create an output.md file with the contents of all files in the current directory and its subdirectories.

# Get the basename of the script file
script_name="mdcat.sh"

for file in ./* ./.github/workflows/*; do
    # Get the basename of the current file
    filename=$(basename "$file")

    # Skip the script file itself
    if [[ $filename == $script_name ]]; then
        continue
    fi

    echo -e "\n\`${file}\`:\n\`\`\`"
    if [[ $file == *.md ]]; then
        # For Markdown files, escape triple backticks
        sed 's/```/\\`\\`\\`/g' "$file"
    else
        # For other files, just print the contents
        cat "$file"
    fi
    echo -e "\`\`\`\n"
done
