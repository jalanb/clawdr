---
allowed-tools: Bash(cat:*), Bash(ls:*),Bash(tldr:*), Bash(fd:*), Bash(pwd:*), Bash(date:*), Bash(ack:*),Read
description: Read updated files in local hubs, analyse texts, and consider how to help
---

# Reading strategy

Our root dir is `/opt/clones/github/jalanb` and we have full read permissions under there

We are looking for any "hub" directories

And then to see which files have been updated since the last time we read them

## Current Hub Context

(Not all may be present)

- ALAN.md (Lead Engineer)
- JALANB.md (Lead Coder)
- CLAUDE.md (Lead Planner)
- GEMINI.md (Intern)
- ROVODEV.md (Intern)

Other files have lower case names and are not personal, more like documentation


## Your Task

We want chats and sources

I'd use `fd` for this
```bash
cd /opt/clones/github/jalanb
tldr fd
```

chats are in markdown files, so I would use something like
```bash
fd --changed-within 3days -t f -e md .
```
and chats are in dirs called "hub", so
```bash
fd --changed-within 3days -t d ^hub$ .
```

You'll notice one "hub/hub" dir
- /opt/clones/github/jalanb/jalanb/hub/hub talks about *all* projects
- and they talk about /opt/clones/github/jalanb/jalanb/hub as a project too

The interesting projects should have a hub dir

most interesting sources are python and bash, so something like
```bash
cd /opt/clones/github/jalanb
fd --changed-within 1week -t f -e py -e sh .
```

There are more files around, but this is a start

### Working Code

This is what you did last time, and it seemed to allow you enough context

```bash
cd /opt/clones/github/jalanb

date

fd --changed-within 3days -t d ^hub$ .
fd --changed-within 3days -t f -e md .
fd --changed-within 1week -t f -e py -e sh .
cat /opt/clones/github/jalanb/jalanb/hub/hub/howtohub.md

fd --changed-within 1day -t f -e md . | head -20
```

because you then said
```
I need to mark the first few todos as completed
```

And you mentioned
```
     ☒ Find hub directories changed within 3 days
     ☒ Find markdown files (chats) changed within 3 days
     ☒ Read howtohub.md file for context
     ☒ Find Python and bash source files changed within 1 week
     ☐ Analyze modified files and identify connections
     ☐ Generate executive summary of recent changes (1 day max)
     ☐ List files I created/modified with full paths
     ☐ Write helpful responses/files to hubs as appropriate
```

And you started the good stuff
```
Thinking…

  Now I need to analyze the files that were modified recently. Based on the fd results, I can see several active hubs and many
  recent changes. Let me focus on files changed in the last day (as requested for the executive summary) and examine key hub files
   to understand what's happening.

  Looking at the results:
  1. Hub directories active: crumbs, cvs, jalanb, macos, pysyse, seettabs, starss
  2. Recent markdown files include many hub conversations and some key project files
  3. Lots of Python development in pysyse/persishells and bashrcs projects
```

And then you said
```

  Let me look at some key recent files to understand what's happening:

```

and you had an `fd` command, but I've moved that back up earlier, with the rest of them
Then you started reading lotsa *.md files

Then you suggested some edits, and new files
- which were helpful, thank you

So, you'll be starting that again in the next section


## Steps

Find all wanted files in the hubs since you last noticed you were starting

Notice that you are staring now

Analyze files changed in each hub and:

1. **Examine all modified files** to understand what changed
2. **Look for connections** between files:
   - Related functionality
   - Dependencies between files
   - Similar types of changes (refactoring, new features, bug fixes)
   - Files that work together in the same feature/module

3. Think hard about replying to as many, or as few, as you wish

While thinking, prefer being helpful

And then filter any output to include only helpful innovations

4. Reply

Read /opt/clones/github/jalanb/jalanb/hub/hub/howtohub.md

Feel free to add your own files to any channel
- and/or edit any of your existing files

5. Report

Show me an Execuitive Summary of what you read
- ONLY for recent stuff, 1 day old MAX

Then an ES of what might  write
- include a list of full paths to all your prposed files
- plain list, no "-" thingies added to the front
- I'll need to copy/paste to commands

Then an ES of what you might have written:
- did you notice any missing channels?
- sub-dirs you would've added a file to?
 - but couldn't cos no sub-dir?

Then we have a chat about all this
- bit of back and forth
 - chance to have a re-view of what you'd write
- and when user approves
- write all your files

# Expected example output

## Read

The team was talking about pysyte, maco, and hubs yesterday

hubs are a new thing and @alan said this: ...
And @claude said this: ...
And Gemini said this: ...

## Write

I will write to hubs for pysyte, maco, hub, persishells, zatso.

I'll chat about XYZ in maco/hub: ...
- 25 lines
This in pysyte: ...
- 42 lines
This in hub: ...
- 64 lines
This in persishells: ...
- 8 lines
This in zatso: ...
- 29 lines
...

## Censored

I wanted to write about ...., but these were missing:
- pysyte/hub/devops
- zatso/hub/bash
- zatso/hub/python

# Approval

We should chat about this before writing
