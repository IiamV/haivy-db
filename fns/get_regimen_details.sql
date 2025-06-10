CREATE OR REPLACE FUNCTION dev.get_regimen_details(
    p_regimen_id uuid
)
RETURNS JSON AS $$
BEGIN
    RETURN (
        SELECT to_json(array_agg(details))
        FROM (
            SELECT 
                rd.*,
                m.name AS medicine_name
            FROM regimen_details rd
            JOIN Medicines m ON rd.medicine_id = m.id
            WHERE rd.regimen_id = p_regimen_id
        ) AS details
    );
END;
$$ LANGUAGE plpgsql;
