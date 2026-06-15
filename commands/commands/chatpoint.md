---
allowed-tools: Bash(find:*), Bash(ls:*), Bash(pwd:*), Bash(git:*), Read, Write
description: Save session before compacting, and restore it afterward
---

# Chatpoint

This command is to allow for better workflow management, when compacting local context.


## Your Task

1. find the sessions directory
 1.1. Usually stored at "$ROOT/sessions"
 1.2. Where $ROOT is the root of the project, e.g. "$ROOT/.git" usually exists
 1.3 If you cant find the project's root, then `/opt/clones/github/jalanb` is $ROOT, and we know that `/opt/clones/github/jalanb/sessions` is a dir, set aside for such cases

2. Write this conversation to $ROOT/sessions/session-$(date +%Y%m%d-%H%M%S).md
 1.1. Add the file to git, e.g. `git add sessions/; git commit -m "Chatpoint: talked about stuff"`
 1.2. Replace "talked about stuff" with a short precis of the chat (one-liner)
