#!/bin/bash

source /env/gitlab_env


gitlab_version=$(cat /opt/gitlab/embedded/service/gitlab-rails/VERSION)
gitlab_backup_prefix=$(date +%s_%Y_%m_%d)_${gitlab_version}
gitlab_backup_file=${gitlab_backup_prefix}_${suffix_pattern}

gitlab-backup create BACKUP=${gitlab_backup_prefix} && \
cp -v ${gitlab_config_dir}/${gitlab_rb} ${gitlab_backup_dir}/${gitlab_backup_prefix}_${gitlab_rb} && \
cp -v ${gitlab_config_dir}/${gitlab_secrets} ${gitlab_backup_dir}/${gitlab_backup_prefix}_${gitlab_secrets}



