--Change foriegn keys for person_id to 'on delete cascade'
DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_procedure_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.procedure_occurrence DROP CONSTRAINT fpk_procedure_person_id;
ALTER TABLE cdm.procedure_occurrence ADD CONSTRAINT fpk_procedure_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_drug_exposure_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.drug_exposure DROP CONSTRAINT fpk_drug_exposure_person_id;
ALTER TABLE cdm.drug_exposure ADD CONSTRAINT fpk_drug_exposure_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_observation_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.observation DROP CONSTRAINT fpk_observation_person_id;
ALTER TABLE cdm.observation ADD CONSTRAINT fpk_observation_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_condition_occurrence_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.condition_occurrence DROP CONSTRAINT fpk_condition_occurrence_person_id;
ALTER TABLE cdm.condition_occurrence ADD CONSTRAINT fpk_condition_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_visit_occurrence_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.visit_occurrence DROP CONSTRAINT fpk_visit_occurrence_person_id;
ALTER TABLE cdm.visit_occurrence ADD CONSTRAINT fpk_visit_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_visit_detail_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.visit_detail DROP CONSTRAINT fpk_visit_detail_person_id;
ALTER TABLE cdm.visit_detail ADD CONSTRAINT fpk_visit_detail_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_observation_period_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.observation_period DROP CONSTRAINT fpk_observation_period_person_id;
ALTER TABLE cdm.observation_period ADD CONSTRAINT fpk_observation_period_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_measurement_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.measurement DROP CONSTRAINT fpk_measurement_person_id;
ALTER TABLE cdm.measurement ADD CONSTRAINT fpk_measurement_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_death_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.death DROP CONSTRAINT fpk_death_person_id;
ALTER TABLE cdm.death ADD CONSTRAINT fpk_death_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_device_exposure_person_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.device_exposure DROP CONSTRAINT fpk_device_exposure_person_id;
ALTER TABLE cdm.device_exposure ADD CONSTRAINT fpk_device_exposure_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id) ON
DELETE
	CASCADE;
END IF;
END
$$;


--Change foriegn keys for visit_occurrence_id to 'on delete set NULL'
DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_procedure_occurrence_visit_id'
	AND confdeltype = 'n')
	THEN
ALTER TABLE cdm.procedure_occurrence DROP CONSTRAINT fpk_procedure_occurrence_visit_id;
ALTER TABLE cdm.procedure_occurrence ADD CONSTRAINT fpk_procedure_occurrence_visit_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id)
ON DELETE SET NULL;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_drug_exposure_visit_occurrence_id'
	AND confdeltype = 'n')
	THEN
ALTER TABLE cdm.drug_exposure DROP CONSTRAINT fpk_drug_exposure_visit_occurrence_id;
ALTER TABLE cdm.drug_exposure ADD CONSTRAINT fpk_drug_exposure_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id)
ON DELETE SET NULL;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_observation_visit_occurrence_id'
	AND confdeltype = 'n')
	THEN
ALTER TABLE cdm.observation DROP CONSTRAINT fpk_observation_visit_occurrence_id;
ALTER TABLE cdm.observation ADD CONSTRAINT fpk_observation_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id)
ON DELETE SET NULL;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_condition_occurrence_visit_occurrence_id'
	AND confdeltype = 'n')
	THEN
ALTER TABLE cdm.condition_occurrence DROP CONSTRAINT fpk_condition_occurrence_visit_occurrence_id;
ALTER TABLE cdm.condition_occurrence ADD CONSTRAINT fpk_condition_occurrence_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id)
ON DELETE SET NULL;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_visit_detail_visit_occurrence_id'
	AND confdeltype = 'c')
	THEN
ALTER TABLE cdm.visit_detail DROP CONSTRAINT fpk_visit_detail_visit_occurrence_id;
ALTER TABLE cdm.visit_detail ADD CONSTRAINT fpk_visit_detail_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id) ON
DELETE
	CASCADE;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_measurement_visit_occurrence_id'
	AND confdeltype = 'n')
	THEN
ALTER TABLE cdm.measurement DROP CONSTRAINT fpk_measurement_visit_occurrence_id;
ALTER TABLE cdm.measurement ADD CONSTRAINT fpk_measurement_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id)
ON DELETE SET NULL;
END IF;
END
$$;

DO
$$
BEGIN
IF NOT EXISTS (
SELECT
	conname
	, confdeltype
FROM
	pg_catalog.pg_constraint
JOIN pg_catalog.pg_class c ON
	c."oid" = conrelid
JOIN pg_catalog.pg_class p ON
	p."oid" = confrelid
WHERE
	conname = 'fpk_device_exposure_person_id'
	AND confdeltype = 'n')
	THEN
ALTER TABLE cdm.device_exposure DROP CONSTRAINT fpk_device_exposure_person_id;
ALTER TABLE cdm.device_exposure ADD CONSTRAINT fpk_device_exposure_person_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id)
ON DELETE SET NULL;
END IF;
END
$$;
