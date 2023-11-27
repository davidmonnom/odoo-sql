#!/bin/bash
current_dir=$(dirname "$0")
cd "$current_dir" || exit 1
source ./sql_common.sh

branch=$(get_branch $_ODOO_DIRECTORY)
return_status=$?
if [ "$return_status" -eq 1 ]; then
    pretty_echo "ERROR" "You need to be on a branch related to odoo-dev or enterprise-dev"
    exit 1
fi

tag=$(get_tag $1)
return_status=$?
if [ "$return_status" -eq 1 ]; then
    pretty_echo "ERROR" "You need to pass a tag name" ;
    exit 1
fi

cd $_SCRIPT_DIRECTORY/data
handle_db_operation pg_dump "$branch" "$branch-_-$tag.sql"

exit 0
