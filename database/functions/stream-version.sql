CREATE OR REPLACE FUNCTION stream_version(
  _stream_name varchar,
  _partition varchar DEFAULT NULL
)
RETURNS int
AS $$
DECLARE
  stream_version int;
BEGIN
  if _partition is null then
    _partition := 'events';
  end if;

  EXECUTE format('select max(position) '
    'from %I '
    'where stream_name = $1',
    _partition)
    INTO
      stream_version
    USING
      _stream_name;

  return stream_version;
END;
$$ LANGUAGE plpgsql;
