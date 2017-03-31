CREATE INDEX CONCURRENTLY "events_category_idx" ON "public"."events" USING btree(category(stream_name) COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST);
