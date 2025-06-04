CREATE OR REPLACE FUNCTION delete_medicine(
    med_id uuid
)
RETURNS VOID AS $$
BEGIN
    UPDATE Medicine m
    SET m.is_available = FALSE
    WHERE medicine_id = med_id;
END;
$$ LANGUAGE plpgsql;