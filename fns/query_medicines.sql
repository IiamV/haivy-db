create or replace function query_medicines (
  query text default '',
  _offset int default 0,
  _limit int default 100
) RETURNS json SECURITY DEFINER as $$
DECLARE query_token text := '%'||query||'%';
BEGIN
    RETURN COALESCE(
        (SELECT json_agg(med) 
        FROM (
          SELECT * 
          FROM medicines
          WHERE id::text ILIKE query_token 
                OR name ILIKE query_token 
                OR description ILIKE query_token
                OR consumption_note ILIKE query_token
                OFFSET _offset LIMIT _limit
        ) med
        )
        ,'[]'::JSON);
END;
$$ language PLPGSQL;