CREATE OR REPLACE FUNCTION write_event(
  _stream_name varchar,
  _type varchar,
  _data jsonb,
  _partition varchar DEFAULT NULL,
  _metadata jsonb DEFAULT NULL,
  _expected_version int DEFAULT NULL
)
RETURNS int
AS $$
DECLARE
  stream_version int;
  stream_position int;
  category varchar;
  -- _partition varchar;
BEGIN
  stream_version := stream_version(_stream_name);

  if _partition is null then
    _partition := 'events';
  end if;

  if stream_version is null then
    stream_version := -1;
  end if;

  if _expected_version is not null then
    if _expected_version != stream_version then
      raise exception 'Wrong expected version: % (Stream: %, Stream Version: %)', _expected_version, _stream_name, stream_version;
    end if;
  end if;

  stream_position := stream_version + 1;

  EXECUTE format('insert into %I ('
      '"stream_name", '
      '"stream_position", '
      '"type", '
      '"data", '
      '"metadata"'
    ') '
    'values ('
      '$1, '
      '$2, '
      '$3, '
      '$4, '
      '$5
    )',
    _partition)
    USING
      _stream_name,
      stream_position,
      _type,
      _data,
      _metadata
    ;

  return stream_position;
END;
$$ LANGUAGE plpgsql;
