-- ----------------------------
--  Indexes structure for table events
-- ----------------------------
CREATE INDEX CONCURRENTLY  "events_category_global_position_idx" ON "public"."events" USING btree(category(stream_name) COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST, "global_position" "pg_catalog"."int8_ops" ASC NULLS LAST);
CREATE INDEX CONCURRENTLY "events_category_idx" ON "public"."events" USING btree(category(stream_name) COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST);
CREATE INDEX CONCURRENTLY "events_stream_name_idx" ON "public"."events" USING btree(stream_name COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST);
CREATE UNIQUE INDEX CONCURRENTLY "events_stream_name_stream_position_uniq_idx" ON "public"."events" USING btree(stream_name COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST, "stream_position" "pg_catalog"."int4_ops" ASC NULLS LAST);
