CREATE OR REPLACE FUNCTION get_medication_info(
       p_id uuid
) 
RETURNS JSON AS $$ 
BEGIN
        RETURN (
                SELECT to_json(medicine)
                FROM Medicine m
                WHERE m.medicine_id = p_id
        );

-- incase error occurs
EXCEPTION
        WHEN OTHERS THEN
        RAISE EXCEPTION 'Something went wrong when trying to view this medicine: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;