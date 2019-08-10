set -e

while true
do
	if [[ $(gpio read 2) == 1 ]]; then
		bash wakeMonitor.sh
	fi
	sleep 1
done
