#!/bin/bash

source /env/gitlab_env

# sync
for backup in ${gitlab_backup_dir}/*; do
    hasDump=0
    for dump in ${gitlab_backup_dump_dir}/*; do
        if [ "$(basename ${backup})" == "$(basename ${dump})" -a "$(md5sum ${backup})" == "$(md5sum ${dump})" ]; then
            echo "skip ${backup}"
            hasDump=1
            break
        fi
    done

    if [ ${hasDump} -eq 0 ]; then
        cp -v ${backup} ${gitlab_backup_dump_dir}/
    fi
done