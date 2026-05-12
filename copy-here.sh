#!/bin/bash

# Copy different items (files and folders) from a target to the working directory 
# Usage: ./copy-folders-here.sh <target_dir>

# Public folders variable to keep track of folders that want to be copied
declare -a items=()
declare targetDir=$1
declare destDir=$(pwd)

# DEBUG ONLY
# echo "folders:   $items"
# echo "targetDir: $targetDir"
# echo "destDir:   $destDir"

# Reads folders and files from user and indexes then in items global variable.
function readItems() {
  echo "Enter what folders/files you want to copy to this folder"
  item="startingValue"

  # If the read value does not equal "done" read another and check if it exists.
  while [ $item != "done" ]; do
    read -p ">" item
    if [[ -n "$item" && -e "${targetDir}/${item}" ]]; then
      items+=("$item")
      echo "Added $item to the files to copy"
    else
      # edge case ensure no message when trying to exit loop
      if [ $item != "done" ]; then
        echo "\"$item\" does not exist in $targetDir..."
      fi
    fi
  done

  # List input captured by above
  echo ""
  echo "Folders that are going to be copied"
  echo "-----------------------------------"
  for item in "${items[@]}"; do
    echo "$item"
  done
}

# Copies all items already indexted to destination dir (working dir)
function copyItems() {
  echo "Copying items to working directory..."

  for item in "${items[@]}"; do
    local targetItem="$targetDir/$item"
    cp -r $targetItem $destDir
  done
   
  echo "Done."
}

# Cleans up all files other than the script DEBUG ONLY
function cleanItems() {
  echo "Cleaning up items just coppied"

  # instead of using rm, move clened files to .trash for safety. manual removal later.
  if [[ ! -d ".trash" ]]; then
    echo "Making \".trash\" directory for cleaning"
    mkdir .trash
  fi

  for item in "${items[@]}"; do
    mv -f $item .trash/
  done
}

# main run
readItems
copyItems
# cleanItems
