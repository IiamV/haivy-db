CREATE OR REPLACE FUNCTION query_account_information(_offset integer, _limit integer, query text) 
returns json as $$
DECLARE
    res json
BEGIN  
SELECT json_agg(ad) FROM accountdetails ad INTO res WHERE  first_name LIKE "%"||query||"%" 
                                    OR last_name LIKE "%"||query||"%" 
                                    OR account_type LIKE "%"||query||"%" 
LIMIT _limit OFFSET _offset;
RETURN json_build_object(
    'users', res
);
END;