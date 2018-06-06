
CREATE OR REPLACE FUNCTION get_messages(
  condition varchar DEFAULT NULL
  -- stream_name varchar,
  -- position bigint DEFAULT 0,
  -- batch_size bigint DEFAULT 1000,
)
RETURNS SETOF messages
AS $$
DECLARE
  command text;
BEGIN
  command := 'SELECT * FROM messages';

  -- command := '
  -- SELECT
  --     id,
  --     stream_name,
  --     position,
  --     type,
  --     global_position,
  --     data,
  --     metadata,
  --     time
  --   FROM
  --     messages';

    -- WHERE
    --   #{formatted_where_clause}
    -- ORDER BY
    --   #{position_field} ASC
    -- LIMIT
    --   #{batch_size}
    -- ;


  if condition is not null then
    command := command || ' WHERE %s';
    command := format(command, condition);
  end if;


  RETURN QUERY EXECUTE command;
END;
$$ LANGUAGE plpgsql
VOLATILE;
