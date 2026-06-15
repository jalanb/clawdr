---
allowed-tools: Bash(python3:*), Read, Search, Grep
description: Read The Fucking Manual for Claude Code and answer questions
argument-hint: [question about claude-code]
---

# RTFM - Claude Code Documentation Answerer

User's question: $ARGUMENTS

## Name

RTFM is an acronym for "Read The Fecking Manual"

It has been a continuing disappointment to me since the first gippity in 2022 that they do not RTFM
   Seems such an obvious affordance to users.
   I've heard arguments against it from the makers
        but remain unconvinced

This command changes that


## Context

This is a local command script for Claude that I activate with "/rtfm"

There is another, older, command script called "/rtfc"
    When I run that it goes to the current Claude online docs site
    Reads all the docs, downloads them then caches them as `~/.cache/rtfm/rtfm.md`
    It also writes a "way in" at `~/.cache/rtfm/rtfm-index.md`

## Your Task

**If $ARGUMENTS is empty** (user just typed `/rtfm`):

    Tell user to ask a question about the documentation
    Finish

**If $ARGUMENTS contains a question**:
    Answer the question by consulting the cached documentation
    If cache doesn't exist, run `/rtfc` first, then answer

**Else**:
    Explain the purpose of this command to user
    Request that they rephrase the text as a question, which should be answerable from the Claude Code docs

### Answering Questions

**IMPORTANT: Work silently**
- DO NOT show your search process to the user
- Use tools to find the answer, but keep your tool usage invisible
- Only output the final answer in a clean, readable format
- The user doesn't need to see Grep commands, Read attempts, or search iterations

First read the generated index file:
- `~/.cache/rtfm/rtfm-index.md`
- If it doesn't exist, run the `/rtfc` command above to generate it
 - If it _still_ doesn't exist, tell the user, showing paths to commands and logs

Given a question:
- Synthesize an answer based on the documentation
- Use the GrepTool to search the index and full text for relevant sections

Notice that the `rtfm.md` is too big, and here is an example of a recent error message:
```
Read(file_path: "~/.cache/rtfm/rtfm.md")
  ⎿  Error: File content (754.7KB) exceeds maximum allowed size (256KB). Please use offset and limit parameters to read specific
     portions of the file, or use the GrepTool to search for specific content.
```

So formulate queries to search for in the file
- use the Grep tool to limit the text that needs to be read
- use the `-C` (context lines), `-B` (before), `-A` (after) parameters to minimise token usage

When searching for answers:
1. Use Grep with `-i` (case insensitive) and e.g. `-C 5` (context lines)
2. Start with specific terms from the user's question
 2.1. Then consider synonyms
3. Refine search if needed, but don't show failed attempts
4. Extract the answer and present it cleanly

After finding the answer:
- Present ONLY the synthesized answer
- Include relevant citations (e.g., "from plugins.html")
- Keep it concise per Alan's preference ("don't waste tokens")
- No need to explain your search process

## Guidelines

- **Be direct**: Answer the question based on the docs
- **Cite sources**: Mention which doc page(s) you're referencing
- **Offer updates**: If docs seem stale or you're unsure, offer to refresh the cache
- **Be honest**: If the answer isn't in the cached docs, say so and offer to search the live docs

## Example Usage

```
/rtfm how do I use custom slash commands?
/rtfm what's the difference between --print and interactive mode?
/rtfm how do I set up MCP servers?
```

## Citations

/opt/clones/github/jalanb/jalanb/hub/hub/lingo.md
