CREATE OR REPLACE FUNCTION updateAppointmentStatus(
    id uuid,
    status apt_status
)
RETURNS VOID AS $$
BEGIN
    UPDATE Appointment apt
    SET apt.status = status
    WHERE apt.appointment_id = id;
END;
$$ LANGUAGE plpgsql;