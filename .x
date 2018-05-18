#!/bin/bash

let size=0
while	ok="$(git status --porcelain)" && [ -n "$ok" ]
do
	first="${ok%%$'\n'*}"
	first="${first:3}"
	[ -d "$first" ] && [ ! -L "$first" ] && first="$(find "$first" ! -type d -print | head -1)"

	echo "=== $first ==="

	[ -L "$first" ] || [ -f "$first" ] || break

	git add "$first"
	size+=$(stat -c %s "$first")
	[ 100000 -lt "$size" ] && continue

	git commit -m "$first"
	git push || break

	size=0

	git status --porcelain

	keypressed 20000 && break
done
