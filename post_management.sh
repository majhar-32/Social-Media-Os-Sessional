#!/bin/bash

source config.sh
source utils.sh

# ─────────────────────────────────────────────
#  Manage posts menu (update / delete)
# ─────────────────────────────────────────────
manage_posts() {
    while true
    do
        echo
        echo "=== Manage My Posts ==="

        index=1
        post_ids=""

        while IFS='|' read -r post_id user_id username content timestamp
        do
            if [ "$user_id" = "$CURRENT_USER_ID" ]; then
                like_count=$(grep -c "^$post_id|" "$LIKES_FILE" 2>/dev/null || echo 0)
                comment_count=$(grep -c "^$post_id|" "$COMMENTS_FILE" 2>/dev/null || echo 0)

                echo
                echo "$index) $content"
                echo "   ❤  Likes: $like_count   💬 Comments: $comment_count"

                post_ids="$post_ids $post_id"
                index=$((index + 1))
            fi
        done < <(sort -t '|' -k5 -nr "$POSTS_FILE")

        if [ $index -eq 1 ]; then
            echo "You have no posts"
            read -p "Press Enter to return..."
            return
        fi

        echo
        echo "1. Edit a post"
        echo "2. Delete a post"
        echo "3. Back"

        read -p "Choose option: " opt

        if [ "$opt" = "3" ]; then
            return
        fi

        # ── Edit post ──────────────────────────────
        if [ "$opt" = "1" ]; then
            read -p "Enter post number to edit: " num
            chosen_post=$(echo $post_ids | tr ' ' '\n' | grep -v '^$' | sed -n "${num}p")

            if [ -z "$chosen_post" ]; then
                echo "Invalid post number"
                continue
            fi

            # Show current content
            current_content=$(grep "^$chosen_post|" "$POSTS_FILE" | cut -d '|' -f4)
            echo "Current content: $current_content"
            read -p "New content: " new_content

            if [ -z "$new_content" ]; then
                echo "Content cannot be empty"
                continue
            fi

            # Escape any special sed characters in new_content
            escaped_content=$(printf '%s\n' "$new_content" | sed 's/[[\.*^$()+?{|]/\\&/g; s/\//\\\//g; s/&/\\\&/g')


            # posts.txt format: post_id|user_id|username|content|timestamp
            # Replace field 4 (content) only for this post_id line
            sed_inplace "s/^\($chosen_post|[^|]*|[^|]*|\)[^|]*|/\1$escaped_content|/" "$POSTS_FILE"


            echo "Post updated"
        fi

        # ── Delete post ────────────────────────────
        if [ "$opt" = "2" ]; then
            read -p "Enter post number to delete: " num
            chosen_post=$(echo $post_ids | tr ' ' '\n' | grep -v '^$' | sed -n "${num}p")

            if [ -z "$chosen_post" ]; then
                echo "Invalid post number"
                continue
            fi

            current_content=$(grep "^$chosen_post|" "$POSTS_FILE" | cut -d '|' -f4)
            echo "Post: $current_content"
            read -p "Are you sure you want to delete this post? (y/n): " confirm

            if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
                echo "Cancelled"
                continue
            fi

            # Remove post from posts.txt
            sed_inplace "/^$chosen_post|/d" "$POSTS_FILE"


            # Remove associated likes
            sed_inplace "/^$chosen_post|/d" "$LIKES_FILE"


            # Remove associated comments
            sed_inplace "/^$chosen_post|/d" "$COMMENTS_FILE"


            echo "Post deleted"
        fi

    done
}