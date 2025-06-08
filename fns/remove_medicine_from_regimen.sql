create or replace function dev.remove_medicine_from_regimen(p_medicine_id uuid, p_regimen_id uuid)
returns void as 
$$
begin
    IF (auth.uid() IS NULL) OR NOT ((SELECT roles FROM user_details WHERE user_id = auth.uid()) @> ARRAY['administrator', 'manager']::role[]) THEN
    RAISE EXCEPTION 'You do not have permission to perform this action';
    END IF;
    delete from regimen_details
        where regimen_id = p_regimen_id and medicine_id = p_medicine_id;
    begin
    exception
    when others then
     raise exception 'something went wrong while trying to remove medicine from regimen detail: %', SQLERRM;
    end;
end;     
$$
language plpgsql;