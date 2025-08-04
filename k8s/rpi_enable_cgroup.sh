#!/usr/bin/env bash
set -e

text="cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
fpath=/boot/firmware/cmdline.txt

# Space at the beginning of the echo to ensure it's parsed as a separate argument
grep "$text" "$fpath" \
	|| (echo " $text" >> /boot/firmware/cmdline.txt && shutdown -r now)
