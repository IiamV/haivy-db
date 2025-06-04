CREATE POLICY "manager_can_update_medicine"
ON Medicine
FOR UPDATE
USING (
    EXISTS (
        SELECT 1
        FROM staff s
        WHERE s.account_uid = auth.uid()
        AND s.status = true
        AND s.role IN ('manager', 'admin')
    )
);