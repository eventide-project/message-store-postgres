CREATE TYPE message AS (
  id varchar,
  stream_name varchar,
  position bigint,
  type varchar,
  global_position bigint,
  data varchar,
  metadata varchar,
  time timestamp
);
