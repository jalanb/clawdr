---
allowed-tools: Bash(cd:*), Bash(brew:*), Bash(which:*), Bash(wget:*), Bash(mkdir:*), Bash(curl:*), Bash(ls:*), Bash(find:*), Bash(python3:*), Bash(wc:*), Read, Search
description: Read The Fucking Manual for Claude Code and answer questions
argument-hint: [question about claude-code]
---

# RTFC - Claude Code Documentation Helper

## Name

RTFC is an acronym for "Rebuild The Fecking Cache"

This command supports "/rtfm"

## Arguments

No arguments are expected

If they exist ignore them.
- Warn the user that you did

## Your Task

Important notes:
- Commands must be run from the `~/.cache/rtfm` directory
- No external Python dependencies are needed — stdlib only
- If permission errors occur, STOP and show the erroring command to the user

## Documentation Cache

The Claude Code documentation should be cached locally at:
- `~/.cache/rtfm/docs.claude.com/en/docs/claude-code/` (as HTML files)

There should be a single consolidated file generated from the last download:
- `~/.cache/rtfm/rtfm.md` (Markdown format)

And an index file into it:
- `~/.cache/rtfm/rtfm-index.md` (Markdown format)

### Downloading/Updating the Cache

Use the example commands below to download and update the documentation.
- these are example commands which we found worked as of Oct 2025
 - and re-confirmed in Mar 2026
- offered as a guide only
 - feel free to elaborate

Notice the "> rtfm.log 2>&1" used often in the examples below.
These commands should be "backgrounded" in the sense of user not seeing their stdout/stderr

```bash
PATH=/usr/local/bin:$PATH
export PATH

RTFM_CACHE="$HOME/.cache/rtfm"

cd "$RTFM_CACHE"

# Note: "--timestamping" only downloads changed files: better for our regular downloads

wget --quiet \
     --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --timestamping \
     https://docs.claude.com/en/docs/claude-code/ > rtfm.log 2>&1

# Download release notes (different domain)
# Note: exit code 8 is expected (server redirect quirk) — the file downloads fine
wget --quiet \
     --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --timestamping \
     https://docs.anthropic.com/en/release-notes/claude-code >> rtfm.log 2>&1 || true

# Download raw CHANGELOG.md directly from GitHub (plain text — wget gets the real content)
# This is preferable to the Next.js SPA release-notes page which wget cannot render
wget --quiet \
     --timestamping \
     --output-document="$RTFM_CACHE/CHANGELOG.md" \
     https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md >> rtfm.log 2>&1
```

### Generating the Consolidated Documentation File

The site is a Next.js app: pandoc only gets nav/footer chrome.
Use `~/.cache/rtfm/extract_docs.py` instead — it targets `role="main"` to get real content.

```bash
python3 ~/.cache/rtfm/extract_docs.py 2>> "$RTFM_CACHE/rtfm.log"
```

### Generating the Index File

```bash
python3 ~/.cache/rtfm/gen_index.py >> "$RTFM_CACHE/rtfm.log" 2>&1
```

Then tell the user where to find the new consolidated markdown file: `~/.cache/rtfm/rtfm.md`

Check it is sane: `wc -l ~/.cache/rtfm/rtfm.md` should be > 20,000 lines.

## Example Usage

```
/rtfc   # Updates the docs cache
```
