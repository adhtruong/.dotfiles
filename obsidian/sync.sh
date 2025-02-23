##!/bin/usr/env sh

vaults=(
    ~/Google\ Drive/My\ Drive/Obsidian/Vault/Test
    ~/Documents/Notes
)
targets=(
    '.obsidian.vimrc'
    '.obsidian/hotkeys.json'
    '.obsidian/core-plugins.json'
    '.obsidian/community-plugins.json'
    '.obsidian/templates.json'
    'templates/Daily Note.md'
)

outdir=$(dirname "$0")

export_settings() {
    vault=$1
    echo "Processing $vault..."

    if [ ! -d "$vault" ]; then
        echo "$vault does not exists. Skipping export"
        return
    fi

    for file in "${targets[@]}"; do
        target="$outdir/$file"
        echo $target
        mkdir -p $(dirname "$target")
        cp "$vault/$file" "$target"
    done
}

import_settings() {
    vault=$1
    echo "Processing $vault..."

    if [ ! -d "$vault" ]; then
        echo "$vault does not exists. Skipping import"
        return
    fi

    for file in "${targets[@]}"; do
        source="$outdir/$file"
        echo "Copying $source to $vault"
        cp "$source" "$vault/$file"
    done
}

usage() {
  echo "Usage:"
  echo "  $0 export"
  echo "  $0 import"
}

main() {
    case "$1" in
    import)
    for vault in "${vaults[@]}"; do
        import_settings "$vault"
    done
    ;;
    export)
    for vault in "${vaults[@]}"; do
        export_settings "$vault"
    done
    ;;
    *)
    echo "Unknown command"
    exit 1
    ;;
    esac
}

main $1
