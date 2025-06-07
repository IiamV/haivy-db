CREATE OR REPLACE FUNCTION "public"."get_all_tickets" () RETURNS "json" LANGUAGE "plpgsql" AS $$
DECLARE
  content JSON;
BEGIN

  SELECT
    json_agg(q) INTO content
  FROM
    (
      SELECT
        tx.*,
        latest.last_interacted_on
      FROM
        public.ticket tx
        LEFT JOIN (
          SELECT
            ticket_id,
            MAX(time) as last_interacted_on
          FROM
            public.ticket_interaction_history ti
          GROUP BY
            ticket_id
        ) latest ON tx.ticket_id = latest.ticket_id
    ) q
  WHERE
    q.assigned_to = auth.uid();

  RETURN COALESCE(content, '[]'::json);
END;
$$;