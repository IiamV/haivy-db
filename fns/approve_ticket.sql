-- Name: approve_ticket("uuid", "text"); Type: FUNCTION; Schema: public; Owner: -
CREATE OR REPLACE FUNCTION "public"."approve_ticket" (
  "p_ticket_id" "uuid",
  "p_note" "text"
) RETURNS "void" LANGUAGE "plpgsql" AS $$
BEGIN

  -- update the related appointment status
  UPDATE public.appointment apt
  SET status = 'approved'::public.appointment_status
  WHERE apt.ticket_id = p_ticket_id;

  --insert information into tables
  INSERT INTO public.ticket_interaction_history(ticket_id, action, note)
  VALUES
  (p_ticket_id, 'approve'::public.ticket_interaction_type, p_note);

EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Something went wrong when approving ticket, Error: %', sqlerrm;
END;
$$;
