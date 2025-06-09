create or replace function dev.check_roles(p_roles role[])
returns boolean as
$$
begin
    if(auth.uid() is null) or not (select roles from user_details where user_id = auth.uid() @> p_roles)
    then
    return false;
    else 
    return true;
    end if;
end;
$$
language plpgsql;
