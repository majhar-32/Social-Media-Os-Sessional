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
- 🔔 Notifications (likes, comments, follows)
- 👤 Profile view (posts, followers, following count)

All data is stored in **plain `.txt` files** using `|` as a delimiter — no external dependencies required.

---

## ⚙️ Requirements

| Tool | Check |
|------|-------|
| `bash` | `bash --version` |
| `awk` | Built-in on macOS/Linux |
| `grep` | Built-in |
| `tail` | Built-in |
| `mkfifo` | Built-in |

> ✅ Works on **macOS** and **Linux** out of the box. No installation needed.

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
│   ├── messages.txt     ← All chat messages
│   └── notifications.txt← Like/comment notifications
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
| `notifications.txt` | `user_id \| notification_text` |

---

## 🧭 Full Feature Walkthrough

### 1️⃣ Register a New Account

```
===== Terminal Social Media =====
1. Register
Choose option: 1

=== Register ===
Enter username: alice
Enter password: ****
Confirm password: ****
Registration successful
```

> Passwords are stored as plain text (this is a sessional project, not production 😄).

---

### 2️⃣ Login

```
Choose option: 2

=== Login ===
Username: alice
Password: ****
Login successful

=== Notifications ===
(any pending notifications shown here)

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
User: alice
Post: Hello everyone! This is my first post.
Likes: 0
Comments: 0

1 Like
2 Comment
3 View Comments
4 Back
```

**To like a post:**
```
Choose option: 1
Enter post number: 1
```

**To comment on a post:**
```
Choose option: 2
Enter post number: 1
Write comment: Great post!
```

**To view comments:**
```
Choose option: 3
Enter post number: 1

=== Comments ===
bob: Great post!
```

> ⚠️ You can only like a post **once**. Liking your own post won't send a notification.

---

### 5️⃣ Follow a User

```
Choose option: 4

=== Follow User ===
Enter username to follow: bob
Followed successfully
```

> You cannot follow yourself or follow the same person twice.

After following, **bob's posts will appear in your feed**.

---

### 6️⃣ View Your Profile

```
Choose option: 3

=== Profile ===
Username: alice
Total Posts: 3
Followers: 1
Following: 2

=== Recent Posts ===
- Hello everyone! This is my first post.
- What a great day!
```

---

### 7️⃣ 💬 Messages (Live Chat)

This is the most advanced feature. Open **Messages** from the dashboard:

```
Choose option: 5

=== Messages ===
1. Live Chat
2. Conversation List
3. Back
```

---

#### 💬 Live Chat — How It Works

**Scenario A: Both users open live chat at the same time**

- **Terminal 1** (alice logs in, opens live chat with bob):
```
Enter username to chat with: bob

=== Chat with bob ===
[Live] bob is online — messages appear in real time
(Type /exit to leave chat)
```

- **Terminal 2** (bob logs in, opens live chat with alice):
```
Enter username to chat with: alice

=== Chat with alice ===
[Live] alice is online — messages appear in real time
(Type /exit to leave chat)
```

Now both can type and messages appear on each other's screen **instantly**.

---

**Scenario B: One user opens chat first (other is offline)**

- **Terminal 1** (alice opens chat, bob not online yet):
```
[Offline] bob is not online — messages will be saved as history
          Waiting for bob to come online...
(Type /exit to leave chat)
```

Alice can still **send messages** — they're saved.

- When **bob logs in** and opens live chat with alice:
```
(bob's terminal)
[Live] alice is online — messages appear in real time
```

- And **alice's terminal automatically updates:**
```
>>> [Live] bob just came online! You are now in real-time chat.
```

Both sides are now live — **no need to restart chat**. ✅

---

**To exit live chat:**
```
/exit
```

> ⚠️ Always type `/exit` to leave. Pressing `Ctrl+C` also works safely — a trap handles cleanup.

---

#### 📋 Conversation List

Shows all users you've chatted with (only **their names**, not your own):

```
=== Messages ===
2. Conversation List

=== Your Conversations ===
bob
charlie
```

---

### 8️⃣ 🔔 Notifications

Notifications appear **automatically right after login**:

```
=== Notifications ===
bob liked your post
charlie commented on your post
```

---

## 🧪 Quick Test (Two Terminals)

To test live chat properly, open **two terminal windows**:

```bash
# Terminal 1
cd Social-Media-Os-Sessional
bash main.sh
# → Login as: alice

# Terminal 2
cd Social-Media-Os-Sessional
bash main.sh
# → Login as: bob
```

Then in both:
- Go to **Messages → Live Chat**
- Terminal 1: type `bob` as the user to chat with
- Terminal 2: type `alice` as the user to chat with
- Start typing — messages flow **both ways in real time** 🎉

---

## 🏗️ Architecture Notes (For OS Sessional)

### Why no database?
All data is stored in **pipe-delimited `.txt` files**. This demonstrates fundamental OS concepts:
- **File I/O** for persistent storage
- **Process management** (`$$`, `$!`, background jobs)
- **Inter-Process Communication** via **named pipes (FIFOs)**
- **Signal handling** (`trap`, `SIGINT`, `SIGTERM`)

### How Live Chat Works Internally

```
User A (Terminal 1)                    User B (Terminal 2)
        │                                      │
        ▼                                      ▼
   enter_active_chat()              enter_active_chat()
        │                                      │
        ▼                                      ▼
  is_in_active_chat()?              is_in_active_chat()?
    YES → start watcher               YES → start watcher
        │                                      │
        ▼                                      ▼
  tail -f messages.txt               tail -f messages.txt
        │  (writes to FIFO)                   │  (writes to FIFO)
        ▼                                      ▼
  while-reader (reads FIFO)          while-reader (reads FIFO)
        │  (prints to terminal)               │  (prints to terminal)
        ▼                                      ▼
   Terminal 1 screen                   Terminal 2 screen
```

**If one user is offline** → a background **monitor** polls `active_chats.txt` every 1 second. When the other user comes online, the watcher is started dynamically.

### Session Tracking Files (auto-managed, not committed)
| File | Purpose |
|------|---------|
| `data/active_chats.txt` | Tracks who is currently in live chat (with live PID) |
| `data/watcher_pids.txt` | Tracks tail & reader PIDs for clean process kill |
| `data/.chat_fifo_<PID>` | Named pipe for each live chat session |

---

## 👨‍💻 Contributors

| Name | Role |
|------|------|
| Majharul Islam | Developer |

---

## 📄 License

This project is built for **Academic / OS Sessional** purposes.

---

> *"Built with nothing but Bash, pipes, and determination."* 🐚
