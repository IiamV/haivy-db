CREATE OR REPLACE FUNCTION delete_medication(
    p_id uuid
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
    SET m.is_available = FALSE
    WHERE medicine_id = p_id;
--in case something else went wrong
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Something went wrong while trying to delete medicine: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;