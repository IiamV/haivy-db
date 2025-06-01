CREATE POLICY "staff_can_update_ticket" ON public.ticket
FOR UPDATE 
TO authenticated
USING (
    assigned_to IN (
        SELECT staff_id 
        FROM staff 
        WHERE account_uid = auth.uid() 
        AND status = true
    )
);