#!/bin/bash
set -e

dirs=(books comics movies music podcasts shows sync/family/family-photos)
raidDir=/raid
backupDir="/media/$USER/cold storage/backup"
cd "$backupDir"

HERE=$(dirname $(readlink -f "$0"))
PATH=$PATH:$HERE
for dir in "${dirs[@]}"; do
	timemachine "home:${raidDir}/" "./${dir}/"
done

hardlink --keep-oldest --ignore-time .
