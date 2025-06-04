CREATE OR REPLACE FUNCTION get_medication_info(
        med_id uuid
) 
RETURNS JSON AS $$ 
DECLARE
        result json;
BEGIN
        SELECT json_build_object(
                'name', m.name,
                'description', m.description,
                'is_available', m.is_available,
                'med_time', m.med_time
        ) INTO result
        FROM medicine m
        WHERE m.medicine_id = med_id;

        RETURN result;
END;
$$ LANGUAGE plpgsql;