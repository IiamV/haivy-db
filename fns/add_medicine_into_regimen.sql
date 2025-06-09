create or replace function dev.add_medicine_into_regimen(
    p_medicine_id uuid,
    p_regimen_id uuid,
    p_total_day smallint,
    p_daily_dosage_schedule json
)
returns void as 
$$
begin
--check user role
    -- if(auth.uid() is null) or not ((select roles from user_details where user_id = auth.uid()) @> array['administrator', 'manager']::role[])
    -- then
    -- raise exception 'You do not have permission to perform this action';
    -- end if;
    if not(check_roles(array['administrator', 'manager'])::role[]) then
    then
    raise exception 'You do not have permission to perform this action';
    end if;
--eheck for empty json
    if json_array_length(p_daily_dosage_schedule) = 0 
    then
    raise exception 'Dosage schedule cannot be empty';
    end if;
--check if medicine exist
    if not exists (select 1 from mecidicines where medicine_id = p_medicine_id)
    then
    raise exception 'Medicine id does not exist: %s', p_medicine_id;
    end if;
--check if regimen exist
    if not exists (select 1 from regimen_details where regimen_id = p_regimen_id)
    then
    raise exception 'Regimen id does not exist: %s', p_regimen_id;
    end if;
--start adding medicine to regimen
        insert into regimen_details(
            regimen_id,
            medicine_id,
            total_day,
            daily_dosage_schedule
        )
        values(
            p_regimen_id,
            p_medicine_id,
            p_total_day,
            p_daily_dosage_schedule
        );
end;
$$
language plpgsql;