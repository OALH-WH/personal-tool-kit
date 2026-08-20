#!/bin/bash

source /env/gitlab_env


for dir in $gitlab_backup_dir  $gitlab_backup_dump_dir; do
    echo "----------------------------------"
    echo "current dir is $dir"
    echo "check file create time:"
    for file in $(find $dir -type f -mtime +3); do
        echo "  rm $file"
        rm -f $file
    done
done
