#!/bin/sh
find . -name '*.md' | while read -r mdfile; do
	dir=$(dirname "$mdfile")
	base=$(basename "$mdfile" .md)
	htmlfile="$dir/$base.html"

	if [ ! -f "$htmlfile" ] || [ "$mdfile" -nt "$htmlfile" ]; then
		echo "Converting: $mdfile -> $htmlfile"
		title=$(./extract_title.pl "$mdfile")
		escaped_title=$(echo $title | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')
		sed "s/{{title}}/$escaped_title/" head._html >"$htmlfile"
		cat "$mdfile" | sed -E 's/(\[[^][]+\])\((https?:\/\/[^)]+)\)/\1(\2)🔗/g' | markdown >>"$htmlfile"
		cat tail._html >>"$htmlfile"
		tidy -mq "$htmlfile" 2>/dev/null
	fi
done
