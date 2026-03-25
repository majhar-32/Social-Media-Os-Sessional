#!/bin/bash

source config.sh
source utils.sh

create_post() {
    echo
    echo "=== Create Post ==="
    read -p "Write your post: " content

    if [ -z "$content" ]; then
        echo "Post cannot be empty"
        return
    fi

    post_id=$(generate_id "$POST_ID_COUNTER")
    timestamp=$(date +%s)

    echo "$post_id|$CURRENT_USER_ID|$CURRENT_USERNAME|$content|$timestamp" >> "$POSTS_FILE"

    echo "Post created"
}
