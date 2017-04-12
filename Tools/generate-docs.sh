#!/bin/sh

if [[ -z $SRCROOT ]]
then
	SRCROOT="$(dirname $0)/.."
fi

pushd $SRCROOT >/dev/null

COMMIT=$(git rev-parse HEAD)
VERSION=$(cat "GfycatApiKit.podspec" | grep 's.version.*=' | sed "s/.*'\(.*\)'.*/\\1/g")

jazzy \
	--objc \
	--clean \
	--author Gfycat \
	--author_url "https://gfycat.com" \
	--github_url "https://github.com/gfycat/GfycatApiKit" \
	--github-file-prefix "https://github.com/gfycat/GfycatApiKit/blob/$COMMIT" \
	--module-version "$VERSION" \
	--umbrella-header "GfycatApiKit/GfycatApiKit.h" \
	--framework-root .\
	--module GfycatApiKit \
	--output docs

popd >/dev/null
