2.1.新建用户
CREATE USER infodba SUPERUSER PASSWORD 'infodba';
CREATE USER replica PASSWORD '123456' REPLICATION;
CREATE USER pgrewind SUPERUSER PASSWORD '123456';
create user TcClusterDB password 'tcclusterdb';

2.2新建表空间
-- infodba_idata   /data01/pgsql/tc/infodba_idata
-- infodba_ilog    /data01/pgsql/tc/infodba_ilog
-- infodba_indx   /data01/pgsql/tc/infodba_index
  --tcclusterdb_idata  /data01/pgsql/tc/tcclusterdb_idata
  mkdir -p /data01/pgsql/tc/infodba_idata
  mkdir -p /data01/pgsql/tc/infodba_ilog
  mkdir -p /data01/pgsql/tc/infodba_index
  mkdir -p /data01/pgsql/tc/tcclusterdb_idata
  

CREATE TABLESPACE infodba_idata LOCATION '/data01/pgsql/tc/infodba_idata';
CREATE TABLESPACE infodba_ilog LOCATION '/data01/pgsql/tc/infodba_ilog';
CREATE TABLESPACE infodba_indx LOCATION '/data01/pgsql/tc/infodba_index';
CREATE TABLESPACE tcclusterdb_idata LOCATION '/data01/pgsql/tc/tcclusterdb_idata';

2.3新建库
CREATE DATABASE tc WITH  owner infodba  encoding 'UTF8' template template0 LC_COLLATE='C'  tablespace infodba_idata ;
create database TcClusterDB with owner TcClusterDB encoding 'UTF8' template template0 lc_collate 'C' tablespace TcClusterDB_idata;
grant all privileges on database TcClusterDB to TcClusterDB;
grant CREATE ON TABLESPACE TcClusterDB_idata to TcClusterDB;
grant all privileges on database tc to infodba;
grant CREATE ON TABLESPACE infodba_idata to infodba;
