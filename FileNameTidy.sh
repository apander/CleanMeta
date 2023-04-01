#!/bin/bash

# Print script usage instructions
usage() {
  echo "Usage: $(basename $0) [-y]"
  echo "Renaming video files in the current directory."
  echo "  -y  Assume yes to all confirmations"
  exit 1
}

# Check if a confirmation is required
get_confirmation() {
  if [ "$assume_yes" = true ]; then
    return 0
  fi

  while true; do
    read -rp "Rename this file '$1' to '$2'? [Y/N]: " answer
    case $answer in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

# Process each video file in the current directory
rename_video_files() {
  for file in *.mp4 *.avi *.m4v *.wmv, *.mkv; do
    # Skip if no files found
    [ -e "$file" ] || continue

    # Extract file name and extension
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    # Remove year and resolution from filename
    new_filename=$(echo "$filename" | sed -E 's/([a-zA-Z0-9]+)[._](20[0-9]{2}|1080p?).*/\1/g' | tr '.' ' ')

    # Confirm renaming of file
    if get_confirmation "$filename.$extension" "$new_filename.$extension"; then
      # Rename file
      mv "$filename.$extension" "$new_filename.$extension"
      echo "Renamed '$filename.$extension' to '$new_filename.$extension'"
    else
      echo "Skipping '$filename.$extension'"
    fi
  done
}

# Parse command-line arguments
assume_yes=false
while getopts "hy" option; do
  case $option in
    h ) usage;;
    y ) assume_yes=true;;
    * ) usage;;
  esac
done

# Rename video files in the current directory
echo "Renaming video files in the current directory:"
rename_video_files
echo "Done!"
