create or replace function dev.delete_regimen(p_regimen_id uuid)
returns void as
$$
begin
    if(auth.uid() is null) or not ((select roles from user_details where user_id = auth.uid()) @> array['administrator', 'manager']::role[]) 
    then
    raise exception 'You do not have permission to perform this action';
    end if;
    begin
    update on regimens
    set is_available = false
    where regimen_id = p_regimen_id;
    exception
    when others then
    raise exception 'Something went wrong while trying to delete regimen: %', SQLERRM;
    end;
end;
$$
language plpgsql;