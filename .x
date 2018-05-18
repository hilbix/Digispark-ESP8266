#!/bin/bash

while	ok="$(git status --porcelain)" && [ -n "$ok" ]
do
	first="${ok%%$'\n'*}"
	first="${first:3}"
	[ -d "$first" ] && [ ! -L "$first" ] && first="$(find "$first" ! -type d -print | head -1)"

	echo "=== $first ==="

	[ -L "$first" ] || [ -f "$first" ] || break

	git add "$first"
	git commit -m "$first"
	git push || break
	sleep 10
done
