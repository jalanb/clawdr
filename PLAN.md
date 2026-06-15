# Plan: clawdr

## Priority 1 — Git repo + submodules

This dir is not yet a git repo. Until it is, nothing else in this plan is stable.

1. `git init` here, push to `github.com/jalanb/clawdr`
2. `bashr/` and `iterm3/` already have `.git` — push them to GitHub
3. `git init` + initial commit in `barium/`, `claudr/`, `smbc/`, push each to GitHub
4. From `clawdr` root: `rm -rf skills/*` then `git submodule add <url> skills/<name>` for each
5. `git submodule update --init`
6. Update `new-skill` recipe: add `git init` + `gh repo create jalanb/{{name}} --public` + `git submodule add`

Only `skills/` become submodules — `commands/` stays as plain files in `clawdr`.

## Development

All skills and command should ask for review and improvemnt

Once one of them is invoked by Claude it should be ready to review itself

If it has a distinct goal, then the review should happen when that goal is reached
 - otherwise it should happen at the end of the session

### How to review

Ask Claude if it found the skill/command useful, if it noticed any error output, any failures, any re-work needed, and what it did well.

If Claude says there are changes that could be made to the text, then offer those changes as suggestions to the user, and start a chat with user, oriented toward updating the texts' files.

## DevOps

1. Each skill is its own GitHub repo, added to `clawdr` as a git submodule
2. The `new-skill` recipe automates the full setup
3. The skill `push`/`pull` interface is documented and audited
4. Deployment should be gated on a clean git state

### Skills are independent projects

Each skill is a self-contained project with its own `justfile`.
The top-level `push-skills` delegates to each skill's own `just push` —
it does not reimplement the logic. This means:
- A skill can be used on any machine independently (e.g. not all skills
  make sense on Windows — `iterm3` is Mac-only)
- The skill's `justfile` is the single source of truth for how it deploys

### Justfile interface contract

Every skill justfile must expose:
- `push` — deploy `src/SKILL.md` to `~/.claude/skills/<name>/SKILL.md`
- `pull` — reverse (with `test -f` guard on source)

Document this contract in a comment at the top of each skill `justfile`.

### new-skill recipe

After creating the directory scaffold, the recipe should:
1. `git init` inside the new skill dir
2. `gh repo create jalanb/<name> --public`
3. `git submodule add <repo-url> skills/<name>`

### Deployment gate

`just push` in each skill should fail if there are uncommitted changes in `src/`:

```
push:
    git diff --exit-code src/
    mkdir -p ~/.claude/skills/<name>
    cp src/SKILL.md ~/.claude/skills/<name>/SKILL.md
```

### Converting skills to submodules (HIGH PRIORITY)

`bashr/` and `iterm3/` already have `.git`. `barium/`, `claudr/`, `smbc/` need backfilling.
Note: only skills become submodules — `commands/` stays as plain files in `clawdr`.
Note: this dir is under active development, there are more skills now than since I wrote this

Steps:

1. Add `git init` to `new-skill` recipe (fix going forward)
2. `git init` + initial commit in `barium/`, `claudr/`, `smbc/`
3. Ensure all skills are fully committed and pushed to GitHub
4. `cd skills && rm -rf *` — removes working dirs, submodule metadata stays clean
5. From `clawdr` root: `git submodule add <url> skills/<name>` for each skill
6. `git submodule update --init` — restores all skill dirs from their repos

### Scan ~/.claude/ for untracked content (HIGH PRIORITY)

`~/.claude/` may contain skills, commands, rules, or config written directly
(not via clawdr). Scan it, identify anything not already in clawdr, and move
it in — so clawdr is the true source of truth.

### Language scaffolding

`add-python` and `add-bash` recipes add language-specific files to an existing skill.

`add-python skill level="python"` — two levels:
- `python`: renders `templates/python/src/name.py.j2` → `skills/<skill>/src/<skill>.py`
- `package`: mkdir `src/<skill>/`, renders `templates/package/src/name/{__init__,__main__}.py.j2`,
  then if `<skill>.py` has more lines than the rendered `__main__.py`, mv it there

`add-bash skill` — renders `templates/bash/src/name.sh.j2` → `skills/<skill>/src/<skill>.sh`

Template filename convention: `name` is the literal placeholder, substituted with skill name at render time.

All template rendering goes through `jrender()` — never overwrites existing files.

### Tests

Each `add-*` recipe and `new-skill` needs a corresponding `test-*` recipe.
Vim suppression: `sed -i 's,vim,# vim,' justfile` before test, restore after.
See TODO.md for checklist.

### Hierarchical justfiles

Current approach: convention only (parent loops, calls `just push` in each skill dir).
Staying with this for now — `mod` is relatively new and adds complexity.
Revisit if the number of shared recipes grows.
