#!/bin/sh -l

pwd
ls -la
ls -la $HOME/

./scancode \
	-clipeu \
	--license-diag \
	--classify \
	--summary \
	--verbose /github/workspace/$1 \
	--processes `expr $(nproc --all) - 1` \
	--json /github/workspace/scancode.json \
	--html /github/workspace/scancode.html
