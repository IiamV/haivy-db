CREATE OR REPLACE FUNCTION "public"."get_account_details" ("p_id" "uuid") RETURNS "jsonb" LANGUAGE "plpgsql" SECURITY DEFINER AS $$
DECLARE
  user_details_info jsonb;
  staff_info jsonb;
  auth_details jsonb;
BEGIN
  -- Get details from user_details
  SELECT to_jsonb(ud)
  INTO user_details_info
  FROM public.user_details ud
  WHERE ud.user_id = p_id;

  -- Get staff-specific details if applicable
  SELECT to_jsonb(s)
  INTO staff_info
  FROM public.staffs s
  WHERE s.user_id = p_id;

  -- Get auth.users details
  SELECT to_jsonb(r)
  INTO auth_details
  FROM (SELECT email, phone FROM auth.users WHERE id = p_id) r;

  -- Combine all information. staff_info will be undefined if not a staff.
  RETURN user_details_info || jsonb_build_object('staff_info', staff_info) || auth_details;
END;
$$;