create
or replace function update_appointment_content (id_to_update uuid, new_content text) returns void as $$
declare 
    temp_ticket_id uuid;
begin
--modify the required field in appointment table
    update Appointment apt 
    set apt.content = new_content
    where apt.appointment_id = id_to_update;
-- get the corresponding ticket
    select apt.ticket_id
    from Appointment apt 
    where apt.appointment_id = id_to_update
    into temp_ticket_id;
--update corresponding ticket interaction history
    insert into Ticket_interaction_history(ticket_id, action, note)
    values (
        temp_ticket_id,
        'appointment_update',
        format('Updated appointment id: %s  with new content: %s', id_to_update::text, new_content)  -- format note for readability
    );
end;
$$ language plpgsql;