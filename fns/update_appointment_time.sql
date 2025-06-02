create or replace function update_appointment_meeting_time(id_to_update uuid, new_meeting_time timestamptz)
returns void as
 
 $$
 declare 
    temp_ticket_id uuid;
 begin
 -- update required field in appointment table
    update Appointment apt
    set apt.meeting_date = new_meeting_time
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
        'appointment_update',
        format('Updated appointment id: %s  with new meeting time: %L', id_to_update::text, new_meeting_time),
        auth.uid()
    );
end;
 $$
 language plpgsql;