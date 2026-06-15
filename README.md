# clawdr

User's Claude environment — skills, commands, and the `just` workflows that keep them in sync with `~/.claude/`.

GitHub is source of truth. `just push` deploys to `~/.claude/`. `just pull` pulls back.

---

## Skills

Skills teach Claude how to behave in specific contexts. Each skill is a `SKILL.md` file deployed to `~/.claude/skills/<name>/`.

### Using skills

```bash
just push-skills              # deploy all skills to ~/.claude/skills/
just push-skill <name>        # deploy one skill
just pull-skill <name>        # pull changes back from ~/.claude/ to repo
```

Or from inside a skill dir:

```bash
cd skills/<name> && just push
cd skills/<name> && just pull
```

### Adding a skill

```bash
just new-skill <name>
```

Scaffolds `skills/<name>/` from `templates/`, substitutes `{{ name }}`, opens `SKILL.md` and `README.md` in vim.

### Skill layout

```
skills/<name>/
  src/
    SKILL.md        ← the skill content deployed to ~/.claude/skills/<name>/
  justfile          ← push / pull
  pyproject.toml    ← packaging (if skill has Python code)
  README.md         ← dev notes
```

---

## Commands

Commands are slash commands for Claude Code, deployed to `~/.claude/commands/`.

```bash
just push-commands            # deploy all commands to ~/.claude/commands/
just pull-commands            # pull changes back
```

Commands live in `commands/commands/*.md` (and `.py`, `.sh`).

---

## Background

See `context.md` for the origin story — why this project exists and what problems it solves.
