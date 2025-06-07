CREATE OR REPLACE FUNCTION public.update_medicine_info(
    p_id uuid,
    p_name text DEFAULT NULL,
    p_description text DEFAULT NULL,
    p_is_available boolean DEFAULT NULL,
    p_consumption_note text DEFAULT NULL
) RETURNS void AS $$

BEGIN
    IF (auth.uid() IS NULL) OR NOT ((SELECT roles FROM user_details WHERE user_id = auth.uid()) @> ARRAY['administrator', 'manager']::role[]) THEN
        RAISE EXCEPTION 'You do not have permission to perform this action';
    END IF;

    UPDATE Medicines
    SET 
        name = COALESCE(p_name, name),
        description = COALESCE(p_description, description),
        is_available = COALESCE(p_is_available, is_available),
        consumption_note = COALESCE(p_consumption_note, consumption_note)
    WHERE id = p_id;

END;
$$ LANGUAGE plpgsql;