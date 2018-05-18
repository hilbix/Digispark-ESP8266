#!/bin/bash


ok=:
while	$ok
do
	let size=0;
	files=""
	while read -ru6 x first;
	do
		[ -d "$first" ] && [ ! -L "$first" ] && first="$(find "$first" ! -type d -print | head -1)"

		echo "=== $first ==="

		[ -L "$first" ] || [ -f "$first" ] || continue

		bytes="$(stat -c %s "$first")"
		let size+=$bytes
		[ -n "$files" ] && [ 100000 -lt "$size" ] && continue

		git add "$first"

		files="$files$first"$'\n'

	done 6< <(git status --porcelain)

	git commit -m "$files"
	git push || break

	git status --porcelain

	keypressed 20000 && break
done

