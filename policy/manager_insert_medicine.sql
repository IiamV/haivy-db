CREATE POLICY "manager_can_insert_medicine"
ON Medicine
FOR INSERT
USING (
    EXISTS (
        SELECT 1
        FROM staff s
        WHERE s.account_uid = auth.uid()
        AND s.status = true
        AND s.role IN ('manager', 'admin')
    )
);