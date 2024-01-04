@set lastEventID = 1000

SELECT
	mi.event_id AS eventId,
	mi.mobile_phone_number AS mobilePhoneNumber,
	(
	SELECT
		cm.full_name
	FROM
		"sid_bidan".client_mother cm
	WHERE
		cm.base_entity_id = mi.mother_base_entity_id
	ORDER BY
		cm.server_version_epoch DESC
	LIMIT 1) AS fullName,
	(
	SELECT
		CONCAT_WS(',',
		CASE
			WHEN av_sub1.anc_date IS NULL THEN 'N/A'
			ELSE av_sub1.anc_date::varchar
		END,
		CASE
			WHEN (av_sub1.gestational_age = '') IS NOT FALSE THEN 'N/A'
			ELSE av_sub1.gestational_age
		END,
		CASE
			WHEN ((
			SELECT
				height_in_cm
			FROM
				"sid_bidan".anc_register
			WHERE
				mother_base_entity_id = av_sub1.mother_base_entity_id
			ORDER BY
				server_version_epoch DESC
			LIMIT 1) = '') IS NOT FALSE THEN '-'
			ELSE (
			SELECT
				height_in_cm
			FROM
				"sid_bidan".anc_register
			WHERE
				mother_base_entity_id = av_sub1.mother_base_entity_id
			ORDER BY
				server_version_epoch DESC
			LIMIT 1)
		END,
		CASE
			WHEN (av_sub1.weight_in_kg = '') IS NOT FALSE THEN '-'
			ELSE av_sub1.weight_in_kg
		END,
		CASE
			WHEN (av_sub1.mid_upper_arm_circumference_in_cm = '') IS NOT FALSE THEN '-'
			ELSE av_sub1.mid_upper_arm_circumference_in_cm
		END,
		CASE
			WHEN (av_sub1.vital_sign_systolic_blood_pressure = '') IS NOT FALSE THEN '-'
			ELSE av_sub1.vital_sign_systolic_blood_pressure
		END,
		CASE
			WHEN (av_sub1.vital_sign_diastolic_blood_pressure = '') IS NOT FALSE THEN '-'
			ELSE av_sub1.vital_sign_diastolic_blood_pressure
		END,
		CASE
			WHEN (av_sub1.gestational_age::integer >= 20) THEN ( CASE
				WHEN (av_sub1.uterine_fundal_height = '') IS NOT FALSE THEN '-'
				ELSE av_sub1.uterine_fundal_height || ' cm'
			END)
			ELSE 'Janin belum teraba'
		END,
		CASE
			WHEN (av_sub1.gestational_age::integer >= 20) THEN ( CASE
				WHEN (av_sub1.fetal_presentation = '') IS NOT FALSE THEN '-'
				ELSE av_sub1.fetal_presentation
			END)
			ELSE 'Janin belum teraba'
		END,
		CASE
			WHEN (av_sub1.gestational_age::integer >= 12) THEN ( CASE
				WHEN (av_sub1.fetal_heart_rate = '') IS NOT FALSE THEN '-'
				ELSE av_sub1.fetal_heart_rate
			END)
			ELSE 'Detak jantung janin belum terdengar'
		END,
		CASE
			WHEN (av_sub1.tetanus_toxoid_immunization_status = '') IS NOT FALSE THEN '-'
			ELSE av_sub1.tetanus_toxoid_immunization_status
		END,
		CASE
			WHEN (av_sub1.is_given_tetanus_toxoid_injection = '') IS NOT FALSE THEN '-'
			ELSE ( CASE
				WHEN av_sub1.is_given_tetanus_toxoid_injection = 'jika_dilakukan' THEN 'Ya'
				ELSE 'Tidak'
			END)
		END,
		CASE
			WHEN (av_sub1.is_given_iron_folic_acid_tablet = '') IS NOT FALSE THEN '-'
			ELSE av_sub1.is_given_iron_folic_acid_tablet
		END,
		CASE
			WHEN (EXISTS (
			SELECT
				1
			FROM
				"sid_bidan".lab_test_anc_visit
			WHERE
				mother_base_entity_id = av_sub1.mother_base_entity_id)) THEN (
			SELECT
				CONCAT_WS(',',
				CASE
					WHEN (ltav.has_proteinuria = '') IS NOT FALSE THEN '-'
					ELSE ( CASE
						WHEN ltav.has_proteinuria = 'Ya' THEN 'positif'
						ELSE 'negatif'
					END)
				END,
				CASE
					WHEN (ltav.hb_level_lab_test_result = '') IS NOT FALSE THEN '-'
					ELSE ltav.hb_level_lab_test_result
				END,
				CASE
					WHEN (ltav.is_glucose_blood_more_than_140_mg_dl = '') IS NOT FALSE THEN '-'
					ELSE ltav.is_glucose_blood_more_than_140_mg_dl
				END,
				CASE
					WHEN (ltav.has_thalasemia = '') IS NOT FALSE THEN '-'
					ELSE ltav.has_thalasemia
				END,
				CASE
					WHEN (ltav.has_syphilis = '') IS NOT FALSE THEN '-'
					ELSE ltav.has_syphilis
				END,
				CASE
					WHEN (ltav.has_hbsag = '') IS NOT FALSE THEN '-'
					ELSE ltav.has_hbsag
				END,
				CASE
					WHEN (ltav.has_hiv = '') IS NOT FALSE THEN '-'
					ELSE ltav.has_hiv
				END )
			FROM
				"sid_bidan".lab_test_anc_visit ltav
			WHERE
				mother_base_entity_id = av_sub1.mother_base_entity_id
			ORDER BY
				server_version_epoch DESC
			LIMIT 1 )
			ELSE '-,-,-,-,-,-,-'
		END )
	FROM
		"sid_bidan".anc_visit av_sub1
	INNER JOIN (
		SELECT
			MAX(av_sub2.event_id) AS latest_event_id
		FROM
			"sid_bidan".anc_visit av_sub2
		INNER JOIN (
			SELECT
				mother_base_entity_id,
				MAX(anc_date) AS latest_anc_date
			FROM
				"sid_bidan".anc_visit av_sub3
			GROUP BY
				mother_base_entity_id) av_max_anc_date ON
			(av_sub2.mother_base_entity_id = av_max_anc_date.mother_base_entity_id
				AND av_sub2.anc_date = av_max_anc_date.latest_anc_date)
		GROUP BY
			av_sub2.mother_base_entity_id,
			av_sub2.anc_date) av_max_event_id ON
		av_sub1.event_id = av_max_event_id.latest_event_id
	WHERE
		av_sub1.mother_base_entity_id = mi.mother_base_entity_id
		AND av_sub1.event_id > ${lastEventID}) AS pregnancyGapCommaSeparatedValues
FROM
	"sid_bidan".mother_identity mi
WHERE
	mi.event_id IN (
	SELECT
		MAX(mi_id_only.event_id)
	FROM
		"sid_bidan".mother_identity mi_id_only
	INNER JOIN "sid_bidan".anc_visit av ON
		mi_id_only.mother_base_entity_id = av.mother_base_entity_id
	WHERE
		mi_id_only.mobile_phone_number IS NOT NULL
		AND mi_id_only.provider_id NOT ILIKE '%demo%'
		AND mi_id_only.mother_base_entity_id IN (
		SELECT
			ar.mother_base_entity_id
		FROM
			"sid_bidan".anc_register ar
		WHERE
			ar.is_consented_whatsapp IS NULL
			OR ar.is_consented_whatsapp != 'Tidak' )
		AND av.event_id > ${lastEventID}
	GROUP BY
		mi_id_only.mobile_phone_number)
ORDER BY
	mi.event_id