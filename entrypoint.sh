#!/bin/sh -l

./scancode \
	-clipeu \
	--license-diag \
	--classify \
	--summary \
	--verbose /scan/$1 \
	--processes `expr $(nproc --all) - 1` \
	--json /scan/scancode.json \
	--html /scan/scancode.html
