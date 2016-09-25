-- ----------------------------
--  Table structure for events
-- ----------------------------
DROP TABLE IF EXISTS "public"."events";
CREATE TABLE "public"."events" (
  "stream_name" varchar(255) NOT NULL COLLATE "default",
  "stream_position" int4 NOT NULL,
  "type" varchar(255) NOT NULL COLLATE "default",
  "global_position" bigserial NOT NULL ,
  "data" jsonb NOT NULL,
  "metadata" jsonb,
  "created_time" TIMESTAMP WITHOUT TIME ZONE DEFAULT (now() AT TIME ZONE 'utc') NOT NULL
)
WITH (OIDS=FALSE);

-- ----------------------------
--  Primary key structure for table events
-- ----------------------------
ALTER TABLE "public"."events" ADD PRIMARY KEY ("global_position") NOT DEFERRABLE INITIALLY IMMEDIATE;
