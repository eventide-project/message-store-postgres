#!/usr/bin/env bash

set -e

echo
echo "Installing Database"
echo "= = ="
echo

default_name=message_store

if [ -z ${DATABASE_USER+x} ]; then
  echo "(DATABASE_USER is not set. Default will be used.)"
  user=$default_name
else
  user=$DATABASE_USER
fi

if [ -z ${DATABASE_NAME+x} ]; then
  echo "(DATABASE_NAME is not set. Default will be used.)"
  database=$default_name
else
  database=$DATABASE_NAME
fi

echo

function create-user {
  echo "Database user is: $user"

  user_exists=`psql postgres -qtAXc "SELECT 1 FROM pg_roles WHERE rolname='$user'"`

  if [ "$user_exists" = "1" ]; then
    echo "Database user \"$user\" was previously created. Not creating again."
  else
    echo "Database user \"$user\" has not yet been created"
    echo "Creating database user \"$user\"..."
    createuser -s $user
  fi

  echo
}

function create-database {
  echo "Database name is: $database"
  echo "Creating database \"$database\"..."
  createdb $database
  echo
}

function script_dir {
  val="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "$val"
}

function create-extensions {
  echo "Creating extensions..."
  base=$(script_dir)
  psql $database -f $base/extensions.sql
  echo
}

function create-table {
  echo "Creating messages table..."
  base=$(script_dir)
  psql $database -f $base/table/messages-table.sql
  echo
}

function create-functions {
  base=$(script_dir)
  echo "Creating functions..."
  echo "category function"
  psql $database -f $base/functions/category.sql
  echo "stream_version function"
  psql $database -f $base/functions/stream-version.sql
  echo "write_sql function"
  psql $database -f $base/functions/write-message.sql
  echo
}

function create-indexes {
  base=$(script_dir)
  echo "Creating indexes..."
  echo "messages_id_idx"
  psql $database -f $base/indexes/messages-id.sql
  echo "messages_category_global_position_idx"
  psql $database -f $base/indexes/messages-category-global-position.sql
  echo "messages_category_idx"
  psql $database -f $base/indexes/messages-category.sql
  echo "messages_stream_name_idx"
  psql $database -f $base/indexes/messages-stream-name.sql
  echo "messages_stream_name_position_uniq_idx"
  psql $database -f $base/indexes/messages-stream-name-position-uniq.sql
  echo
}

create-user
create-database
create-extensions
create-table
create-functions
create-indexes
