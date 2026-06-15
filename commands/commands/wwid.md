---
allowed-tools: Bash(find:*), Bash(ls:*), Bash(git:*), Bash(head:*), Bash(tail:*), Bash(wc:*), Bash(sort:*), Bash(stat:*), Read, Glob, Grep
description: What was I doing recently?
---

# WWID - What Was I Doing?

Reconstruct recent work context. **MAX 30 lines output.**

## Step 1: Gather Files

Find 100 most recently modified files under `/opt/clones/github/jalanb/`

**Exclude:**
- `.git/`
- `.tox/`
- `.venv/`
- `*.egg-info/`
- `.DS_Store`
- `build/`
- `dist/`
- `.*_cache/` (matches .mypy_cache, .pytest_cache, etc.)
- `fred.*` (throwaway temp files)

## Step 2: Detect Projects

A directory is a "project" if:
1. It contains a `.git/` subdirectory, OR
2. Path matches `/opt/clones/github/jalanb/X/Y` where X is roughly plural of Y (e.g., `pysyse/pysyte`, `sumpfs/sumpf`), OR
3. It is `/opt/clones/github/jalanb/jalanb` (special case)

Map each file to its project directory.

## Step 3: Score Projects

### Time Scoring (Fibonacci, relative to most recent file)

Anchor = mtime of most recent file found. All ages calculated relative to anchor.

| Bucket    | Age from anchor | Points |
|-----------|-----------------|--------|
| today     | 0-24h           | 13     |
| yesterday | 24-48h          | 8      |
| days      | 2-7 days        | 5      |
| week      | 8-28 days       | 3      |
| month     | 29-90 days      | 2      |
| year      | 91-365 days     | 1      |
| more      | >365 days       | 1      |

### File Weighting

Apply multiplier before summing:
- `hub/*.md` → ×3 (chat artifacts, high signal)
- `CLAUDE.md`, `TODO.md`, `PLAN.md` → ×2.5
- `*.md` (other) → ×1.5
- `*.py`, `*.sh` → ×1
- `*.json`, `*.toml`, `*.yaml` → ×0.3 (likely tool-generated)

### Project Score

```
project_score = sqrt(weighted_file_count) × sum(time_points)
```

## Step 4: Determine Cutoff

Rank projects by score descending.

**Significant drop**: next project scores < 50% of previous project.

Show all projects above the drop, plus exactly 1 project below (to show why we cut).

## Step 5: Output

Minimal header:
```
# WIWID (last activity: [time bucket of most recent file])
```

Per project (most active first):
```
## [Project Name]
[time bucket] | hub: N | md: N | py: N | sh: N
branch: [name] | uncommitted: N
```

The "+1 below the fold" project gets same format but comes last.

No footer. No "Also touched" summary.
