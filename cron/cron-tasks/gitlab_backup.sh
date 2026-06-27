#!/bin/bash

gitlab_backup_dir=/var/opt/gitlab/backups
gitlab_backup_dump_dir=/mnt/gitlab/backups

gitlab_rb=gitlab.rb
gitlab_secrets=gitlab-secrets.json

gitlab-backup create

# sync
for fd in ${gitlab_rb} ${gitlab_secrets}; do

    if [ ! -f "${gitlab_backup_dir}/${fd}" ]; then
        echo "file not found: ${gitlab_backup_dir}/${fd}"
        continue
    fi

    back_md5sum=$(md5sum ${gitlab_backup_dir}/${fd} | awk '{print $1}')
    dump_md5sum=$(md5sum ${gitlab_backup_dump_dir}/${fd} | awk '{print $1}')

    if [ "${back_md5sum}" != "${dump_md5sum}" ]; then
        echo " ${gitlab_backup_dir}/${fd} copy to ${gitlab_backup_dump_dir}/${fd}"
        cp ${gitlab_backup_dir}/${fd} ${gitlab_backup_dump_dir}/
    fi

    echo " ${gitlab_backup_dir}/${fd} md5sum: ${back_md5sum}"
    echo " ${gitlab_backup_dump_dir}/${fd} md5sum: ${dump_md5sum}"

done


for backup in ${gitlab_backup_dir}/*; do
    hasDump=0
    for dump in ${gitlab_backup_dump_dir}/*; do
        if [ "${backup}" == "${dump}" ]; then
            echo "skip ${backup}"
            hasDump=1
            break
        fi
    done

    if [ ${hasDump} -eq 0 ]; then
        echo " ${backup} copy to ${gitlab_backup_dump_dir}"
        cp ${backup} ${gitlab_backup_dump_dir}/
    fi

    echo "backup: ${backup}"
done




