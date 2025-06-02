CREATE OR REPLACE FUNCTION update_appointment_doctor(
    id uuid,
    staff_id uuid
)
RETURNS VOID AS $$
DECLARE 
    ticket_id_temp uuid;
    old_staff_id uuid;
BEGIN
    SELECT apt.ticket_id, apt.staff_id INTO ticket_id_temp, old_staff_id
    FROM Appointment apt
    WHERE apt.appointment_id = id;

    UPDATE Appointment apt
    SET apt.staff_id = staff_id
    WHERE apt.appointment_id = id;

    INSERT INTO ticket_interaction_history (ticket_id, time, action, note, by)
    VALUES (
        ticket_id_temp, 
        now(),
        'appointment_update'::ticket_interaction_type, 
        'Doctor update changed from ' || old_staff_id || ' to ' || staff_id || ' for appointment ' || id, 
        auth.uid()
    );
END;
$$ LANGUAGE plpgsql;