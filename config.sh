#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DATA_DIR="$BASE_DIR/data"
COUNTER_DIR="$BASE_DIR/counters"

USERS_FILE="$DATA_DIR/users.txt"
POSTS_FILE="$DATA_DIR/posts.txt"
FOLLOWS_FILE="$DATA_DIR/follows.txt"
LIKES_FILE="$DATA_DIR/likes.txt"
COMMENTS_FILE="$DATA_DIR/comments.txt"
MESSAGES_FILE="$DATA_DIR/messages.txt"
INBOX_STATUS_FILE="$DATA_DIR/inbox_status.txt"
NOTIFICATIONS_FILE="$DATA_DIR/notifications.txt"

USER_ID_COUNTER="$COUNTER_DIR/user_id.txt"
POST_ID_COUNTER="$COUNTER_DIR/post_id.txt"
COMMENT_ID_COUNTER="$COUNTER_DIR/comment_id.txt"
MESSAGE_ID_COUNTER="$COUNTER_DIR/message_id.txt"
ACTIVE_CHATS_FILE="$DATA_DIR/active_chats.txt"
WATCHER_PIDS_FILE="$DATA_DIR/watcher_pids.txt"