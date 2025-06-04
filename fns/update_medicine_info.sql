CREATE OR REPLACE FUNCTION update_medicine(
    med_id uuid,
    med_name varchar,
    med_description text,
    med_availability boolean,
    med_time medicine_timing
)
RETURNS VOID AS $$
BEGIN
    UPDATE Medicine m
    SET 
        m.name = med_name,
        m.description = med_description,
        m.is_available = med_availability,
        m.med_time = med_time
    WHERE m.medicine_id = med_id;
END;
$$ LANGUAGE plpgsql;