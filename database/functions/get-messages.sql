CREATE OR REPLACE FUNCTION get_messages()
RETURNS SETOF messages
AS $$
DECLARE
  command text;
BEGIN
  command := 'SELECT * FROM messages';
  RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql
VOLATILE;
