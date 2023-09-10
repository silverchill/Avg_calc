#!/bin/bash

# ANSI escape codes for colors
RED='\033[0;31m'
NC='\033[0m' # No color

# Configuration
source_file="./avg_cal"
destination_dir="/bin/"
destination_file="$destination_dir/avg_cal"

# Function to calculate the MD5 checksum of a file
calculate_checksum() {
    md5sum "$1" | awk '{print $1}'
}

# Check if the user has sufficient permissions
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Error: This script requires root (sudo) permissions to copy files to $destination_dir.${NC}"
    exit 1
fi

# Check if the destination directory exists
if [ ! -d "$destination_dir" ]; then
    echo -e "${RED}Error: Destination directory '$destination_dir' does not exist.${NC}"
    exit 1
fi

# Check if the source file exists
if [ ! -e "$source_file" ]; then
    echo -e "${RED}Error: Source file '$source_file' does not exist.${NC}"
    exit 1
fi

# Calculate checksums of source and destination files
source_checksum=$(calculate_checksum "$source_file")
destination_checksum=$(calculate_checksum "$destination_file")

# Compare checksums
if [ "$source_checksum" == "$destination_checksum" ]; then
    echo -e "${RED}No change detected. Version already installed. \n\t\tCheck for Update!.${NC}"
else
    # Check if the destination file already exists
    if [ -e "$destination_file" ]; then
        read -p "File 'avg_cal' in '$destination_dir' has changed. Do you want to replace it? (y/n): " replace
        if [ "$replace" != "y" ]; then
            echo "Operation canceled."
            exit 0
        fi
    fi

    # Copy the file to /bin
    sudo cp "$source_file" "$destination_file"
    if [ $? -eq 0 ]; then
        echo "File updated successfully in '$destination_dir'."
    else
        echo -e "${RED}Error: Failed to copy file to '$destination_dir'.${NC}"
        exit 1
    fi
fi
