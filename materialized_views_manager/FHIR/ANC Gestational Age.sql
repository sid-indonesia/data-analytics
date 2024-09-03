-- Login with "materialized_views_manager" to run these, ensure connected DB is correct

-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = analytics
@set viewName = ANC Gestational Age
@set userNamesToBeGrantedReadPermissions = "metabase_scraper", "owner_materialized_views", "bigquery_scraper", "readonly_opensrp", "fhir_data_pipes" --, "readonly", "sas_readonly", "read_only"

CREATE SCHEMA IF NOT EXISTS "${schemaName}" AUTHORIZATION owner_materialized_views;


-- Create (Materialized) View
CREATE
MATERIALIZED
VIEW "${schemaName}"."${viewName}" AS
-- Write here the analytical query
-- OR Metabase Model (https://www.metabase.com/learn/data-modeling/models#why-not-run-an-etl-job-to-create-a-model-in-your-database:~:text=Models%20are%20stepping%20stones%20for%20improving%20your%20database%E2%80%99s%20performance.%20After%20experimenting%20with%20models%20in%20Metabase%2C%20you%20can%20%E2%80%9Cpromote%E2%80%9D%20the%20most%20popular%20models%20to%20materialized%20views%20in%20your%20database.)
-- OR Metabase Question
SELECT
"Patient"."pid",
"Patient"."patient_reference",
"patient_id",
"patient_name",
"patient_birthdate",
"patient_current_age_month",
"patient_current_age_year",
"patient_gender",
"patient_system",
"patient_city",
"patient_district",
"organization_puskesmas",
"patient_village",
"patient_subvillage",
"count_anc_registration",
"count_anc_visit",
"count_bkkbn_visit",
"count_cadre_visit",
"count_vaccinator_visit",
"observation_date_lmp",
"observation_date_usg",
"observation_gest_age_usg",
"observation_current_gest_age"
FROM (
    SELECT
        MAX("pid") :: text AS "pid"
    FROM
        "user_defined_views"."Patient_all_versions_view"
    GROUP BY
        "res_id"
) "latest_res"
INNER JOIN (
    SELECT
    "pid" :: text AS "pid",
    "Patient.referenceString" AS "patient_reference",
    CASE 
        WHEN "Patient.address" :: jsonb -> 0 ->> 'city' IS NOT NULL
        THEN "Patient.address" :: jsonb -> 0 ->> 'city'
        ELSE CASE
            WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 0 ->> 'url' = 'city'
            THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 0 ->> 'valueString'
            ELSE NULL
        END
    END AS "patient_city",
    CASE 
        WHEN "Patient.address" :: jsonb -> 0 ->> 'district' IS NOT NULL
        THEN "Patient.address" :: jsonb -> 0 ->> 'district'
        ELSE CASE
            WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 1 ->> 'url' = 'district'
            AND "Patient.address" :: jsonb -> 0 -> 'extension' -> 1 ->> 'valueString' IS NOT NULL
            THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 1 ->> 'valueString'
            ELSE CASE
                WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 0 ->> 'url' = 'district'
                THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 0 ->> 'valueString'
                ELSE NULL
            END
        END
    END AS "patient_district",
    CASE 
        WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 2 ->> 'url' = 'village'
        AND "Patient.address" :: jsonb -> 0 -> 'extension' -> 2 ->> 'valueString' IS NOT NULL
        THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 2 ->> 'valueString'
        ELSE CASE
            WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 1 ->> 'url' = 'village'
            THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 1 ->> 'valueString'
            ELSE NULL
        END
    END AS "patient_village",
    CASE 
        WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 3 ->> 'url' = 'subvillage'
        AND "Patient.address" :: jsonb -> 0 -> 'extension' -> 3 ->> 'valueString' IS NOT NULL
        THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 3 ->> 'valueString'
        ELSE CASE
            WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 2 ->> 'url' = 'subvillage'
            THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 2 ->> 'valueString'
            ELSE NULL
        END
    END AS "patient_subvillage",
    "Patient.birthDate" :: date AS "patient_birthdate",
    extract(year FROM age(current_date, "Patient.birthDate" :: date)) * 12 + extract(month FROM AGE(current_date, "Patient.birthDate" :: date)) AS "patient_current_age_month",
    extract(year FROM age(current_date, "Patient.birthDate" :: date)) AS "patient_current_age_year",
    "Patient.gender" AS "patient_gender",
    "Patient.identifier" :: jsonb -> 0 ->> 'value' AS "patient_id",
    "Patient.identifier" :: jsonb -> 0 ->> 'system' AS "patient_system",
    "Patient.name" :: jsonb -> 0 ->> 'text' AS "patient_name"
    FROM
    "user_defined_views"."Patient_all_versions_view"
) "Patient" ON "latest_res"."pid" = "Patient"."pid"
LEFT JOIN (
    SELECT DISTINCT ON ("patient_reference")
    "patient_reference", 
    "organization_puskesmas",
     COUNT(*)
    FROM (
        SELECT
        "Encounter.subject.reference" AS "patient_reference",
        "Encounter.serviceProvider.reference" AS "organization_reference"
        FROM
        "user_defined_views"."Encounter_all_versions_view"
    ) "Encounter"
    INNER JOIN (
        SELECT
        "Organization.referenceString" AS "organization_reference",
        "Organization.name" AS "organization_puskesmas"
        FROM
        "user_defined_views"."Organization_all_versions_view"
    ) "Organization" ON "Encounter"."organization_reference" = "Organization"."organization_reference"
    WHERE 
    "organization_puskesmas" IS NOT NULL
    GROUP BY 
    "patient_reference", "organization_puskesmas"
    ORDER BY
    "patient_reference", COUNT(*) DESC
) "Organization" ON "Patient"."patient_reference" = "Organization"."patient_reference"
LEFT JOIN (
    SELECT
    coalesce("LMP"."patient_reference", "USG"."patient_reference") AS "patient_reference",
    "observation_date_lmp",
    "observation_date_usg",
    "observation_gest_age_usg",
    CASE 
        WHEN "observation_gest_age_usg" < 14 OR "observation_gest_age_lmp" IS NULL
        THEN floor((current_date - "observation_date_usg") / 7 + "observation_gest_age_usg")
        ELSE floor((current_date - "observation_date_lmp") / 7)
    END AS "observation_current_gest_age"
    FROM (
        SELECT
        min(("Observation.component" :: jsonb -> 4 ->> 'valueDateTime') :: date) AS "observation_date_lmp",
        max(("Observation.component" :: jsonb -> 5 -> 'valueQuantity' ->> 'value') :: numeric) AS "observation_gest_age_lmp",
        max("Observation.effectiveDateTime" :: date) AS "observation_date",
        "Observation.subject.reference" AS "patient_reference"
        FROM
        "user_defined_views"."Observation_all_versions_view"
        WHERE
        "Observation.component" LIKE '%11885-1%'
        GROUP BY 
        "Observation.subject.reference"
    ) "LMP"
    FULL OUTER JOIN (
        SELECT
        min(("Observation.component" :: jsonb -> 0 -> 'valueQuantity' ->> 'value') :: numeric) AS "observation_gest_age_usg",
        min("Observation.effectiveDateTime" :: date) AS "observation_date_usg",
        "Observation.subject.reference" AS "patient_reference"
        FROM
        "user_defined_views"."Observation_all_versions_view"
        WHERE
        "Observation.component" LIKE '%11888-5%'
        GROUP BY 
        "Observation.subject.reference"
    ) "USG" ON "LMP"."patient_reference" = "USG"."patient_reference"
) "Observation" ON "Patient"."patient_reference" = "Observation"."patient_reference"
LEFT JOIN (
    SELECT
    "Encounter.subject.reference" AS "patient_reference",
    count(distinct "Encounter.referenceString") AS "count_anc_visit"
    FROM
    "user_defined_views"."Encounter_all_versions_view"
    WHERE
    "Encounter.identifier" LIKE '%ANC_VISIT%'
    GROUP BY
    "Encounter.subject.reference"
) "ANC_VISIT" ON "Patient"."patient_reference" = "ANC_VISIT"."patient_reference"
LEFT JOIN (
    SELECT
    "Encounter.subject.reference" AS "patient_reference",
    count(distinct "Encounter.referenceString") AS "count_cadre_visit"
    FROM
    "user_defined_views"."Encounter_all_versions_view"
    WHERE
    "Encounter.identifier" LIKE '%CADRE%'
    GROUP BY
    "Encounter.subject.reference"
) "CADRE_VISIT" ON "Patient"."patient_reference" = "CADRE_VISIT"."patient_reference"
LEFT JOIN (
    SELECT
    "Encounter.subject.reference" AS "patient_reference",
    count(distinct "Encounter.referenceString") AS "count_bkkbn_visit"
    FROM
    "user_defined_views"."Encounter_all_versions_view"
    WHERE
    "Encounter.identifier" LIKE '%BKKBN%'
    GROUP BY
    "Encounter.subject.reference"
) "BKKBN_VISIT" ON "Patient"."patient_reference" = "BKKBN_VISIT"."patient_reference"
LEFT JOIN (
    SELECT
    "Encounter.subject.reference" AS "patient_reference",
    count(distinct "Encounter.referenceString") AS "count_vaccinator_visit"
    FROM
    "user_defined_views"."Encounter_all_versions_view"
    WHERE
    "Encounter.identifier" LIKE '%VACCINATOR%'
    GROUP BY
    "Encounter.subject.reference"
) "VACCINATOR_VISIT" ON "Patient"."patient_reference" = "VACCINATOR_VISIT"."patient_reference"
LEFT JOIN (
    SELECT
    "Encounter.subject.reference" AS "patient_reference",
    count(distinct "Encounter.referenceString") AS "count_anc_registration"
    FROM
    "user_defined_views"."Encounter_all_versions_view"
    WHERE
    "Encounter.identifier" LIKE '%ANC_REGISTRATION%'
    GROUP BY
    "Encounter.subject.reference"
) "ANC_REGISTRATION" ON "Patient"."patient_reference" = "ANC_REGISTRATION"."patient_reference"

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
ON "${schemaName}"."${viewName}" (pid);
REFRESH MATERIALIZED VIEW CONCURRENTLY "${schemaName}"."${viewName}";

-- Grant read-only permissions to some users for accessing the (materialized) views
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
