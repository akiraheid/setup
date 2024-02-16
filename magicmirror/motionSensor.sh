#!/bin/bash
set -e

while true
do
	if [[ $(gpio read 2) == 1 ]]; then
		echo "`date \"+%F %T\"` Detected motion"
		~/wakeMonitor.sh
	fi
	sleep 1
done
