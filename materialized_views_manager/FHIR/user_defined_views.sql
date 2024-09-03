-- Login with "materialized_views_manager" to run these, ensure connected DB is correct

-- Change the values (if needed) and execute these first to assign non-dynamic variables in DBeaver (can be executed per line, not yet know if can be bulk). Reference: https://dbeaver.com/docs/dbeaver/Client-Side-Scripting/
@set schemaName = user_defined_views
@set userNamesToBeGrantedReadPermissions = "metabase_scraper", "owner_materialized_views", "bigquery_scraper", "readonly_opensrp", "fhir_data_pipes" --, "readonly" 

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.7
-- Dumped by pg_dump version 15.3

-- Started on 2024-08-28 21:50:58

-- -- Levi: I think does not need these to generate views for `${schemaName}` schema
-- SET statement_timeout = 0;
-- SET lock_timeout = 0;
-- SET idle_in_transaction_session_timeout = 0;
-- SET client_encoding = 'UTF8';
-- SET standard_conforming_strings = on;
-- SELECT pg_catalog.set_config('search_path', '', false);
-- SET check_function_bodies = false;
-- SET xmloption = content;
-- SET client_min_messages = warning;
-- SET row_security = off;

--
-- TOC entry 576 (class 1259 OID 878049)
-- Name: AllergyIntolerance_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."AllergyIntolerance_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('AllergyIntolerance', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "AllergyIntolerance.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{clinicalStatus,coding}'::text[]) AS "AllergyIntolerance.clinicalStatus.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "AllergyIntolerance.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "AllergyIntolerance.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "AllergyIntolerance.encounter.reference",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,type}'::text[]) AS "AllergyIntolerance.encounter.type",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "AllergyIntolerance.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{patient,reference}'::text[]) AS "AllergyIntolerance.patient.reference",
    ((hrv.res_text_vc)::jsonb #>> '{patient,type}'::text[]) AS "AllergyIntolerance.patient.type",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "AllergyIntolerance.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{type}'::text[]) AS "AllergyIntolerance.type",
    ((hrv.res_text_vc)::jsonb #>> '{verificationStatus,coding}'::text[]) AS "AllergyIntolerance.verificationStatus.coding"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'AllergyIntolerance'::text);


ALTER TABLE ${schemaName}."AllergyIntolerance_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 583 (class 1259 OID 2508823)
-- Name: Binary_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Binary_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Binary', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Binary.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{contentType}'::text[]) AS "Binary.contentType",
    ((hrv.res_text_vc)::jsonb #>> '{data}'::text[]) AS "Binary.data",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Binary.resourceType"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Binary'::text);


ALTER TABLE ${schemaName}."Binary_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 584 (class 1259 OID 2508829)
-- Name: CarePlan_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."CarePlan_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('CarePlan', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "CarePlan.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{activity}'::text[]) AS "CarePlan.activity",
    ((hrv.res_text_vc)::jsonb #>> '{author,reference}'::text[]) AS "CarePlan.author.reference",
    ((hrv.res_text_vc)::jsonb #>> '{category}'::text[]) AS "CarePlan.category",
    ((hrv.res_text_vc)::jsonb #>> '{created}'::text[]) AS "CarePlan.created",
    ((hrv.res_text_vc)::jsonb #>> '{description}'::text[]) AS "CarePlan.description",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "CarePlan.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{instantiatesCanonical}'::text[]) AS "CarePlan.instantiatesCanonical",
    ((hrv.res_text_vc)::jsonb #>> '{intent}'::text[]) AS "CarePlan.intent",
    ((hrv.res_text_vc)::jsonb #>> '{period,end}'::text[]) AS "CarePlan.period.end",
    ((hrv.res_text_vc)::jsonb #>> '{period,start}'::text[]) AS "CarePlan.period.start",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "CarePlan.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "CarePlan.status",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "CarePlan.subject.reference",
    ((hrv.res_text_vc)::jsonb #>> '{title}'::text[]) AS "CarePlan.title"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'CarePlan'::text);


ALTER TABLE ${schemaName}."CarePlan_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 585 (class 1259 OID 2508835)
-- Name: CareTeam_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."CareTeam_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('CareTeam', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "CareTeam.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "CareTeam.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{managingOrganization}'::text[]) AS "CareTeam.managingOrganization",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "CareTeam.name",
    ((hrv.res_text_vc)::jsonb #>> '{participant}'::text[]) AS "CareTeam.participant",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "CareTeam.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "CareTeam.status"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'CareTeam'::text);


ALTER TABLE ${schemaName}."CareTeam_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 586 (class 1259 OID 2508841)
-- Name: Composition_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Composition_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Composition', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Composition.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{confidentiality}'::text[]) AS "Composition.confidentiality",
    ((hrv.res_text_vc)::jsonb #>> '{date}'::text[]) AS "Composition.date",
    ((hrv.res_text_vc)::jsonb #>> '{identifier,use}'::text[]) AS "Composition.identifier.use",
    ((hrv.res_text_vc)::jsonb #>> '{identifier,value}'::text[]) AS "Composition.identifier.value",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Composition.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{section}'::text[]) AS "Composition.section",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Composition.status",
    ((hrv.res_text_vc)::jsonb #>> '{title}'::text[]) AS "Composition.title",
    ((hrv.res_text_vc)::jsonb #>> '{type,coding}'::text[]) AS "Composition.type.coding"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Composition'::text);


ALTER TABLE ${schemaName}."Composition_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 587 (class 1259 OID 2508847)
-- Name: Condition_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Condition_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Condition', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Condition.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{category}'::text[]) AS "Condition.category",
    ((hrv.res_text_vc)::jsonb #>> '{clinicalStatus,coding}'::text[]) AS "Condition.clinicalStatus.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "Condition.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "Condition.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "Condition.encounter.reference",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Condition.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{onsetDateTime}'::text[]) AS "Condition.onsetDateTime",
    ((hrv.res_text_vc)::jsonb #>> '{recordedDate}'::text[]) AS "Condition.recordedDate",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Condition.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "Condition.subject.reference",
    ((hrv.res_text_vc)::jsonb #>> '{subject,type}'::text[]) AS "Condition.subject.type",
    ((hrv.res_text_vc)::jsonb #>> '{verificationStatus,coding}'::text[]) AS "Condition.verificationStatus.coding"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Condition'::text);


ALTER TABLE ${schemaName}."Condition_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 588 (class 1259 OID 2508853)
-- Name: Coverage_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Coverage_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Coverage', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Coverage.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Coverage.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Coverage.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{subscriber,reference}'::text[]) AS "Coverage.subscriber.reference",
    ((hrv.res_text_vc)::jsonb #>> '{subscriber,type}'::text[]) AS "Coverage.subscriber.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Coverage'::text);


ALTER TABLE ${schemaName}."Coverage_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 589 (class 1259 OID 2508859)
-- Name: DiagnosticReport_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."DiagnosticReport_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('DiagnosticReport', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "DiagnosticReport.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "DiagnosticReport.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "DiagnosticReport.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "DiagnosticReport.encounter.reference",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "DiagnosticReport.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{result}'::text[]) AS "DiagnosticReport.result",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "DiagnosticReport.status",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "DiagnosticReport.subject.reference",
    ((hrv.res_text_vc)::jsonb #>> '{text,div}'::text[]) AS "DiagnosticReport.text.div",
    ((hrv.res_text_vc)::jsonb #>> '{text,status}'::text[]) AS "DiagnosticReport.text.status"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'DiagnosticReport'::text);


ALTER TABLE ${schemaName}."DiagnosticReport_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 590 (class 1259 OID 2508865)
-- Name: Encounter_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Encounter_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Encounter', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Encounter.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{class,code}'::text[]) AS "Encounter.class.code",
    ((hrv.res_text_vc)::jsonb #>> '{class,display}'::text[]) AS "Encounter.class.display",
    ((hrv.res_text_vc)::jsonb #>> '{class,system}'::text[]) AS "Encounter.class.system",
    ((hrv.res_text_vc)::jsonb #>> '{extension}'::text[]) AS "Encounter.extension",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Encounter.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{location}'::text[]) AS "Encounter.location",
    ((hrv.res_text_vc)::jsonb #>> '{participant}'::text[]) AS "Encounter.participant",
    ((hrv.res_text_vc)::jsonb #>> '{period,end}'::text[]) AS "Encounter.period.end",
    ((hrv.res_text_vc)::jsonb #>> '{period,start}'::text[]) AS "Encounter.period.start",
    ((hrv.res_text_vc)::jsonb #>> '{priority,coding}'::text[]) AS "Encounter.priority.coding",
    ((hrv.res_text_vc)::jsonb #>> '{priority,text}'::text[]) AS "Encounter.priority.text",
    ((hrv.res_text_vc)::jsonb #>> '{reasonCode}'::text[]) AS "Encounter.reasonCode",
    ((hrv.res_text_vc)::jsonb #>> '{reasonReference}'::text[]) AS "Encounter.reasonReference",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Encounter.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{serviceProvider,reference}'::text[]) AS "Encounter.serviceProvider.reference",
    ((hrv.res_text_vc)::jsonb #>> '{serviceProvider,type}'::text[]) AS "Encounter.serviceProvider.type",
    ((hrv.res_text_vc)::jsonb #>> '{serviceType,coding}'::text[]) AS "Encounter.serviceType.coding",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Encounter.status",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "Encounter.subject.reference",
    ((hrv.res_text_vc)::jsonb #>> '{subject,type}'::text[]) AS "Encounter.subject.type",
    ((hrv.res_text_vc)::jsonb #>> '{type}'::text[]) AS "Encounter.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Encounter'::text);


ALTER TABLE ${schemaName}."Encounter_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 577 (class 1259 OID 878097)
-- Name: EpisodeOfCare_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."EpisodeOfCare_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('EpisodeOfCare', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "EpisodeOfCare.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "EpisodeOfCare.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "EpisodeOfCare.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{type}'::text[]) AS "EpisodeOfCare.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'EpisodeOfCare'::text);


ALTER TABLE ${schemaName}."EpisodeOfCare_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 591 (class 1259 OID 2508871)
-- Name: Flag_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Flag_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Flag', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Flag.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{author,reference}'::text[]) AS "Flag.author.reference",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "Flag.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "Flag.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "Flag.encounter.reference",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Flag.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{period,end}'::text[]) AS "Flag.period.end",
    ((hrv.res_text_vc)::jsonb #>> '{period,start}'::text[]) AS "Flag.period.start",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Flag.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "Flag.subject.reference"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Flag'::text);


ALTER TABLE ${schemaName}."Flag_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 592 (class 1259 OID 2508877)
-- Name: Group_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Group_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Group', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Group.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{active}'::text[]) AS "Group.active",
    ((hrv.res_text_vc)::jsonb #>> '{actual}'::text[]) AS "Group.actual",
    ((hrv.res_text_vc)::jsonb #>> '{characteristic}'::text[]) AS "Group.characteristic",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "Group.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Group.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{managingEntity,reference}'::text[]) AS "Group.managingEntity.reference",
    ((hrv.res_text_vc)::jsonb #>> '{member}'::text[]) AS "Group.member",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "Group.name",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Group.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{type}'::text[]) AS "Group.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Group'::text);


ALTER TABLE ${schemaName}."Group_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 593 (class 1259 OID 2508883)
-- Name: Immunization_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Immunization_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Immunization', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Immunization.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "Immunization.encounter.reference",
        ((hrv.res_text_vc)::jsonb #>> '{encounter,type}'::text[]) AS "Immunization.encounter.type",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Immunization.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{lotNumber}'::text[]) AS "Immunization.lotNumber",
    ((hrv.res_text_vc)::jsonb #>> '{occurrenceDateTime}'::text[]) AS "Immunization.occurrenceDateTime",
    ((hrv.res_text_vc)::jsonb #>> '{occurrenceString}'::text[]) AS "Immunization.occurrenceString",
    ((hrv.res_text_vc)::jsonb #>> '{patient,reference}'::text[]) AS "Immunization.patient.reference",
    ((hrv.res_text_vc)::jsonb #>> '{patient,type}'::text[]) AS "Immunization.patient.type",
    ((hrv.res_text_vc)::jsonb #>> '{protocolApplied}'::text[]) AS "Immunization.protocolApplied",
    ((hrv.res_text_vc)::jsonb #>> '{recorded}'::text[]) AS "Immunization.recorded",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Immunization.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Immunization.status",
    ((hrv.res_text_vc)::jsonb #>> '{vaccineCode,coding}'::text[]) AS "Immunization.vaccineCode.coding",
    ((hrv.res_text_vc)::jsonb #>> '{vaccineCode,text}'::text[]) AS "Immunization.vaccineCode.text"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Immunization'::text);


ALTER TABLE ${schemaName}."Immunization_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 594 (class 1259 OID 2508889)
-- Name: List_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."List_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('List', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "List.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "List.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "List.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{entry}'::text[]) AS "List.entry",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "List.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{mode}'::text[]) AS "List.mode",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "List.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "List.status",
    ((hrv.res_text_vc)::jsonb #>> '{title}'::text[]) AS "List.title"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'List'::text);


ALTER TABLE ${schemaName}."List_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 595 (class 1259 OID 2508895)
-- Name: Location_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Location_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Location', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Location.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{alias}'::text[]) AS "Location.alias",
    ((hrv.res_text_vc)::jsonb #>> '{description}'::text[]) AS "Location.description",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Location.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "Location.name",
    ((hrv.res_text_vc)::jsonb #>> '{partOf,display}'::text[]) AS "Location.partOf.display",
    ((hrv.res_text_vc)::jsonb #>> '{partOf,reference}'::text[]) AS "Location.partOf.reference",
    ((hrv.res_text_vc)::jsonb #>> '{physicalType,coding}'::text[]) AS "Location.physicalType.coding",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Location.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Location.status",
    ((hrv.res_text_vc)::jsonb #>> '{type}'::text[]) AS "Location.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Location'::text);


ALTER TABLE ${schemaName}."Location_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 597 (class 1259 OID 2508907)
-- Name: MedicationRequest_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."MedicationRequest_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('MedicationRequest', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "MedicationRequest.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "MedicationRequest.encounter.reference",
    ((hrv.res_text_vc)::jsonb #>> '{intent}'::text[]) AS "MedicationRequest.intent",
    ((hrv.res_text_vc)::jsonb #>> '{medicationReference,reference}'::text[]) AS "MedicationRequest.medicationReference.reference",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "MedicationRequest.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "MedicationRequest.status",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "MedicationRequest.subject.reference"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'MedicationRequest'::text);


ALTER TABLE ${schemaName}."MedicationRequest_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 578 (class 1259 OID 878127)
-- Name: MedicationStatement_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."MedicationStatement_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('MedicationStatement', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "MedicationStatement.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{context,reference}'::text[]) AS "MedicationStatement.context.reference",
    ((hrv.res_text_vc)::jsonb #>> '{context,type}'::text[]) AS "MedicationStatement.context.type",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "MedicationStatement.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{medicationCodeableConcept,coding}'::text[]) AS "MedicationStatement.medicationCodeableConcept.coding",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "MedicationStatement.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "MedicationStatement.subject.reference",
    ((hrv.res_text_vc)::jsonb #>> '{subject,type}'::text[]) AS "MedicationStatement.subject.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'MedicationStatement'::text);


ALTER TABLE ${schemaName}."MedicationStatement_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 596 (class 1259 OID 2508901)
-- Name: Medication_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Medication_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Medication', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Medication.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "Medication.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Medication.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{text,div}'::text[]) AS "Medication.text.div",
    ((hrv.res_text_vc)::jsonb #>> '{text,status}'::text[]) AS "Medication.text.status"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Medication'::text);


ALTER TABLE ${schemaName}."Medication_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 598 (class 1259 OID 2508913)
-- Name: Observation_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Observation_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Observation', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Observation.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{category}'::text[]) AS "Observation.category",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "Observation.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "Observation.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{component}'::text[]) AS "Observation.component",
    ((hrv.res_text_vc)::jsonb #>> '{code,_text,extension}'::text[]) AS "Observation.code._text.extension",
    ((hrv.res_text_vc)::jsonb #>> '{effectiveDateTime}'::text[]) AS "Observation.effectiveDateTime",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "Observation.encounter.reference",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,type}'::text[]) AS "Observation.encounter.type",
    ((hrv.res_text_vc)::jsonb #>> '{extension}'::text[]) AS "Observation.extension",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Observation.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{interpretation}'::text[]) AS "Observation.interpretation",
    ((hrv.res_text_vc)::jsonb #>> '{performer}'::text[]) AS "Observation.performer",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Observation.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Observation.status",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "Observation.subject.reference",
    ((hrv.res_text_vc)::jsonb #>> '{subject,type}'::text[]) AS "Observation.subject.type",
    ((hrv.res_text_vc)::jsonb #>> '{valueCodeableConcept,coding}'::text[]) AS "Observation.valueCodeableConcept.coding",
    ((hrv.res_text_vc)::jsonb #>> '{valueCodeableConcept,text}'::text[]) AS "Observation.valueCodeableConcept.text",
    ((hrv.res_text_vc)::jsonb #>> '{valueCodeableConcept,_text,extension}'::text[]) AS "Observation.valueCodeableConcept._text.extension",
    ((hrv.res_text_vc)::jsonb #>> '{valueDateTime}'::text[]) AS "Observation.valueDateTime",
    ((hrv.res_text_vc)::jsonb #>> '{valueInteger}'::text[]) AS "Observation.valueInteger",
    ((hrv.res_text_vc)::jsonb #>> '{valueQuantity,code}'::text[]) AS "Observation.valueQuantity.code",
    ((hrv.res_text_vc)::jsonb #>> '{valueQuantity,comparator}'::text[]) AS "Observation.valueQuantity.comparator",
    ((hrv.res_text_vc)::jsonb #>> '{valueQuantity,system}'::text[]) AS "Observation.valueQuantity.system",
    ((hrv.res_text_vc)::jsonb #>> '{valueQuantity,unit}'::text[]) AS "Observation.valueQuantity.unit",
    ((hrv.res_text_vc)::jsonb #>> '{valueQuantity,value}'::text[]) AS "Observation.valueQuantity.value",
    ((hrv.res_text_vc)::jsonb #>> '{valueString}'::text[]) AS "Observation.valueString"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Observation'::text);


ALTER TABLE ${schemaName}."Observation_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 600 (class 1259 OID 2508925)
-- Name: OrganizationAffiliation_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."OrganizationAffiliation_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('OrganizationAffiliation', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "OrganizationAffiliation.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{active}'::text[]) AS "OrganizationAffiliation.active",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "OrganizationAffiliation.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{location}'::text[]) AS "OrganizationAffiliation.location",
    ((hrv.res_text_vc)::jsonb #>> '{organization,display}'::text[]) AS "OrganizationAffiliation.organization.display",
    ((hrv.res_text_vc)::jsonb #>> '{organization,reference}'::text[]) AS "OrganizationAffiliation.organization.reference",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "OrganizationAffiliation.resourceType"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'OrganizationAffiliation'::text);


ALTER TABLE ${schemaName}."OrganizationAffiliation_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 599 (class 1259 OID 2508919)
-- Name: Organization_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Organization_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Organization', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Organization.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{active}'::text[]) AS "Organization.active",
    ((hrv.res_text_vc)::jsonb #>> '{address}'::text[]) AS "Organization.address",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Organization.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "Organization.name",
    ((hrv.res_text_vc)::jsonb #>> '{partOf,reference}'::text[]) AS "Organization.partOf.reference",
    ((hrv.res_text_vc)::jsonb #>> '{partOf,type}'::text[]) AS "Organization.partOf.type",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Organization.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{type}'::text[]) AS "Organization.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Organization'::text);


ALTER TABLE ${schemaName}."Organization_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 601 (class 1259 OID 2508931)
-- Name: Patient_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Patient_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Patient', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Patient.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{active}'::text[]) AS "Patient.active",
    ((hrv.res_text_vc)::jsonb #>> '{address}'::text[]) AS "Patient.address",
    ((hrv.res_text_vc)::jsonb #>> '{birthDate}'::text[]) AS "Patient.birthDate",
    ((hrv.res_text_vc)::jsonb #>> '{extension}'::text[]) AS "Patient.extension",
    ((hrv.res_text_vc)::jsonb #>> '{gender}'::text[]) AS "Patient.gender",
    ((hrv.res_text_vc)::jsonb #>> '{generalPractitioner}'::text[]) AS "Patient.generalPractitioner",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Patient.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{managingOrganization,reference}'::text[]) AS "Patient.managingOrganization.reference",
    ((hrv.res_text_vc)::jsonb #>> '{managingOrganization,type}'::text[]) AS "Patient.managingOrganization.type",
    ((hrv.res_text_vc)::jsonb #>> '{maritalStatus,coding}'::text[]) AS "Patient.maritalStatus.coding",
    ((hrv.res_text_vc)::jsonb #>> '{maritalStatus,text}'::text[]) AS "Patient.maritalStatus.text",
    ((hrv.res_text_vc)::jsonb #>> '{maritalStatus,_text,extension}'::text[]) AS "Patient.maritalStatus._text.extension",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "Patient.name",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Patient.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{telecom}'::text[]) AS "Patient.telecom",
    ((hrv.res_text_vc)::jsonb #>> '{text,div}'::text[]) AS "Patient.text.div",
    ((hrv.res_text_vc)::jsonb #>> '{text,status}'::text[]) AS "Patient.text.status"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Patient'::text);


ALTER TABLE ${schemaName}."Patient_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 602 (class 1259 OID 2508937)
-- Name: PlanDefinition_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."PlanDefinition_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('PlanDefinition', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "PlanDefinition.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{action}'::text[]) AS "PlanDefinition.action",
    ((hrv.res_text_vc)::jsonb #>> '{contained}'::text[]) AS "PlanDefinition.contained",
    ((hrv.res_text_vc)::jsonb #>> '{description}'::text[]) AS "PlanDefinition.description",
    ((hrv.res_text_vc)::jsonb #>> '{goal}'::text[]) AS "PlanDefinition.goal",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "PlanDefinition.name",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "PlanDefinition.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "PlanDefinition.status",
    ((hrv.res_text_vc)::jsonb #>> '{title}'::text[]) AS "PlanDefinition.title"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'PlanDefinition'::text);


ALTER TABLE ${schemaName}."PlanDefinition_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 604 (class 1259 OID 2508949)
-- Name: PractitionerRole_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."PractitionerRole_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('PractitionerRole', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "PractitionerRole.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{active}'::text[]) AS "PractitionerRole.active",
    ((hrv.res_text_vc)::jsonb #>> '{code}'::text[]) AS "PractitionerRole.code",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "PractitionerRole.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{organization,display}'::text[]) AS "PractitionerRole.organization.display",
    ((hrv.res_text_vc)::jsonb #>> '{organization,reference}'::text[]) AS "PractitionerRole.organization.reference",
    ((hrv.res_text_vc)::jsonb #>> '{practitioner,display}'::text[]) AS "PractitionerRole.practitioner.display",
    ((hrv.res_text_vc)::jsonb #>> '{practitioner,reference}'::text[]) AS "PractitionerRole.practitioner.reference",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "PractitionerRole.resourceType"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'PractitionerRole'::text);


ALTER TABLE ${schemaName}."PractitionerRole_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 603 (class 1259 OID 2508943)
-- Name: Practitioner_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Practitioner_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Practitioner', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Practitioner.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{active}'::text[]) AS "Practitioner.active",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Practitioner.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "Practitioner.name",
    ((hrv.res_text_vc)::jsonb #>> '{qualification}'::text[]) AS "Practitioner.qualification",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Practitioner.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{telecom}'::text[]) AS "Practitioner.telecom"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Practitioner'::text);


ALTER TABLE ${schemaName}."Practitioner_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 605 (class 1259 OID 2508955)
-- Name: Procedure_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Procedure_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Procedure', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Procedure.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "Procedure.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "Procedure.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{encounter,reference}'::text[]) AS "Procedure.encounter.reference",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Procedure.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{performedDateTime}'::text[]) AS "Procedure.performedDateTime",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Procedure.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Procedure.status",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "Procedure.subject.reference",
    ((hrv.res_text_vc)::jsonb #>> '{subject,type}'::text[]) AS "Procedure.subject.type"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Procedure'::text);


ALTER TABLE ${schemaName}."Procedure_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 607 (class 1259 OID 2508967)
-- Name: QuestionnaireResponse_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."QuestionnaireResponse_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('QuestionnaireResponse', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "QuestionnaireResponse.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{authored}'::text[]) AS "QuestionnaireResponse.authored",
    ((hrv.res_text_vc)::jsonb #>> '{author,reference}'::text[]) AS "QuestionnaireResponse.author.reference",
    ((hrv.res_text_vc)::jsonb #>> '{contained}'::text[]) AS "QuestionnaireResponse.contained",
    ((hrv.res_text_vc)::jsonb #>> '{item}'::text[]) AS "QuestionnaireResponse.item",
    ((hrv.res_text_vc)::jsonb #>> '{questionnaire}'::text[]) AS "QuestionnaireResponse.questionnaire",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "QuestionnaireResponse.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "QuestionnaireResponse.status",
    ((hrv.res_text_vc)::jsonb #>> '{subject,reference}'::text[]) AS "QuestionnaireResponse.subject.reference"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'QuestionnaireResponse'::text);


ALTER TABLE ${schemaName}."QuestionnaireResponse_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 606 (class 1259 OID 2508961)
-- Name: Questionnaire_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Questionnaire_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Questionnaire', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Questionnaire.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{contact}'::text[]) AS "Questionnaire.contact",
    ((hrv.res_text_vc)::jsonb #>> '{date}'::text[]) AS "Questionnaire.date",
    ((hrv.res_text_vc)::jsonb #>> '{description}'::text[]) AS "Questionnaire.description",
    ((hrv.res_text_vc)::jsonb #>> '{extension}'::text[]) AS "Questionnaire.extension",
    ((hrv.res_text_vc)::jsonb #>> '{item}'::text[]) AS "Questionnaire.item",
    ((hrv.res_text_vc)::jsonb #>> '{language}'::text[]) AS "Questionnaire.language",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "Questionnaire.name",
    ((hrv.res_text_vc)::jsonb #>> '{publisher}'::text[]) AS "Questionnaire.publisher",
    ((hrv.res_text_vc)::jsonb #>> '{purpose}'::text[]) AS "Questionnaire.purpose",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Questionnaire.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Questionnaire.status",
    ((hrv.res_text_vc)::jsonb #>> '{subjectType}'::text[]) AS "Questionnaire.subjectType",
    ((hrv.res_text_vc)::jsonb #>> '{title}'::text[]) AS "Questionnaire.title",
    ((hrv.res_text_vc)::jsonb #>> '{_title,extension}'::text[]) AS "Questionnaire._title.extension",
    ((hrv.res_text_vc)::jsonb #>> '{useContext}'::text[]) AS "Questionnaire.useContext",
    ((hrv.res_text_vc)::jsonb #>> '{version}'::text[]) AS "Questionnaire.version"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Questionnaire'::text);


ALTER TABLE ${schemaName}."Questionnaire_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 608 (class 1259 OID 2508973)
-- Name: RelatedPerson_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."RelatedPerson_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('RelatedPerson', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "RelatedPerson.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{active}'::text[]) AS "RelatedPerson.active",
    ((hrv.res_text_vc)::jsonb #>> '{birthDate}'::text[]) AS "RelatedPerson.birthDate",
    ((hrv.res_text_vc)::jsonb #>> '{gender}'::text[]) AS "RelatedPerson.gender",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "RelatedPerson.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "RelatedPerson.name",
    ((hrv.res_text_vc)::jsonb #>> '{patient,reference}'::text[]) AS "RelatedPerson.patient.reference",
    ((hrv.res_text_vc)::jsonb #>> '{patient,type}'::text[]) AS "RelatedPerson.patient.type",
    ((hrv.res_text_vc)::jsonb #>> '{relationship}'::text[]) AS "RelatedPerson.relationship",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "RelatedPerson.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{telecom}'::text[]) AS "RelatedPerson.telecom"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'RelatedPerson'::text);


ALTER TABLE ${schemaName}."RelatedPerson_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 609 (class 1259 OID 2508979)
-- Name: StructureMap_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."StructureMap_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('StructureMap', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "StructureMap.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{group}'::text[]) AS "StructureMap.group",
    ((hrv.res_text_vc)::jsonb #>> '{name}'::text[]) AS "StructureMap.name",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "StructureMap.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{structure}'::text[]) AS "StructureMap.structure",
    ((hrv.res_text_vc)::jsonb #>> '{text,div}'::text[]) AS "StructureMap.text.div",
    ((hrv.res_text_vc)::jsonb #>> '{text,status}'::text[]) AS "StructureMap.text.status",
    ((hrv.res_text_vc)::jsonb #>> '{url}'::text[]) AS "StructureMap.url"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'StructureMap'::text);


ALTER TABLE ${schemaName}."StructureMap_all_versions_view" OWNER TO owner_materialized_views;

--
-- TOC entry 610 (class 1259 OID 2508985)
-- Name: Task_all_versions_view; Type: VIEW; Schema: ${schemaName}; Owner: owner_materialized_views
--

CREATE OR REPLACE VIEW ${schemaName}."Task_all_versions_view" AS
 SELECT hrv.pid,
    hrv.partition_date,
    hrv.partition_id,
    hrv.res_deleted_at,
    hrv.res_version,
    hrv.has_tags,
    hrv.res_published,
    hrv.res_updated,
    hrv.res_encoding,
    hrv.res_text,
    hrv.res_id,
    hrv.res_type,
    hrv.res_ver,
    concat('Task', '/',
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id))) THEN (( SELECT hfi.forced_id
               FROM public.hfj_forced_id hfi
              WHERE (hfi.resource_pid = hrv.res_id)))::text
            ELSE (hrv.res_id)::text
        END) AS "Task.referenceString",
    ((hrv.res_text_vc)::jsonb #>> '{authoredOn}'::text[]) AS "Task.authoredOn",
    ((hrv.res_text_vc)::jsonb #>> '{basedOn}'::text[]) AS "Task.basedOn",
    ((hrv.res_text_vc)::jsonb #>> '{code,coding}'::text[]) AS "Task.code.coding",
    ((hrv.res_text_vc)::jsonb #>> '{code,text}'::text[]) AS "Task.code.text",
    ((hrv.res_text_vc)::jsonb #>> '{description}'::text[]) AS "Task.description",
    ((hrv.res_text_vc)::jsonb #>> '{executionPeriod,end}'::text[]) AS "Task.executionPeriod.end",
    ((hrv.res_text_vc)::jsonb #>> '{executionPeriod,start}'::text[]) AS "Task.executionPeriod.start",
    ((hrv.res_text_vc)::jsonb #>> '{for,reference}'::text[]) AS "Task.for.reference",
    ((hrv.res_text_vc)::jsonb #>> '{groupIdentifier,use}'::text[]) AS "Task.groupIdentifier.use",
    ((hrv.res_text_vc)::jsonb #>> '{groupIdentifier,value}'::text[]) AS "Task.groupIdentifier.value",
    ((hrv.res_text_vc)::jsonb #>> '{identifier}'::text[]) AS "Task.identifier",
    ((hrv.res_text_vc)::jsonb #>> '{input}'::text[]) AS "Task.input",
    ((hrv.res_text_vc)::jsonb #>> '{intent}'::text[]) AS "Task.intent",
    ((hrv.res_text_vc)::jsonb #>> '{lastModified}'::text[]) AS "Task.lastModified",
    ((hrv.res_text_vc)::jsonb #>> '{output}'::text[]) AS "Task.output",
    ((hrv.res_text_vc)::jsonb #>> '{owner,reference}'::text[]) AS "Task.owner.reference",
    ((hrv.res_text_vc)::jsonb #>> '{partOf}'::text[]) AS "Task.partOf",
    ((hrv.res_text_vc)::jsonb #>> '{priority}'::text[]) AS "Task.priority",
    ((hrv.res_text_vc)::jsonb #>> '{reasonCode,coding}'::text[]) AS "Task.reasonCode.coding",
    ((hrv.res_text_vc)::jsonb #>> '{reasonCode,text}'::text[]) AS "Task.reasonCode.text",
    ((hrv.res_text_vc)::jsonb #>> '{reasonReference,reference}'::text[]) AS "Task.reasonReference.reference",
    ((hrv.res_text_vc)::jsonb #>> '{requester,reference}'::text[]) AS "Task.requester.reference",
    ((hrv.res_text_vc)::jsonb #>> '{resourceType}'::text[]) AS "Task.resourceType",
    ((hrv.res_text_vc)::jsonb #>> '{restriction,period,end}'::text[]) AS "Task.restriction.period.end",
    ((hrv.res_text_vc)::jsonb #>> '{restriction,period,start}'::text[]) AS "Task.restriction.period.start",
    ((hrv.res_text_vc)::jsonb #>> '{status}'::text[]) AS "Task.status"
   FROM public.hfj_res_ver hrv
  WHERE ((hrv.res_type)::text = 'Task'::text);


ALTER TABLE ${schemaName}."Task_all_versions_view" OWNER TO owner_materialized_views;


-- Completed on 2024-08-28 21:50:58

--
-- PostgreSQL database dump complete
--

-- Grant read-only permissions to some users for accessing the (materialized) views
GRANT USAGE ON
SCHEMA
"${schemaName}"
TO ${userNamesToBeGrantedReadPermissions}
;

GRANT
SELECT
	ON
	ALL TABLES IN SCHEMA
    "${schemaName}"
TO ${userNamesToBeGrantedReadPermissions}
;

ALTER DEFAULT PRIVILEGES IN SCHEMA
"${schemaName}"
GRANT
SELECT
	ON
	TABLES TO ${userNamesToBeGrantedReadPermissions}
;