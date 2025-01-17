#!/bin/bash

PGDATA='/data01/pgsql'

# echo "修改selinux"
# sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
# setenforce 0

# echo "关闭服务器防火墙"
# systemctl stop firewalld.service
# systemctl disable firewalld.service

# echo "yum 安装依赖包"
# 提前下载安装包
mkdir -p /root/rpm
yum install -y yum-utils
yum install --downloadonly --downloaddir=/root/rpm iproute bind iptables which sudo sysstat ftp make cmake gcc uuid uuid-devel bison flex perl perl-devel python-devel readline readline-devel libxml2 libxml2-devel iotop tcpdump strace gdb systemtap net-tools xdpyinfo libstdc++-devel gcc-c++ ksh libaio libaio-devel libX11 libXau libXi libXtst libXrender libXrender-devel libgcc libstdc++ libstdc++-devel libxcb make smartmontools zlib-devel tcl glibc glibc-devel openssl openssl-devel bc binutils nfs-utils perl-ExtUtils-Embed zstd zstd-devel libcurl libcurl-devel lz4 lz4-devel libicu libicu-devel autoconf
rpm -Uvh /root/rpm/*.rpm

# 直接下载安装（需要挂载安装盘）
# yum install -y iproute bind iptables which sudo sysstat ftp make cmake gcc uuid uuid-devel bison flex perl perl-devel python-devel readline readline-devel libxml2 libxml2-devel iotop tcpdump strace gdb systemtap net-tools xdpyinfo libstdc++-devel gcc-c++ ksh libaio libaio-devel libX11 libXau libXi libXtst libXrender libXrender-devel libgcc libstdc++ libstdc++-devel libxcb make smartmontools zlib-devel tcl glibc glibc-devel openssl openssl-devel bc binutils nfs-utils perl-ExtUtils-Embed zstd zstd-devel libcurl libcurl-devel lz4 lz4-devel libicu libicu-devel autoconf

echo '创建用户和组'
groupadd -g 1000 postgres
useradd -u 1000 -g postgres postgres

# SUSE12下创建用户目录并授权
# mkdir -p /home/postgres
# chown -R postgres:postgres /home/postgres


echo '创建目录'
# 解压目录
mkdir -p /data01/app/install
mkdir -P /data01/app/postgresql
# 数据库目录
mkdir -p $PGDATA


echo '解压软件'
# 需要先上传到root
tar -zxvf postgresql-14.8.tar.gz -C /data01/app/install


echo "修改服务器内存和信号量"
echo "kernel.sem = 4096 4194304 32768 1024" >> /etc/sysctl.conf
sysctl -p


echo "修改服务器资源限制"
echo "postgres            soft    nproc           unlimited" >> /etc/security/limits.conf
echo "postgres            hard    nproc           unlimited" >> /etc/security/limits.conf
echo "postgres            soft    nofile          1024000" >> /etc/security/limits.conf
echo "postgres            hard    nofile          1024000" >> /etc/security/limits.conf
echo "postgres            soft    stack           unlimited" >> /etc/security/limits.conf
echo "postgres            hard    stack           unlimited" >> /etc/security/limits.conf
echo "postgres            soft    memlock         unlimited" >> /etc/security/limits.conf
echo "postgres            hard    memlock         unlimited" >> /etc/security/limits.conf
echo "postgres            soft    core            unlimited" >> /etc/security/limits.conf
echo "postgres            hard    core            unlimited" >> /etc/security/limits.conf


echo "编译包"
cd  /data01/app/install/postgresql-14.8

./configure --prefix=/data01/app/postgresql 

make && make install


echo "添加配置文件"
su - postgres -c "echo 'export PG_HOME=/data01/app/postgresql' >> /home/postgres/.bash_profile"
su - postgres -c "echo 'export LD_LIBRARY_PATH=\$PG_HOME/lib' >> /home/postgres/.bash_profile"
su - postgres -c "echo 'export PGDATA=$PGDATA' >> /home/postgres/.bash_profile"
su - postgres -c "echo 'export PATH=\$PG_HOME/bin:\$PATH' >> /home/postgres/.bash_profile"
su - postgres -c "echo 'PATH=\$PATH:\$PG_HOME/.local/bin:\$PG_HOME/bin' >> /home/postgres/.bash_profile"
su - postgres -c "echo 'export PATH' >> /home/postgres/.bash_profile"

su - postgres -c "source /home/postgres/.bash_profile"

echo "初始化数据库"

chown -R postgres:postgres /data01/app/install
chown -R postgres:postgres /data01/app/postgresql
chown -R postgres:postgres $PGDATA

su - postgres -c "/data01/app/postgresql/bin/initdb -D $PGDATA -E UTF8"

echo "创建归档日志目录"
su - postgres -c "mkdir -p $PGDATA/archivedir"

echo "修改pg_hba.conf"
su - postgres -c "echo 'host    all             all             0/0                 md5' >> $PGDATA/pg_hba.conf"
su - postgres -c "echo 'host    replication     replica         0/0                 md5' >> $PGDATA/pg_hba.conf"

echo "配置 postgresql.conf"
if [ $(lscpu |grep '^CPU(s): ' | awk -F " " '{print $1}') == 'CPU(s):' ]
then
   CPU=$(lscpu |grep '^CPU(s): ' | awk -F " " '{print $2}')
elif [ $(lscpu |grep '^CPU: ' | awk -F " " '{print $1}') == 'CPU:' ]
then
   CPU=$(lscpu |grep '^CPU: ' | awk -F " " '{print $2}')
else
   echo "没有符合的条件"
fi

MEM_S=$(free -m|grep '^Mem:' | awk -F " " '{print expr $2/1024*0.4}' | cut -d '.' -f1)GB
MEM_E=$(free -m|grep '^Mem:' | awk -F " " '{print $2/1024*0.5}' | cut -d '.' -f1)GB

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" $PGDATA/postgresql.conf
sed -i "s/#port = 5432/port = 5432/" $PGDATA/postgresql.conf
sed -i "s/max_connections = 100/max_connections = 3000/" $PGDATA/postgresql.conf
# 开启大页，这个项也要开启
# sed -i "s/#huge_pages = try/huge_pages = on/" $PGDATA/postgresql.conf     
sed -i "s/shared_buffers = 128MB/shared_buffers = $MEM_S/" $PGDATA/postgresql.conf
sed -i "s/#work_mem = 4MB/work_mem = 16MB/" $PGDATA/postgresql.conf
sed -i "s/#wal_buffers = -1/wal_buffers = 16MB/" $PGDATA/postgresql.conf
sed -i "s/#checkpoint_completion_target = 0.9/checkpoint_completion_target = 0.9/" $PGDATA/postgresql.conf
sed -i "s/max_wal_size = 1GB/max_wal_size = 8GB/" $PGDATA/postgresql.conf
sed -i "s/min_wal_size = 80MB/min_wal_size = 2GB/" $PGDATA/postgresql.conf
sed -i "s/#archive_mode = off/archive_mode = on/" $PGDATA/postgresql.conf
sed -i "s/#archive_command = ''/archive_command = 'test ! -f \/data01\/pgsql\/archivedir\/%f \&\& cp %p \/data01\/pgsql\/archivedir\/%f'/" $PGDATA/postgresql.conf
sed -i "s/#default_statistics_target = 100/default_statistics_target = 100/" $PGDATA/postgresql.conf
sed -i "s/#log_destination = 'stderr'/log_destination = 'csvlog'/" $PGDATA/postgresql.conf
sed -i "s/#logging_collector = off/logging_collector = on/" $PGDATA/postgresql.conf
sed -i "s/#effective_cache_size = 4GB/effective_cache_size = $MEM_E/" $PGDATA/postgresql.conf
sed -i "s/#random_page_cost = 4.0/random_page_cost = 1.1/" $PGDATA/postgresql.conf
sed -i "s/#maintenance_io_concurrency = 10/maintenance_io_concurrency = 200/" $PGDATA/postgresql.conf
sed -i "s/#max_worker_processes = 8/max_worker_processes = $CPU/" $PGDATA/postgresql.conf
sed -i "s/#max_parallel_workers_per_gather = 2/max_parallel_workers_per_gather = 4/" $PGDATA/postgresql.conf
sed -i "s/#max_parallel_maintenance_workers = 2/max_parallel_maintenance_workers = 4/" $PGDATA/postgresql.conf
sed -i "s/#max_parallel_workers = 8/max_parallel_workers = $CPU/" $PGDATA/postgresql.conf
sed -i "s/#wal_log_hints = off/wal_log_hints = on/" $PGDATA/postgresql.conf
sed -i "s/#restore_command = ''/restore_command = 'cp \/data01\/pgsql\/archivedir\/%f %p'/" $PGDATA/postgresql.conf


echo '启动数据库'
su - postgres -c "/data01/app/postgresql/bin/pg_ctl start -D $PGDATA"

echo '连接数据库--建库建用户'
su - postgres -c "psql -c \"CREATE DATABASE bopdrill WITH LC_COLLATE='C' TEMPLATE=template0;\"
"

su - postgres -c "psql -c \"
CREATE USER dbadmin SUPERUSER PASSWORD 'Siemens@Tcm@2023';
CREATE USER infodba SUPERUSER PASSWORD 'Siemens@Tcm123';
CREATE USER replica PASSWORD '123456' REPLICATION;
CREATE USER pgrewind SUPERUSER PASSWORD '123456';
\" "

su - postgres -c "psql -d bopdrill  -c \"CREATE SCHEMA infodba;\" "
