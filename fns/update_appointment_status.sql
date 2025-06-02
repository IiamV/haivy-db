CREATE OR REPLACE FUNCTION update_appointment_status(
    id uuid,
    status apt_status
)
RETURNS VOID AS $$
DECLARE 
    ticket_id_temp uuid;
    old_status apt_status;
BEGIN
    SELECT apt.ticket_id, apt.status INTO ticket_id_temp, old_status
    FROM Appointment apt
    WHERE apt.appointment_id = id;

    UPDATE Appointment apt
    SET apt.status = status
    WHERE apt.appointment_id = id;

    INSERT INTO ticket_interaction_history (ticket_id, time, action, note, by)
    VALUES (
        ticket_id_temp, 
        now(),
        'appointment_update'::ticket_interaction_type, 
        'Status update changed from ' || old_status || ' to ' || status || ' for appointment ' || id, 
        auth.uid()
    );
END;
$$ LANGUAGE plpgsql;