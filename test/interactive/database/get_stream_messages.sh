#!/usr/bin/env bash

test/interactive/database/setup.sh

psql message_store -c -P pager=off "select * from get_stream_messages('someStream-123', 2, 1, _condition => 'global_position = 3');"
