#!/bin/bash

source config.sh
source utils.sh

register_user() {
    echo
    echo "=== Register ==="

    read -p "Enter username: " username

    if username_exists "$username"; then
        echo "Username already exists"
        return
    fi

    read -s -p "Enter password: " password
    echo
    read -s -p "Confirm password: " confirm
    echo

    if [ "$password" != "$confirm" ]; then
        echo "Password mismatch"
        return
    fi

    user_id=$(generate_id "$USER_ID_COUNTER")

    echo "$user_id|$username|$password" >> "$USERS_FILE"

    echo "Registration successful"
}

login_user() {
    echo
    echo "=== Login ==="

    read -p "Username: " username
    read -s -p "Password: " password
    echo

    user_record=$(grep "|$username|" "$USERS_FILE")

    if [ -z "$user_record" ]; then
        echo "User not found"
        return 1
    fi

    stored_password=$(echo "$user_record" | cut -d '|' -f3)
    user_id=$(echo "$user_record" | cut -d '|' -f1)

    if [ "$password" = "$stored_password" ]; then
        CURRENT_USER_ID="$user_id"
        CURRENT_USERNAME="$username"
        echo "Login successful"
        return 0
    else
        echo "Wrong password"
        return 1
    fi
}
