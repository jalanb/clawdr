---
allowed-tools: Bash(df:*), Bash(du:*), Bash(rm:*), Bash(find:*), Bash(ls:*), Bash(brew:*), Bash(npm:*), Bash(pip*), Bash(tmutil:*), Read
description: Analyze disk usage and suggest cleanup actions
---

# Disk Cleanup

Clean up disk space using standard Mac rules and Alan's personal rules.

## Step 1: Baseline

Capture current usage - we'll compare against this at the end.

```bash
df -h / | grep -v Filesystem
du -sh /Users/jab
```

Store these values for the summary.

## Step 2: Standard Mac Rules

These are safe for any Mac. Check and report sizes for each:

| Location | Command | Notes |
|----------|---------|-------|
| Trash | `du -sh ~/.Trash` | Always safe to empty |
| Caches | `du -sh ~/Library/Caches` | Apps rebuild as needed |
| Logs | `du -sh ~/Library/Logs` | Old logs can go |
| Homebrew | `brew cleanup --dry-run` | Old versions, downloads |
| npm | `du -sh ~/.npm/_cacache` | `npm cache clean --force` |
| pip | `pip cache info` | `pip cache purge` (main cache only, ignore venvs) |
| Xcode DerivedData | `du -sh ~/Library/Developer/Xcode/DerivedData` | Safe to delete |
| iOS Backups | `du -sh ~/Library/Application\ Support/MobileSync/Backup` | Old device backups |

Present findings as a table with sizes.
Ask user which to keep before removing old files.

## Step 3: Alan's Rules

In `~/Downloads`:

- **DELETE**: 
 - `*.dmg` files - always re-downloadable
 - ~/Downloads/Apps/* - same

```bash
# Show DMGs that can go
find ~/Downloads -name "*.dmg" -exec du -sh {} \; | sort -hr

# Show large non-PDF files for review
find ~/Downloads -type f ! -name "*.pdf" ! -name "*.dmg" -exec du -sh {} \; | sort -hr | head -20
```

## Step 4: Orphan Detection

Find leftover data from uninstalled apps. Check these locations for large directories:

```bash
# Large containers
find ~/Library/Containers -maxdepth 1 -type d -exec du -sh {} \; 2>/dev/null | sort -hr | head -15

# Large app support dirs
find "/Users/jab/Library/Application Support" -maxdepth 1 -type d -exec du -sh {} \; 2>/dev/null | sort -hr | head -15
```

For each large directory (>100M), check if the app is still installed:

```bash
# Extract app name from container/folder name and check /Applications
ls -d /Applications/*AppName* 2>/dev/null || echo "NOT INSTALLED"
```

Common orphan patterns:
- `com.microsoft.teams*` - Teams leftovers
- `WebEx Folder` - Cisco WebEx
- `Zoom` - if Zoom uninstalled
- `Slack` - if Slack uninstalled
- UUID-named directories (e.g., `C8A75E2A-0E15-...`) - often orphaned

Present orphans in a table with sizes. Ask user which to delete.

**Important**: Only delete after confirming app is truly uninstalled.

## Step 5: Execute

Only after user confirms each category (from steps 2-4):
- Empty Trash: `rm -rf ~/.Trash/*`
- Clear Caches: `rm -rf ~/Library/Caches/*`
- Clear Logs: `rm -rf ~/Library/Logs/*`
- Homebrew: `brew cleanup`
- npm: `npm cache clean --force`
- pip: `pip cache purge`
- Xcode: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
- Downloads/Apps: `rm -rf ~/Downloads/Apps/*` (preserve the directory)
- DMG files: `find ~/Downloads -name "*.dmg" -delete`

**Important**: Always use `rm -rf dir/*` not `rm -rf dir` - preserve directory structure.

## Step 6: Summary

After cleanup, show comparison:

```
             Before      After       Saved
/            ???G        ???G        ???G
/Users/jab   ???G        ???G        ???G
```

Calculate and display total space recovered.
