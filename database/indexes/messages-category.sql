CREATE INDEX CONCURRENTLY "messages_category_idx" ON "public"."messages" USING btree(category(stream_name) COLLATE "default" "pg_catalog"."text_ops" ASC NULLS LAST);
