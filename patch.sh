#!/bin/bash

if [ -z "$*" ]; then
	echo $'Option  Meaning\n-am     Patch using `git am`\n-ap     Patch using `git apply`\n-r      Revert patches'
fi

if [ "$(basename "$PWD")" = extra ]; then
	cd ../..
	ROOT="$PWD"
else
	ROOT="$PWD"

fi

for repository in $(find vendor/extra/patches -mindepth 2 -type d | sed 's#.*patches/##'); do

	LAST_COMMIT_HASH="$ROOT/$(sed 's#/#_#g' <<<"$repository").log"
	PATCHES="$ROOT/vendor/extra/patches/$repository"

	cd "$ROOT/$repository" || exit

	case $1 in
	-am)
		git log -n 1 --pretty=format:"%H" >"$LAST_COMMIT_HASH"
		git am --keep-cr "$PATCHES"/*
		;;
	-ap)
		git apply -v "$PATCHES"/*
		;;
	-ch)
		git apply -v --check "$PATCHES"/*
		;;
	-r)
		if [ -e "$LAST_COMMIT_HASH" ]; then
			git reset --hard "$(cat "$LAST_COMMIT_HASH")" 2>/dev/null
			rm "$LAST_COMMIT_HASH"
		else
			git reset --hard 2>/dev/null && git clean -df
		fi
		;;
	esac
	cd "$ROOT" || exit

done
