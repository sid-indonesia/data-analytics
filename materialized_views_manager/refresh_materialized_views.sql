-- Copied from https://wiki.postgresql.org/wiki/Refresh_All_Materialized_Views
-- Notes:
-- Commented `owneroid`, `ownername` due to insufficient permissions to access table `pg_authid`
-- SQL Error [42501]: ERROR: permission denied for table pg_authid

-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = analytics

-- Refresh Materialized Views
CREATE OR REPLACE VIEW "${schemaName}".mat_view_dependencies AS
WITH RECURSIVE s(start_schemaname,start_relname,start_relkind,
		 schemaname,relname,relkind,reloid,
--		 owneroid,ownername,
		 depth)
		 AS (
-- List of tables and views that mat views depend on
SELECT n.nspname AS start_schemaname, c.relname AS start_relname,
c.relkind AS start_relkind,
n2.nspname AS schemaname, c2.relname, c2.relkind,
c2.oid AS reloid,
--au.oid AS owneroid,
--au.rolname AS ownername,
0 AS depth
FROM pg_class c JOIN pg_namespace n
     ON c.relnamespace=n.oid AND c.relkind IN ('r','m','v','t','f', 'p')
JOIN pg_depend d ON c.oid=d.refobjid
JOIN pg_rewrite r ON d.objid=r.oid
JOIN pg_class c2 ON r.ev_class=c2.oid -- AND c2.relkind='m'
JOIN pg_namespace n2 ON n2.oid=c2.relnamespace
--JOIN pg_authid au ON au.oid=c2.relowner

UNION

-- Recursively find all mat views depending on previous level
SELECT s.start_schemaname, s.start_relname, s.start_relkind,
n.nspname AS schemaname, c2.relname,
c2.relkind, c2.oid,
--au.oid AS owneroid, au.rolname AS ownername,
s.depth+1 AS depth
FROM s
JOIN pg_depend d ON s.reloid=d.refobjid
JOIN pg_rewrite r ON d.objid=r.oid
JOIN pg_class c2 ON r.ev_class=c2.oid AND (c2.relkind IN ('m','v'))
JOIN pg_namespace n ON n.oid=c2.relnamespace
--JOIN pg_authid au ON au.oid=c2.relowner

WHERE s.reloid <> c2.oid -- exclude the current MV which always depends on itself
)
SELECT * FROM s;

--------------------------------------------------
--- A view that returns the list of mat views in the
--- order they should be refreshed.
--------------------------------------------------
CREATE OR REPLACE VIEW "${schemaName}".mat_view_refresh_order AS
WITH b AS (
-- Select the highest depth of each mat view name
SELECT DISTINCT ON (schemaname,relname) schemaname, relname,
-- ownername,
depth
FROM "${schemaName}".mat_view_dependencies
WHERE relkind='m'
ORDER BY schemaname, relname, depth DESC
)
-- Reorder appropriately
SELECT schemaname, relname,
-- ownername,
depth AS refresh_order
FROM b
ORDER BY depth, schemaname, relname
;

--
--
-- Refreshing all materialized views (PL/PGSQL)
SELECT string_agg(
       'REFRESH MATERIALIZED VIEW "' || schemaname || '"."' || relname || '";',
       E'\n' ORDER BY refresh_order) AS script
FROM "${schemaName}".mat_view_refresh_order \gset

-- Visualize the script
\echo :script

-- Execute the script
:script

--
--
-- Refreshing just the materialized views in a particular schema
SELECT string_agg(
       'REFRESH MATERIALIZED VIEW "' || schemaname || '"."' || relname || '";',
       E'\n' ORDER BY refresh_order) AS script
FROM "${schemaName}".mat_view_refresh_order WHERE schemaname='myschema' \gset

-- Visualize the script
\echo :script

-- Execute the script
:script

--
--
-- Refreshing just the materialized views that depend on particular tables
WITH b AS (
-- Select the highest depth of each mat view name
SELECT DISTINCT ON (schemaname,relname) schemaname, relname, depth
FROM "${schemaName}".mat_view_dependencies
WHERE relkind='m' AND 
      (start_schemaname,start_relname) IN (('schema1','table1'),('schema2','table2'))
ORDER BY schemaname, relname, depth DESC
)
SELECT string_agg(
       'REFRESH MATERIALIZED VIEW "' || schemaname || '"."' || relname || '";',
       E'\n' ORDER BY depth) AS script
FROM b \gset

-- Visualize the script
\echo :script

-- Execute the script
:script



--
-- 
-- Function to Refresh All Materialized Views
CREATE OR REPLACE FUNCTION "${schemaName}".refresh_all_materialized_views_in_correct_order() RETURNS TEXT LANGUAGE plpgsql AS $$
DECLARE the_queries TEXT;
BEGIN EXECUTE format (
  $ex$
  SELECT string_agg(
       'REFRESH MATERIALIZED VIEW CONCURRENTLY "' || schemaname || '"."' || relname || '";',
       E'\n' ORDER BY refresh_order) AS script
  FROM "${schemaName}".mat_view_refresh_order
$ex$
) INTO the_queries;
EXECUTE format(
  $ex$
  %1$s $ex$,
    the_queries
);
RETURN the_queries;
END $$;
SELECT "${schemaName}".refresh_all_materialized_views_in_correct_order();
