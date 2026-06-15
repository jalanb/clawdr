---
allowed-tools: Bash(find:*), Bash(ls:*), Bash(tree:*), Bash(git:*), Read, Glob, Grep
description: Find related local projects
---

# Related Projects

Find local projects similar to the current one.

Input: Current working directory (or $ARGUMENTS if provided)

## Step 1: Identify Current Project

If $ARGUMENTS is a path, use it. Otherwise use `pwd`.

Read from project root:
- README.md (if exists)
- CLAUDE.md (if exists)
- `tree -L 2 -d` output

## Step 2: Discover All Projects

Base: `/opt/clones/github/jalanb/`

A directory is a "project" if:

1. Path matches `jalanb/Xs/X` pattern (plural parent, singular child is a git clone), OR
2. It is a git clone directly under `jalanb/`, OR
3. It is `/opt/clones/github/jalanb/jalanb` (special case)

For plural/singular projects with multiple clones, pick one:
- Prefer `__main__/` if it exists
- Else prefer the singular-named clone
- Else pick alphabetically first

**Exclude** the current project from the list.

## Step 3: Extract Project Metadata

For each discovered project, read:
- README.md first 50 lines
- CLAUDE.md first 50 lines
- `tree -L 2 -d` output

Produce a summary for each:

```json
{
  "name": "project-name",
  "path": "/opt/clones/github/jalanb/...",
  "one_liner": "What it does in <10 words",
  "domain": ["tag1", "tag2"],
  "tech": ["python", "lib1", "lib2"],
  "operates_on": ["files", "git repos"],
  "patterns": ["cli", "library"]
}
```

**Domain tags** (pick 2-4): ai, cli, web, automation, dev-tools, text-processing, file-management, git, chat, data, testing, docs, shell, mac

**Pattern tags** (pick 1-2): cli, library, web-service, bot, wrapper, daemon, tui, protocol-interface, plugin, framework

## Step 4: Score Similarity

Compare current project against each discovered project.

| Match Type | Points |
|------------|--------|
| Same `tech` item | 3 |
| Same `domain` tag | 2 |
| Same `pattern` tag | 2 |
| Same `operates_on` item | 1 |

```
similarity_score = sum(points)
```

## Step 5: Output

Sort by score descending. Show top 5 (or fewer if <5 exist).

```
# Related to: [current project name]

## [Project Name] (score: N)
path: /opt/clones/github/jalanb/...
> one_liner here
tech: python, slack-bolt, httpx
domain: chat, automation

## [Project Name] (score: N)
...
```

If top scorer has score > 10, add:
```
⚠️  High similarity with [name] - consider if these should merge
```
