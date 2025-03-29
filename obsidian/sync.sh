#!/usr/bin/env bash

targets=(
	'.obsidian.vimrc'
	'.obsidian/hotkeys.json'
	'.obsidian/core-plugins.json'
	'.obsidian/community-plugins.json'
	'.obsidian/templates.json'
	'.obsidian/plugins/obsidian-linter/data.json'
	'.obsidian/plugins/templater-obsidian/data.json'
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
		echo "$target"
		mkdir -p "$(dirname "$target")"
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
	vault=$OBSIDIAN_VAULT
	if [[ -z $vault ]]; then
		echo "OBSIDIAN_VAULT not set"
		exit 1
	fi

	case "$1" in
	import)
		import_settings "$vault"
		;;
	export)
		export_settings "$vault"
		;;
	*)
		echo "Unknown command"
		exit 1
		;;
	esac
}

main "$1"
