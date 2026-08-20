#!/bin/bash

source /env/gitlab_env

# sync
for backup in ${gitlab_backup_dir}/*; do
    hasDump=0
    for dump in ${gitlab_backup_dump_dir}/*; do
        

        echo "----------------------------------"
        echo -e "compare file:\n  ${backup}\n  ${dump}"
        
        if [ "$(basename ${backup})" == "$(basename ${dump})" ]; then
            #echo "file exists and same, md5sum check..."
            #backup_md5sum=$(md5sum ${backup} | awk '{print $1}')
            #dump_md5sum=$(md5sum ${dump} | awk '{print $1}')
            #echo "md5sum ${backup}: $backup_md5sum"
            #echo "md5sum ${dump}: $dump_md5sum"
            #if [ "$backup_md5sum" == "$dump_md5sum" ]; then
            echo "file exists and same, check file size..."
            backup_size=$(stat -c %s ${backup})
            dump_size=$(stat -c %s ${dump})
            echo "file ${backup} size : $backup_size"
            echo "file ${dump} size : $dump_size"
            if [ "$backup_size" == "$dump_size" ]; then
                echo "skip ${backup}"
                hasDump=1
                break
            fi
            echo "file exists and different, rm ${dump}"
            rm -v ${dump}
        fi
    done

    if [ ${hasDump} -eq 0 ]; then
        echo ""

        #cp -v -p ${backup} ${gitlab_backup_dump_dir}/

        # 单个tar文件复制，显示进度，断点续传
        rsync -ahW --progress --partial ${backup} ${gitlab_backup_dump_dir}/

    fi
done