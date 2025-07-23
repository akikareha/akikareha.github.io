#!/bin/sh
find . -name '*.md' | while read -r mdfile; do
	dir=$(dirname "$mdfile")
	base=$(basename "$mdfile" .md)
	htmlfile="$dir/$base.html"

	if [ ! -f "$htmlfile" ] || [ "$mdfile" -nt "$htmlfile" ]; then
		echo "Converting: $mdfile -> $htmlfile"
		cp head._html "$htmlfile"
		markdown "$mdfile" >>"$htmlfile"
		cat tail._html >>"$htmlfile"
		tidy -mq "$htmlfile" 2>/dev/null
	fi
done
