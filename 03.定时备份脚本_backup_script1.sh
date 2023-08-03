#!/bin/bash

ARCHIVEDIR='归档地址'
BACKUP_PATH='备份地址'
IP_ADDR='备库地址'

echo "清除前一天归档日志"
echo 'del starting'
find $ARCHIVEDIR -type f -mtime +1 - name '000*'|xargs -i rm -rf {} >> $BACKUP_PATH/dellog.log
echo 'del stoping' 

echo "创建当天备份文件夹"
mkdir -p $BACKUP_PATH/`date +%F` 
export PGPASSWORD=123456

echo `date` > buckuptime.log
pg_basebackup -F t -X fetch -v -P -h 127.0.0.1 -p 5432 -U replica -D $BACKUP_PATH/`date +%F` | pigz -p 8 > `date +%F`.tar.gz
echo `date` > buckuptime.log

rm -rf $BACKUP_PATH/`date +%F`
================================================
[postgres@kwebtmpmgp00002 backup]$ tar -c -I 'zstd -T8' -f 202308.02.tar.zst 2023-08-03
tar (child): zstd -T8: Cannot exec: No such file or directory
tar (child): Error is not recoverable: exiting now
[postgres@kwebtmpmgp00002 backup]$ zstd --version
*** zstd command line interface 64-bits v1.5.0, by Yann Collet ***
[postgres@kwebtmpmgp00002 backup]$
