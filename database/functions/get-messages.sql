CREATE OR REPLACE FUNCTION get_messages()
RETURNS messages
AS $$
BEGIN
  SELECT * FROM messages WHERE global_position > 0;
END;
$$ LANGUAGE plpgsql
VOLATILE;
