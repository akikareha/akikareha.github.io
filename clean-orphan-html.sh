#!/bin/sh
find . -name '*.html' | while read -r htmlfile; do
	dir=$(dirname "$htmlfile")
	base=$(basename "$htmlfile" .html)
	mdfile="$dir/$base.md"

	if [ ! -f "$mdfile" ]; then
		echo "Removing orphan: $htmlfile"
		rm "$htmlfile"
	fi
done
