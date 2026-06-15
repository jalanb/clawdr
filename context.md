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

### Naming history
- First called "Flooder" (voice transcription error)
- Then "Clawer"
- Final name: **Clawder**

---

## Key Decisions Made

- **GitHub is source of truth** — always overwrites local
- **Startup sync** — runs every time Claude starts, on all supported machines
- **Scope rule** — clawder only contains things you'd expect in `~/.claude/`
- **Starting directories** — `skills/` and `commands/` only (expandable later)
- **Multi-machine branching** — each Mac gets its own branch; Alan does the careful merging
- **Windows is export-only** — no Claude on Windows Surface, Copilot instead; clawder will push to it eventually but not pull back

---

## Machines in Scope

| Machine | Role |
|---|---|
| MacBook Air M2 | Primary personal machine, main Claude machine |
| iMac | Standing desk machine, also gets clawder sync |
| Mac Mini (2011) | Music server — not in scope |
| Windows Surface 6 | JRI corporate machine — export only, future |

---

## Windows / Copilot Notes

- Windows Surface runs Microsoft Copilot, not Claude
- Copilot uses `AGENTS.md`; Claude uses `CLAUDE.md`
- Claude could write a good `AGENTS.md` from its own knowledge
- Copilot in terminal is coming — that's the hook
- Alan SSHes from Windows into Linux machines; a Microsoft Agent tool will eventually run there
- Clawder will export to Windows, not sync (to start)

---

## JRII / SMBC Separation (from notebook)

Strong separation needed between the two contexts:

| | JRII | SMBC |
|---|---|---|
| Source | Open source | Closed source (under GPL) |
| Time | Night work | Day work |
| Machine | Mac | Windows |
| AI | Claude + `CLAUDE.md` | ChatGPT + `AGENTS.md` |

Key insight from notebook: **JRII knows how to do Ansible Engineering** in a way that can easily write `AGENTS.md`, given `~/github/SMBC/ALAN.md` or similar.

---

## JRI/SMBC Current Tasks (from notebook, addressed to Claude)

- **EA-12210 management** — Done
- **Netwrix agent** — almost complete. Review of whether needed in progress.
- **Gigamon server setup** — meeting abandoned last Friday by them, waiting on new time
- **GitHub as Code** — stumbling; new feature: allow usage of GitHub via Ansible, e.g. trigger Copilot as reviewer for all "collection repos"

---

## Notebook Pages — JRI Technical Notes (separate batch)

From an earlier set of notebook photos (likely from a flight/commute):

- Download the RPM? Whence?
- Netwrix hub password
- Satellite (partially legible)
- System Setting Dark A.P (partially legible)
- Remove BGENV!! / Password for `*.xml` / Any app has a log dir / Expect server
- Renew Ansible — Create cred in CyberArk, add to default CAC repo, then add to company team-specific CAC (has an injector)
- New var `-uid/git`
- Not connected yet: Maybe Fail / Maybe Retry / Creds instance

**Gigamon:**
- Cluster + nodes + (hardware details)
- Gigamon Playbooks — clone / Gigamon config mgmt / README / wiki
- 1) Get var file setup first / 2) Reach out to Colin for deploy
- Clustered up in NJ? Or more like Brazil?

**Parts of an Agent:**
1. Software itself — how installed (rpm/deb), how updated, uninstalled, dependencies (java? python?)
2. Service (probably) to run it — service name, what happens on crash, who starts/stops
3. Config files — must be somewhere, format?, keys/passwords?
4. Comms — every agent "phones home", where is home? host/port, certs/tokens/keys
5. Logs — where, how big, rotation?
6. Disaster — is it up (how to ask?), if not bring it back, heartbeating?

Netwrix should check that "CIS Rules" are OK.

**Agents general:**
- Installed? Add files
- Refer back to other agent scripts
- If installed — get version / if not — rpm install it
- New agent: Netwrix. See also: (other agents)

---

## NPW Note (from meeting, notebook)

> "Can we switch all our... to NPW"
> NPW = Non Project Work — longer term item
