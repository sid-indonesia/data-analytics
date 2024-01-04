-- Login with "materialized_views_manager" to run these, ensure connected DB is correct

-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = analytics
@set viewName = Systolic Blood Pressure Measurements
@set userNamesToBeGrantedReadPermissions = "metabase_scraper", "readonly_opensrp"

CREATE SCHEMA IF NOT EXISTS "${schemaName}" AUTHORIZATION owner_materialized_views;


-- Create (Materialized) View
CREATE
MATERIALIZED
VIEW "${schemaName}"."${viewName}" AS
-- Write here the analytical query
-- OR Metabase Model (https://www.metabase.com/learn/data-modeling/models#why-not-run-an-etl-job-to-create-a-model-in-your-database:~:text=Models%20are%20stepping%20stones%20for%20improving%20your%20database%E2%80%99s%20performance.%20After%20experimenting%20with%20models%20in%20Metabase%2C%20you%20can%20%E2%80%9Cpromote%E2%80%9D%20the%20most%20popular%20models%20to%20materialized%20views%20in%20your%20database.)
-- OR Metabase Question
SELECT
    "source"."bp_measurement" AS "bp_measurement",
    "source"."bp_systolic" AS "bp_systolic",
    count(distinct "source"."baseEntityId") AS "count"
FROM
    (
    SELECT 
        "source"."baseEntityId" AS "baseEntityId",
        "source"."dateCreated" AS "dateCreated",
        CASE 
            WHEN "source"."gest_age_current" < 14
            THEN 'Trimester 1'
            ELSE CASE
                WHEN "source"."gest_age_current" < 27
                THEN 'Trimester 2'
                ELSE 'Trimester 3'
            END 
        END AS "gest_trimester",
        "source"."bp_measurement" AS "bp_measurement",
        "source"."bp_systolic" AS "bp_systolic"
    FROM
        (
        SELECT
            "profile"."baseEntityId" AS "baseEntityId",
            "physical_exam"."dateCreated" AS "dateCreated",
            FLOOR((NOW():: date - "profile"."dateCreated"):: numeric / 7) + "profile"."gest_age_openmrs" AS "gest_age_current",
            CASE 
                WHEN "physical_exam"."bp_systolic" IS NOT NULL
                THEN 'OptiBP'
                ELSE CASE
                    WHEN "physical_exam"."bp_systolic_manual" IS NOT NULL
                    THEN 'Manual'
                    ELSE NULL
                END
            END AS "bp_measurement",
            COALESCE("physical_exam"."bp_systolic", "physical_exam"."bp_systolic_manual") AS "bp_systolic"
        FROM
            (
                SELECT
                    MAX("core"."event_Profile_view"."id") AS "id"
                FROM
                  "core"."event_Profile_view"
                GROUP BY
                    "core"."event_Profile_view"."baseEntityId"
                ) AS "latest_profile"
        INNER JOIN
            (
                SELECT
                  "core"."event_Profile_view"."id" AS "id",
                  "core"."event_Profile_view"."baseEntityId" AS "baseEntityId",
                  "core"."event_Profile_view"."dateCreated":: date AS "dateCreated",
                  ("core"."event_Profile_view"."obs.gest_age_openmrs.values"::JSONB ->> 0):: numeric  AS "gest_age_openmrs"
                FROM
                  "core"."event_Profile_view"
                 ) AS "profile"
        ON 
            "latest_profile"."id" = "profile"."id"
        LEFT JOIN 
            (
                SELECT
                    "core"."event_ANC Close_view"."baseEntityId" AS "baseEntityId"
                FROM
                    "core"."event_ANC Close_view"
                ) AS "close"
        ON 
            "profile"."baseEntityId" = "close"."baseEntityId"
        LEFT JOIN 
            (
                SELECT
                    "core"."event_Physical Exam_view"."baseEntityId" AS "baseEntityId",
                    "core"."event_Physical Exam_view"."dateCreated":: date AS "dateCreated",
                    ("core"."event_Physical Exam_view"."obs.bp_systolic.values":: jsonb ->> 0):: numeric AS "bp_systolic",
                    ("core"."event_Physical Exam_view"."obs.bp_systolic_manual.values":: jsonb ->> 0):: numeric AS "bp_systolic_manual"
                FROM
                    "core"."event_Physical Exam_view"
                ) AS "physical_exam"
        ON 
            "profile"."baseEntityId" = "physical_exam"."baseEntityId"
        WHERE 
            "close"."baseEntityId" IS NULL
        ) AS "source"
    WHERE
        "source"."gest_age_current" <= 40 AND
        "source"."bp_measurement" IS NOT NULL
    ORDER BY 
        "source"."baseEntityId" DESC,
        "source"."dateCreated" DESC
    ) AS "source"
GROUP BY
    "source"."bp_measurement",
    "source"."bp_systolic"
ORDER BY
    "source"."bp_systolic" ASC,
    "source"."bp_measurement" ASC;
-- Suggestion: Change ownership of the (materialized) view to owner_materialized_views
ALTER
MATERIALIZED
VIEW "${schemaName}"."${viewName}"
OWNER TO owner_materialized_views;

-- To refresh the materialized view (locking / not concurrent?)
REFRESH MATERIALIZED VIEW "${schemaName}"."${viewName}";

-- To refresh the materialized view concurrently
-- Need at least one unique index to use `CONCURRENTLY` option
CREATE UNIQUE INDEX "${viewName}_id_idx"
ON "${schemaName}"."${viewName}" (bp_measurement, bp_systolic);
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

-- To drop the (materialized) view
DROP
MATERIALIZED
VIEW "${schemaName}"."${viewName}";
