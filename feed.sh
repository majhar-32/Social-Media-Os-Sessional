#!/bin/bash

source config.sh

view_feed() {

while true
do

    echo
    echo "=== Your Feed ==="

    following_ids=$(grep "^$CURRENT_USER_ID|" "$FOLLOWS_FILE" | cut -d '|' -f2)

    index=1
    post_ids=""
    post_owners=""

    while IFS='|' read -r post_id user_id username content timestamp
    do
        show_post=false

        if [ "$user_id" = "$CURRENT_USER_ID" ]; then
            show_post=true
        fi

        for fid in $following_ids
        do
            if [ "$user_id" = "$fid" ]; then
                show_post=true
            fi
        done

        if [ "$show_post" = true ]; then

            like_count=$(grep -c "^$post_id|" "$LIKES_FILE")
            comment_count=$(grep -c "^$post_id|" "$COMMENTS_FILE")

            echo
            echo "$index)"
            echo "User: $username"
            echo "Post: $content"
            echo "Likes: $like_count"
            echo "Comments: $comment_count"

            post_ids="$post_ids $post_id"
            post_owners="$post_owners $user_id"

            index=$((index+1))
        fi

    done < <(sort -t '|' -k5 -nr "$POSTS_FILE")

    if [ $index -eq 1 ]; then
        echo "No posts yet"
        return
    fi

    echo
    echo "1 Like"
    echo "2 Comment"
    echo "3 View Comments"
    echo "4 Back"

    read -p "Choose option: " option

    if [ "$option" = "4" ]; then
        return
    fi

    if [ "$option" = "1" ]; then
        read -p "Enter post number: " num
        post_id=$(echo $post_ids | cut -d ' ' -f$num)
        owner_id=$(echo $post_owners | cut -d ' ' -f$num)

        if [ -z "$post_id" ]; then
            continue
        fi

        if grep -q "^$post_id|$CURRENT_USER_ID$" "$LIKES_FILE"; then
            continue
        fi

        echo "$post_id|$CURRENT_USER_ID" >> "$LIKES_FILE"
    fi

    if [ "$option" = "2" ]; then
        read -p "Enter post number: " num
        post_id=$(echo $post_ids | cut -d ' ' -f$num)
        owner_id=$(echo $post_owners | cut -d ' ' -f$num)

        if [ -z "$post_id" ]; then
            continue
        fi

        read -p "Write comment: " comment
        echo "$post_id|$CURRENT_USER_ID|$CURRENT_USERNAME|$comment" >> "$COMMENTS_FILE"
    fi

    if [ "$option" = "3" ]; then
        read -p "Enter post number: " num
        post_id=$(echo $post_ids | cut -d ' ' -f$num)

        if [ -z "$post_id" ]; then
            continue
        fi

        echo
        echo "=== Comments ==="

        found=false

        while IFS='|' read -r c_post_id c_user_id c_username c_comment
        do
            if [ "$c_post_id" = "$post_id" ]; then
                echo "$c_username: $c_comment"
                found=true
            fi
        done < "$COMMENTS_FILE"

        if [ "$found" = false ]; then
            echo "No comments yet"
        fi

        echo
        read -p "Press Enter to continue..."
    fi

done

}
