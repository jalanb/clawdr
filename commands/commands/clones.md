---
allowed-tools: Bash(cd:*), Bash(cat:*), Bash(grep:*), Bash(ls:*), Bash(git:*), Read, Write,Search
description: Summarise status of local clones
argument-hint: [No arguments expected]
---

This command should get the status of _all_ clones under /opt/clones/github/jalanb

That directory is the root of all my checked out projects from GitHub, so we are expecting to find many clone directories under it; with each clone being a copy of a particular project.

# Expected directories

This command will list well over 50 git directories, maybe more than 100
```bash
find /opt/clones/github/jalanb -type d -name .git
```

Most of these are in the root of a project cloned from my GitHub projects, few are cloned from local projects. Many will be duplicated, for example the `psyste` project currently has over 10 clones.

## Irrelevant directories

Some clones are needed as part of other tools.
For example there are a number of `vim` plugins which are cloned locally just to get them to work with vim. They are not "mine" in the sense that I do not develop them.

They arre likely to be much deeper in the directory tree than most clones.
For example the clones for vim live here:
 - /opt/clones/github/jalanb/bashrcs/jab/vim/bundle/*/.git
Whereas most of my clones are higher, e.g.
 - /opt/clones/github/jalanb/bashrcs/jab/.git
# Expected actions

This command should traverse every clone found under /..../jalanb and classify each one as either
- Active
 - this is a clone with current activity, such as files which need commiting, or commits that have happened in the last month
- Recent
 - this is a clone which has commits in the last year, but not in the last month
- Mature
 - this is a clone which has commits, all of which are older than 1 year
- Abandoned
 - this is a clone which has very few files and/or commits
 - for example a brand new project by me will get populated with `.gitignore`, `README.md` and `LICENSE`. So if a clone has only those 3 then it was never "really" started, but abandoned soon after it was started.
 - A project with only a few more files, or a few more commits might also be abandoned:
  - if it is so small, and years old, then it is abandoned
  - if it is so small, but has a lot of activity in the git log, especially a lot of recent activity: then it is not abandoned
  - if it has not much activity in the git log, but a lot of files, then it may be "mature" rather than abandoned.



