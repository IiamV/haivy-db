CREATE FUNCTION "public"."create_ticket" (
  "p_title" "text",
  "p_content" "text",
  "p_type" "public"."ticket_type"
) RETURNS "uuid" LANGUAGE "plpgsql" AS $$
DECLARE
  free_staff_user_id uuid;
BEGIN
  -- Select a staff member with the least assigned tickets
  -- This assumes 'assigned_to' in 'ticket' refers to user_id (auth.users.id)
  SELECT t.assigned_to, count(t.assigned_to) c
  INTO free_staff_user_id
  FROM public.ticket t
  GROUP BY t.assigned_to
  ORDER BY c ASC
  LIMIT 1; -- Changed to LIMIT 1 as you want one staff member

  IF free_staff_user_id IS NULL THEN
    -- Fallback if no staff is assigned any tickets yet, assign to an arbitrary staff
    SELECT user_id INTO free_staff_user_id FROM public.staffs LIMIT 1;
    IF free_staff_user_id IS NULL THEN
        RAISE EXCEPTION 'No staff members found to assign the ticket.';
    END IF;
  END IF;

  RETURN public.create_ticket(p_title, p_content, p_type, free_staff_user_id);
END;
$$;

-- Name: create_ticket("text", "text", "public"."ticket_type", "uuid"); Type: FUNCTION; Schema: public; Owner: -
CREATE FUNCTION "public"."create_ticket" (
  "p_title" "text",
  "p_content" "text",
  "p_type" "public"."ticket_type",
  "p_assigned_to" "uuid"
) RETURNS "uuid" LANGUAGE "plpgsql" AS $$
DECLARE
  new_id uuid = gen_random_uuid();
BEGIN
  INSERT INTO public.ticket (ticket_id, assigned_to, content, title, ticket_type, created_by)
  VALUES (new_id, p_assigned_to, p_content, p_title, p_type, auth.uid());
  RETURN new_id;
END;
$$;
