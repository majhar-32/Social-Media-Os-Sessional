#!/bin/bash

source config.sh
source utils.sh

touch "$WATCHER_PIDS_FILE" 2>/dev/null

# ─────────────────────────────────────────────────────────────────────────────
# clean_stale_chats — removes dead-PID entries and kills their orphaned processes
# ─────────────────────────────────────────────────────────────────────────────
clean_stale_chats() {
    local temp_ac="$DATA_DIR/tmp_ac.txt"
    local temp_wp="$DATA_DIR/tmp_wp.txt"
    > "$temp_ac"
    > "$temp_wp"

    while IFS='|' read -r uid cid spid; do
        [ -z "$uid" ] && continue
        if kill -0 "$spid" 2>/dev/null; then
            echo "$uid|$cid|$spid" >> "$temp_ac"
        else
            local wentry
            wentry=$(grep "^$spid|" "$WATCHER_PIDS_FILE" 2>/dev/null)
            if [ -n "$wentry" ]; then
                local tpid rpid fpath
                tpid=$(echo "$wentry"  | cut -d'|' -f2)
                rpid=$(echo "$wentry"  | cut -d'|' -f3)
                fpath=$(echo "$wentry" | cut -d'|' -f4)
                kill "$tpid" 2>/dev/null
                kill "$rpid" 2>/dev/null
                rm -f "$fpath"
            fi
        fi
    done < "$ACTIVE_CHATS_FILE"

    while IFS='|' read -r spid tpid rpid fpath; do
        [ -z "$spid" ] && continue
        kill -0 "$spid" 2>/dev/null && echo "$spid|$tpid|$rpid|$fpath" >> "$temp_wp"
    done < "$WATCHER_PIDS_FILE"

    mv "$temp_ac" "$ACTIVE_CHATS_FILE"
    mv "$temp_wp" "$WATCHER_PIDS_FILE"
}

# ─────────────────────────────────────────────────────────────────────────────
# is_in_active_chat user_id chat_with
#   Returns 0 only if entry exists WITH a live shell PID — no ghost entries
# ─────────────────────────────────────────────────────────────────────────────
is_in_active_chat() {
    local user_id="$1"
    local chat_with="$2"
    while IFS='|' read -r uid cid spid; do
        [ -z "$uid" ] && continue
        if [[ "$uid" == "$user_id" && "$cid" == "$chat_with" ]]; then
            kill -0 "$spid" 2>/dev/null && return 0
        fi
    done < "$ACTIVE_CHATS_FILE"
    return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# Watcher registry (watcher_pids.txt): shell_pid | tail_pid | reader_pid | fifo
# ─────────────────────────────────────────────────────────────────────────────
register_watcher() {
    echo "$$|$1|$2|$3" >> "$WATCHER_PIDS_FILE"
}

unregister_watcher() {
    grep -v "^$$|" "$WATCHER_PIDS_FILE" > "$DATA_DIR/tmp_wp.txt"
    mv "$DATA_DIR/tmp_wp.txt" "$WATCHER_PIDS_FILE"
}

# ─────────────────────────────────────────────────────────────────────────────
# Active-chat registration (active_chats.txt): user_id | receiver_id | shell_pid
# ─────────────────────────────────────────────────────────────────────────────
enter_active_chat() {
    echo "$CURRENT_USER_ID|$1|$$" >> "$ACTIVE_CHATS_FILE"
}

leave_active_chat() {
    grep -v "^$CURRENT_USER_ID|$1|$$" "$ACTIVE_CHATS_FILE" > "$DATA_DIR/tmp_ac.txt"
    mv "$DATA_DIR/tmp_ac.txt" "$ACTIVE_CHATS_FILE"
}

# ─────────────────────────────────────────────────────────────────────────────
# list_conversations
#   Shows usernames of everyone the logged-in user has chatted with.
#   Messages format: id | sender_id | receiver_id | sendername | msg | time
#   - When I sent   ($2 == my_id): other person is receiver ($3) → look up name in users.txt
#   - When I received ($3 == my_id): other person is sender  → name is $4 (sendername)
# ─────────────────────────────────────────────────────────────────────────────
list_conversations() {
    echo
    echo "=== Your Conversations ==="

    awk -F '|' -v uid="$CURRENT_USER_ID" '
        NR == FNR {
            users[$1] = $2   # build id→username map from users.txt
            next
        }
        {
            if ($2 == uid && $3 != uid) {
                # I sent this message → other person is receiver, look up their name
                if ($3 in users) print users[$3]
            }
            if ($3 == uid && $2 != uid) {
                # I received this message → sender name is $4
                print $4
            }
        }
    ' "$USERS_FILE" "$MESSAGES_FILE" | sort -u

    echo
}

# ─────────────────────────────────────────────────────────────────────────────
# live_chat
#
#  Architecture:
#   ┌──────────────────────────────────────────────────────────────────────┐
#   │ Both users online from start → watcher starts immediately both sides │
#   ├──────────────────────────────────────────────────────────────────────┤
#   │ One user offline → shows [Offline], background MONITOR polls every   │
#   │ 1s. When other user comes online → monitor auto-starts FIFO watcher  │
#   │ and prints [Live] notification in real time                          │
#   └──────────────────────────────────────────────────────────────────────┘
#
#  FIFO flow (no orphan leakage):
#   tail -f ──► .chat_fifo_$$ ──► while-reader ──► terminal
#   (tpid)       (named pipe)       (rpid)
#   Kill tpid → FIFO write-end closes → reader gets EOF → reader exits alone
# ─────────────────────────────────────────────────────────────────────────────
live_chat() {
    echo
    read -p "Enter username to chat with: " target_username

    receiver_id=$(get_user_id "$target_username")
    if [ -z "$receiver_id" ]; then echo "User not found"; return; fi

    echo
    echo "=== Chat with $target_username ==="
    echo

    # Print existing chat history
    grep -E "\|$CURRENT_USER_ID\|$receiver_id\||\|$receiver_id\|$CURRENT_USER_ID\|" "$MESSAGES_FILE" \
    | while IFS='|' read -r id sender receiver sendername msg time; do
        echo "$sendername: $msg"
    done

    # Step 1: purge ghost entries
    clean_stale_chats

    # Step 2: mark ourselves as active
    enter_active_chat "$receiver_id"

    # Session PID tracking files — unique per shell PID, shared with background subshells
    _tail_pid_file="$DATA_DIR/.tail_$$"
    _reader_pid_file="$DATA_DIR/.reader_$$"
    _fifo_path_file="$DATA_DIR/.fifo_$$"

    # ── Helper: create FIFO + start tail & reader, record exact PIDs ──────────
    # Works whether called from main context OR from background monitor subshell
    _start_watcher_processes() {
        local chat_fifo="$DATA_DIR/.chat_fifo_$$"
        mkfifo "$chat_fifo" 2>/dev/null

        # tail writes to FIFO — exact PID captured
        tail -n 0 -f "$MESSAGES_FILE" > "$chat_fifo" &
        local tpid=$!

        # reader reads from FIFO — exact PID captured
        # When tail is killed → FIFO write-end closes → reader gets EOF → exits
        while IFS='|' read -r id sender receiver sendername msg time; do
            if [[ "$sender" == "$receiver_id" && "$receiver" == "$CURRENT_USER_ID" ]]; then
                echo "$sendername: $msg"
            fi
        done < "$chat_fifo" &
        local rpid=$!

        # Write PIDs to session files so _chat_cleanup can always find them
        echo "$tpid" > "$_tail_pid_file"
        echo "$rpid" > "$_reader_pid_file"
        echo "$chat_fifo" > "$_fifo_path_file"

        register_watcher "$tpid" "$rpid" "$chat_fifo"
    }

    # ── Background monitor: polls every 1s until receiver comes online ────────
    # Once detected: starts the watcher, prints [Live] notification, then exits
    _online_monitor() {
        while kill -0 "$$" 2>/dev/null; do
            if is_in_active_chat "$receiver_id" "$CURRENT_USER_ID"; then
                _start_watcher_processes
                echo ""
                echo ">>> [Live] $target_username just came online! You are now in real-time chat."
                break
            fi
            sleep 1
        done
    }

    monitor_pid=""

    # Step 3: check if receiver is already online
    if is_in_active_chat "$receiver_id" "$CURRENT_USER_ID"; then
        # Both online — start watcher immediately
        _start_watcher_processes
        echo "[Live] $target_username is online — messages appear in real time"
    else
        # Receiver offline — show status, start background monitor
        echo "[Offline] $target_username is not online — messages will be saved as history"
        echo "          Waiting for $target_username to come online..."
        _online_monitor &
        monitor_pid=$!
    fi

    echo "(Type /exit to leave chat)"
    echo

    # ── Unified cleanup: kills monitor + watcher (via PID files) ─────────────
    _chat_cleanup() {
        # Stop the online monitor
        [ -n "$monitor_pid" ] && kill "$monitor_pid" 2>/dev/null

        # Read exact PIDs from session files and kill them
        local tpid rpid fpath
        tpid=$(cat "$_tail_pid_file"  2>/dev/null)
        rpid=$(cat "$_reader_pid_file" 2>/dev/null)
        fpath=$(cat "$_fifo_path_file" 2>/dev/null)

        [ -n "$tpid" ]  && kill "$tpid" 2>/dev/null
        [ -n "$rpid" ]  && kill "$rpid" 2>/dev/null
        [ -n "$fpath" ] && rm -f "$fpath"

        # Remove session PID files
        rm -f "$_tail_pid_file" "$_reader_pid_file" "$_fifo_path_file"

        unregister_watcher
        leave_active_chat "$receiver_id"
    }

    # Trap Ctrl-C / SIGTERM — cleanup always runs even on force-quit
    trap '_chat_cleanup; trap - INT TERM' INT TERM

    # ── Message send loop ─────────────────────────────────────────────────────
    while true; do
        read msg

        if [[ "$msg" == "/exit" ]]; then
            _chat_cleanup
            trap - INT TERM
            break
        fi

        message_id=$(generate_id "$MESSAGE_ID_COUNTER")
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$message_id|$CURRENT_USER_ID|$receiver_id|$CURRENT_USERNAME|$msg|$timestamp" >> "$MESSAGES_FILE"
        echo "You: $msg"
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# messages_menu
# ─────────────────────────────────────────────────────────────────────────────
messages_menu() {
    while true; do
        echo
        echo "=== Messages ==="
        echo "1. Live Chat"
        echo "2. Conversation List"
        echo "3. Back"

        read -p "Choose option: " choice

        case $choice in
            1) live_chat ;;
            2) list_conversations ;;
            3) break ;;
            *) echo "Invalid option" ;;
        esac
    done
}