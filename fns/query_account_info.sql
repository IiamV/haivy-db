CREATE OR REPLACE FUNCTION query_account_information(_offset integer, _limit integer, query text) 
returns json as $$
DECLARE 
    res JSON;
    pat TEXT;
BEGIN
    pat := '%' || query || '%';

    SELECT json_agg(ud)
    FROM user_details ud INTO res
    WHERE
        full_name ILIKE pat
        OR array_to_string(roles::text[], '') ILIKE pat
    LIMIT _limit
    OFFSET _offset;

    RETURN COALESCE(res, '[]'::JSON);
END;
$$;
-- By @The3dit0r