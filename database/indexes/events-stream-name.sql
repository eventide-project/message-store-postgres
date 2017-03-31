CREATE INDEX CONCURRENTLY "events_stream_name_idx" ON "public"."events" USING btree(stream_name COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST);
