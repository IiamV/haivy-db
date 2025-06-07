-- Function: dismiss_ticket
CREATE OR REPLACE FUNCTION public.dismiss_ticket(
    p_ticket_id UUID,
    p_note TEXT
)
RETURNS VOID AS $$

BEGIN
    -- Update the ticket status
    UPDATE ticket 
    SET status = 'canceled'::tik_status 
    WHERE ticket.ticket_id = p_ticket_id;
    
    -- Update related appointments
    UPDATE appointment 
    SET status = 'canceled'::apt_status 
    WHERE appointment.ticket_id = p_ticket_id;

    -- Log the dismissal
    INSERT INTO public.ticket_interaction_history (ticket_id, action, note)
    VALUES (p_ticket_id, 'cancel'::public.ticket_interaction_type, p_note);

END;
$$ LANGUAGE plpgsql;