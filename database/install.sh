#!/usr/bin/env bash

set -e

# function foo {
#   createdb event_source
# }

# foo

echo
echo "Installing Database"
echo "= = ="
echo

default_name=event_source

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

function create-user {
  echo "Database user is: $user"

  user_exists=`psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$user'"`

  if [ "$user_exists" = "1" ]; then
    echo "Database user \"$user\" was previously created. Not creating again."
  else
    echo "Database user \"$user\" has not yet been created"
    echo "Creating database user \"$user\""
    createuser -s $user
  fi

  echo
}

function create-database {
  echo "Database name is: $database"
  createdb $database
  echo
}

function script_dir {
  val="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "$val"
}

function create-extensions {
  base=$(script_dir)
  psql $database -f $base/extensions.sql
}

function create-table {
  base=$(script_dir)
  psql $database -f $base/table/events-table.sql
}

function create-functions {
  base=$(script_dir)
  psql $database -f $base/functions/category.sql
  psql $database -f $base/functions/stream-version.sql
  psql $database -f $base/functions/write-event.sql
}

function create-indexes {
  base=$(script_dir)
  psql $database -f $base/indexes/events-id.sql
  psql $database -f $base/indexes/events-category-global-position.sql
  psql $database -f $base/indexes/events-category.sql
  psql $database -f $base/indexes/events-stream-name.sql
  psql $database -f $base/indexes/events-stream-name-position-uniq.sql
}

create-user
create-database
create-extensions
create-table
create-functions
create-indexes
