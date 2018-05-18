#!/bin/bash

for a
do
	NAME="${a##*/}"
	NAME="${NAME##.*}"
	BASE="${NAME%%-*}"
	STAMP="$(stat -c %y "$a" | sed 's/ .*$//')"
	git branch "$BASE" empty
	echo "$NAME" | fakeroot gbp import-orig --upstream-branch="$BASE" --pristine-tar --upstream-tag="$BASE-%(version)s" --upstream-version="$STAMP" "$a"
done

