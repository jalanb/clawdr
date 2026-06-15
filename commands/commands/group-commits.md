---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(pwd:*), Read, Grep
description: Analyze git changes and suggest logical commit groupings with messages
---

# Git Commit Grouping Analysis

## Current Repository Context

- Working directory: !`pwd`
- Git status: !`git status --porcelain`
- Staged changes: !`git diff --cached --name-only`
- Unstaged changes: !`git diff --name-only`
- Recent commit messages for style reference: !`git log --oneline -5`

## Your Task

Analyze the git changes and:

1. **Examine all modified files** to understand what changed
2. **Look for connections** between files:
   - Related functionality
   - Dependencies between files
   - Similar types of changes (refactoring, new features, bug fixes)
   - Files that work together in the same feature/module

3. **Suggest logical groupings** for commits based on these connections

4. **Create commit messages** for each group that:
   - **Describe the changes** (what this adds/modifies/removes for other developers)
   - **Focus on code changes** not problems being solved
   - **Use imperative mood** ("Add class", "Refactor method", not "Added" or "Fixed")
   - **Follow 50/72 convention** (50 char headline, blank line, 72 char wrapped details)
   - **Avoid "Fixed..." messages** - describe what the code now does instead

Ultrathink about the relationships between the changed files.

5. **Present as actionable git commands** showing which files to add for each commit

Multi-line commit messages are encouraged

Often they will up in the log as the only full context for "why is this code here"

Current context is a temporary chat, so adding as much of the current chat into the message may help someone later
 - Of course: only current context is relevant to the change
 - but, if known, do especially include any arguments against the change
 - if we have been arguing back-and-forth in a chat and ended up with this change
 - then do mention both side of the story

6. The Zen of Python

We do allow lines from the Zen to be used as commit messages
but ONLY when
 1. The message is allowed to be a one-liner
  1.1 The change must be very small and obvious
 2. The line from the Zen is relevant
 3. Explicit approval is requested from, and granted by, the user


Expected example output:
```bash
git add fred.py test_fred.py
git commit -m "Adds a new class Fred, and tests it"

git add fred.sh
git commit -m "Readability counts"


git rm fred.txt
git commit -m "Remove redundant text"
```
