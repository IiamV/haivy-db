Create or replace function spawn_ticket(from_staff uuid, to_staff uuid)
returns void as $$
begin
insert into public.ticket_interaction_history (ticket_id, action, note) VALUES (ticket_id, 'forward', 'Forwarded from ' + from_staff + ' to ' + to_staff);

update public.ticket
set assigned_to = to_staff
where assigned_to = from_staff;

end;
$$ language plpgsql;