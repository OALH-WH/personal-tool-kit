#!/bin/bash

gitlab_backup_dir=/var/opt/gitlab/backups
gitlab_backup_dump_dir=/mnt/gitlab/backups
gitlab_config_dir=/etc/gitlab

gitlab_rb=gitlab.rb
gitlab_secrets=gitlab-secrets.json

gitlab-backup create

gitlab_backup_prefix=""
suffix_pattern="_gitlab_backup.tar"
get_gitlab_backup_prefix() {
    gitlab_backup_prefix=$(echo $1 | awk -F${suffix_pattern} '{print $1}')
}


# sync
for backup in ${gitlab_backup_dir}/*; do
    hasDump=0
    for dump in ${gitlab_backup_dump_dir}/*; do
        if [ "$(basename ${backup})" == "$(basename ${dump})" ]; then
            echo "skip ${backup}"
            hasDump=1
            break
        fi
    done

    if [ ${hasDump} -eq 0 ]; then
        echo " ${backup} copy to ${gitlab_backup_dump_dir}"
        
        gitlab_backup_prefix=""
        get_gitlab_backup_prefix $(basename ${backup})

        cp -v ${backup} ${gitlab_backup_dump_dir}/
        if [ $? == 0 -a ! -z "${gitlab_backup_prefix}" ]; then
            cp -v ${gitlab_config_dir}/${gitlab_rb} ${gitlab_backup_dump_dir}/${gitlab_backup_prefix}_${gitlab_rb}
            cp -v ${gitlab_config_dir}/${gitlab_secrets} ${gitlab_backup_dump_dir}/${gitlab_backup_prefix}_${gitlab_secrets}
        fi
        
        echo "-----------------------------------------------------"
        echo "backup: ${backup}"
        echo "config rb: ${gitlab_config_dir}/${gitlab_rb} copy to \
        ${gitlab_backup_dump_dir}/${gitlab_backup_prefix}_${gitlab_rb}"
        echo "config secrets: ${gitlab_config_dir}/${gitlab_secrets} copy to \
        ${gitlab_backup_dump_dir}/${gitlab_backup_prefix}_${gitlab_secrets}"
    fi
done
