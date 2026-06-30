#!/bin/bash

source /env/gitlab_env


for dir in $gitlab_backup_dir  $gitlab_backup_dump_dir; do
    for file in $(find $dir -type f -mtime +7); do
        rm -f file
    done
done
