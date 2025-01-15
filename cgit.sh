#!/bin/bash

# Exit on errors
set -e

# Function to display usage information
usage() {
    echo "This function concatenates all source code files in a GitHub repository into a single file. Useful for submitting to AI code interpreters."
    echo ""
    echo "Usage: $0 REPO_URL [EXTENSIONS] [DIRECTORIES] [--keep]"
    echo ""
    echo "Arguments:"
    echo "  REPO_URL         The URL of the GitHub repository to clone"
    echo ""
    echo "  EXTENSIONS       Optional comma-separated list of file extensions to process"
    echo "                   If not provided, uses standard list of programming language extensions"
    echo "                   Examples:"
    echo "                     - \"go,py,js\"        : Only process these specific extensions"
    echo "                     - \"+txt,+rtf\"      : Add these extensions to standard list"
    echo "                     - \"-c,-cpp\"         : Remove these extensions from standard list"
    echo "                     - \"+abc,123,-c\"     : Add abc, add 123, remove c from standard list"
    echo ""
    echo "  DIRECTORIES      Optional comma-separated list of directories to search within"
    echo "                   If not provided, searches all directories in the repository"
    echo "                   Examples:"
    echo "                     - \"app\"             : Search in app directory"
    echo "                     - \"app/,src/\"       : Search in app and src directories"
    echo "                     - \"app/html,cmd\"    : Search in app/html and cmd directories"
    echo ""
    echo "Options:"
    echo "  --keep          Keep the downloaded repository in the current directory"
    echo ""
    echo "Standard extensions: ${STANDARD_EXTENSIONS[*]}"
    exit 1
}

# Default standard extensions
STANDARD_EXTENSIONS=(c cpp cc cxx java py js ts cs rb php html htm css swift kt kts go rs sh bat pl lua r m vb sql asm sc erl ex exs hs dart pas groovy f for f90 v vh sv pyx clj cljs md tsx jsx yaml yml json ini cfg xml ipynb)
EXTENSIONS=()
DIRECTORIES=()

# Parse arguments
KEEP=false
REPO_URL=""
EXTENSION_INPUT=""
DIRECTORY_INPUT=""

for ARG in "$@"; do
    case $ARG in
        --keep)
            KEEP=true
            ;;
        http*)
            REPO_URL=$ARG
            ;;
        *)
            if [ -z "$EXTENSION_INPUT" ]; then
                EXTENSION_INPUT=$ARG
            elif [ -z "$DIRECTORY_INPUT" ]; then
                DIRECTORY_INPUT=$ARG
            fi
            ;;
    esac
done

# Validate repo URL
if [ -z "$REPO_URL" ]; then
    usage
fi

# Process extensions if specified
process_extensions() {
    local input=$1
    local added=()
    local removed=()
    local has_modifiers=false

    # Normalize to lowercase and split by comma
    IFS=',' read -ra EXT_ARRAY <<< "${input,,}"

    # First pass: check if any modifiers exist
    for EXT in "${EXT_ARRAY[@]}"; do
        if [[ "$EXT" =~ ^[+-] ]]; then
            has_modifiers=true
            break
        fi
    done

    # If no modifiers, use the input list as-is
    if [ "$has_modifiers" = false ]; then
        EXTENSIONS=(${EXT_ARRAY[@]})
        return
    fi

    # If we have modifiers, process them
    # Start with standard extensions
    EXTENSIONS=(${STANDARD_EXTENSIONS[@]})
    
    # Process each extension
    for EXT in "${EXT_ARRAY[@]}"; do
        case $EXT in
            +*)
                # Add extension (removing + prefix)
                if [[ ! " ${EXTENSIONS[@]} " =~ " ${EXT#+} " ]]; then
                    EXTENSIONS+=("${EXT#+}")
                fi
                ;;
            -*)
                # Remove extension (removing - prefix)
                EXTENSIONS=("${EXTENSIONS[@]/${EXT#-}}")
                ;;
            *)
                # No prefix, treat as add
                if [[ ! " ${EXTENSIONS[@]} " =~ " $EXT " ]]; then
                    EXTENSIONS+=("$EXT")
                fi
                ;;
        esac
    done
}

process_directories() {
    local input=$1
    # Split by comma and store in DIRECTORIES array
    IFS=',' read -ra DIRECTORIES <<< "$input"
    
    # Ensure each directory starts with / and ends with /
    for i in "${!DIRECTORIES[@]}"; do
        dir="${DIRECTORIES[$i]}"
        # Remove leading/trailing slashes and spaces
        dir=$(echo "$dir" | sed 's:^/*::; s:/*$::')
        # Add trailing slash
        DIRECTORIES[$i]="$dir/"
    done
}

if [ -n "$EXTENSION_INPUT" ]; then
    process_extensions "$EXTENSION_INPUT"
else
    EXTENSIONS=(${STANDARD_EXTENSIONS[@]})
fi

# Add directory processing
if [ -n "$DIRECTORY_INPUT" ]; then
    process_directories "$DIRECTORY_INPUT"
fi

# Add this configuration summary before the cloning starts
echo "=== Configuration Summary ==="
echo "Repository URL: $REPO_URL"
echo
echo "Extensions to process:"
if [ -n "$EXTENSION_INPUT" ]; then
    echo "  Custom extension list provided: $EXTENSION_INPUT"
else
    echo "  Using standard extension list"
fi
echo "  Final extension list: ${EXTENSIONS[*]}"
echo
echo "Directory filtering:"
if [ ${#DIRECTORIES[@]} -gt 0 ]; then
    echo "  Searching only in directories: ${DIRECTORIES[*]}"
else
    echo "  Searching in all directories"
fi
echo
echo "Keep repository: $KEEP"
echo "=========================="
echo

# Extract repo name from URL
REPO_NAME=$(basename -s .git "$REPO_URL")
OUTPUT_FILE="${REPO_NAME}.txt"
TEMP_DIR=$(mktemp -d)

# Clone the repo to temp directory
echo "Cloning repository..."
git clone "$REPO_URL" "$TEMP_DIR/$REPO_NAME"

# Find all source code files matching extensions
find_pattern=""
for ext in "${EXTENSIONS[@]}"; do
    if [ -z "$find_pattern" ]; then
        find_pattern="-name \"*.${ext}\""
    else
        find_pattern="${find_pattern} -o -name \"*.${ext}\""
    fi
done

# Add directory filtering to the find command
if [ ${#DIRECTORIES[@]} -gt 0 ]; then
    dir_pattern=""
    for dir in "${DIRECTORIES[@]}"; do
        if [ -z "$dir_pattern" ]; then
            dir_pattern="-path \"*/$dir*\""
        else
            dir_pattern="${dir_pattern} -o -path \"*/$dir*\""
        fi
    done
    CODE_FILES=$(eval "find \"$TEMP_DIR/$REPO_NAME\" -type f \( ${dir_pattern} \) -a \( ${find_pattern} \)")
else
    CODE_FILES=$(eval "find \"$TEMP_DIR/$REPO_NAME\" -type f \( ${find_pattern} \)")
fi

# Concatenate all source code files into one output file
echo "Concatenating source code files..."
> "$OUTPUT_FILE"  # Clear the output file if it exists
for FILE in $CODE_FILES; do
    # Remove the temp directory prefix to get clean relative path
    relative_path=${FILE#$TEMP_DIR/$REPO_NAME/}
    echo "--- $relative_path ---" >> "$OUTPUT_FILE"
    cat "$FILE" >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"  # Add a single newline between files
done

# Move the repo to current directory if --keep is specified
if $KEEP; then
    mv "$TEMP_DIR/$REPO_NAME" "./$REPO_NAME"
    echo "Repository saved to $REPO_NAME"
else
    rm -rf "$TEMP_DIR"
fi

# Notify the user
echo "Concatenated source code files into $OUTPUT_FILE"
echo "Extensions used: ${EXTENSIONS[@]}"


