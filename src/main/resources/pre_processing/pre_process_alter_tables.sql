Do $$
BEGIN
--Adds two new columns called fhir_logical_id and fhir_identifier to tables in OMOP CDM.
ALTER TABLE person ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE visit_occurrence ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE visit_detail ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE observation ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE measurement ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE procedure_occurrence ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE death ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE drug_exposure ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE condition_occurrence ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;
ALTER TABLE device_exposure ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;

ALTER TABLE fact_relationship ADD COLUMN IF NOT EXISTS fhir_logical_id_1 varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier_1 varchar(250) NULL;
ALTER TABLE fact_relationship ADD COLUMN IF NOT EXISTS fhir_logical_id_2 varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier_2 varchar(250) NULL;

--Temporarily deleted the FK constraints for the column preceding_visit_detail_id
ALTER TABLE visit_detail DROP CONSTRAINT IF EXISTS fpk_visit_detail_preceding_visit_detail_id;

--Adds two new columns called fhir_logical_id and fhir_identifier to cds_etl_helper.post_process_map table
ALTER TABLE IF EXISTS cds_etl_helper.post_process_map ADD COLUMN IF NOT EXISTS fhir_logical_id varchar(250) NULL, ADD COLUMN IF NOT EXISTS fhir_identifier varchar(250) NULL;

--Alter drug_exposure table to automatically increment drug_exposure_id
CREATE SEQUENCE IF NOT EXISTS drug_exposure_id_seq INCREMENT BY 1 START WITH 1;
ALTER TABLE drug_exposure ALTER COLUMN drug_exposure_id SET DEFAULT nextval('drug_exposure_id_seq');

--Alter visit_detail table to automatically increment visit_detail_id
CREATE SEQUENCE IF NOT EXISTS visit_detail_id_seq INCREMENT BY 1 START WITH 1;
ALTER TABLE visit_detail ALTER COLUMN visit_detail_id SET DEFAULT nextval('visit_detail_id_seq');

--Alter device_exposure table to automatically increment device_exposure_id
CREATE SEQUENCE IF NOT EXISTS device_exposure_id_seq INCREMENT BY 1 START WITH 1;
ALTER TABLE device_exposure ALTER COLUMN device_exposure_id SET DEFAULT nextval('device_exposure_id_seq');

--Rename cds_etl_helper.data_persistant_map to cds_etl_helper.post_process_map
ALTER TABLE IF EXISTS cds_etl_helper.data_persistant_map RENAME TO post_process_map;

--Change foriegn keys for person_id to 'on delete cascade'
ALTER TABLE cdm.procedure_occurrence DROP CONSTRAINT fpk_procedure_occurrence_person_id;
ALTER TABLE cdm.procedure_occurrence ADD CONSTRAINT fpk_procedure_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.drug_exposure DROP CONSTRAINT fpk_drug_exposure_person_id;
ALTER TABLE cdm.drug_exposure ADD CONSTRAINT fpk_drug_exposure_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.observation DROP CONSTRAINT fpk_observation_person_id;
ALTER TABLE cdm.observation ADD CONSTRAINT fpk_observation_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.condition_occurrence DROP CONSTRAINT fpk_condition_occurrence_person_id;
ALTER TABLE cdm.condition_occurrence ADD CONSTRAINT fpk_condition_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.visit_occurrence DROP CONSTRAINT fpk_visit_occurrence_person_id;
ALTER TABLE cdm.visit_occurrence ADD CONSTRAINT fpk_visit_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.visit_detail DROP CONSTRAINT fpk_visit_detail_person_id;
ALTER TABLE cdm.visit_detail ADD CONSTRAINT fpk_visit_detail_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.observation_period DROP CONSTRAINT fpk_observation_period_person_id;
ALTER TABLE cdm.observation_period ADD CONSTRAINT fpk_observation_period_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.measurement DROP CONSTRAINT fpk_measurement_person_id;
ALTER TABLE cdm.measurement ADD CONSTRAINT fpk_measurement_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.death DROP CONSTRAINT fpk_death_person_id;
ALTER TABLE cdm.death ADD CONSTRAINT fpk_death_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

ALTER TABLE cdm.device_exposure DROP CONSTRAINT fpk_device_exposure_person_id;
ALTER TABLE cdm.device_exposure ADD CONSTRAINT fpk_device_exposure_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON DELETE CASCADE;

--Change foreign keys for visit_occurrence_id to 'on delete cascade'
ALTER TABLE cdm.procedure_occurrence DROP CONSTRAINT fpk_procedure_occurrence_visit_occurrence_id;
ALTER TABLE cdm.procedure_occurrence ADD CONSTRAINT fpk_procedure_occurrence_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON DELETE CASCADE;

ALTER TABLE cdm.drug_exposure DROP CONSTRAINT fpk_drug_exposure_visit_occurrence_id;
ALTER TABLE cdm.drug_exposure ADD CONSTRAINT fpk_drug_exposure_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON DELETE CASCADE;

ALTER TABLE cdm.observation DROP CONSTRAINT fpk_observation_visit_occurrence_id;
ALTER TABLE cdm.observation ADD CONSTRAINT fpk_observation_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON DELETE CASCADE;

ALTER TABLE cdm.condition_occurrence DROP CONSTRAINT fpk_condition_occurrence_visit_occurrence_id;
ALTER TABLE cdm.condition_occurrence ADD CONSTRAINT fpk_condition_occurrence_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON DELETE CASCADE;

ALTER TABLE cdm.visit_detail DROP CONSTRAINT fpk_visit_detail_visit_occurrence_id;
ALTER TABLE cdm.visit_detail ADD CONSTRAINT fpk_visit_detail_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON DELETE CASCADE;

ALTER TABLE cdm.measurement DROP CONSTRAINT fpk_measurement_visit_occurrence_id;
ALTER TABLE cdm.measurement ADD CONSTRAINT fpk_measurement_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON DELETE CASCADE;

ALTER TABLE cdm.device_exposure DROP CONSTRAINT fpk_device_exposure_visit_occurrence_id;
ALTER TABLE cdm.device_exposure ADD CONSTRAINT fpk_device_exposure_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON DELETE CASCADE;

-- Make id columns generated
ALTER TABLE cdm.procedure_occurrence ALTER COLUMN procedure_occurrence_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.procedure_occurrence ALTER COLUMN procedure_occurrence_id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE cdm.observation ALTER COLUMN observation_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.observation ALTER COLUMN observation_id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE cdm.condition_occurrence ALTER COLUMN condition_occurrence_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.condition_occurrence ALTER COLUMN condition_occurrence_id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE cdm.visit_occurrence ALTER COLUMN visit_occurrence_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.visit_occurrence ALTER COLUMN visit_occurrence_id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE cdm.observation_period ALTER COLUMN observation_period_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.observation_period ALTER COLUMN observation_period_id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE cdm.measurement ALTER COLUMN measurement_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.measurement ALTER COLUMN measurement_id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE cdm.person ALTER COLUMN person_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.person ALTER COLUMN person_id ADD GENERATED BY DEFAULT AS IDENTITY;

ALTER TABLE cdm.location ALTER COLUMN location_id DROP IDENTITY IF EXISTS;
ALTER TABLE cdm.location ALTER COLUMN location_id ADD GENERATED BY DEFAULT AS IDENTITY;

END
$$;
