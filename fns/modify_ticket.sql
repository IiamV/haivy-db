create or replace function modify_ticket(ticket_id_to_mod uuid, new_content text, new_title text)
returns void as 

$$
begin
    update Ticket t
    set content = new_content,
        title = new_title
        where t.ticket_id = ticket_id_to_mod;
end;
$$
language plpgsql;
