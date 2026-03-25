#!/bin/bash

source config.sh

view_profile() {

    echo
    echo "=== Profile ==="
    echo "Username: $CURRENT_USERNAME"

    total_posts=$(grep -c "|$CURRENT_USER_ID|" "$POSTS_FILE")
    followers=$(grep -c "|$CURRENT_USER_ID$" "$FOLLOWS_FILE")
    following=$(grep -c "^$CURRENT_USER_ID|" "$FOLLOWS_FILE")

    echo "Total Posts: $total_posts"
    echo "Followers: $followers"
    echo "Following: $following"

    echo
    echo "=== Recent Posts ==="

    found=false

    while IFS='|' read -r post_id user_id username content timestamp
    do
        if [ "$user_id" = "$CURRENT_USER_ID" ]; then
            echo "- $content"
            found=true
        fi
    done < <(tail -n 5 "$POSTS_FILE")

    if [ "$found" = false ]; then
        echo "No posts yet"
    fi

    echo
    read -p "Press Enter to return..."
}
