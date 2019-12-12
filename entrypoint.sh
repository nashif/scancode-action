#!/bin/sh -l

mkdir -p scan
git rebase origin/master
for f in `git  diff --name-only --diff-filter=A origin/master..`; do cp --parents  $f scan; done
ls -la scan/

mkdir -p /github/workspace/artifacts

cd /scancode-toolkit
./scancode \
	-clipeu \
	--license-diag \
	--classify \
	--summary \
	--verbose /github/workspace/$1 \
	--processes `expr $(nproc --all) - 1` \
	--json /github/workspace/artifacts/scancode.json \
	--html /github/workspace/artifacts/scancode.html
