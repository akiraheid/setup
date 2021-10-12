# Find files with the same sha256 for cleanup/reorganization
# Based on https://stackoverflow.com/a/19552048

find . -not -empty -type f -print0 \
	| xargs -0 sha256sum \
	| sort \
	| uniq -w32 --all-repeated=separate
