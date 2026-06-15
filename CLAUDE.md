# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

`clawdr` is the source of truth for Alan's `~/.claude/` configuration — skills and commands that teach Claude how to behave in specific contexts. GitHub is authoritative; `~/.claude/` is the deploy target.

## Key directions

- **push**: repo → `~/.claude/` (deploy to the active user environment)
- **pull**: `~/.claude/` → repo (backup changes made during use)

Never reverse these directions.

## Development workflow

Common commands:

```bash
just push-skills               # deploy all skills to ~/.claude/skills/
just push-skill <name>         # deploy one skill
just pull-skill <name>         # pull changes back from ~/.claude/ to repo

just push-commands             # deploy all commands to ~/.claude/commands/
just pull-commands             # pull changes back

just new-skill <name>          # scaffold a new skill from templates/
just add-python <skill>        # add Python code to an existing skill
just add-bash <skill>          # add Bash code to an existing skill
```

## Project structure

```
skills/                        ← skill implementations (currently being converted to submodules)
commands/                      ← slash commands deployed to ~/.claude/commands/
templates/                     ← Jinja2 scaffolds for new-skill and add-* recipes
justfile                       ← orchestrates push/pull and skill scaffolding
```

## Skills and submodules (in progress)

Skills are being migrated to independent git repos, managed as git submodules. See `TODO.md` and `PLAN.md` for the conversion status. This means:

- Each skill is expected to become its own GitHub repo
- More skills will be added over time
- The `skills/` directory will eventually contain only submodule references

## Conventions

- All template files use `.j2` suffix
- Template filename placeholders: `name` is substituted at render time (e.g. `name.py.j2` → `fred.py`)
- Template rendering uses `jrender()` — never overwrites existing files
