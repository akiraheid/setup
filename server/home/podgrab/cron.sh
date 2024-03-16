#!/bin/bash
set -e

dataDir=/raid/apps/podgrab
storageDir=/raid/podcasts
echo "Making hardlinks for $dataDir..."
cd $dataDir
for dir in */; do
	dir=${dir%*/} # Remove trailing '/'
	dir=${dir##*/} # print folder name
	echo "Processing $dir"
	mkdir -pv "$storageDir/$dir"
	pushd "$dir"
	find -type f -links 1 -exec ln -v {} "$storageDir/$dir/{}" \;
	popd
done
echo "Making hardlinks for $dataDir... done"

./start.sh | tee -a ./log.txt
