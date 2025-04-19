#!/bin/bash
set -e

dirs=(adventures books comics movies music podcasts shows sync)
raidDir=/raid
backupDir="/media/$USER/cold storage/backup"
mkdir -p "${backupDir}"
cd "${backupDir}"

for dir in "${dirs[@]}"; do
	mkdir -p "./${dir}"
	timemachine "home-local:${raidDir}/${dir}/" "./${dir}/"
done

# Not doing "--content" because the results may be unpredictable
hardlink --keep-oldest --ignore-time --minimum-size 1MiB .
