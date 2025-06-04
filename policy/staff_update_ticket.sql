CREATE POLICY "staff_can_update_ticket" 
ON public.ticket
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 
        FROM staff s
        WHERE s.staff_id = auth.uid() 
        AND s.status = true
    )
);