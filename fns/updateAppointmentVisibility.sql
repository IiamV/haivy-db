CREATE OR REPLACE FUNCTION updateAppointmentVisibility(
    id uuid,
    isPublic boolean
)
RETURNS VOID AS $$
BEGIN
    UPDATE Appointment apt
    SET apt.isPublic = isPublic
    WHERE apt.appointment_id = id;
END;
$$ LANGUAGE plpgsql;