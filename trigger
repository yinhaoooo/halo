CREATE 
	OR REPLACE FUNCTION "public"."fast_sync_add_trigger_func" ( ) RETURNS "pg_catalog"."trigger" AS $BODY$ DECLARE
	gmtDate TIMESTAMP;
BEGIN
	SELECT
		timezone ( 'UTC', now( ) ) INTO gmtDate;
	INSERT INTO scratch_table
	VALUES
		( COALESCE ( NEW.aoid, NEW.puid ), gmtDate, '8' );
	RETURN NEW;

END; $BODY$ LANGUAGE plpgsql VOLATILE COST 100

CREATE OR REPLACE FUNCTION "public"."fast_sync_delete_trigger_func"()
  RETURNS "pg_catalog"."trigger" AS $BODY$ DECLARE gmtDate TIMESTAMP; BEGIN SELECT timezone('UTC', now()) INTO gmtDate; INSERT INTO scratch_table VALUES (COALESCE( OLD.aoid, OLD.puid ), gmtDate, '9'); RETURN NULL; END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100

CREATE OR REPLACE FUNCTION "public"."lock_keys_delete_trigger_func"()
  RETURNS "pg_catalog"."trigger" AS $BODY$                                   BEGIN                                    DELETE FROM POM_LOCK_KEYS WHERE puid = OLD.puid AND NOT EXISTS ( SELECT 1 FROM PPOM_STUB ps WHERE ps.pobject_uid = POM_LOCK_KEYS.puid);                                   RETURN NULL;                                   END;                                   $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100

SELECT tgname, tgrelid::regclass AS tablename, tgtype, pg_get_triggerdef(oid) AS definition
FROM pg_trigger


CREATE OR REPLACE FUNCTION "public"."lock_keys_insert_trigger_func"()
  RETURNS "pg_catalog"."trigger" AS $BODY$                                   BEGIN                                    INSERT INTO POM_LOCK_KEYS( puid ) VALUES(NEW.puid) ON CONFLICT (puid) DO UPDATE SET puid = EXCLUDED.puid;                                   RETURN NEW;                                   END;                                   $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100


CREATE OR REPLACE FUNCTION "public"."object_uid_insert_trigger_func"()
  RETURNS "pg_catalog"."trigger" AS $BODY$                                   BEGIN                                     INSERT INTO POM_LOCK_KEYS( puid ) VALUES(NEW.pobject_uid) ON CONFLICT (puid) DO UPDATE SET puid = EXCLUDED.puid;                                   RETURN NEW;                                   END;                                   $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100

CREATE OR REPLACE FUNCTION "public"."ppom_object_vlock_delete"()
  RETURNS "pg_catalog"."trigger" AS $BODY$ 
BEGIN 
   DELETE FROM POM_LOCK_KEYS WHERE puid = OLD.aoid AND NOT EXISTS ( SELECT 1 FROM PPOM_STUB ps WHERE ps.pobject_uid = POM_LOCK_KEYS.puid) AND NOT EXISTS ( SELECT COUNT(pt.aoid),pt.aoid FROM PPOM_OBJECT pt WHERE pt.aoid = POM_LOCK_KEYS.puid GROUP BY pt.aoid HAVING COUNT(pt.aoid) >1);  
RETURN NULL; 
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
