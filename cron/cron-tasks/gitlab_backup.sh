#!/bin/bash

gitlab_backup_dir=/var/opt/gitlab/backups
gitlab_backup_dump_dir=/mnt/gitlab/backups

gitlab-backup create

# sync
cp -r ${gitlab_backup_dir}/* ${gitlab_backup_dump_dir}



