-- Function: forward_ticket_comment
CREATE OR REPLACE FUNCTION public.forward_ticket_comment(
    from_staff UUID,
    to_staff UUID,
    note TEXT
)
RETURNS VOID AS $$
DECLARE
    current_user_id UUID;
    from_staff_name TEXT;
    to_staff_name TEXT;
    ticket_exists BOOLEAN;
    forward_note TEXT;
BEGIN
    -- Get current user ID
    SELECT auth.uid() INTO current_user_id;
    
    -- Get staff names for better logging
    SELECT public.get_display_name(s.account_uid) INTO from_staff_name
    FROM staff s WHERE s.staff_id = from_staff;
    
    SELECT public.get_display_name(s.account_uid) INTO to_staff_name
    FROM staff s WHERE s.staff_id = to_staff;
    
    -- Update ticket assignment
    UPDATE public.ticket
    SET assigned_to = to_staff
    WHERE ticket.ticket_id = forward_ticket_comment.ticket_id;
    
    -- Build forward note with comment if provided
    forward_note := 'Forwarded from ' || COALESCE(from_staff_name, from_staff::text) || 
                   ' to ' || COALESCE(to_staff_name, to_staff::text);
    
    IF note IS NOT NULL AND LENGTH(TRIM(note)) > 0 THEN
        forward_note := forward_note || '. Comment: ' || note;
    END IF;
    
    -- Log the forward action in ticket interaction history
    INSERT INTO public.ticket_interaction_history (ticket_id, action, note, by)
    VALUES (
        forward_ticket_comment.ticket_id, 
        'forward'::ticket_interaction_type, 
        forward_note,
        current_user_id
    );
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.forward_ticket(from_staff UUID, to_staff UUID, note TEXT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO public.ticket_interaction_history (ticket_id, action, note)
    VALUES (ticket_id, 'forward', 'Forwarded from ' || from_staff || ' to ' || to_staff || '.\nComment: ' || note);
    
    UPDATE public.ticket
    SET assigned_to = to_staff
    WHERE assigned_to = from_staff;
END;
$$ LANGUAGE plpgsql;