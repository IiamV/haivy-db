CREATE OR REPLACE FUNCTION add_medication(
    p_name varchar,
    p_description text,
    p_availability boolean,
    p_time medicine_timing
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
        p_name, 
        p_description, 
        p_availability, 
        p_time
    );
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Something went wrong while trying to add medicine: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;