SELECT
"pid",
jsonb_array_elements("Observation.component" :: jsonb) AS "Observation.component"
FROM "user_defined_views"."Observation_all_versions_view"