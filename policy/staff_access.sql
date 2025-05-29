create policy "staff_can_see_patient_in_appointment"
on "AccountDetails"
for select
using (
    exists(
        select 1
            from Staff s
            join Appointment a on a.staff_id = s.staff_id
            join Patient p on p.patient_uid = a.patient_uid
            
            where s.account_uid = auth.uid()
            and p.account_uid = AccountDetails.account_uid
    )
);