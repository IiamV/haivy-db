create or replace function update_appointment_duration(id_to_update uuid, new_duration integer)
returns void as 

$$
declare 
    temp_ticket_id uuid;
begin
-- update required field in appointment table
    update Appointment apt 
    set apt.duration = new_duration
    where apt.appointment_id = id_to_update;
-- get the corresponding ticket
    select apt.ticket_id
    from Appointment apt 
    where apt.appointment_id = id_to_update
    into temp_ticket_id;
--update corresponding ticket interaction history
    insert into Ticket_interaction_history(ticket_id, time, action, note, "by")
    values (
        temp_ticket_id,
        now(),
        'comment',
        format('Updated appointment id: %s  with new duration: %s', id_to_update::text, new_duration),    -- format for readability
        current_setting('jwt.claim.user_id')::uuid                                                      -- this takes id from user who logged in
    );
end;
$$
language plpgsql;