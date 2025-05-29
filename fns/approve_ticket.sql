create or replace function approve_ticket(ticket_id_to_approve uuid, approve_note text)
returns void as

$$
declare 
    temp_ticket_id uuid;
    temp_staff_id uuid;
begin
-- log the ticket interaction history
select ti.ticket_id, ti.created_by
into temp_ticket_id, temp_staff_id
from Ticket ti
where ticket_id_to_approve = ti.ticket_id;

-- update the related appointment status
update appointment apt
set apt.status = 'approved'
where apt.ticket_id = ticket_id_to_approve;

--insert information into tables
insert into Ticket_interaction_history(ticket_id, time , action, note, "by")
values
(temp_ticket_id, now(), 'processed', approve_note, temp_staff_id);

exception
    when others then
        raise notice 'Something went wrong when approving ticket, Error: %', sqlerrm;
end;
$$
language plpgsql;

