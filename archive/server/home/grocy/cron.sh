#!/bin/bash
set -e

cd /raid/apps/grocy
./start.sh | tee -a ./log.txt
