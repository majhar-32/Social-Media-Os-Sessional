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

| Relationship | Details |
|---|---|
| Follows | alice→bob, alice→charlie, bob→diana, charlie→alice, charlie→bob, diana→bob |
| Posts | 2 posts per user (8 total) |
| Likes | Posts have 2–3 likes each (no self-likes) |
| Comments | 7 comments spread across posts (no self-comments) |
| Messages | alice↔bob conversation, alice↔charlie conversation |

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

2)
User: alice
Post: Just joined this platform! Excited to connect with everyone 👋
Likes: 2
Comments: 2

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
alice: Same here, coffee is absolutely essential ☕
```

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
> You cannot follow yourself or follow the same person twice.

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

Open Messages from the dashboard:

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

**Step 2 — Both go to:** Messages → Live Chat

**Terminal 1 (alice):**
```
Enter username to chat with: bob

=== Chat with bob ===
alice: Hey bob! How are you doing?        ← existing history shown
bob: Hi alice! I am great...
...
[Live] bob is online — messages appear in real time
(Type /exit to leave chat)
```

**Terminal 2 (bob):**
```
Enter username to chat with: alice

=== Chat with alice ===
[Live] alice is online — messages appear in real time
(Type /exit to leave chat)
```

**Step 3 — Start typing!** Messages appear on the other screen instantly 🎉

---

#### 🔄 What If One User Is Not Online Yet?

- **Terminal 1 (alice)** opens chat while bob is offline:
```
[Offline] bob is not online — messages will be saved as history
          Waiting for bob to come online...
```

- Alice can still type and send messages — they are saved.
- When **Terminal 2 (bob)** opens live chat with alice, alice's terminal **auto-updates:**
```
>>> [Live] bob just came online! You are now in real-time chat.
```

✅ No need to restart. It detects online status **automatically every 1 second**.

---

#### 📋 Conversation List

Shows all usernames you have chatted with (only their names, never your own):

```
=== Messages ===
Choose option: 2

=== Your Conversations ===
bob
charlie
```

---

#### ⏹️ Exiting Live Chat

```
/exit
```

> Typing `/exit` or pressing `Ctrl+C` both clean up properly — no orphan processes left behind.

---

## 🏗️ Architecture Notes (For OS Concepts)

### Why No Database?
All data uses **pipe-delimited `.txt` files**. This demonstrates fundamental OS concepts in action:

| Concept | Where Used |
|---|---|
| **File I/O** | All data storage (users, posts, messages) |
| **Process Management** | `$$`, `$!`, background jobs (`&`) |
| **Named Pipes (FIFOs)** | Live chat message streaming |
| **Signal Handling** | `trap` on `SIGINT`/`SIGTERM` for clean exit |
| **IPC** | `active_chats.txt` + FIFO for process coordination |
| **Background Processes** | Online monitor polls every 1s |

### How Live Chat Works Internally

```
User A (Terminal 1)                    User B (Terminal 2)
        │                                      │
   enter_active_chat()              enter_active_chat()
        │                                      │
   is_in_active_chat()?              is_in_active_chat()?
    YES → start FIFO watcher           YES → start FIFO watcher
        │                                      │
   tail -f messages.txt ──► FIFO   tail -f messages.txt ──► FIFO
        │                                      │
   while-reader (prints to T1)      while-reader (prints to T2)
```

If one user is **offline** when the other opens chat:
- A **background monitor** polls `active_chats.txt` every `1s`
- When the other user comes online → FIFO watcher starts dynamically
- Both terminals switch to `[Live]` mode automatically

### Session Tracking Files *(auto-managed, not committed to git)*

| File | Purpose |
|------|---------|
| `data/active_chats.txt` | Who is currently in live chat (with live shell PID) |
| `data/watcher_pids.txt` | tail & reader PIDs for precise process kill |
| `data/.chat_fifo_<PID>` | Named pipe for each live chat session |
