# 🖥️ Terminal Social Media App
### *A fully functional social media platform — built entirely in Bash*

> **OS Sessional Project** | No database, no server, no framework — just Shell Script + plain text files.

---

## 📌 What Is This?

This is a **terminal-based social media application** written purely in **Bash shell scripting**. It runs directly in your terminal and supports:

- 👤 User Registration & Login
- 📝 Create & View Posts (your own feed)
- ❤️ Like & 💬 Comment on Posts
- 👥 Follow other users
- 💬 **Live Real-Time Chat** between two terminals
- 📋 Conversation List
- 👤 Profile view (posts, followers, following count)

All data is stored in **plain `.txt` files** using `|` as a delimiter — no external dependencies required.

---

## ⚙️ Requirements

| Tool | Check Command |
|------|--------------|
| `bash` | `bash --version` |
| `awk` | Built-in on macOS/Linux |
| `grep` | Built-in |
| `tail` | Built-in |
| `mkfifo` | Built-in |

> ✅ Works on **macOS** and **Linux** out of the box. No installation needed.  
> ⚠️ Run with `bash`, **not** `zsh` or `sh`.

---

## 🚀 How to Run

```bash
# 1. Clone the repository
git clone https://github.com/majhar-32/Social-Media-Os-Sessional.git

# 2. Go into the project folder
cd Social-Media-Os-Sessional

# 3. Give execute permission (only needed once)
chmod +x *.sh

# 4. Run the app
bash main.sh
```

You'll see:
```
===== Terminal Social Media =====
1. Register
2. Login
3. Exit
Choose option:
```

---

## 📁 Project Structure

```
social_media/
│
├── main.sh              ← Entry point — runs the app
├── config.sh            ← All file path variables (centralized)
├── auth.sh              ← Register & Login logic
├── posts.sh             ← Create post
├── feed.sh              ← View feed, Like, Comment
├── follow.sh            ← Follow other users
├── messages.sh          ← Live chat + Conversation list
├── profile.sh           ← View profile stats
├── utils.sh             ← Shared helper functions
│
├── data/
│   ├── users.txt        ← Registered users
│   ├── posts.txt        ← All posts
│   ├── follows.txt      ← Follow relationships
│   ├── likes.txt        ← Who liked which post
│   ├── comments.txt     ← Comments on posts
│   └── messages.txt     ← All chat messages
│
└── counters/
    ├── user_id.txt      ← Auto-increment user ID
    ├── post_id.txt      ← Auto-increment post ID
    ├── comment_id.txt   ← Auto-increment comment ID
    └── message_id.txt   ← Auto-increment message ID
```

---

## 🗃️ Data File Formats

All data is stored as pipe-delimited (`|`) plain text.

| File | Format |
|------|--------|
| `users.txt` | `user_id \| username \| password` |
| `posts.txt` | `post_id \| user_id \| username \| content \| timestamp` |
| `follows.txt` | `follower_id \| followee_id` |
| `likes.txt` | `post_id \| user_id` |
| `comments.txt` | `post_id \| user_id \| username \| comment` |
| `messages.txt` | `msg_id \| sender_id \| receiver_id \| sendername \| message \| datetime` |

---

## 📊 Data Relationship Diagram

This shows how all the data files are connected to each other:

```
┌─────────────┐
│  users.txt  │◄──────────────────────────────────────┐
│ id|name|pass│                                       │
└──────┬──────┘                                       │
       │ user_id                                      │
       ├──────────────────────────────────────────┐   │
       │                  │              │         │   │
       ▼                  ▼              ▼         ▼   │
┌─────────────┐   ┌──────────────┐  ┌──────────────┐  │
│  posts.txt  │   │ follows.txt  │  │ messages.txt │  │
│post|user|.. │   │follower|foll.│  │id|from|to|.. │  │
└──────┬──────┘   └──────────────┘  └──────────────┘  │
       │ post_id                                       │
       ├───────────────────┐          user_id──────────┘
       │                   │
       ▼                   ▼
┌─────────────┐   ┌──────────────┐
│  likes.txt  │   │ comments.txt │
│ post|user   │   │post|user|name│
└─────────────┘   └──────────────┘
```

**Key rules maintained in the data:**
- `likes.txt` → `post_id` must exist in `posts.txt`, `user_id` must exist in `users.txt`
- `comments.txt` → same as above
- `follows.txt` → both IDs must exist in `users.txt`, no self-follows
- `messages.txt` → both `sender_id` and `receiver_id` must exist in `users.txt`

---

## 👥 Sample Data

The project comes with pre-loaded sample data so you can explore all features immediately.

**Test Accounts:**

| Username | Password |
|----------|----------|
| `alice`   | `alice123` |
| `bob`     | `bob123`   |
| `charlie` | `charlie123` |
| `diana`   | `diana123`   |

**Pre-loaded relationships:**

| Type | Details |
|---|---|
| 👥 Follows | alice→bob, alice→charlie, bob→diana, charlie→alice, charlie→bob, diana→bob |
| 📝 Posts | 2 posts per user (8 total) |
| ❤️ Likes | Each post has 2–3 likes (no self-likes) |
| 💬 Comments | 7 comments spread across posts (no self-comments) |
| 📩 Messages | alice↔bob conversation, alice↔charlie conversation |

---

## 🧭 Full Feature Walkthrough

### 1️⃣ Register a New Account

```
===== Terminal Social Media =====
1. Register
Choose option: 1

=== Register ===
Enter username: yourname
Enter password: ****
Confirm password: ****
Registration successful
```

> Or just use one of the sample accounts above to get started instantly.

---

### 2️⃣ Login

```
Choose option: 2

=== Login ===
Username: alice
Password: ****
Login successful

===== Dashboard (alice) =====
1. Create Post
2. View Feed
3. Profile
4. Follow User
5. Messages
6. Logout
```

---

### 3️⃣ Create a Post

```
Choose option: 1

=== Create Post ===
Write your post: Hello everyone! This is my first post.
Post created
```

---

### 4️⃣ View Feed

Your feed shows **your own posts + posts from people you follow**, sorted by newest first.

```
Choose option: 2

=== Your Feed ===

1)
User: bob
Post: Morning coffee and coding session ☕ Best way to start the day!
Likes: 2
Comments: 1

1 Like
2 Comment
3 View Comments
4 Back
```

**To like:** `1` → enter post number  
**To comment:** `2` → enter post number → write comment  
**To view comments:** `3` → enter post number  

> ⚠️ You can only like a post **once**. You cannot like your own posts.

---

### 5️⃣ Follow a User

```
Choose option: 4

=== Follow User ===
Enter username to follow: diana
Followed successfully
```

> After following, diana's posts will appear in your feed.

---

### 6️⃣ View Your Profile

```
Choose option: 3

=== Profile ===
Username: alice
Total Posts: 2
Followers: 2
Following: 2

=== Recent Posts ===
- Had an amazing dinner with friends last night 🍕
- Just joined this platform! Excited to connect with everyone 👋
```

---

### 7️⃣ 💬 Messages (Live Chat)

```
Choose option: 5

=== Messages ===
1. Live Chat
2. Conversation List
3. Back
```

---

#### 💬 Live Chat — How It Works

**Step 1 — Open two terminals** and login with different accounts:

```bash
# Terminal 1
bash main.sh   →  login as alice

# Terminal 2
bash main.sh   →  login as bob
```

**Step 2 — Both go to:** Messages → `1` → Live Chat

**Terminal 1 (alice):**
```
Enter username to chat with: bob

=== Chat with bob ===
alice: Hey bob! How are you doing?
bob: Hi alice! I am great, thanks for asking.
...
[Live] bob is online — messages appear in real time
(Type /exit to leave chat)
```

**Terminal 2 (bob):**
```
[Live] alice is online — messages appear in real time
(Type /exit to leave chat)
```

**Step 3 — Start typing!** Messages appear on the other screen instantly 🎉

---

#### 🔄 What If One User Is Not Online Yet?

```
[Offline] bob is not online — messages will be saved as history
          Waiting for bob to come online...
```

- You can still **send messages** — they are saved as history
- The app **automatically checks every 1 second** if they come online
- When bob opens live chat → your terminal instantly shows:

```
>>> [Live] bob just came online! You are now in real-time chat.
```

✅ No need to restart chat — it switches to live mode automatically.

---

#### 📋 Conversation List

```
Choose option: 2

=== Your Conversations ===
bob
charlie
```

Shows all users you have chatted with. Your own name is never shown.

---

#### ⏹️ Exiting Live Chat

```
/exit
```

> Both `/exit` and `Ctrl+C` clean up properly — no zombie processes left.

---

## ⚡ Quick Command Cheatsheet

```
===== Main Menu =====          ===== Dashboard =====
1 → Register                  1 → Create Post
2 → Login                     2 → View Feed
3 → Exit                      3 → Profile
                               4 → Follow User
===== Feed =====               5 → Messages
1 → Like a post                6 → Logout
2 → Comment on a post
3 → View comments              ===== Messages =====
4 → Back                       1 → Live Chat
                               2 → Conversation List
===== Live Chat =====          3 → Back
/exit → Leave chat
```

---

## 🔄 How to Reset Data (Fresh Start)

To wipe all data and start clean:

```bash
# Clear all data files
echo -n "" > data/users.txt
echo -n "" > data/posts.txt
echo -n "" > data/follows.txt
echo -n "" > data/likes.txt
echo -n "" > data/comments.txt
echo -n "" > data/messages.txt
echo -n "" > data/active_chats.txt
echo -n "" > data/watcher_pids.txt

# Reset all ID counters to 0
echo "0" > counters/user_id.txt
echo "0" > counters/post_id.txt
echo "0" > counters/comment_id.txt
echo "0" > counters/message_id.txt
```

---

## 🏗️ Architecture Notes (OS Concepts Used)

| Concept | Where Used |
|---|---|
| **File I/O** | All data storage (users, posts, messages, etc.) |
| **Process Management** | `$$`, `$!`, background jobs (`&`) |
| **Named Pipes (FIFOs)** | Live chat message streaming between terminals |
| **Signal Handling** | `trap` on `SIGINT`/`SIGTERM` for clean exit |
| **IPC** | `active_chats.txt` coordinates which users are live |
| **Background Processes** | Online monitor polls `active_chats.txt` every 1s |

### Live Chat Internal Flow

```
User A types message
        │
        ▼
Writes to messages.txt
        │
        ▼
tail -f (User B's session) detects new line
        │
        ▼
Writes to named FIFO (.chat_fifo_PID)
        │
        ▼
while-reader filters: is this for me?
        │
        ▼
Prints to User B's terminal instantly
```

### Session Tracking Files *(auto-managed, not committed to git)*

| File | Purpose |
|------|---------|
| `data/active_chats.txt` | Who is in live chat right now (with live shell PID) |
| `data/watcher_pids.txt` | Exact tail & reader PIDs for clean process kill |
| `data/.chat_fifo_<PID>` | Named pipe for each live chat session |

---

## 🔧 Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `Permission denied` when running | Script not executable | Run `chmod +x *.sh` |
| `syntax error` or weird behavior | Running with `zsh` or `sh` | Always use `bash main.sh` |
| Messages appearing in wrong terminal | Orphaned `tail` process from old crashed session | Run `pkill -f "tail -n 0 -f"` in terminal |
| Live chat stuck on `[Offline]` | Stale entry in `active_chats.txt` | App cleans it automatically on next chat open; or manually clear the file |
| `User not found` when chatting | Typo in username | Check exact username with Conversation List |
| New message ID conflicts | Counter file out of sync | Set counter to match the last line count in that data file |

---

## ⚠️ Known Limitations

| Limitation | Details |
|---|---|
| 🔐 Plain text passwords | Passwords are stored as-is — this is a learning project, not production |
| 🖥️ Same machine only | Live chat works between terminals on the **same computer** (shared filesystem) |
| 🔒 No write locks | Concurrent writes to data files are not locked — unlikely to cause issues in small scale |
| 🔔 No notifications | Notification feature intentionally removed to keep the app clean |
| 📷 No media support | Text only — no image, video, or file sharing |
| 💤 No offline message alert | If you're not in live chat, you won't know someone messaged you until you open Messages |

---

## � Team Division (6 Members)

Each member owns specific modules so individual contributions are clearly identifiable.

---

### 👤 Member 1 — Project Lead & System Architecture
**Files:** `main.sh` · `config.sh` · `utils.sh` · `.gitignore` · GitHub Setup

| Responsibility | Details |
|---|---|
| `main.sh` | App entry point, main menu loop, dashboard routing |
| `config.sh` | Centralized file path configuration for the entire system |
| `utils.sh` | Shared helpers — `generate_id()`, `username_exists()`, `get_user_id()` |
| GitHub | Repository creation, git init, branch management, deployment |

---

### 👤 Member 2 — Authentication System
**Files:** `auth.sh` · `data/users.txt` · `counters/user_id.txt`

| Responsibility | Details |
|---|---|
| `register_user()` | New user registration with username uniqueness check and password confirmation |
| `login_user()` | Credential validation, session variable setup (`CURRENT_USER_ID`, `CURRENT_USERNAME`) |
| Data Design | `users.txt` format: `id\|username\|password` |

---

### 👤 Member 3 — Post & Feed System
**Files:** `posts.sh` · `feed.sh` (display) · `data/posts.txt` · `counters/post_id.txt`

| Responsibility | Details |
|---|---|
| `create_post()` | Write post, generate ID, save with Unix timestamp to `posts.txt` |
| `view_feed()` | Show own posts + posts of followed users, sorted newest first |
| Data Design | `posts.txt` format: `id\|user_id\|username\|content\|timestamp` |

---

### 👤 Member 4 — Social Interactions (Like, Comment, Follow)
**Files:** `follow.sh` · `feed.sh` (like/comment) · `data/follows.txt` · `data/likes.txt` · `data/comments.txt` · `counters/comment_id.txt`

| Responsibility | Details |
|---|---|
| `follow_user()` | Follow other users with duplicate and self-follow prevention |
| Like logic | Like a post from feed, duplicate like prevention |
| Comment logic | Write and view comments on posts |
| Data Design | `follows.txt`, `likes.txt`, `comments.txt` formats and integrity rules |

---

### 👤 Member 5 — User Profile & Sample Data
**Files:** `profile.sh` · all `data/*.txt` sample files · `counters/`

| Responsibility | Details |
|---|---|
| `view_profile()` | Display username, total posts, followers, following count, recent posts |
| Sample Data | 4 users, 8 posts, 13 likes, 7 comments, 9 messages — all with consistent relations |
| Data Integrity | No self-likes, no self-comments, all foreign key references valid across files |

---

### 👤 Member 6 — Messaging & Live Chat System
**Files:** `messages.sh` · `data/messages.txt` · `data/active_chats.txt` · `data/watcher_pids.txt` · `counters/message_id.txt`

| Responsibility | Details |
|---|---|
| `live_chat()` | Real-time bidirectional chat using named pipe (FIFO) architecture |
| `_online_monitor()` | Background process that polls every 1s — auto-switches to live mode when other user comes online |
| `clean_stale_chats()` | Detects dead PIDs in `active_chats.txt`, kills orphaned tail/reader processes |
| `list_conversations()` | Shows conversation partners (own name excluded) |
| Process Safety | `trap` for Ctrl+C cleanup, FIFO-based kill so no zombie processes ever leak to other terminals |

---

## �🚀 Future Improvements (Ideas for Teammates)

If you want to extend this project, here are some ideas:
- 🔐 **Password Hashing:** Use `openssl` or `sha256sum` to store passwords securely.
- 🖼️ **ASCII Art Support:** Allow users to "upload" ASCII art as posts.
- 🔍 **Search Feature:** Add a way to search for users or posts by keywords.
- 📅 **Post Timestamps:** Convert Unix timestamps to human-readable dates in the feed.
- 🚫 **Block User:** Implement a blocking system to prevent unwanted messages.
- 📊 **Admin Dashboard:** A special mode to view system-wide stats (total users, most liked post, etc.).

---

> *"Built with nothing but Bash, pipes, and determination."* 🐚
