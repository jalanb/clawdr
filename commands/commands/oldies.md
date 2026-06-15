---
allowed-tools: Bash(cd:*), Bash(cat:*), Bash(grep:*), Bash(ls:*), Bash(read:*), Read, Write,Search
description: Upgrade an old project
argument-hint: [root directory of a python project]
---

## Project directory

If no argument is provided, then use the current working directory.

Confirm that the directory is the root dir of a python project, for example, it contains some of
- .git/
- setup.py
- setup.cfg
- pyproject.toml
- requirements.txt
- requirements/

If it is not, then tell the user to run this command from the root dir of a python project.

If it is, then assess how old it is

## Project structuring history

My structuring of Python projects progressed as follows:
1. Add a requirements.txt file
2. Add a setup.py file
3. Add a setup.cfg file
4. Add many requiremnts files - for testing, linting, etc.
5. Reduce setup.py as much as possible by
 5.1. Move all values/variables from setup.py to setup.cfg (as much as possible)
 5.2. Stop relying on code in setup.py
6. Add a pyproject.toml file
 6.1. Initially I added this to hold a "[build-system]" section only
 6.2. Later added extra sections as needed
 6.3. Move all of setup.cfg to pyproject.toml
 6.4. Reduce setup.* as much as possible into pyproject.toml
7. Add a .gitlab-ci.yml
 7.1. This was for one particular job I had, but had side-effects on my OSS projects too.
8. Move _everything_ into pyproject.toml
 8.1. Any tool which allows config in pyproject.toml - do that
 8.2. Any new project config needed - also put that in pyproject.toml

Given this "learning cureve" and reading the relevant files in a project, it should be possible to acccurately place any project on this learning curve, at any one of the points mentioned above. We can call this the project's "project maturity".

And the final level (where as much as possible is in pyproject.toml) is the "fully mature" level.

## Task

You should assses the maturity of the current project, and then determine the ch
