---
allowed-tools: Bash(cd:*), Bash(cat:*), Bash(grep:*), Bash(ls:*), Bash(git:*), Read, Grep, Edit, Write
description: Handle git commands
argument-hint: Normal git arguments, optionally starting with a dir 
---

This command will handle user's normal set of git commands, including, at least
 - clone
 - pull
 - push
 - branch
 - commit
 - log
 - rebase
 - and many more

# Setup

This command knows the git system on the local machine, and can read/write to, e.g.
 - ~/.gitconfig
 - ~/.gitignore_global
 - .git/config
 - .gitignore

For each of those files, and in that order: if it exists you should read it now

In particular you should find any aliases and user's name, email

# Invocation

The first word on the line must be "/g"
If the second word is a real directory on the local machine
 - then use that as "the directory" for commands, and "shift" (like they do in bash)
 - else use "." as "the directory"

Send all the rest of the words on to the git command

# Examples

Some example usages and how they might be handled

```
/g commit
```

This command should consider the files in the current directory which are in the staging area, ready for commit
If some are found:
 - read the code diffs for each
 - compose a message to neatly document the changes to the code
 - run the `$ git commit` command in current dir, with that message

```
/g i
```

This should work in the same way as the earlier "/g commit" example, because I alias "i" to "commit"
 - See ~/.gitconfig for that

```
/g /usr/abrogan/project i
```

This should do the same as the other commits, but should happen in the "/usr/abrogan/project" directory, for example, as
```bash
$ git -C /usr/abrogan/project i "example commit message"
```

```
/g ppu
```
Send a message back to user that we don't know `ppu`
  (As of time of writing, it is not a git alias on this machine)
  Notice that git can help out with mis-spelled alias configured in the machine
  ```bash
  $ git ppu
  WARNING: You called a Git command named 'ppu', which does not exist.
  Run 'puu' instead [y/N]? n
  ```
  So the full message to user might be: "We do not know 'ppu'. git suggests 'puu'"

Notice that git cannot help with single-letter aliases
  For example, `$ git x` will show all 15 1-letter commands, which is not much help
  So, if the arg is unknown and has only 1 letter, simply tell user we do not know it
  
# Co-Authored-By attribution

When composing a commit message, only add `Co-Authored-By: Claude ...` if
Claude wrote or substantially generated the **code** being committed.

Do NOT add it when Claude only:
 - read the diff and composed the commit message
 - ran a command and reported output
 - staged or unstaged files

The question is: **did Claude write what is in the diff?**
 - Yes, Claude generated that function/file/change → add attribution
 - No, the code was already there and Claude just described it → do not

# Early version

We allow short commands like `/g s`, and will pass them on fine
But the real value of this command will be in orchestrating complex ones

Hence the command needs to continuously learn how to improve:
 - after every non-trivial command is run for the user improve this command:
  - read this file
  - consider how it:
    - helped you allow user to use git
    - hindered you in same
  - consider whether it could be better written
  - if needed: update the text, show it to the user as a diff, and request permission to write
