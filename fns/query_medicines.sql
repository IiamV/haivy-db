CREATE OR REPLACE FUNCTION query_medicines(query text) 
RETURNS json
SECURITY DEFINER
AS $$
DECLARE query_token text;
BEGIN
    query_token:= '%'||query||'%';
    RETURN COALESCE(
        (SELECT json_agg(medicines) 
        FROM medicines
        WHERE   id::text ILIKE query_token 
                OR name ILIKE query_token 
                OR description ILIKE query_token
                OR consumption_note ILIKE query_token )
        ,'[]'::JSON);
END;
$$ language PLPGSQL;