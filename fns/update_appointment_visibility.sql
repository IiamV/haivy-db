CREATE OR REPLACE FUNCTION update_appointment_visibility(
    id uuid,
    isPublic boolean
)
RETURNS VOID AS $$
DECLARE 
    ticket_id_temp uuid;
BEGIN
    SELECT apt.ticket_id INTO ticket_id_temp
    FROM Appointment apt
    WHERE apt.appointment_id = id;

    UPDATE Appointment apt
    SET apt.visibility = isPublic
    WHERE apt.appointment_id = id;

    INSERT INTO ticket_interaction_history (ticket_id, action, note)
    VALUES (
        ticket_id_temp, 
        'appointment_update'::ticket_interaction_type, 
        'Visibility update changed to ' || status || ' for appointment ' || id
    );
END;
$$ LANGUAGE plpgsql;