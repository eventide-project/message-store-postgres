#!/usr/bin/env bash

set -e

clear

echo
echo "Creating other_events Table"
echo "= = ="
echo

default_name=eventsource

if [ -z ${DATABASE_USER+x} ]; then
  echo "(DATABASE_USER is not set)"
  user=$default_name
else
  user=$DATABASE_USER
fi

if [ -z ${DATABASE_NAME+x} ]; then
  echo "(DATABASE_NAME is not set)"
  database=$default_name
else
  database=$DATABASE_NAME
fi

echo

psql $database -f database/tables/other-events-table.sql
