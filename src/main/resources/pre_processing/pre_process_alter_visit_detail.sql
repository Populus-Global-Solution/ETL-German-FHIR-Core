Do
$$
DECLARE v_rowCount int;
BEGIN
--Temporarily deleted the FK constraints for the column precending_visit_detail_id
ALTER TABLE visit_detail DROP CONSTRAINT IF EXISTS fpk_visit_detail_preceding_visit_detail_id;
COMMIT;
ALTER TABLE visit_detail DROP CONSTRAINT IF EXISTS fpk_visit_detail_parent_visit_detail_id;
COMMIT;
END
$$;
