---
allowed-tools: Bash(find:*), Bash(rm:*), Bash(ls:*), Bash(pwd:*), Bash(git:*), Bash(python:*), Read, Write
description: Bottom-up CLAUDE.md initialization - script handles discovery, Claude handles /init workflow
---

# Deep Init

Bottom-up CLAUDE.md initialization for hierarchical project structures

## Current Project Context

- Working directory: !`pwd`
- Git root: !`git rev-parse --show-toplevel 2>/dev/null || pwd`
- Existing CLAUDE.md files: !`find . -name "CLAUDE.md" | head -10`
- Directory structure preview: !`find . -type d -not -path '*/.*' | head -15`

## Your Task

Automatically execute bottom-up CLAUDE.md initialization for the entire project hierarchy:

  1. **Discovery phase**: Identify all directories and create execution plan
  2. **Automated execution**: Run /init in proper order across all directories
     - Initial root context creation
     - All leaf directories in parallel/sequence
     - Parent directories in dependency order
     - Final root context with complete project overview


### Working Code

This command uses a Python helper script to provide project structure data, then orchestrates the /init workflow:

```bash
# Helper script provides project structure data
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py stats
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py root
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py leafs  
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py parents
```

Available helper commands:
- `root` - Show git root directory
- `leafs` - List all leaf directories  
- `parents` - List parent directories in dependency order
- `clean` - Clean CLAUDE.md files (with --all, --leafs, --parents, --root options)
- `stats` - Show project statistics

## Orchestrated Workflow

Use the helper script data to execute the complete /init workflow:

### Step 1: Get Project Structure
```bash
# Get the root directory  
ROOT=$(python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py root)

# Clean existing CLAUDE.md files
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py clean --all
```

### Step 2: Initial Root Context
```bash
cd "$ROOT"
claude -p "/init"
```

### Step 3: Initialize All Leaf Directories  
```bash
# Process each leaf directory
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py clean --leafs
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py leafs | while read leaf; do
  echo "Initializing leaf: $leaf"
  cd "$leaf"
  claude -p "/init"
done
```

### Step 4: Initialize Parent Directories
```bash
# Process parents in dependency order
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py clean --parents
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py parents | while read parent; do
  echo "Initializing parent: $parent" 
  cd "$parent"
  claude -p "/init"
done
```

### Step 5: Final Root Context
```bash
cd "$ROOT"
python3 /opt/clones/github/jalanb/commmands/commands/commands/deep-init.py clean --root
claude -p "/init"
```

## Expected Results

After completing all steps, you should have:

- **Root CLAUDE.md**: Initial context, then final comprehensive overview
- **Leaf CLAUDE.md files**: Context-aware, referencing parent project
- **Parent CLAUDE.md files**: Aggregated context from children
- **Complete hierarchy**: Bottom-up context propagation throughout project

## Notes

- **Hybrid approach**: Python provides structure data, Claude handles /init workflow
- **Context propagation**: Each level can reference higher/lower contexts  
- **Proper ordering**: Root first (for context), then leaves, then parents, then root again
- **Path-independent**: Can be run from any project directory
- **Flexible cleaning**: Multiple clean options (--leafs, --parents, --root, --all)
- **Composable**: Use individual helper commands as needed
