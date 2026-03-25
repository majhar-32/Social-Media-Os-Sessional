#!/bin/bash

source config.sh

generate_id() {
    file=$1
    id=$(cat "$file")
    id=$((id + 1))
    echo "$id" > "$file"
    echo "$id"
}

username_exists() {
    username=$1
    grep -q "^.*|$username|" "$USERS_FILE"
}

get_user_id() {
    username=$1
    grep "|$username|" "$USERS_FILE" | cut -d '|' -f1
}
