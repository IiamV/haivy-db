-- Name: get_doctor_schedule_with_date("date"); Type: FUNCTION; Schema: public; Owner: -
CREATE FUNCTION "public"."get_doctor_schedule_with_date" ("date" "date") RETURNS "jsonb" LANGUAGE "plpgsql" AS $$
DECLARE
  current_user_id UUID;
  result JSONB;
BEGIN
  -- Get the user ID for the currently authenticated user
  SELECT auth.uid() INTO current_user_id;

  IF NOT EXISTS (SELECT 1 FROM public.staffs WHERE user_id = current_user_id) THEN
    RAISE EXCEPTION 'Current user is not a staff member.';
  END IF;

  -- Build and return the aggregated JSONB schedule
  SELECT jsonb_agg(
    to_jsonb(tap) ||
    jsonb_build_object(
      'patient_info', to_jsonb(ud_patient)
    )
  )
  INTO result
  FROM public.appointment tap
  JOIN public.user_details ud_patient ON tap.patient_id = ud_patient.user_id
  WHERE tap.meeting_date::date = date
    AND tap.staff_id = current_user_id; -- Assuming staff_id in appointment is the user_id of the staff

  RETURN COALESCE(result, '[]'::jsonb); -- Ensure empty array if no results
END;
$$;