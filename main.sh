#!/bin/bash

source config.sh
source auth.sh
source posts.sh
source follow.sh
source feed.sh
source messages.sh
source profile.sh

while true
do
    echo
    echo "===== Terminal Social Media ====="
    echo "1. Register"
    echo "2. Login"
    echo "3. Exit"

    read -p "Choose option: " option

    if [ "$option" = "1" ]; then
        register_user
    fi

    if [ "$option" = "2" ]; then
        login_user

        if [ $? -eq 0 ]; then

            echo
            echo "=== Notifications ==="
            grep "^$CURRENT_USER_ID|" "$NOTIFICATIONS_FILE" | cut -d '|' -f2

            while true
            do
                echo
                echo "===== Dashboard ($CURRENT_USERNAME) ====="
                echo "1. Create Post"
                echo "2. View Feed"
                echo "3. Profile"
                echo "4. Follow User"
                echo "5. Messages"
                echo "6. Logout"

                read -p "Choose option: " dash

                if [ "$dash" = "1" ]; then
                    create_post
                fi

                if [ "$dash" = "2" ]; then
                    view_feed
                fi

                if [ "$dash" = "3" ]; then
                    view_profile
                fi

                if [ "$dash" = "4" ]; then
                    follow_user
                fi

                if [ "$dash" = "5" ]; then
                    messages_menu
                fi

                if [ "$dash" = "6" ]; then
                    break
                fi
            done

        fi
    fi

    if [ "$option" = "3" ]; then
        exit
    fi

done
