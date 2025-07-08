# 1. Overview

This document specifies how home server backups are performed and why.

# 2. Backup Strategy

1. **Goals**: Minimize data loss, ensure rapid recovery, test the restoration process regularly.
2. **Principles**:
    1. **3-2-1 rule**: Maintain at least 3 copies of data across 2 different media and 1 offsite copy.
    2. **Automation**: Schedule backups to run automatically without manual intervention to ensure consistency and execution.
    3. **Verification**: Regularly test restoring backups to ensure they are working and the process is understood.

# 3. Backup Types & Schedule

## 3.1 Offsite backup

1. Frequency: Monthly
2. Data covered: All applications and data
3. Locations: Offsite
4. Rationale: Protects data loss in case of local failures.

Copy the latest local backup to offsite backup storage.

This is done via syncthing with a server in California.

## 3.2 Full Backup

1. Frequency: Weekly
2. Data covered: All applications and data
3. Locations: Local
4. Rationale: Fast, uses minimal storage space because of hard linking.

Perform a backup with `backupRaid.sh` to a local HDD.

# 4. Retention Policy

## 4.1 Offsite Backup

Offsite backup is overwritten with the latest information. Not ideal, but I don't have a machine to manage at the offsite.

## 4.2 Full Backup

Retain backups for a year.

This should be enough time to discover issues or realize it's not worth keeping what was deleted.

# 5. Automation

## 5.1 Cron Job

An [anacron](https://en.wikipedia.org/wiki/Anacron) job is set up to automate performing the Full Backup in case the machine hosting the backup HDD is not online during the regular scheduled time.

# 6. References

1. https://tecadmin.net/backup-linux-system/
2. https://tldp.org/LDP/lame/LAME/linux-admin-made-easy/server-backup.html
