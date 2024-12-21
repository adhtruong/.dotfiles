#!/bin/bash

set -euo pipefail

outdir=$(dirname "$0")
domains=(
  "com.knollsoft.Rectangle"
  "com.lwouis.alt-tab-macos"
  "com.microsoft.VSCode"
)

# macOS Defaults Import/Export Script
# This script allows you to export and import macOS defaults by domain

# Function to display usage instructions
usage() {
  echo "Usage:"
  echo "  $0 export"
  echo "  $0 import"
}

# Export function to save defaults for a specific domain
export_defaults() {
  local domain="$1"
  local output_file="${outdir}/${domain}.plist"

  # Validate input
  if [ -z "$domain" ]; then
    echo "Error: Domain is required."
    usage
    exit 1
  fi

  # Check if domain exists
  if ! defaults read "$domain" &>/dev/null; then
    echo "Error: Invalid domain '$domain'"
    exit 1
  fi

  # Export defaults to the domain-named file
  if defaults export "$domain" "$output_file"; then
    echo "Successfully exported defaults for $domain to $output_file"
  else
    echo "Failed to export defaults for $domain"
    exit 1
  fi
}

# Import function to restore defaults from a saved file
import_defaults() {
  local input_file="${outdir}/$1.plist"

  # Validate input
  if [ -z "$input_file" ]; then
    echo "Error: Input file is required."
    usage
    exit 1
  fi

  # Check if file exists
  if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' does not exist."
    exit 1
  fi

  # Determine the domain from the imported file
  domain=$(basename "$input_file" .plist)

  # Import defaults from the specified file
  if defaults import "$domain" "$input_file"; then
    echo "Successfully imported defaults for $domain from $input_file"
    echo "Note: Some changes may require logging out or restarting the application"
  else
    echo "Failed to import defaults for $domain"
    exit 1
  fi
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

case "$1" in
import)
  for domain in "${domains[@]}"; do
    echo "Processing $domain"
    import_defaults "$domain"
  done
  ;;
export)
  for domain in "${domains[@]}"; do
    echo "Processing $domain"
    export_defaults "$domain"
  done
  ;;
*)
  echo "Unknown command"
  exit 1
  ;;
esac
