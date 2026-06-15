# TODO items for clawdr

## High

### Make clawdr a proper git repo with skills as submodules ← START HERE
See PLAN.md for steps.
- [ ] `git init` this dir and push to `github.com/jalanb/clawdr`
- [ ] Backfill `barium/`, `claudr/`, `smbc/` with `git init` + push to GitHub
- [ ] Commit and push all skills (`bashr`, `iterm3` already have `.git`)
- [ ] Migrate to submodules (`rm -rf`, `submodule add`, `update --init`)
- [ ] Add `git init` + `gh repo create` to `new-skill` recipe

### Scan ~/.claude/ for untracked content
See PLAN.md.
- [ ] Audit and move anything not yet in clawdr

### Improve Texts
See PLAN.md.
- [ ] All skills should ask to be reviewed and improved at end of session
- [ ] Same for commands

## Medium

### Tests
- [ ] `test-new-skill` recipe: create testskill, push, pull round-trip, verify, cleanup
- [ ] `test-add-python` recipe: new-skill testskill, add-python, verify src/testskill.py, cleanup
- [ ] `test-add-python-package` recipe: add-python testskill package, verify __init__.py + mv logic
- [ ] `test-add-bash` recipe: new-skill testskill, add-bash, verify src/testskill.sh, cleanup
- [ ] sed-based vim suppression in test recipes (`s,vim,# vim,` before, undo after)

### Justfile audit
- [ ] Verify `push`/`pull` targets in all skill justfiles
- [ ] Add `git diff --exit-code` guard to `push`
- [ ] Document the interface contract

## Low

### Documentation
- [ ] Add CLAUDE.md to clawdr root

### Deferred
- [ ] Hierarchical justfiles (`mod`)
