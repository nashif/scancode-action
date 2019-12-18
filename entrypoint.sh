#!/bin/sh -l

mkdir -p ${1}
#git rebase origin/master
for f in `git  diff --name-only --diff-filter=A origin/master..`; do
	echo "found new file: $f";
	cp --parents  $f ${1};
done

ls -la
ls -la ${1}

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


python /license_check.py -c /github/workspace/.github/license_config.yml -s /github/workspace/artifacts/scancode.json  -f /github/workspace/$1 -o /github/workspace/artifacts/report.txt
