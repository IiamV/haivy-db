CREATE OR REPLACE FUNCTION update_medication_info(
    med_id uuid,
    med_name varchar,
    med_description text,
    med_availability boolean,
    med_time medicine_timing
)
RETURNS VOID AS $$
DECLARE
    user_role role_type;
BEGIN
-- take the role from authorized user
    SELECT s.role
    FROM staffs s
    WHERE s.user_id = auth.uid()
    INTO user_role;
-- restrict operation to admin and manager only
    IF user_role IS NULL or user_role NOT IN ('admin', 'manager') THEN
    RAISE EXCEPTION 'You do not have permission to perform this action';
    END IF;
    UPDATE Medicine m
    SET 
        m.name = med_name,
        m.description = med_description,
        m.is_available = med_availability,
        m.med_time = med_time
    WHERE m.medicine_id = med_id;
--in case something else went wrong
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Something went wrong while trying to update medicine: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;