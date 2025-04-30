#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directories
DOTFILES_DIR="${HOME}/.dotfiles"
CONFIG_DIR="${DOTFILES_DIR}/.config"
TEMP_DIR="${DOTFILES_DIR}/tmp"
ALL_PKGS_DIR="${TEMP_DIR}/.all"

# Create directories
mkdir -p "$ALL_PKGS_DIR"

# Modern spinner function with better visibility
spinner() {
    local pid=$1
    local msg="$2"
    local delay=0.1
    local spin_chars=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
    local i=0
    
    # Hide cursor
    tput civis
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${BLUE}==>${NC} ${msg} ${spin_chars[i]} "
        i=$(( (i+1) % ${#spin_chars[@]} ))
        sleep $delay
    done
    
    # Clear spinner and restore cursor
    tput cnorm
    printf "\r"
}

# Function to run command with spinner
run_with_spinner() {
    local cmd="$1"
    local msg="$2"
    local success_msg="$3"
    local error_msg="$4"
    local tmpfile=$(mktemp)
    
    # Start the command in background
    (eval "$cmd" > "$tmpfile" 2>&1) &
    local pid=$!
    
    # Show spinner
    spinner "$pid" "$msg"
    
    # Wait for completion
    wait "$pid"
    local status=$?
    
    # Handle result
    if [ $status -eq 0 ]; then
        printf "${BLUE}==>${NC} ${msg} ${GREEN}✓${NC} ${success_msg}\n"
    else
        printf "${BLUE}==>${NC} ${msg} ${RED}✗${NC} ${error_msg}\n"
        cat "$tmpfile" >&2
    fi
    
    rm -f "$tmpfile"
    return $status
}

# Function to display status messages
status_msg() {
    printf "${BLUE}==>${NC} ${1}\n"
}

# Function to display success messages
success_msg() {
    printf "${GREEN}✓${NC} ${1}\n"
}

# Function to display warning messages
warning_msg() {
    printf "${YELLOW}!${NC} ${1}\n"
}

# Function to display error messages
error_msg() {
    printf "${RED}✗${NC} ${1}\n" >&2
}

# Step 1: Generate master package lists
run_with_spinner \
    "pacman -Qe | cut -d' ' -f1 > \"${ALL_PKGS_DIR}/pacman.txt\"" \
    "Generating pacman package list..." \
    "Pacman package list generated" \
    "Error generating pacman package list!" || exit 1

run_with_spinner \
    "pacman -Qm | cut -d' ' -f1 > \"${ALL_PKGS_DIR}/yay.txt\"" \
    "Generating AUR package list..." \
    "AUR package list generated" \
    "Error generating AUR package list!" || exit 1

# Step 2: Process all directories in CONFIG_DIR
status_msg "Processing all directories in ${CONFIG_DIR}..."

for TARGET_DIR in "$CONFIG_DIR"/*; do
    # Skip if not a directory
    [[ ! -d "$TARGET_DIR" ]] && continue
    
    # Get just the directory name without path
    dir_name=$(basename "$TARGET_DIR")
    
    # Skip the ALL_PKGS_DIR if it exists in CONFIG_DIR
    [[ "$dir_name" == "$(basename "$ALL_PKGS_DIR")" ]] && continue
    
    status_msg "Processing directory: ${dir_name}"
    
    # Create output directory
    OUTPUT_DIR="${TEMP_DIR}/${dir_name}"
    mkdir -p "$OUTPUT_DIR"
    
    # Initialize output files
    PACMAN_FILE="${OUTPUT_DIR}/pacman.txt"
    YAY_FILE="${OUTPUT_DIR}/yay.txt"
    
    # Temporary files
    PACMAN_TMP="${OUTPUT_DIR}/pacman.tmp"
    YAY_TMP="${OUTPUT_DIR}/yay.tmp"
    
    # Create empty temp files
    : > "$PACMAN_TMP"
    : > "$YAY_TMP"
    
    # Process all files in target directory with spinner
    (
        total_files=$(find "$TARGET_DIR" -type f | wc -l)
        current_file=0
        
        find "$TARGET_DIR" -type f | while read -r file; do
            ((current_file++))
            
            # Extract all words from file (safer method)
            grep -oE -- '[a-zA-Z0-9_.-]+' "$file" | while read -r word; do
                # Skip short words to reduce false positives
                [[ ${#word} -lt 3 ]] && continue
                
                # Check against pacman packages
                if grep -qxF -- "$word" "${ALL_PKGS_DIR}/pacman.txt"; then
                    echo "$word" >> "$PACMAN_TMP"
                fi
                
                # Check against yay packages
                if grep -qxF -- "$word" "${ALL_PKGS_DIR}/yay.txt"; then
                    echo "$word" >> "$YAY_TMP"
                fi
            done
        done
    ) &
    spinner $! "Processing files..." || {
        error_msg "Error processing files for ${dir_name}!"
        continue
    }
    printf "${BLUE}==>${NC} Processing files... ${GREEN}✓${NC} Completed processing ${total_files} files in ${dir_name}\n"
    
    # Process results
    process_results() {
        local input_file=$1
        local output_file=$2
        local pkg_type=$3
        local dir_name=$4
        
        if [[ -s "$input_file" ]]; then
            sort -u "$input_file" > "$output_file"
            count=$(wc -l < "$output_file")
            success_msg "${pkg_type} packages found for ${dir_name}: ${count}"
            echo "    File created: ${output_file}"
        else
            warning_msg "No ${pkg_type} dependencies found for ${dir_name}."
            rm -f "$output_file"  # Remove empty file
        fi
        rm -f "$input_file"
    }
    
    echo -e "\n${GREEN}RESULTS for ${dir_name}:${NC}"
    process_results "$PACMAN_TMP" "$PACMAN_FILE" "Pacman" "$dir_name"
    process_results "$YAY_TMP" "$YAY_FILE" "AUR" "$dir_name"
    
    # Show directory contents if any files were created
    echo -e "\n${BLUE}Output directory contents for ${dir_name}:${NC}"
    if [[ -n "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]]; then
        ls -lh "$OUTPUT_DIR" | awk 'NR>1 {print $5 ($5 ~ /^[0-9]+$/ ? "B" : ""), $9}'
    else
        warning_msg "No dependency files created for ${dir_name}."
        rmdir "$OUTPUT_DIR"  # Remove empty directory
    fi
    
    echo -e "\n"
done

echo -e "\n${GREEN}Operation completed successfully for all directories!${NC}"
