-- Login with "materialized_views_manager" to run these, ensure connected DB is correct

-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = analytics
@set viewName = Weekly Health Education
@set userNamesToBeGrantedReadPermissions = "sid", "readonly_opensrp"

CREATE SCHEMA IF NOT EXISTS "${schemaName}" AUTHORIZATION owner_materialized_views;


-- Create (Materialized) View
CREATE
-- MATERIALIZED
VIEW "${schemaName}"."${viewName}" AS
-- Write here the analytical query
-- OR Metabase Model (https://www.metabase.com/learn/data-modeling/models#why-not-run-an-etl-job-to-create-a-model-in-your-database:~:text=Models%20are%20stepping%20stones%20for%20improving%20your%20database%E2%80%99s%20performance.%20After%20experimenting%20with%20models%20in%20Metabase%2C%20you%20can%20%E2%80%9Cpromote%E2%80%9D%20the%20most%20popular%20models%20to%20materialized%20views%20in%20your%20database.)
-- OR Metabase Question
SELECT
  phone_number,
  full_name,
  full_name AS customer_name,
  'Bunda App' AS company,
  calc_gestational,
  CASE
      WHEN calc_gestational >= 28
      THEN '3'
      ELSE (CASE
          WHEN (calc_gestational >= 13)
          THEN '2'
          ELSE (CASE
              WHEN calc_gestational >= 0
              THEN '1'
              ELSE '-'
          END
          )
      END
      )
  END
  AS "pregna_trimester"
FROM
  (
  SELECT
      '62' || substring((anc_registration."obs.phone_number.values"::jsonb) ->> 0, 2) AS "phone_number",
      CASE
          WHEN (the_mother."firstName" = the_mother."lastName")
          THEN the_mother."firstName"
          ELSE the_mother."firstName" || ' ' || the_mother."lastName"
      END AS "full_name",
      CASE
          WHEN latest_profile."obs.ultrasound_done.humanReadableValues"::jsonb ->> 0 ILIKE 'yes'
          THEN (current_date - (
                  to_date(
                      latest_profile."obs.ultrasound_edd.values"::jsonb ->> 0,
                      'dd-mm-yyyy'
                  ) - INTERVAL '280 days'
              )::date
          ) / 7
          ELSE (current_date - (
                  the_mother."attributes.edd"::date - INTERVAL '280 days'
              )::date
          ) / 7
      END
      AS "calc_gestational"
  FROM
      core.client_detailed_view the_mother
  LEFT JOIN core."event_ANC Registration_view" anc_registration ON
      the_mother."baseEntityId" = anc_registration."baseEntityId"
  LEFT JOIN (
      SELECT
          sub_profile."baseEntityId",
          max(sub_profile.id) AS latest_id
      FROM
          core."event_Profile_view" sub_profile
      GROUP BY
          sub_profile."baseEntityId"
      ) latest_id_of_profile ON
      latest_id_of_profile."baseEntityId" = the_mother."baseEntityId"
  LEFT JOIN
      core."event_Profile_view" latest_profile ON
      latest_profile.id = latest_id_of_profile.latest_id
  WHERE
      (CASE
          WHEN latest_profile."obs.ultrasound_done.humanReadableValues"::jsonb ->> 0 ILIKE 'yes'
          THEN to_date((latest_profile."obs.ultrasound_edd.values"::jsonb ->> 0), 'dd-mm-yyyy') > current_date
          ELSE (CASE
              WHEN (
                  the_mother."attributes.edd" != '0'
                  AND
                  the_mother."attributes.edd" != ''
              )
              THEN the_mother."attributes.edd"::date > current_date
              ELSE FALSE
          END)
      END)
      AND
      anc_registration."obs.phone_number.values"::jsonb ->> 0 IS NOT NULL
      AND
      anc_registration."obs.phone_number.values"::jsonb ->> 0 != '0'
      AND
      anc_registration."obs.phone_number.values"::jsonb ->> 0 != '999'
      AND
      anc_registration."obs.phone_number.values"::jsonb ->> 0 !~ '^000*'
      AND
      length(anc_registration."obs.phone_number.values"::jsonb ->> 0) >= 10
      AND
      anc_registration."obs.reminders.humanReadableValues"::jsonb ->> 0 ILIKE 'yes'
      AND 
      (CASE
          WHEN (EXISTS (
          SELECT
              1
          FROM
              core."event_ANC Close_view" anc_close
          WHERE
              anc_close."baseEntityId" = the_mother."baseEntityId")
          )
          THEN FALSE
          ELSE TRUE
      END)
  ) qontak;
-- Suggestion: Change ownership of the (materialized) view to owner_materialized_views
ALTER
--MATERIALIZED
VIEW "${schemaName}"."${viewName}"
OWNER TO owner_materialized_views;

-- To refresh the materialized view (locking / not concurrent?)
--REFRESH MATERIALIZED VIEW "${schemaName}"."${viewName}";

-- To refresh the materialized view concurrently
-- Need at least one unique index to use `CONCURRENTLY` option
--CREATE UNIQUE INDEX "${viewName}_id_idx"
--ON "${schemaName}"."${viewName}" (bp_measurement, bp_systolic);
--REFRESH MATERIALIZED VIEW CONCURRENTLY "${schemaName}"."${viewName}";

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
--MATERIALIZED
VIEW "${schemaName}"."${viewName}";
