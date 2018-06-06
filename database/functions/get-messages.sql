CREATE OR REPLACE FUNCTION get_messages(
  condition varchar DEFAULT NULL
)
RETURNS SETOF messages
AS $$
DECLARE
  command text;
BEGIN
  command := 'SELECT * FROM messages';

  if condition is not null then
    command := command || ' WHERE %s';
    command := format(command, condition);
  end if;

  RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql
VOLATILE;
