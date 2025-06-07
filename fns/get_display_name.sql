CREATE OR REPLACE FUNCTION "public"."get_display_name" ("p_id" "uuid") RETURNS "text" LANGUAGE "plpgsql" AS $$
DECLARE
    display_name TEXT;
BEGIN
    SELECT full_name
    INTO display_name
    FROM public.user_details
    WHERE user_id = p_id;

    IF display_name IS NULL THEN
        RETURN public.get_random_name();
    END IF;
    RETURN display_name;
END;
$$