# Global variables
_ODOO_DIRECTORY=~/src/odoo
_ENTERPRISE_DIRECTORY=~/src/enterprise
_DB_OVERRIDE=""

# Do not change this line
_SCRIPT_DIRECTORY=$(dirname "$0")

get_branch() {
    folder=$1

    cd $1 || { echo "Cannot change directory to $_ODOO_DIRECTORY. Exiting." >&2; return 1; }

    branch=$(git branch --show-current)
    remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})

    if [[ $remote_branch == *"odoo-dev"* || $remote_branch == *"enterprise-dev"* ]]; then
        echo "$branch"
        return 0
    elif [ "$folder" = "odoo" ]; then
        get_branch $_ENTERPRISE_DIRECTORY
    else
        return 1
    fi
}

get_tag() {
    tag=$1

    if [[ -z "$tag" ]];
    then
        return 1
    else
        if [[ ! "$tag" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            return 1
        fi

        echo "$tag"
        return 0
    fi
}

pretty_echo() {
    bold='\033[1m'
    regular='\033[0m'
    red='\033[0;31m'
    green='\033[0;32m'
    yellow='\033[0;33m'
    orange='\033[0;33m'
    white='\033[1;37m'

    if [ "$1" == "ERROR" ]; then
        color=$red
    elif [ "$1" == "SUCCESS" ]; then
        color=$green
    elif [ "$1" == "RUNNING" ]; then
        color=$yellow
    elif [ "$1" == "WARNING"]; then
        color=$orange
    else
        color=$white
    fi

    echo -e "${color}${bold}**** $1 ${white}${regular} $2"
}

# Function definition
handle_db_operation() {
    local command=$1
    local dbname=$2

    if [ -z "$_DB_OVERRIDE" ]; then
        dbname=$2
    else
        dbname=$_DB_OVERRIDE
        pretty_echo "WARNING" "Database override. Using $dbname"
    fi

    pretty_echo "RUNNING" "$command database $dbname"

    if [ "$command" = "psql" ]; then
        error_msg=$("$command" -d "$dbname" -f "$3" 2>&1 >/dev/null)
        local error_code=$?
    elif [ "$command" = "pg_dump" ]; then
        error_msg=$("$command" -d "$dbname" -f "$3" 2>&1 >/dev/null)
        local error_code=$?
    else
        error_msg=$("$command" "$dbname" 2>&1 >/dev/null)
        local error_code=$?
    fi

    if [ "$error_code" -ne 0 ]; then
        pretty_echo "ERROR" "Failed to $command database $dbname"
        pretty_echo "ERROR" "Error code: $error_code"
        pretty_echo "ERROR" "Error message: $error_msg"
        exit "$error_code"
    else
        pretty_echo "SUCCESS" "$command database $dbname"
    fi
}
