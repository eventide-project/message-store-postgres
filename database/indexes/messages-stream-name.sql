CREATE INDEX CONCURRENTLY "messages_stream_name_idx" ON "public"."messages" USING btree(stream_name COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST);
