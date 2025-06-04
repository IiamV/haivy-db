CREATE OR REPLACE FUNCTION add_medication(
    med_name varchar,
    med_description text,
    med_availability boolean,
    med_time medicine_timing
)
RETURNS VOID AS $$
BEGIN
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
END;
$$ LANGUAGE plpgsql;