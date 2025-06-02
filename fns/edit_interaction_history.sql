CREATE OR REPLACE FUNCTION edit_interaction_history(
    uid integer,
    note text
)
RETURNS VOID AS $$
BEGIN
    UPDATE ticket_interaction_history history
    SET history.note = note
    WHERE history.id = uid;
END;
$$ LANGUAGE plpgsql;