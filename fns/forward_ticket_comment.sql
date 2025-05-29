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