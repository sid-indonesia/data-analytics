-- Login with "materialized_views_manager" to run these, ensure connected DB is correct

-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = analytics
@set viewName = Pregnancy Care Gap
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
  "source"."res_id" AS "res_id",
  "source"."max" AS "max",
  "source"."Observation All Versions View - Res__pid" AS "Observation All Versions View - Res__pid",
  "source"."Observation All Versions View - Res__partition_date" AS "Observation All Versions View - Res__partition_date",
  "source"."Observation All Versions View - Res__partition_id" AS "Observation All Versions View - Res__partition_id",
  "source"."Observation All Versions View - Res__res_deleted_at" AS "Observation All Versions View - Res__res_deleted_at",
  "source"."Observation All Versions View - Res__res_version" AS "Observation All Versions View - Res__res_version",
  "source"."Observation All Versions View - Res__has_tags" AS "Observation All Versions View - Res__has_tags",
  "source"."Observation All Versions View - Res__res_published" AS "Observation All Versions View - Res__res_published",
  "source"."Observation All Versions View - Res__res_updated" AS "Observation All Versions View - Res__res_updated",
  "source"."Observation All Versions View - Res__res_encoding" AS "Observation All Versions View - Res__res_encoding",
  "source"."Observation All Versions View - Res__res_text" AS "Observation All Versions View - Res__res_text",
  "source"."Observation All Versions View - Res__res_id" AS "Observation All Versions View - Res__res_id",
  "source"."Observation All Versions View - Res__res_type" AS "Observation All Versions View - Res__res_type",
  "source"."Observation All Versions View - Res__res_ver" AS "Observation All Versions View - Res__res_ver",
  "source"."Observation All Versions View - Res__Observation.code.coding" AS "Observation All Versions View - Res__Observation.code.coding",
  "source"."Observation All Versions View - Res__Observation.code.text" AS "Observation All Versions View - Res__Observation.code.text",
  "source"."Observation All Versions View - Res__Observation.component" AS "Observation All Versions View - Res__Observation.component",
  "source"."Observation All Versions View - Res__Observation.ef_8a5b9e19" AS "Observation All Versions View - Res__Observation.ef_8a5b9e19",
  "source"."Observation All Versions View - Res__Observation.en_b7d12bfa" AS "Observation All Versions View - Res__Observation.en_b7d12bfa",
  "source"."Observation All Versions View - Res__Observation.en_9b3b79fb" AS "Observation All Versions View - Res__Observation.en_9b3b79fb",
  "source"."Observation All Versions View - Res__Observation.identifier" AS "Observation All Versions View - Res__Observation.identifier",
  "source"."Observation All Versions View - Res__Observation.re_854558fc" AS "Observation All Versions View - Res__Observation.re_854558fc",
  "source"."Observation All Versions View - Res__Observation.status" AS "Observation All Versions View - Res__Observation.status",
  "source"."Observation All Versions View - Res__Observation.su_cf3632d6" AS "Observation All Versions View - Res__Observation.su_cf3632d6",
  "source"."Observation All Versions View - Res__Observation.su_1e3d2dd5" AS "Observation All Versions View - Res__Observation.su_1e3d2dd5",
  "source"."Observation All Versions View - Res__Observation.va_d4d33eea" AS "Observation All Versions View - Res__Observation.va_d4d33eea",
  "source"."Observation All Versions View - Res__Observation.va_3029dd4e" AS "Observation All Versions View - Res__Observation.va_3029dd4e",
  "source"."Observation All Versions View - Res__Observation.va_04591d89" AS "Observation All Versions View - Res__Observation.va_04591d89",
  "source"."Observation All Versions View - Res__Observation.va_1bdfb0ad" AS "Observation All Versions View - Res__Observation.va_1bdfb0ad",
  "source"."Observation All Versions View - Res__Observation.va_47b5e393" AS "Observation All Versions View - Res__Observation.va_47b5e393",
  "source"."Observation All Versions View - Res__Observation.valueString" AS "Observation All Versions View - Res__Observation.valueString"
FROM
  (
    SELECT
      "source"."res_id" AS "res_id",
      "source"."max" AS "max",
      "Observation All Versions View - Res"."pid" AS "Observation All Versions View - Res__pid",
      "Observation All Versions View - Res"."partition_date" AS "Observation All Versions View - Res__partition_date",
      "Observation All Versions View - Res"."partition_id" AS "Observation All Versions View - Res__partition_id",
      "Observation All Versions View - Res"."res_deleted_at" AS "Observation All Versions View - Res__res_deleted_at",
      "Observation All Versions View - Res"."res_version" AS "Observation All Versions View - Res__res_version",
      "Observation All Versions View - Res"."has_tags" AS "Observation All Versions View - Res__has_tags",
      "Observation All Versions View - Res"."res_published" AS "Observation All Versions View - Res__res_published",
      "Observation All Versions View - Res"."res_updated" AS "Observation All Versions View - Res__res_updated",
      "Observation All Versions View - Res"."res_encoding" AS "Observation All Versions View - Res__res_encoding",
      "Observation All Versions View - Res"."res_text" AS "Observation All Versions View - Res__res_text",
      "Observation All Versions View - Res"."res_id" AS "Observation All Versions View - Res__res_id",
      "Observation All Versions View - Res"."res_type" AS "Observation All Versions View - Res__res_type",
      "Observation All Versions View - Res"."res_ver" AS "Observation All Versions View - Res__res_ver",
      "Observation All Versions View - Res"."Observation.category" AS "Observation All Versions View - Res__Observation.category",
      "Observation All Versions View - Res"."Observation.code.coding" AS "Observation All Versions View - Res__Observation.code.coding",
      "Observation All Versions View - Res"."Observation.code.text" AS "Observation All Versions View - Res__Observation.code.text",
      "Observation All Versions View - Res"."Observation.component" AS "Observation All Versions View - Res__Observation.component",
      "Observation All Versions View - Res"."Observation.effectiveDateTime" AS "Observation All Versions View - Res__Observation.ef_8a5b9e19",
      "Observation All Versions View - Res"."Observation.encounter.reference" AS "Observation All Versions View - Res__Observation.en_b7d12bfa",
      "Observation All Versions View - Res"."Observation.encounter.type" AS "Observation All Versions View - Res__Observation.en_9b3b79fb",
      "Observation All Versions View - Res"."Observation.identifier" AS "Observation All Versions View - Res__Observation.identifier",
      "Observation All Versions View - Res"."Observation.issued" AS "Observation All Versions View - Res__Observation.issued",
      "Observation All Versions View - Res"."Observation.resourceType" AS "Observation All Versions View - Res__Observation.re_854558fc",
      "Observation All Versions View - Res"."Observation.status" AS "Observation All Versions View - Res__Observation.status",
      "Observation All Versions View - Res"."Observation.subject.reference" AS "Observation All Versions View - Res__Observation.su_cf3632d6",
      "Observation All Versions View - Res"."Observation.subject.type" AS "Observation All Versions View - Res__Observation.su_1e3d2dd5",
      "Observation All Versions View - Res"."Observation.valueBoolean" AS "Observation All Versions View - Res__Observation.va_d4d33eea",
      "Observation All Versions View - Res"."Observation.valueCodeableConcept.coding" AS "Observation All Versions View - Res__Observation.va_e099662f",
      "Observation All Versions View - Res"."Observation.valueCodeableConcept.text" AS "Observation All Versions View - Res__Observation.va_c6ea8a54",
      "Observation All Versions View - Res"."Observation.valueDateTime" AS "Observation All Versions View - Res__Observation.va_3029dd4e",
      "Observation All Versions View - Res"."Observation.valueInteger" AS "Observation All Versions View - Res__Observation.va_04591d89",
      "Observation All Versions View - Res"."Observation.valueQuantity.code" AS "Observation All Versions View - Res__Observation.va_b0718c66",
      "Observation All Versions View - Res"."Observation.valueQuantity.system" AS "Observation All Versions View - Res__Observation.va_81a5e57b",
      "Observation All Versions View - Res"."Observation.valueQuantity.unit" AS "Observation All Versions View - Res__Observation.va_1bdfb0ad",
      "Observation All Versions View - Res"."Observation.valueQuantity.value" AS "Observation All Versions View - Res__Observation.va_47b5e393",
      "Observation All Versions View - Res"."Observation.valueString" AS "Observation All Versions View - Res__Observation.valueString",
      "Observation All Versions View - Res"."Observation.referenceString" AS "Observation All Versions View - Res__Observation.re_50feae27"
    FROM
      (
        SELECT
          "public"."hfj_res_ver"."res_id" AS "res_id",
          MAX("public"."hfj_res_ver"."res_ver") AS "max"
        FROM
          "public"."hfj_res_ver"
GROUP BY
          "public"."hfj_res_ver"."res_id"
ORDER BY
          "public"."hfj_res_ver"."res_id" ASC
      ) AS "source"
      INNER JOIN "generated_views"."Observation_all_versions_view" AS "Observation All Versions View - Res" ON (
        "source"."res_id" = "Observation All Versions View - Res"."res_id"
      )
   AND (
        "source"."max" = "Observation All Versions View - Res"."res_ver"
      )
  ) AS "source";
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
