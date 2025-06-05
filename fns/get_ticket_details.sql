CREATE FUNCTION "public"."get_ticket_details" ("tid" "uuid") RETURNS "json" LANGUAGE "plpgsql" AS $$
DECLARE
  content JSON;
  history JSON;
  apt JSON;
  result JSON;
BEGIN
  -- Fetch the ticket data
  SELECT
    to_jsonb(tic) || jsonb_build_object(
      'created_by', get_account_details(tic.created_by)
    ) AS result
  INTO content
  FROM public.ticket tic
  WHERE ticket_id = tid;

  SELECT json_agg(
    to_jsonb(tih) || jsonb_build_object(
        'by', get_account_details(tih.by)
    )
  ) INTO history
  FROM public.ticket_interaction_history tih
  WHERE ticket_id = tid;

  SELECT json_agg(appointment) INTO apt
  FROM public.appointment
  WHERE appointment.ticket_id = tid;

  result := json_build_object(
    'ticket', content,
    'interactions', COALESCE(history, '[]'::json),
    'appointments', COALESCE(apt, '[]'::json)
  );

  RETURN result;
END;
$$;