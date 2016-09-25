#!/usr/bin/env bash

set -e

clear

echo
echo "Uninstalling Database"
echo "= = ="
echo

if [ -z ${DATABASE_USER+x} ]; then
  echo "(DATABASE_USER is not set)"
  user=eventstream
else
  user=$DATABASE_USER
fi

if [ -z ${DATABASE_NAME+x} ]; then
  echo "(DATABASE_NAME is not set)"
  database=eventstream
else
  database=$DATABASE_NAME
fi

echo

function delete-user {
  echo "Database user is: $user"

  user_exists=`psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$user'"`

  if [ "$user_exists" = "1" ]; then
    echo "Deleting database user \"$user\""
    dropuser $user
  else
    echo "Database user \"$user\" does not exist. Not deleting."
  fi

  echo
}

function delete-database {
  echo "Database name is: $database"

  database_exists=`psql -tAc "SELECT 1 FROM pg_database WHERE datname='$database'"`

  if [ "$database_exists" = "1" ]; then
    echo "Deleting database \"$database\""
    dropdb $database
  else
    echo "Database \"$database\" does not exist. Not deleting."
  fi

  echo
}


delete-database
delete-user
