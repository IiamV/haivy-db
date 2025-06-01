CREATE OR REPLACE FUNCTION updateAppointmentDoctor(
    id uuid,
    staff_id uuid
)
RETURNS VOID AS $$
BEGIN
    UPDATE Appointment apt
    SET apt.staff_id = staff_id
    WHERE apt.appointment_id = id;
END;
$$ LANGUAGE plpgsql;