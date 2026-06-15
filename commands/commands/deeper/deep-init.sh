#!/bin/bash

# Deep Init: Automated CLAUDE.md initialization for project hierarchies
# Usage: ./deep-init.sh [target_directory]

set -e

# Configuration
TARGET_DIR="${1:-$(pwd)}"
GIT_ROOT=$(cd "$TARGET_DIR" && git rev-parse --show-toplevel 2>/dev/null || echo "$TARGET_DIR")

echo "🚀 Deep Init: Automated CLAUDE.md Initialization"
echo "Target: $TARGET_DIR"
echo "Git Root: $GIT_ROOT"
echo

# Phase 1: Find all leaf directories
echo "📁 Phase 1: Finding leaf directories..."
LEAF_DIRS=$(find "$GIT_ROOT" -type d -exec bash -c '
    dir="$1"
    # Skip irrelevant dirs
    if [[ "$dir" =~ \.git|node_modules|__pycache__|\.pytest_cache|venv|\.venv|build|dist|\.idea|\.vscode|\.tox ]]; then
        exit 0
    fi
    # Check if directory has any subdirectories
    subdirs=$(find "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    if [ "$subdirs" -eq 0 ]; then
        echo "$dir"
    fi
' _ {} \; | sort)

LEAF_COUNT=$(echo "$LEAF_DIRS" | wc -l)
echo "Found $LEAF_COUNT leaf directories"

# Phase 2: Initialize leaf directories with Claude Code
echo
echo "🤖 Phase 2: Initializing leaf directories with Claude Code..."
echo

failed_dirs=()
for leaf_dir in $LEAF_DIRS; do
    echo "Initializing: $leaf_dir"
    
    # Remove existing CLAUDE.md if present
    if [[ -f "$leaf_dir/CLAUDE.md" ]]; then
        rm "$leaf_dir/CLAUDE.md"
    fi
    
    # Use Claude Code non-interactively to run /init
    # We cd to the directory and run claude with the /init command
    if (cd "$leaf_dir" && claude "/init" 2>/dev/null); then
        if [[ -f "$leaf_dir/CLAUDE.md" ]]; then
            echo "  ✅ Success: CLAUDE.md created"
        else
            echo "  ⚠️  Warning: Command succeeded but no CLAUDE.md found"
            failed_dirs+=("$leaf_dir")
        fi
    else
        echo "  ❌ Failed: Claude Code initialization failed"
        failed_dirs+=("$leaf_dir")
    fi
done

# Phase 3: Build hierarchy bottom-up
echo
echo "🏗️  Phase 3: Building directory hierarchy..."

# Function to generate parent CLAUDE.md
generate_parent_claude_md() {
    local dir="$1"
    local project_name=$(basename "$dir")
    local relative_path=$(realpath --relative-to="$GIT_ROOT" "$dir")
    
    cat > "$dir/CLAUDE.md" << EOF
# $project_name

## Overview

This directory contains multiple subdirectories with their own CLAUDE.md context files.

**Location**: \`$relative_path\`  
**Generated**: $(date)

## Subdirectories

EOF
    
    # List subdirectories with CLAUDE.md files
    find "$dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r subdir; do
        local subdir_name=$(basename "$subdir")
        if [[ -f "$subdir/CLAUDE.md" ]]; then
            # Try to extract a brief description from the subdir's CLAUDE.md
            local description=$(head -n 5 "$subdir/CLAUDE.md" | grep -E "^#+ " | head -n 1 | sed 's/^#* *//' || echo "No description")
            echo "- **$subdir_name/**: $description"
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

# Build hierarchy from bottom up
while true; do
    # Find directories that need CLAUDE.md and have all subdirs ready
    candidates=$(find "$GIT_ROOT" -type d -exec bash -c '
        dir="$1"
        git_root="$2"
        
        # Skip irrelevant dirs and git root
        if [[ "$dir" =~ \.git|node_modules|__pycache__|\.pytest_cache|venv|\.venv|build|dist|\.idea|\.vscode|\.tox ]] || [[ "$dir" == "$git_root" ]]; then
            exit 0
        fi
        
        # Skip if already has CLAUDE.md
        if [[ -f "$dir/CLAUDE.md" ]]; then
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
        done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
        
        # Only output if all subdirs are ready and there are subdirs
        if [[ "$all_subdirs_ready" == "true" ]] && [[ $subdir_count -gt 0 ]]; then
            echo "$dir:$subdir_count"
        fi
    ' _ {} "$GIT_ROOT" \; | sort -t: -k2,2n | cut -d: -f1)
    
    if [[ -z "$candidates" ]]; then
        break
    fi
    
    # Process candidates (starting with those having fewer subdirs)
    for candidate in $candidates; do
        echo "Generating CLAUDE.md for: $candidate"
        generate_parent_claude_md "$candidate"
    done
done

# Phase 4: Generate root CLAUDE.md
echo
echo "🎯 Phase 4: Generating root CLAUDE.md..."

cat > "$GIT_ROOT/CLAUDE.md" << EOF
# $(basename "$GIT_ROOT") - Project Root

## Project Overview

This is the root directory of the project, containing a hierarchical structure of subdirectories, each with their own CLAUDE.md context files.

**Generated**: $(date)

## Directory Structure

The following directories contain CLAUDE.md files:

EOF

# Create a tree-like view of directories with CLAUDE.md files
find "$GIT_ROOT" -name "CLAUDE.md" -not -path "$GIT_ROOT/CLAUDE.md" | sort | while read -r claude_file; do
    local rel_path=$(realpath --relative-to="$GIT_ROOT" "$(dirname "$claude_file")")
    echo "- \`$rel_path/\`"
done >> "$GIT_ROOT/CLAUDE.md"

cat >> "$GIT_ROOT/CLAUDE.md" << EOF

## Context Management Strategy

This project uses a bottom-up approach to context management:

1. **Leaf directories**: Generated using Claude Code's \`/init\` command
2. **Parent directories**: Aggregate context from their subdirectories  
3. **Root directory**: Provides overall project structure and navigation

Each CLAUDE.md file provides context specific to its directory level.

## Git Information

**Repository**: $(git remote get-url origin 2>/dev/null || echo "Local repository")  
**Branch**: $(git branch --show-current 2>/dev/null || echo "Unknown")  
**Last commit**: $(git log -1 --format="%h %s" 2>/dev/null || echo "No commits")

## Statistics

- **Total directories with CLAUDE.md**: $(find "$GIT_ROOT" -name "CLAUDE.md" | wc -l)
- **Leaf directories initialized**: $(echo "$LEAF_DIRS" | wc -l)
- **Failed initializations**: ${#failed_dirs[@]}

EOF

echo "✅ Deep init complete!"
echo
echo "📊 Summary:"
echo "  - Leaf directories: $LEAF_COUNT"
echo "  - Failed initializations: ${#failed_dirs[@]}"
echo "  - Total CLAUDE.md files: $(find "$GIT_ROOT" -name "CLAUDE.md" | wc -l)"

if [[ ${#failed_dirs[@]} -gt 0 ]]; then
    echo
    echo "⚠️  Failed directories:"
    for failed_dir in "${failed_dirs[@]}"; do
        echo "    $failed_dir"
    done
fi