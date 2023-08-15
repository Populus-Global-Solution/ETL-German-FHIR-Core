--Create cds_etl_helper.post_process_map table and its indexies
DO $$
BEGIN
CREATE SCHEMA IF NOT EXISTS cds_etl_helper;
CREATE TABLE IF NOT EXISTS cds_etl_helper.post_process_map(
data_id bigserial, type varchar(64) not null, data_one varchar(255), data_two varchar(255),
omop_id bigint, omop_table varchar(64) not null, fhir_logical_id varchar(250), fhir_identifier varchar(250));
CREATE INDEX IF NOT EXISTS idx_fhir_type ON cds_etl_helper.post_process_map (type);
CREATE INDEX IF NOT EXISTS idx_omop_table ON cds_etl_helper.post_process_map (omop_table);
CREATE INDEX IF NOT EXISTS idx_fhir_logical_id_identifier_post_process ON cds_etl_helper.post_process_map (fhir_logical_id ASC,fhir_identifier ASC);
END
$$;

--Create cds_etl_helper.medication_id_map and its indexies
Do $$
BEGIN
CREATE TABLE IF NOT EXISTS cds_etl_helper.medication_id_map (
fhir_omop_id SERIAL NOT NULL, type varchar(64) NOT NULL, fhir_logical_id varchar(250),
fhir_identifier varchar(250), atc varchar(64) NOT NULL,
CONSTRAINT xpk_medication_id_map PRIMARY KEY (fhir_omop_id));
END
$$;

--cds_etl_helper.snomed_vaccine_standard_lookup source

DO $$
BEGIN
CREATE materialized VIEW IF NOT EXISTS cds_etl_helper.snomed_vaccine_standard_lookup AS
  SELECT c1.concept_code     AS snomed_code,
         c1.concept_id       AS snomed_concept_id,
         cr.concept_id_2     AS standard_vaccine_concept_id,
         c2.domain_id        AS standard_vaccine_domain_id,
         c1.valid_start_date AS snomed_valid_start_date,
         c1.valid_end_date   AS snomed_valid_end_date
  FROM   cdm.concept c1
  JOIN   cdm.concept_relationship cr
  ON     c1.concept_id = cr.concept_id_1
  JOIN   cdm.concept c2
  ON     cr.concept_id_2 = c2.concept_id
  WHERE  1 = 1
  AND    c1.vocabulary_id::text = 'SNOMED'::text
  AND    cr.relationship_id::text = 'Maps to'::text
  AND    c1.domain_id ='Drug'
  AND    c2.domain_id ='Drug'
  WITH data;
END
$$;


--cds_etl_helper.snomed_race_standard_lookup source
DO $$
BEGIN
CREATE materialized VIEW IF NOT EXISTS cds_etl_helper.snomed_race_standard_lookup AS
  SELECT c1.concept_code AS snomed_code,
         c1.concept_id   AS snomed_concept_id,
         cr.concept_id_2 AS standard_race_concept_id
  FROM   cdm.concept c1
  JOIN   cdm.concept_relationship cr
  ON     c1.concept_id = cr.concept_id_1
  JOIN   cdm.concept c2
  ON     cr.concept_id_2 = c2.concept_id
  WHERE  1 = 1
  AND    c1.vocabulary_id::text = 'SNOMED'::text
  AND    cr.relationship_id::text = 'Maps to'::text
  AND    c1.domain_id::text = 'Race'::text WITH data;
END
$$;

DO $$
BEGIN
CREATE MATERIALIZED VIEW IF NOT EXISTS cds_etl_helper.icd_snomed_domain_lookup AS
  SELECT c1.concept_code AS icd_gm_code,
         c1.concept_id AS icd_gm_concept_id,
         cr.concept_id_2 AS snomed_concept_id,
         c2.domain_id AS snomed_domain_id,
         c3.domain_concept_id AS snomed_domain_concept_id,
         c1.valid_start_date AS icd_gm_valid_start_date,
         c1.valid_end_date AS icd_gm_valid_end_date
  FROM cdm.concept c1
  JOIN cdm.concept_relationship cr
  ON   c1.concept_id = cr.concept_id_1
  JOIN cdm.concept c2
  ON   cr.concept_id_2 = c2.concept_id
  JOIN cdm.domain c3
  ON c2.domain_id = c3.domain_id
  WHERE 1=1
    AND c1.vocabulary_id = 'ICD10GM'
    AND cr.relationship_id = 'Maps to';
END
$$;