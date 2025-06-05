create
or replace function modify_ticket (
    p_ticket_id uuid,
    new_content text,
    new_title text
) returns void as $$
begin
    update Ticket t
    set content = new_content,
        title = new_title
        where t.ticket_id = ticket_id;
    INSERT INTO ticket_interaction_history (ticket_id, action)VALUES (p_ticket_id, 'edit'::ticket_interaction_type);
end;
$$ language plpgsql;