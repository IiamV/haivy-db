-- Function: dismiss_ticket
CREATE OR REPLACE FUNCTION public.dismiss_ticket(
    ticket_id UUID,
    note TEXT
)
RETURNS VOID AS $$
DECLARE

    ticket_exists BOOLEAN;
BEGIN
    -- Update the ticket status
    UPDATE ticket 
    SET status = 'canceled'::tik_status 
    WHERE ticket.ticket_id = dismiss_ticket.ticket_id;
    
    -- Update related appointments
    UPDATE appointment 
    SET status = 'canceled'::apt_status 
    WHERE appointment.ticket_id = dismiss_ticket.ticket_id;
END;
$$ LANGUAGE plpgsql;