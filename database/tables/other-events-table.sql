-- ----------------------------
--  Table structure for other_events
-- ----------------------------
DROP TABLE IF EXISTS "public"."other_events";
CREATE TABLE "public"."other_events" (
  "stream_name" varchar(255) NOT NULL COLLATE "default",
  "position" int4 NOT NULL,
  "type" varchar(255) NOT NULL COLLATE "default",
  "global_position" bigserial NOT NULL ,
  "data" jsonb NOT NULL,
  "metadata" jsonb,
  "created_time" TIMESTAMP WITHOUT TIME ZONE DEFAULT (now() AT TIME ZONE 'utc') NOT NULL
)
WITH (OIDS=FALSE);

-- ----------------------------
--  Primary key structure for table other_events
-- ----------------------------
ALTER TABLE "public"."other_events" ADD PRIMARY KEY ("global_position") NOT DEFERRABLE INITIALLY IMMEDIATE;
