#!/bin/bash
set -e

bash updateSystem.sh
bash setupSSH.sh
bash setupFirewall.sh
bash setupCron.sh
