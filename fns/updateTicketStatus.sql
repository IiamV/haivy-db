-- Policy: Only assigned staff can update table ticket
CREATE POLICY "staffUpdateTicket_policy" ON public.ticket
FOR UPDATE 
TO authenticated
USING (
    assigned_to IN (
        SELECT staff_id 
        FROM staff 
        WHERE account_uid = auth.uid() 
        AND status = true
    )
)
WITH CHECK (
    assigned_to IN (
        SELECT staff_id 
        FROM staff 
        WHERE account_uid = auth.uid() 
        AND status = true
    )
);

CREATE OR REPLACE FUNCTION public.updateTicketStatus(
    ticket_id UUID,
    new_status tik_status
)
RETURNS VOID AS $$
DECLARE
    current_status tik_status;
    update_count INTEGER;
BEGIN
    -- Get current status
    SELECT status INTO current_status
    FROM ticket 
    WHERE ticket.ticket_id = updateTicketStatus.ticket_id;
    
    -- Update ticket status
    UPDATE ticket 
    SET status = new_status 
    WHERE ticket.ticket_id = updateTicketStatus.ticket_id;
    
    -- Logs the change
    INSERT INTO ticket_interaction_history (ticket_id, action, note, by)
    VALUES (
        updateTicketStatus.ticket_id, 
        'processed'::ticket_interaction_type,
        'Status changed from ' || current_status || ' to ' || new_status, 
        auth.uid()
    );
END;
$$ LANGUAGE plpgsql;