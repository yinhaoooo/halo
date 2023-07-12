第七步:
7.比较oracle数据库和postgresql表数据量的比较
1）在oracle数据库中执行：
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare num number;
begin
    select count(1) into num from user_tables where table_name = 'TMP_GET_ACTURAL_TABLE_COUNT';
    if num > 0 then
        execute immediate 'drop table TMP_GET_ACTURAL_TABLE_COUNT';
    end if;
end;
/

create table TMP_GET_ACTURAL_TABLE_COUNT(table_name varchar(50),table_cnt int);
/

CREATE OR REPLACE PROCEDURE "GET_ACTURAL_TABLE_COUNT"(isrun integer) AUTHID CURRENT_USER IS 
  sqlstr varchar2(4000);
begin
    for cursor_sql in(
      select 'insert into TMP_GET_ACTURAL_TABLE_COUNT(table_name,table_cnt) select '''||table_name||''' as table_name,count(1) as table_cnt from '||table_name as sqlstr1 from user_tables where temporary = 'N' and table_name not like 'SREF_CON_%'
     ) loop
          execute immediate (cursor_sql.sqlstr1);
   commit;
    end loop;
end;
/

truncate table TMP_GET_ACTURAL_TABLE_COUNT;
/

call GET_ACTURAL_TABLE_COUNT(1);
/

commit;
/

select * from TMP_GET_ACTURAL_TABLE_COUNT order by upper(table_name);
/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

2）在postgresql数据库中执行。
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create table TMP_GET_ACTURAL_TABLE_COUNT(table_name varchar(50),table_cnt int);

CREATE OR REPLACE PROCEDURE GET_ACTURAL_TABLE_COUNT(isrun integer) 
IS $$ 
  sqlstr varchar(4000);
  cursor_sql record;
begin
    for cursor_sql in(
      select 'insert into TMP_GET_ACTURAL_TABLE_COUNT(table_name,table_cnt) select '''||tablename||''' as table_name,count(1) as table_cnt from public.'||tablename as sqlstr1 from pg_tables where schemaname='public' and tablename not like 'sref_con_%'
     ) loop
          execute cursor_sql.sqlstr1;
   commit;
    end loop;
end;
$$;

truncate table TMP_GET_ACTURAL_TABLE_COUNT;
/

call GET_ACTURAL_TABLE_COUNT(1);
/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
在postgresql创建外部表指向oracle数据库的TMP_GET_ACTURAL_TABLE_COUNT，并在postgresql库中比较相同表名的数据量的差异。



第十九步
19.比较对象
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select 'views' as object_name,count(*) as cnt From pg_views where schemaname = 'public'
union all
select 'tables' as object_name,count(*) as cnt From pg_tables where schemaname = 'public'
union all
select 'functions' as object_name,count(*) as cnt from pg_proc c join pg_namespace p on p.oid = c.pronamespace where p.nspname = 'public' 
union all
select 'sequences' as object_name,count(*) as cnt from pg_class where relkind ='S'
union all
select 'triggers' as object_name,count(*) as cnt from pg_trigger where tgname not like 'RI_ConstraintTrigger%';

-- table
\copy (select tablename from pg_tables where tableowner='ecology_target' order by tablename) to '/home/halo/tables_sc.sql';
-- view
\copy (select viewname from pg_views where viewowner='ecology_target' order by viewname) to '/home/halo/views_sc.sql';
-- functions
\copy (select c.proname from pg_proc c join pg_namespace p on p.oid = c.pronamespace where p.nspname = 'public' order by c.proname) to '/home/halo/functions_sc.sql';
-- sequences
\copy (select relname from pg_class where relkind ='S' order by relname) to '/home/halo/sequences_sc1.sql';
\copy (select c.relname from pg_class c join pg_namespace p on p.oid = c.relnamespace where p.nspname = 'public' and c.relkind ='S' order by c.relname) to '/home/halo/sequences_sc2.sql';
-- triggers
\copy (select tgname from pg_trigger a. where tgname not like 'RI_ConstraintTrigger%' order by tgname) to '/home/halo/tiggers_sc.sql';


select c.proname from pg_proc c join pg_namespace p on p.oid = c.pronamespace where p.nspname = 'lis' and c.proname like 'c%' order by c.proname;
select c.proname from pg_proc c join pg_namespace p on p.oid = c.pronamespace where p.nspname = 'lis' order by c.proname;
select count(c.proname) from pg_proc c join pg_namespace p on p.oid = c.pronamespace where p.nspname = 'lis' ;

select c.tgname, p.nspname from pg_trigger c join pg_namespace p on p.oid = c.oid where p.nspname = 'infodba' and c.tgname not like 'RI_ConstraintTrigger%' order by c.tgname;


