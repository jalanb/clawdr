---
allowed-tools: Bash(find:*), Bash(ls:*), Bash(pwd:*), Bash(git:*), Read
description: Find recent files
---

# Recent Files

This command should show me what I've been working on recently.

## UI

Fill a screen with recent ideas on the left and recent files on the right.

Section the ideas by concepts and the files by projects

If there are significantly more/less on one side ot the other, feel free adjust font sizes, if you can

## Recent files

Files are collected in groups like:
- last hour
- last 3 hours
- last 6 hours
- last day
- last days
- last week
- last month

Another AI has offered some `bash` functions you may find useful
- see `recent.sh` in the same dir as this

### Recent dirs

After grouping files, each directory will have some files in each time group.

A directory is "in" the time group that "best represents" its files' and sub-dirs' time-groups
- and then: a project is "in" the time group that "best represents" its directories' time-groups

"Best represents" is defined using a fuzzy sets algorithm.
- see `recent.sh` in the same dir as this

### Recent projects

Projects are in the higher sub-dirs under /opt/clones/github/jalanb/
- usually directly under there

A project dir either
- is a git clone, or
- has many sub-dirs which are git clones

Some examples:
- /opt/clones/github/jalanb/pysyse is a project dir because these are all git clones of the same repo
  - /opt/clones/github/jalanb/pysyse/__dev__
  - /opt/clones/github/jalanb/pysyse/__main__
  - /opt/clones/github/jalanb/pysyse/__pypi__
  - /opt/clones/github/jalanb/pysyse/code
  - /opt/clones/github/jalanb/pysyse/trees
- /opt/clones/github/jalanb/ipythons is a project dir because it is a clone of github repo
- /opt/clones/github/jalanb/jalanb is a project dir because it is a clone of github repo
- /opt/clones/github/jalanb/zatsos is a project dir because these are all git clones of the same repo
  - /opt/clones/github/jalanb/zatsos/__main__
  - /opt/clones/github/jalanb/zatsos/iterm
  - /opt/clones/github/jalanb/zatsos/zatso
- /opt/clones/github/jalanb/pym is a project dir because it is a clone of github repo

