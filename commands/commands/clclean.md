---
allowed-tools: Bash(cd:*), Bash(cat:*), Bash(grep:*), Bash(ls:*), Bash(read:*), Read, Write,Search
description: Clean CLAUDE.md file
argument-hint: [path to a particular CLAUDE.md file]
---

If no argument is provided, then use the CLAUDE.md file in current working directory.
If no argument and no CLAUDE.md file is found in current working directory, then use /opt/clones/github/jalanb/CLAUDE.md

The CLAUDE.md must be in a project root, or higher dir.

Refactor the CLAUDE.md file to follow progressive disclosure principles.

Follow these steps:

1. **Find contradictions**: Identify any instructions that conflict with each other. For each contradiction, ask user which version to keep.

2. **Identify the essentials**: Extract only what belongs in a root CLAUDE.md:
   - One-sentence project description
   - Package manager (if not npm)
   - Non-standard build/typecheck commands
   - Anything truly relevant to every single task

3. **Group the rest**: Organize remaining instructions into logical categories (e.g., TypeScript conventions, testing patterns, API design, Git workflow). For each group, create a separate markdown file.

4. **Create the file structure**: Output:
   - A minimal root CLAUDE.md with markdown links to the separate files
   - Each separate file with its relevant instructions
   - A suggested docs/ folder structure

5. **Flag for deletion**: Identify any instructions that are:
   - Redundant (the agent already knows this)
   - Too vague to be actionable
   - Overly obvious (like "write clean code")

6. If previous steps suggest some  changes are needed, then
   - Present each change to user and ask for approval for it
   - if any changes are approved, then update the CLAUDE.md file, and commit it to git.
