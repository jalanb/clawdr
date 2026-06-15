#!/usr/bin/env python3
"""
Deep Init Discovery Script

Bottom-up CLAUDE.md initialization for hierarchical project structures.
Analyzes directory structure and creates execution plan for /init workflow.
"""

import os
from pathlib import Path
from collections import defaultdict


def find_git_root():
    """Find the git root directory."""
    current = Path.cwd()
    while current != current.parent:
        if (current / '.git').exists():
            return current
        current = current.parent
    return Path.cwd()  # Fallback to current directory


def get_all_directories(root_path):
    """Get all directories recursively, excluding system/build directories."""
    dirs = []
    exclude_patterns = {'.git', '.tox', '.mypy_cache', '.pytest_cache', '__pycache__', 
                       '.venv', 'venv', 'node_modules', '.DS_Store', 'build', 'dist'}
    
    def should_exclude(path):
        """Check if path should be excluded."""
        for part in path.parts:
            if part in exclude_patterns or part.startswith('.'):
                return True
        return False
    
    for item in root_path.rglob('*'):
        if item.is_dir() and not should_exclude(item.relative_to(root_path)):
            dirs.append(item)
    return sorted(dirs)


def identify_leaf_directories(directories):
    """Identify directories with no subdirectories."""
    leaf_dirs = []
    for directory in directories:
        has_subdirs = any(
            child.is_dir() and not child.name.startswith('.')
            for child in directory.iterdir()
        )
        if not has_subdirs:
            leaf_dirs.append(directory)
    return leaf_dirs


def identify_parent_directories(directories, leaf_dirs):
    """Identify parent directories ordered by subdirectory count."""
    parents = []
    leaf_set = set(leaf_dirs)
    
    for directory in directories:
        if directory not in leaf_set:
            subdirs = [
                child for child in directory.iterdir()
                if child.is_dir() and not child.name.startswith('.')
            ]
            parents.append((directory, len(subdirs)))
    
    # Sort by subdir count (fewer subdirs first for bottom-up)
    parents.sort(key=lambda x: x[1])
    return [parent[0] for parent in parents]


def clean_existing_claude_files(leaf_dirs):
    """Clean existing CLAUDE.md files from leaf directories."""
    cleaned = []
    for directory in leaf_dirs:
        claude_file = directory / 'CLAUDE.md'
        if claude_file.exists():
            claude_file.unlink()
            cleaned.append(directory)
    return cleaned


def main():
    print("=== Deep Init Discovery Script ===\n")
    
    # Find git root
    git_root = find_git_root()
    print(f"Git root directory: {git_root}")
    
    # Get all directories
    all_dirs = get_all_directories(git_root)
    print(f"Total directories found: {len(all_dirs)}")
    
    # Identify leaf directories
    leaf_dirs = identify_leaf_directories(all_dirs)
    print(f"Leaf directories: {len(leaf_dirs)}")
    
    # Identify parent directories
    parent_dirs = identify_parent_directories(all_dirs, leaf_dirs)
    print(f"Parent directories: {len(parent_dirs)}")
    
    # Clean existing CLAUDE.md files from leaf directories
    cleaned = clean_existing_claude_files(leaf_dirs)
    if cleaned:
        print(f"Cleaned CLAUDE.md from {len(cleaned)} leaf directories")
    
    print("\n=== Execution Plan ===\n")
    
    print("Step 1: Initial Root Context")
    print(f"cd {git_root}")
    print("claude")
    print("/init")
    print("exit\n")
    
    print("Step 2: Initialize Leaf Directories")
    for i, leaf_dir in enumerate(leaf_dirs, 1):
        rel_path = leaf_dir.relative_to(git_root)
        print(f"# Leaf {i}/{len(leaf_dirs)}")
        print(f"cd {leaf_dir}")
        print("claude")
        print("/init")
        print("exit")
        print()
    
    print("Step 3: Initialize Parent Directories")
    for i, parent_dir in enumerate(parent_dirs, 1):
        rel_path = parent_dir.relative_to(git_root)
        print(f"# Parent {i}/{len(parent_dirs)}")
        print(f"cd {parent_dir}")
        print("claude")
        print("/init")
        print("exit")
        print()
    
    print("Step 4: Final Root Context")
    print(f"cd {git_root}")
    print("claude")
    print("/init")
    print("exit\n")
    
    print("=== Directory Details ===\n")
    
    print("Leaf directories:")
    for leaf_dir in leaf_dirs:
        rel_path = leaf_dir.relative_to(git_root)
        print(f"  {rel_path}")
    
    print(f"\nParent directories (ordered by subdir count):")
    for parent_dir in parent_dirs:
        rel_path = parent_dir.relative_to(git_root)
        subdirs = [
            child for child in parent_dir.iterdir()
            if child.is_dir() and not child.name.startswith('.')
        ]
        print(f"  {rel_path} ({len(subdirs)} subdirs)")


if __name__ == "__main__":
    main()