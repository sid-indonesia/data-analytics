SELECT *
FROM 
    (
    SELECT
      "analytics"."Baby and Toddler Encounters"."pid" AS "pid",
      "analytics"."Baby and Toddler Encounters"."res_published" AS "res_published",
      "analytics"."Baby and Toddler Encounters"."encounter_date" AS "encounter_date",
      "analytics"."Baby and Toddler Encounters"."encounter_type" AS "encounter_type",
      "analytics"."Baby and Toddler Encounters"."patient_id" AS "patient_id",
      "analytics"."Baby and Toddler Encounters"."patient_name" AS "patient_name",
      "analytics"."Baby and Toddler Encounters"."patient_city" AS "patient_city",
      "analytics"."Baby and Toddler Encounters"."patient_district" AS "patient_district",
      "analytics"."Baby and Toddler Encounters"."organization_puskesmas" AS "organization_puskesmas",
      "analytics"."Baby and Toddler Encounters"."patient_village" AS "patient_village",
      "analytics"."Baby and Toddler Encounters"."patient_subvillage" AS "patient_subvillage",
      "analytics"."Baby and Toddler Encounters"."patient_birthdate" AS "patient_birthdate",
      "analytics"."Baby and Toddler Encounters"."patient_gender" AS "patient_gender",
      "analytics"."Baby and Toddler Encounters"."practitioner_id" AS "practitioner_id",
      "analytics"."Baby and Toddler Encounters"."practitioner_name" AS "practitioner_name",
      "analytics"."Baby and Toddler Encounters"."practitioner_type" AS "practitioner_type",
      "analytics"."Baby and Toddler Encounters"."related_person_name" AS "related_person_name",
      "analytics"."Baby and Toddler Encounters"."related_person_relationship" AS "related_person_relationship",
      "analytics"."Baby and Toddler Encounters"."related_person_telecom" AS "related_person_telecom",
      "analytics"."Baby and Toddler Encounters"."encounter_reference" AS "encounter_reference",
      "analytics"."Baby and Toddler Encounters"."patient_reference" AS "patient_reference",
      "analytics"."Baby and Toddler Encounters"."organization_reference" AS "organization_reference",
      jsonb_array_elements("reason_reference":: jsonb) ->> 'reference' AS "reason_reference",
      "analytics"."Baby and Toddler Encounters"."practitioner_reference" AS "practitioner_reference",
      "analytics"."Baby and Toddler Encounters"."related_person_reference" AS "related_person_reference"
    FROM
      "analytics"."Baby and Toddler Encounters"
    ) "Encounter"
INNER JOIN 
    (
    SELECT 
      "observation_reference",
      "observation_code",
      "observation_name",
      "observation_value"
    FROM
        (
        SELECT
          MAX("pid") :: text AS "pid"
        FROM
          "generated_views"."Observation_all_versions_view"
        GROUP BY
          "res_id"
        ) "latest_res"
    INNER JOIN 
        (
        SELECT
          "pid" :: text AS "pid",
          "Observation.referenceString" AS "observation_reference",
          "Observation.code.coding" :: jsonb -> 0 ->> 'code' AS "observation_code",
          "Observation.code.coding" :: jsonb -> 0 ->> 'display' AS "observation_name",
          "Observation.valueQuantity.value" AS "observation_value"
        FROM
          "generated_views"."Observation_all_versions_view"
        ) "Observation" ON "latest_res"."pid" = "Observation"."pid"
    WHERE
      "observation_code" = '3137-7' OR 
      "observation_code" = '3141-9'
    ) "Observation" ON "Encounter"."reason_reference" = "Observation"."observation_reference"