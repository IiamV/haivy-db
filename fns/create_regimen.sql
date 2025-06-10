CREATE OR REPLACE FUNCTION dev.create_regimen(
    p_name text,
    p_level smallint,
    p_description text default '',
    p_is_for_adults boolean default true,
    default_medicines json default null
)
RETURNS uuid AS $$
DECLARE
    v_regimen_id uuid;
    v_medicine_item json;
    v_medicine_id uuid;
    v_total_day smallint;
    v_daily_dosage_schedule json;
BEGIN
    INSERT INTO regimens (
        name,
        description,
        level,
        is_for_adults
    ) VALUES (
        p_name,
        p_description,
        p_level,
        p_is_for_adults
    ) RETURNING regimen_id INTO v_regimen_id;

    IF default_medicines IS NOT NULL THEN
        FOR v_medicine_item IN SELECT value FROM json_array_elements(default_medicines)
        LOOP
            v_medicine_id := (v_medicine_item ->> 'medicine_id')::uuid;
            v_total_day := (v_medicine_item ->> 'total_day')::smallint;
            v_daily_dosage_schedule := v_medicine_item -> 'daily_dosage_schedule';

            INSERT INTO regimen_details(regimen_id, medicine_id, total_day, daily_dosage_schedule) VALUES(v_regimen_id, v_medicine_id, v_total_day, v_daily_dosage_schedule);
        END LOOP;
    END IF;

    RETURN v_regimen_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error creating regimen: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;