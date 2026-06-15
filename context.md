# Clawder — Session Context

> Notes from the driving/walking conversation that led to the clawder concept.
> Transcribed from voice and notebook photos, 2026-04-07.

---

## The Problem

Alan had custom skills in a GitHub project, copying them manually into `~/.claude/skills/` whenever they changed. He wanted Claude to automatically look in a second location — his GitHub projects directory — rather than requiring a manual copy every time.

The insight: put an instruction in `~/.claude/CLAUDE.md` telling Claude to run a sync script on startup.

---

## The Solution: Clawder

A GitHub project (`jalanb/clawder`) that mirrors `~/.claude/`. On every Claude startup, it syncs from GitHub into `~/.claude/`, with GitHub as source of truth.

---

## Key Decisions Made

- **GitHub is source of truth** — always overwrites local
- **Startup sync** — runs every time Claude starts, on all supported machines
- **Scope rule** — clawder only contains things you'd expect in `~/.claude/`
- **Starting directories** — `skills/` and `commands/` only (expandable later)
- Skills will live in submdules, commands live in sub-dirs
