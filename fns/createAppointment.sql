CREATE OR REPLACE FUNCTION public.create_appointment(
  p_duration INTEGER,
  p_meeting_date TIMESTAMPTZ,
  p_isPublic BOOLEAN,
  p_requested_doctor UUID,
  p_service_description text,
  p_phone TEXT,
)
RETURNS UUID AS $$
DECLARE
  v_appointment_id UUID;
  v_ticket_content TEXT;

BEGIN
  -- Create ticket content with newlines
  v_ticket_content := format(
    'Please confirm patient information by phone at number: %s.
    - Service: %s
    Thank you,
    Haivy Limited Company.',
    p_phone,
    p_service_description
  );

  -- Insert appointment with ticket_id
  INSERT INTO Appointment (
    duration,
    meeting_date,
    visibility,
    staff_id,
    patient_uid,
    ticket_id
  ) VALUES (
    p_duration,
    p_meeting_date,
    p_isPublic,
    p_requested_doctor,
    p_patient,
    create_ticket('Confirm appointment information',v_ticket_content, 'appointment'::ticket_type)
  ) RETURNING appointment_id INTO v_appointment_id;

  RETURN v_appointment_id;
END;
$$ LANGUAGE plpgsql;