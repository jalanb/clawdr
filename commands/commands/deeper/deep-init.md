---
allowed-tools: Bash(find:*), Bash(rm:*), Bash(ls:*), Bash(pwd:*), Bash(git:*), Read, Write
description: Bottom-up CLAUDE.md initialization using depth-first strategy
---

# Deep Init

Bottom-up CLAUDE.md initialization for hierarchical project structures

## Given

A project with nested directories like this:

```bash
 $ tree -L 2 -d
.
├── bash -> src/bash/
├── bin
│   ├── iterm
│   └── remote
├── crontab
│   └── bin
├── environ.d
├── etc
│   ├── config
│   ├── pygmentize
│   ├── ssh
│   └── subversion
├── hub
├── src
│   ├── applescript
│   ├── bash
│   ├── python
│   └── templates
└── work

20 directories
```

We have full read permissions under the project root and want to create comprehensive CLAUDE.md files throughout the hierarchy.

### Definitions

#### Root Directory
A "root dir" either:
- has a `.git/`
- has a `pyproject.toml`
- is `/opt/clones/github/jalanb/`

#### Leaf Directory  
A "leaf dir" has no subdirectories

## When

We want to create a really good CLAUDE.md file for the root directory of the project, with proper context propagation from all subdirectories.

## Then

We should use this strategy to "head off" leaf directories with higher context:

### Strategy

#### Phase 1: Discovery and Initial Root Context
Find the project root and create initial CLAUDE.md to provide context for leaf directories

#### Phase 2: Initialize Leaf Directories  
Clean existing CLAUDE.md files from leaves, then manually run `/init` in each (now they can reference root context)

#### Phase 3: Build Hierarchy
Work upward from leaves, generating parent CLAUDE.md files when all children are complete

#### Phase 4: Finalize Root
Re-run `/init` in root with full project context from all subdirectories

## Implementation

### Phase 1: Discovery and Initial Root Context

First, find the project root:

```bash
# Find git root from target directory
target_dir="${1:-$(pwd)}"
git_root=$(cd "$target_dir" && git rev-parse --show-toplevel 2>/dev/null || echo "$target_dir")
echo "Git root: $git_root"
```

#### Initial Root Setup
Create initial context in root directory to provide reference for leaf directories:

```bash
echo "Creating initial root context at: $git_root"
cd "$git_root"
echo "Ready for initial /init command in root directory"
```

#### Manual Step: Initial Root `/init`
1. `cd` to the root directory
2. Run `claude` to start Claude Code session  
3. Run `/init` command to create initial CLAUDE.md
4. Exit session

Find all leaf directories:

```bash
# Find leaf directories - directories with no subdirectories
find "$git_root" -type d -exec bash -c '
    dir="$1"
    # Skip .git and other irrelevant dirs
    if [[ "$dir" =~ \.git|node_modules|__pycache__|\.pytest_cache|venv|\.venv|build|dist|\.idea|\.vscode|\.tox ]]; then
        exit 0
    fi
    # Check if directory has any subdirectories
    if ! find "$dir" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
        echo "$dir"
    fi
' _ {} \; | sort
```

### Phase 2: Clean and Initialize Leaf Directories

For each leaf directory found:

```bash
# For each leaf dir, remove existing CLAUDE.md if it exists
while IFS= read -r leaf_dir; do
    echo "Processing leaf: $leaf_dir"
    
    if [[ -f "$leaf_dir/CLAUDE.md" ]]; then
        echo "  Removing existing CLAUDE.md"
        rm "$leaf_dir/CLAUDE.md"
    fi
    
    echo "  Ready for /init command in: $leaf_dir"
done
```

#### Manual Step
After this phase completes:
1. `cd` to each reported leaf directory  
2. Run `claude` to start Claude Code session
3. Run `/init` command in that session
4. Exit and move to next directory

### Phase 3: Build Up Hierarchy

Process parent directories after all leaf directories have CLAUDE.md files:

```bash
# Build up the hierarchy - process parent directories
# Start from deepest level and work up to git root
find "$git_root" -type d -exec bash -c '
    dir="$1"
    git_root="$2"
    
    # Skip irrelevant dirs
    if [[ "$dir" =~ \.git|node_modules|__pycache__|\.pytest_cache|venv|\.venv|build|dist|\.idea|\.vscode|\.tox ]]; then
        exit 0
    fi
    
    # Skip if already processed or is git root
    if [[ -f "$dir/CLAUDE.md" ]] || [[ "$dir" == "$git_root" ]]; then
        exit 0
    fi
    
    # Check if all immediate subdirs have CLAUDE.md files
    all_subdirs_ready=true
    subdir_count=0
    
    while IFS= read -r subdir; do
        if [[ -n "$subdir" ]]; then
            subdir_count=$((subdir_count + 1))
            if [[ ! -f "$subdir/CLAUDE.md" ]]; then
                all_subdirs_ready=false
                break
            fi
        fi
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d)
    
    # Only process if all subdirs are ready
    if [[ "$all_subdirs_ready" == "true" ]] && [[ $subdir_count -gt 0 ]]; then
        echo "$dir:$subdir_count"
    fi
' _ {} "$git_root" \; | sort -t: -k2,2n | cut -d: -f1
```

#### Generate Parent CLAUDE.md Files

For directories identified in Phase 3:

```bash
# Generate CLAUDE.md content for parent directories
generate_parent_claude_md() {
    local dir="$1"
    local project_name=$(basename "$dir")
    
    cat > "$dir/CLAUDE.md" << EOF
# $project_name

## Overview

This directory contains multiple subdirectories, each with their own CLAUDE.md context files.

Generated: $(date)

## Subdirectories

EOF
    
    # List subdirectories with CLAUDE.md files
    find "$dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r subdir; do
        local subdir_name=$(basename "$subdir")
        if [[ -f "$subdir/CLAUDE.md" ]]; then
            echo "- _${subdir_name}/_: $(head -n 3 "$subdir/CLAUDE.md" | tail -n 1 | sed 's/^# *//' | sed 's/^## *//')"
        fi
    done >> "$dir/CLAUDE.md"
    
    cat >> "$dir/CLAUDE.md" << EOF

## Project Structure

This represents a hierarchical view where each subdirectory maintains its own context through CLAUDE.md files.

## Usage

Navigate to specific subdirectories to access their detailed CLAUDE.md context files.
Each subdirectory's CLAUDE.md was generated using Claude Code's \`/init\` command.

EOF
}
```

### Phase 4: Final Root Context

Re-run `/init` in root directory after all intermediate directories are processed to incorporate full project context:

```bash
echo "Final root context generation at: $git_root"
cd "$git_root" 
echo "Ready for final /init command in root directory with full context"
```

#### Manual Step: Final Root `/init`
1. `cd` to the root directory
2. Run `claude` to start Claude Code session
3. Run `/init` command (now with full context from all subdirectories)
4. Exit session

#### Alternative: Template Generation

If preferred, generate template root CLAUDE.md automatically instead of manual `/init`:

```bash
# Generate root CLAUDE.md last
if [[ "$target_dir" == "$git_root" ]]; then
    echo "Generating final root CLAUDE.md at: $git_root"
    
    cat > "$git_root/CLAUDE.md" << EOF
# $(basename "$git_root") - Project Root

## Project Overview

This is the root directory of the project, containing a hierarchical structure of subdirectories, each with their own CLAUDE.md context files.

Generated: $(date)

## Directory Structure

EOF
    
    # Create a tree-like view of directories with CLAUDE.md files
    find "$git_root" -name "CLAUDE.md" -not -path "$git_root/CLAUDE.md" | sort | while read -r claude_file; do
        local rel_path=$(realpath --relative-to="$git_root" "$(dirname "$claude_file")")
        echo "- $rel_path/"
    done >> "$git_root/CLAUDE.md"
    
    cat >> "$git_root/CLAUDE.md" << EOF

## Context Management

This project uses a bottom-up approach to context management:

1. _Leaf directories_: Generated using Claude Code's \`/init\` command
2. _Parent directories_: Aggregate context from their subdirectories  
3. _Root directory_: Provides overall project structure and navigation

Each CLAUDE.md file provides context specific to its directory level.

## Git Information

Repository: $(git remote get-url origin 2>/dev/null || echo "Local repository")
Branch: $(git branch --show-current 2>/dev/null || echo "Unknown")
Last commit: $(git log -1 --format="%h %s" 2>/dev/null || echo "No commits")

EOF
fi
```

## Summary

This command implements a depth-first strategy for CLAUDE.md management:

### Process Flow
1. _Initial root context_: Run `/init` in root to provide higher context for leaves
2. _Clean and initialize leaves_: Remove old CLAUDE.md files, run `/init` in each leaf directory  
3. _Build hierarchy_: Generate parent CLAUDE.md files when all children are complete
4. _Finalize root_: Re-run `/init` in root with full project context

### Manual Intervention Required
The command handles automation, but you'll need to manually run `/init` in:
- Root directory (initial context creation)
- Each leaf directory (with root context available)
- Root directory again (final context with full project knowledge)

Claude Code sessions can't be automated from within commands.

### Arguments
`$ARGUMENTS` - Target directory (default: current directory)
