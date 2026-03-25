#!/bin/bash

source config.sh

follow_user() {
    echo
    echo "=== Follow User ==="

    read -p "Enter username to follow: " target

    target_record=$(grep "|$target|" "$USERS_FILE")

    if [ -z "$target_record" ]; then
        echo "User not found"
        return
    fi

    target_id=$(echo "$target_record" | cut -d '|' -f1)

    if [ "$target_id" = "$CURRENT_USER_ID" ]; then
        echo "You cannot follow yourself"
        return
    fi

    if grep -q "^$CURRENT_USER_ID|$target_id$" "$FOLLOWS_FILE"; then
        echo "Already following"
        return
    fi

    echo "$CURRENT_USER_ID|$target_id" >> "$FOLLOWS_FILE"

    echo "Followed successfully"
}
