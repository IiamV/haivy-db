CREATE OR REPLACE FUNCTION add_medication(
    med_name varchar,
    med_description text,
    med_availability boolean,
    med_time medicine_timing
)
RETURNS VOID AS $$
DECLARE
    user_role role_type;
BEGIN
    SELECT s.role
    FROM staffs s
    WHERE s.user_id = auth.uid()
    INTO user_role;
    IF user_role IS NULL OR user_role NOT IN ('admin', 'manager') THEN
    RAISE EXCEPTION 'You do not have permission to perform this action';
    END IF;
    INSERT INTO Medicine (
        name, 
        description, 
        is_available, 
        med_time
    )
    VALUES (
        med_name, 
        med_description, 
        med_availability, 
        med_time
    );
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Something went wrong while trying to add medicine: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;