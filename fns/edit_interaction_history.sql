CREATE OR REPLACE FUNCTION edit_interaction_history(
    p_id integer,
    p_note text
)
RETURNS VOID AS $$
BEGIN
    UPDATE ticket_interaction_history history
    SET history.note = p_note
    WHERE history.id = p_id;
END;
$$ LANGUAGE plpgsql;