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
