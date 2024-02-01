-- https://github.com/sid-indonesia/data-analytics/blob/main/materialized_views_manager/refresh_materialized_views-init.sql
-- DO NOT FORGET to execute the hyperlinked script above beforehand as an initialization (one-time execution)
DO
$$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_stat_activity
            WHERE pid <> pg_backend_pid()
            	AND query ILIKE '%refresh_all_materialized_views_in_correct_order%'
    ) THEN
        PERFORM "${schemaName}".refresh_all_materialized_views_in_correct_order();
    END IF;
END;
$$;
