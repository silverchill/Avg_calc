#!/bin/bash

# Define the source and destination paths
source_file="./avg_cal"
destination_dir="/bin/"

# Check if the user has sufficient permissions
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script requires root (sudo) permissions to copy files to $destination_dir."
    exit 1
fi

# Copy the file to /bin if it doesn't already exist there
if [ ! -e "$destination_dir/avg_cal" ]; then
    sudo cp "$source_file" "$destination_dir"
    echo "File copied successfully."
else
    echo "File 'avg_cal' already exists in '$destination_dir'."
fi
