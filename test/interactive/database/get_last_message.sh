#!/usr/bin/env bash

test/interactive/database/setup.sh

psql message_store -c "select * from get_last_message('someStream-123');"
