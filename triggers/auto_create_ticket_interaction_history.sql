create or replace trigger trigger_create_ticket_interaction_history
after update on Appointment apt
for each row
execute log_ticket_interaction_history();
--the previous function must be created before this trigger executes



