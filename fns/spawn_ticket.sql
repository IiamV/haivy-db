Create or replace function spawn_ticket(f_assigned_to uuid, f_content text )
returns void as $$
begin

    insert into Ticket(assigned_to, date_created, content)
    values (f_assigned_to, now(), f_content);

end;
$$ language plpgsql;
-----------------------------------------------------------------------------------
-- a second function incase staffs wants to get log  or want to take ticket uuid for further uses
-- 
create or replace function spawn_ticket_with_noti_and_id_returned(f_assigned_to uuid, f_content text )
return uuid as $$
declare
    new_spawned_ticket_id uuid;
    new_spawned_ticket_time timestamptz;
begin 

    insert into Ticket(assigned_to, date_created, content)
    values (f_assigned_to, now(), f_content)
    returning ticket_id, date_created into new_spawned_ticket_id, new_spawned_ticket_time;  

    raise notice 'Created ticket at % with id: %', new_spawned_ticket_time, new_spawned_ticket_id;

    returns new_spawned_ticket_id;
end;
$$ language plpgsql;