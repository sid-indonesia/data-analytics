-- Login with "materialized_views_manager" to run these, ensure connected DB is correct

-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = analytics
@set viewName = Baby and Toddler Encounters
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
  "pid",
  "res_published",
  "encounter_date",
  "encounter_type",
  "patient_id",
  "patient_name",
  "patient_city",
  "patient_district",
  "organization_puskesmas",
  "patient_village",
  "patient_subvillage",
  "patient_birthdate",
  "patient_gender",
  "practitioner_id",
  "practitioner_name",
  "practitioner_type",
  "related_person_name",
  "related_person_relationship",
  "related_person_telecom",
  "encounter_reference",
  "Encounter"."patient_reference",
  "Encounter"."organization_reference",
  "Encounter"."reason_reference",
  "Encounter"."practitioner_reference",
  "Encounter"."related_person_reference"
FROM
    (
    SELECT
      "Encounter"."pid",
      "res_published",
      "encounter_date",
      "identifier"[2] AS "encounter_type",
      "identifier"[1] AS "patient_id",
      "encounter_reference",
      "patient_reference",
      "organization_reference",
      "reason_reference",
      "practitioner_reference",
      "related_person_reference"
    FROM
        (
        SELECT
          MAX("pid") :: text AS "pid"
        FROM
          "user_defined_views"."Encounter_all_versions_view"
        GROUP BY
          "res_id"
        ) "latest_res"
    INNER JOIN 
        (
        SELECT
          "pid" :: text AS "pid",
          "res_published",
          "Encounter.period.end" :: date AS "encounter_date",
          REGEXP_SPLIT_TO_ARRAY("Encounter.identifier" :: jsonb -> 0 ->> 'value', '-') AS "identifier",
          "Encounter.referenceString" AS "encounter_reference",
          "Encounter.subject.reference" AS "patient_reference",
          "Encounter.serviceProvider.reference" AS "organization_reference",
        --   jsonb_array_elements("Encounter.reasonReference" :: jsonb) ->> 'reference' AS "reason_reference",
          "Encounter.reasonReference" AS "reason_reference",
          "Encounter.participant" :: jsonb -> 0 -> 'individual' ->> 'reference' AS "practitioner_reference",
          "Encounter.participant" :: jsonb -> 1 -> 'individual' ->> 'reference' AS "related_person_reference"
        FROM
          "user_defined_views"."Encounter_all_versions_view"
        ) "Encounter" ON "latest_res"."pid" = "Encounter"."pid"
    ) "Encounter"
LEFT JOIN
    (
    SELECT
      "patient_reference",
      "patient_city",
      "patient_district",
      "patient_village",
      "patient_subvillage",
      "patient_birthdate",
      "patient_gender",
      "patient_name"
    FROM
        (
        SELECT
          MAX("pid") :: text AS "pid"
        FROM
          "user_defined_views"."Patient_all_versions_view"
        GROUP BY
          "res_id"
        ) "latest_res"
    INNER JOIN 
        (
        SELECT
          "pid" :: text AS "pid",
          "Patient.referenceString" AS "patient_reference",
          CASE 
           WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 0 ->> 'url' = 'city'
             THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 0 ->> 'valueString'
           ELSE NULL
          END AS "patient_city",
          CASE 
           WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 1 ->> 'url' = 'district'
             THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 1 ->> 'valueString'
           ELSE NULL
          END AS "patient_district",
          CASE 
           WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 2 ->> 'url' = 'village'
             THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 2 ->> 'valueString'
           ELSE NULL
          END AS "patient_village",
          CASE 
           WHEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 3 ->> 'url' = 'subvillage'
             THEN "Patient.address" :: jsonb -> 0 -> 'extension' -> 3 ->> 'valueString'
           ELSE NULL
          END AS "patient_subvillage",
          "Patient.birthDate" :: date AS "patient_birthdate",
          "Patient.gender" AS "patient_gender",
        --   "Patient.identifier" :: jsonb -> 0 ->> 'value' AS "patient_id",
          "Patient.name" :: jsonb -> 0 ->> 'text' AS "patient_name"
        FROM
          "user_defined_views"."Patient_all_versions_view"
        ) "Patient" ON "latest_res"."pid" = "Patient"."pid"
    ) "Patient" ON "Encounter"."patient_reference" = "Patient"."patient_reference"
LEFT JOIN
    (
    SELECT
      "organization_reference",
      "organization_puskesmas"
    FROM
        (
        SELECT
          MAX("pid") :: text AS "pid"
        FROM
          "user_defined_views"."Organization_all_versions_view"
        GROUP BY
          "res_id"
        ) "latest_res"
    INNER JOIN 
        (
        SELECT
          "pid" :: text AS "pid",
          "Organization.referenceString" AS "organization_reference",
          "Organization.name" AS "organization_puskesmas"
        FROM
          "user_defined_views"."Organization_all_versions_view"
        ) "Organization" ON "latest_res"."pid" = "Organization"."pid"
    ) "Organization" ON "Encounter"."organization_reference" = "Organization"."organization_reference"
LEFT JOIN
    (
    SELECT
      "practitioner_reference",
      "practitioner_id",
      "practitioner_name",
      "practitioner_type"
    FROM
        (
        SELECT
          MAX("pid") :: text AS "pid"
        FROM
          "user_defined_views"."Practitioner_all_versions_view"
        GROUP BY
          "res_id"
        ) "latest_res"
    INNER JOIN
        (
        SELECT
          "pid" :: text AS "pid",
          "Practitioner.referenceString" AS "practitioner_reference",
          "Practitioner.identifier" :: jsonb -> 0 ->> 'value' AS "practitioner_id",
          "Practitioner.name" :: jsonb -> 0 ->> 'text' AS "practitioner_name",
          "Practitioner.qualification" :: jsonb -> 0 -> 'code' -> 'coding' -> 0 ->> 'display' AS "practitioner_type"
        FROM
          "user_defined_views"."Practitioner_all_versions_view"
        ) "Practitioner" ON "latest_res"."pid" = "Practitioner"."pid"
    ) "Practitioner" ON "Encounter"."practitioner_reference" = "Practitioner"."practitioner_reference"
LEFT JOIN
    (
    SELECT
      "related_person_reference",
      "related_person_name",
      "related_person_relationship",
      "related_person_telecom"
    FROM
        (
        SELECT
          MAX("pid") :: text AS "pid"
        FROM
          "user_defined_views"."RelatedPerson_all_versions_view"
        GROUP BY
          "res_id"
        ) "latest_res"
    INNER JOIN
        (
        SELECT
          "pid" :: text AS "pid",
          "RelatedPerson.referenceString" AS "related_person_reference",
          "RelatedPerson.name" :: jsonb -> 0 ->> 'text' AS "related_person_name",
          "RelatedPerson.relationship" :: jsonb -> 0 ->> 'text' AS "related_person_relationship",
          "RelatedPerson.telecom" :: jsonb -> 0 ->> 'value' AS "related_person_telecom"
        FROM
          "user_defined_views"."RelatedPerson_all_versions_view"
        ) "RelatedPerson" ON "latest_res"."pid" = "RelatedPerson"."pid"
    ) "RelatedPerson" ON "Encounter"."related_person_reference" = "RelatedPerson"."related_person_reference"
WHERE
  "encounter_type" = 'BKKBN_VISIT' OR
  "encounter_type" = 'CADRE_VISIT'
ORDER BY
  "res_published" DESC,
  "pid" DESC;

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
