CREATE OR REPLACE FUNCTION editInteractionHistory(
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