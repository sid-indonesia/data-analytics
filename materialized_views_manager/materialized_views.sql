-- Login with "materialized_views_manager" to run these, ensure connected DB is correct
-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = analytics
@set viewName = Some Analysis Indicators
@set userNamesToBeGrantedReadPermissions = "metabase_scraper", "readonly_opensrp"

CREATE SCHEMA IF NOT EXISTS "${schemaName}" AUTHORIZATION owner_materialized_views;

-- Create Materialized View
CREATE MATERIALIZED VIEW "${schemaName}"."${viewName}" AS
-- Write here the analytical query
-- OR Metabase Model (https://www.metabase.com/learn/data-modeling/models#why-not-run-an-etl-job-to-create-a-model-in-your-database:~:text=Models%20are%20stepping%20stones%20for%20improving%20your%20database%E2%80%99s%20performance.%20After%20experimenting%20with%20models%20in%20Metabase%2C%20you%20can%20%E2%80%9Cpromote%E2%80%9D%20the%20most%20popular%20models%20to%20materialized%20views%20in%20your%20database.)
-- OR Metabase Question
SELECT * FROM "core"."event_ANC Registration_view" earv;
-- Suggestion: Change ownership of the materialized view to owner_materialized_views
ALTER
MATERIALIZED
VIEW "${schemaName}"."${viewName}"
OWNER TO owner_materialized_views;

-- To refresh the materialized view (locking / not concurrent?)
REFRESH MATERIALIZED VIEW "${schemaName}"."${viewName}";

-- To refresh the materialized view concurrently
-- Need at least one unique index to use `CONCURRENTLY` option
CREATE UNIQUE INDEX "${viewName}_id_idx"
ON "${schemaName}"."${viewName}" (id);
REFRESH MATERIALIZED VIEW CONCURRENTLY "${schemaName}"."${viewName}";

-- Grant read-only permissions to some users for accessing the materialized views
GRANT USAGE ON
SCHEMA
"${schemaName}"
TO ${userNamesToBeGrantedReadPermissions};

GRANT
SELECT
	ON
	ALL TABLES IN SCHEMA
    "${schemaName}"
TO ${userNamesToBeGrantedReadPermissions};

ALTER DEFAULT PRIVILEGES IN SCHEMA
"${schemaName}"
GRANT
SELECT
	ON
	TABLES TO ${userNamesToBeGrantedReadPermissions};

-- To drop the materialized view
DROP MATERIALIZED VIEW "${schemaName}"."${viewName}";
