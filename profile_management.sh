#!/bin/bash

source config.sh
source utils.sh

# ─────────────────────────────────────────────
#  Update username
# ─────────────────────────────────────────────
update_username() {
    echo
    echo "=== Change Username ==="

    read -p "New username: " new_username

    if [ -z "$new_username" ]; then
        echo "Username cannot be empty"
        return
    fi

    if [ "$new_username" = "$CURRENT_USERNAME" ]; then
        echo "That is already your username"
        return
    fi

    if username_exists "$new_username"; then
        echo "Username already taken"
        return
    fi

    # Update users.txt
    sed -i "s/^$CURRENT_USER_ID|$CURRENT_USERNAME|/$CURRENT_USER_ID|$new_username|/" "$USERS_FILE"

    # Update username in posts.txt (field 3)
    sed -i "s/^\([^|]*\)|$CURRENT_USER_ID|$CURRENT_USERNAME|/\1|$CURRENT_USER_ID|$new_username|/" "$POSTS_FILE"

    # Update username in comments.txt (field 3)
    sed -i "s/^\([^|]*\)|$CURRENT_USER_ID|$CURRENT_USERNAME|/\1|$CURRENT_USER_ID|$new_username|/" "$COMMENTS_FILE"

    CURRENT_USERNAME="$new_username"
    echo "Username updated to: $CURRENT_USERNAME"
}

# ─────────────────────────────────────────────
#  Update password
# ─────────────────────────────────────────────
update_password() {
    echo
    echo "=== Change Password ==="

    read -s -p "Current password: " current_pass
    echo

    stored=$(grep "^$CURRENT_USER_ID|" "$USERS_FILE" | cut -d '|' -f3)

    if [ "$current_pass" != "$stored" ]; then
        echo "Incorrect current password"
        return
    fi

    read -s -p "New password: " new_pass
    echo
    read -s -p "Confirm new password: " confirm_pass
    echo

    if [ "$new_pass" != "$confirm_pass" ]; then
        echo "Passwords do not match"
        return
    fi

    if [ -z "$new_pass" ]; then
        echo "Password cannot be empty"
        return
    fi

    # Replace the password field (field 3) for this user
    sed -i "s/^$CURRENT_USER_ID|$CURRENT_USERNAME|.*/$CURRENT_USER_ID|$CURRENT_USERNAME|$new_pass/" "$USERS_FILE"

    echo "Password updated successfully"
}

# ─────────────────────────────────────────────
#  Unfollow user
# ─────────────────────────────────────────────
unfollow_user() {
    echo
    echo "=== Unfollow User ==="

    # List who the current user is following
    following_count=$(grep -c "^$CURRENT_USER_ID|" "$FOLLOWS_FILE" 2>/dev/null || echo 0)

    if [ "$following_count" -eq 0 ]; then
        echo "You are not following anyone"
        read -p "Press Enter to return..."
        return
    fi

    echo "You are currently following:"
    echo

    index=1
    declare -a target_ids=()

    while IFS='|' read -r follower_id target_id
    do
        target_name=$(grep "^$target_id|" "$USERS_FILE" | cut -d '|' -f2)
        echo "$index) $target_name"
        target_ids+=("$target_id")
        index=$((index + 1))
    done < <(grep "^$CURRENT_USER_ID|" "$FOLLOWS_FILE")

    echo
    read -p "Enter number to unfollow (or 0 to cancel): " choice

    if [ "$choice" = "0" ] || [ -z "$choice" ]; then
        return
    fi

    # Validate range
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#target_ids[@]}" ]; then
        echo "Invalid choice"
        return
    fi

    selected_id="${target_ids[$((choice - 1))]}"
    selected_name=$(grep "^$selected_id|" "$USERS_FILE" | cut -d '|' -f2)

    # Remove the follow record
    sed -i "/^$CURRENT_USER_ID|$selected_id$/d" "$FOLLOWS_FILE"

    echo "Unfollowed $selected_name"
}

# ─────────────────────────────────────────────
#  View full profile (posts + likes + comments)
# ─────────────────────────────────────────────
view_profile() {
    while true
    do
        echo
        echo "=== Profile: $CURRENT_USERNAME ==="

        total_posts=$(grep -c "|$CURRENT_USER_ID|" "$POSTS_FILE" 2>/dev/null || echo 0)
        followers=$(grep -c "|$CURRENT_USER_ID$" "$FOLLOWS_FILE" 2>/dev/null || echo 0)
        following=$(grep -c "^$CURRENT_USER_ID|" "$FOLLOWS_FILE" 2>/dev/null || echo 0)

        echo "Total Posts : $total_posts"
        echo "Followers   : $followers"
        echo "Following   : $following"
        echo
        echo "=== My Posts ==="

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
            echo "No posts yet"
        fi

        echo
        echo "1. View comments on a post"
        echo "2. Edit username"
        echo "3. Change password"
        echo "4. Unfollow someone"
        echo "5. Back"

        read -p "Choose option: " opt

        if [ "$opt" = "5" ]; then
            return
        fi

        if [ "$opt" = "1" ]; then
            if [ $index -eq 1 ]; then
                echo "No posts to select"
                continue
            fi
            read -p "Enter post number: " num
            chosen_post=$(echo $post_ids | tr ' ' '\n' | grep -v '^$' | sed -n "${num}p")

            if [ -z "$chosen_post" ]; then
                echo "Invalid post number"
                continue
            fi

            echo
            echo "=== Comments ==="
            found=false

            while IFS='|' read -r c_post_id c_user_id c_username c_comment
            do
                if [ "$c_post_id" = "$chosen_post" ]; then
                    echo "  $c_username: $c_comment"
                    found=true
                fi
            done < "$COMMENTS_FILE"

            if [ "$found" = false ]; then
                echo "No comments yet"
            fi

            echo
            read -p "Press Enter to continue..."
        fi

        if [ "$opt" = "2" ]; then
            update_username
        fi

        if [ "$opt" = "3" ]; then
            update_password
        fi

        if [ "$opt" = "4" ]; then
            unfollow_user
        fi

    done
}