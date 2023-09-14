query	total_exec_time
SELECT pom_class.pname classname, count(*) num FROM PPOM_CLASS pom_class, PPOM_OBJECT pom_object, SCRATCH_TABLE scratch                                              WHERE pom_class.pcpid=pom_object.ppid and pom_object.puid=scratch.puid GROUP BY pom_class.pname ORDER BY num DESC	16064578.1
SELECT trigger_condition, count(*) num FROM SCRATCH_TABLE GROUP BY trigger_condition	1696270.28
SELECT  DISTINCT t_03.puid FROM PWORKSPACEOBJECT t_01 , PSTRUCTURE_REVISIONS t_02 , PMEPRODUCTBOPREVISION t_03 , PPSBOMVIEWREVISION t_04 , PPSOCCURRENCE t_05 , PITEM t_06 , PMEOP t_07 , PMEPROCESSREVISION t_08 , PSTRUCTURE_REVISIONS t_09 , PITEMREVISION t_010 , PMEPROCESS t_011 , PPSOCCURRENCE t_012 , PPSBOMVIEWREVISION t_013 WHERE ( ( ( ( t_02.pvalu_0 = t_013.puid ) AND ( ( t_013.puid = t_012.rparent_bvru ) AND ( ( t_012.rchild_itemu = t_011.puid ) AND ( ( t_011.puid = t_010.ritems_tagu ) AND ( ( t_09.pvalu_0 = t_04.puid ) AND ( ( t_04.puid = t_05.rparent_bvru ) AND ( ( t_05.rchild_itemu = t_07.puid ) AND  ( UPPER(t_06.pitem_id)  =  UPPER( $1  )  ) ) ) ) ) ) ) ) AND ( t_01.pactive_seq != $2::int4  ) ) AND ( t_08.puid = t_09.puid AND t_09.puid = t_010.puid AND t_06.puid = t_07.puid AND t_01.puid = t_02.puid AND t_02.puid = t_03.puid ) )	1113271.476
SELECT  DISTINCT t_01.aoid AS puid  FROM PWORKSPACEOBJECT t_01 , PPOM_APPLICATION_OBJECT t_02 , VL10N_OBJECT_NAME t_03 WHERE ( ( (  ( UPPER(t_03.pval_0)  =  UPPER( $1  )  ) AND ( t_03.locale IN  ($2 , $3  ) AND ( ( t_01.puid = t_03.puid ) AND t_03.status IN  ($4 , $5  ) ) ) ) AND (  ( UPPER(t_01.pobject_type)  =  UPPER( $6  )  ) AND t_02.rowning_useru = $7  ) ) AND ( t_01.puid = t_02.puid ) ) AND (t_01.arev_category IN ($8,$9)) AND t_02.arev_category IN ($10,$11)	944031.7929
SELECT  DISTINCT t_01.aoid AS puid  FROM PDATASET t_01 , VL10N_OBJECT_NAME t_02 WHERE (  ( UPPER(t_02.pval_0)  =  UPPER( $1  )  ) AND ( t_02.locale IN  ($2 , $3  ) AND ( ( t_01.puid = t_02.puid ) AND t_02.status IN  ($4 , $5  ) ) ) ) AND (t_01.arev_category IN ($6,$7))	883599.6801
DELETE FROM SCRATCH_TABLE WHERE (lsd IS NULL) OR (lsd < (SELECT MIN(lpd) FROM SUBSCRIPTION_TABLE))	555469.9851
SELECT  DISTINCT t_01.puid FROM PMECOLLABORATIONCONTEXT t_01 , VL10N_OBJECT_NAME t_02 WHERE (  ( UPPER(t_02.pval_0)  =  UPPER( $1  )  ) AND ( t_02.locale IN  ($2 , $3  ) AND ( ( t_01.puid = t_02.puid ) AND t_02.status IN  ($4 , $5  ) ) ) )	311764.8651
SELECT $1 AS TABLE_CAT, n.nspname AS TABLE_SCHEM,   ct.relname AS TABLE_NAME, a.attname AS COLUMN_NAME,   (i.keys).n AS KEY_SEQ, ci.relname AS PK_NAME FROM pg_catalog.pg_class ct   JOIN pg_catalog.pg_attribute a ON (ct.oid = a.attrelid)   JOIN pg_catalog.pg_namespace n ON (ct.relnamespace = n.oid)   JOIN (SELECT i.indexrelid, i.indrelid, i.indisprimary,              information_schema._pg_expandarray(i.indkey) AS keys         FROM pg_catalog.pg_index i) i     ON (a.attnum = (i.keys).x AND a.attrelid = i.indrelid)   JOIN pg_catalog.pg_class ci ON (ci.oid = i.indexrelid) WHERE $2  AND ct.relname = $3 AND i.indisprimary  ORDER BY table_name, pk_name, key_seq	308765.1488
WITH reladd2 AS (                 SELECT  /*+  LEADING(subscr, scratch) */ rel.rprimary_objectu primaryuid, rel.rsecondary_objectu secondaryuid, scratch.lsd lsd                 FROM SUBSCRIPTION_TABLE subscr, SCRATCH_TABLE scratch, PIMANRELATION rel                 WHERE subscr.app_id = $1 AND scratch.lsd > subscr.lpd                 AND scratch.trigger_condition = $2 AND scratch.puid = rel.puid )             SELECT /*+ DYNAMIC_SAMPLING(acct 4) */ acct.island_anchor_uid islanduid             FROM reladd2, ACCT_TABLE acct              WHERE acct.exp_obj_uid = reladd2.primaryuid AND acct.app_id = $3 AND acct.state = $4 AND reladd2.lsd > acct.led             UNION ALL             SELECT /*+ DYNAMIC_SAMPLING(acct 4) */ acct.island_anchor_uid islanduid             FROM reladd2, ACCT_TABLE acct              WHERE acct.exp_obj_uid = reladd2.secondaryuid AND acct.app_id = $5 AND acct.state = $6 AND reladd2.lsd > acct.led	278118.8564
SELECT  DISTINCT t_01.island_anchor_uid FROM ACCT_TABLE t_01 WHERE ( ( t_01.app_id = $1  ) AND t_01.state = $2::int4  )	261430.1262

SELECT  DISTINCT t_01.puid FROM PMECOLLABORATIONCONTEXT t_01 , VL10N_OBJECT_NAME t_02 WHERE (  ( UPPER(t_02.pval_0)  =  UPPER( '0302042595产品工艺数据包' )  ) AND ( t_02.locale IN  ('NONE', 'zh_CN' ) AND ( ( t_01.puid = t_02.puid ) AND t_02.status IN  ('A', 'M' ) ) ) ) ;


SELECT  DISTINCT t_01.puid FROM PMECOLLABORATIONCONTEXT t_01 , VL10N_OBJECT_NAME t_02 WHERE (  ( UPPER(t_02.pval_0)  =  UPPER( '0302042595产品工艺数据包' )  ) AND ( t_02.locale IN  ('NONE', 'zh_CN' ) AND ( ( t_01.puid = t_02.puid ) AND t_02.status IN  ('A', 'M' ) ) ) ) ;
WITH CTE_1 AS (SELECT t_03.puid, t_03.rparent_bvru FROM PPSALTERNATELIST t_01 , PALT_ITEMS t_02 , PPSOCCURRENCE t_03 WHERE ( ( t_02.pvalu_0 IN  ('H5GAAA_b47UIUC', 'H9IAAA_b47UIUC' ) AND ( t_01.puid = t_03.ralternate_etc_refu ) ) AND ( t_01.puid = t_02.puid ) ) UNION SELECT t_04.puid, t_04.rparent_bvru FROM PPSOCCURRENCE t_04 WHERE t_04.rchild_itemu IN  ('H5GAAA_b47UIUC', 'H9IAAA_b47UIUC' ) )  SELECT t_07.puid FROM CTE_1 t_05 , PSTRUCTURE_REVISIONS t_06 , PITEMREVISION t_07 WHERE ( ( ( t_05.rparent_bvru = t_06.pvalu_0 ) AND ( t_07.puid = t_06.puid ) ) AND ( t_06.puid = t_07.puid ) ) UNION  ( SELECT t_010.puid FROM CTE_1 t_08 , PSTRUCTURE_REVISIONS t_09 , PITEMREVISION t_010 , PWORKSPACEOBJECT t_011 , PFND0ABSTRACTOCCREVISION t_012 , PFND0RELEVANTBVR t_013 WHERE ( ( ( ( ( t_08.rparent_bvru = t_012.puid ) AND ( t_011.rwso_threadu = t_013.rfnd0Occurrenceu ) ) AND ( t_013.rfnd0Bvru = t_09.pvalu_0 ) ) AND ( t_010.puid = t_09.puid ) ) AND ( t_011.puid = t_012.puid AND t_09.puid = t_010.puid ) ) UNION SELECT t_020.puid FROM CTE_1 t_014 , PWORKSPACEOBJECT t_015 , PFND0ABSTRACTOCCREVISION t_016 , PFND0ABSTRACTOCC t_017 , PPSBOMVIEWREVISION t_018 , PSTRUCTURE_REVISIONS t_019 , PITEMREVISION t_020 , PPSBOMVIEW t_021 WHERE ( ( ( ( ( ( ( ( t_014.rparent_bvru = t_016.puid ) AND ( t_015.rwso_threadu = t_017.puid ) ) AND ( t_017.rfnd0BOMViewu = t_018.rbom_viewu ) ) AND ( t_018.puid = t_019.pvalu_0 ) ) AND ( t_019.puid = t_020.puid ) ) AND ( t_018.rbom_viewu = t_021.puid ) ) AND ( t_021.pfnd0StructManagementMode = 1 ) ) AND ( t_015.puid = t_016.puid AND t_019.puid = t_020.puid ) ) )  ;
SELECT  DISTINCT t_01.puid FROM PMECOLLABORATIONCONTEXT t_01 , VL10N_OBJECT_NAME t_02 WHERE (  ( UPPER(t_02.pval_0)  =  UPPER( '0302042595图纸版本A产品工艺数据包' )  ) AND ( t_02.locale IN  ('NONE', 'zh_CN' ) AND ( ( t_01.puid = t_02.puid ) AND t_02.status IN  ('A', 'M' ) ) ) ) ;

SELECT /*+DYNAMIC_SAMPLING( tt 4)*/  DISTINCT po.puid, po.ppid, ps.ascope_uid FROM PPOM_OBJECT po LEFT OUTER JOIN POM_SCOPE ps ON po.aoid = ps.aoid , POM_uid_scratch2 tt WHERE po.puid = tt.auid;

create global temporary table POM_UID_SCRATCH2
(
  auid VARCHAR2(15)
)
on commit delete rows;

==================================================================

tc=# create  table POM_UID_SCRATCH2
(
  auid VARCHAR(15)
)
on commit delete rows;
ERROR:  ON COMMIT can only be used on temporary table

------------------------------------------------------------
tc=# create  temporary table public.POM_UID_SCRATCH2
(
  auid VARCHAR(15)
)
on commit delete rows;
ERROR:  cannot create temporary relation in non-temporary schema
LINE 1: create  temporary table public.POM_UID_SCRATCH2
                                ^
tc=# create   table POM_UID_SCRATCH2
(
  auid VARCHAR(15)
)
on commit delete rows;
ERROR:  ON COMMIT can only be used on temporary tables
----------------------------------------------------------
tc=# create   table POM_UID_SCRATCH2
(
  auid VARCHAR(15)
)
;
CREATE TABLE
