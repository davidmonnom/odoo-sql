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

# Function to extract the part after '-_-'
get_after_dash() {
    for file in "$@"; do
        # Extract the part after '-_-'
        after_dash="${file##*-_-}"

        # Remove '.sql' extension
        after_dash="${after_dash%.sql}"

        echo "$after_dash"
    done
}

directory=$_SCRIPT_DIRECTORY/data
files_with_dash=$(find "$directory" -type f -name "*$branch-_-*" -exec basename {} \;)

pretty_echo "Available tags for" "$branch:"
get_after_dash $files_with_dash

exit 0
