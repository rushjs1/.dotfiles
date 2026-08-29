---
name: commit-msg
description: Draft a commit message for the current uncommitted work, matching the repo's existing commit conventions. Never runs git commit — the user commits by hand. Use when the user asks for a commit message, or asks "what should I call this commit".
---

# Commit message drafting

Write a commit message for the work in progress. **Do not commit.** The user runs
all git write commands themselves; your only output is the message text.

## Steps

1. Gather context in one batch of parallel calls:
   - `git status` — see what's staged vs unstaged vs untracked
   - `git diff HEAD` — the actual change (add `--stat` first if the diff is huge)
   - `git log --oneline -20` — learn this repo's conventions

2. Read the recent log for the conventions actually in use, and match them:
   - Conventional Commits prefixes (`feat:`, `fix:`, `chore:`) or plain prose?
   - Imperative (`add`) or past tense (`added`)?
   - Typical subject length, capitalization, trailing period or not
   - Scopes like `feat(api):`? Ticket/issue refs like `[ABC-123]`?

3. Draft the message:
   - Subject line under ~72 characters, describing the *why*, not a file list
   - Body only if the change needs justification or has non-obvious consequences.
     Small changes get a subject line and nothing else.
   - If the staged and unstaged changes are different things, say so and draft
     for what's *staged* — mention that unstaged work isn't covered.

## Output format

Print the message in a fenced code block so it's easy to copy, then the command
to use it — for the user to run, not you:

```
git commit -m "subject line here"
```

For a multi-line message, suggest `git commit` (opens their editor) instead of
stacking `-m` flags.

## Hard rules

- Never call `git commit`, `git add`, `git push`, or any other git command that
  writes. Read-only git commands are fine and expected.
- Do not add `Co-Authored-By` or "Generated with Claude Code" trailers unless
  the repo's own log shows that pattern.
- If there are no changes to describe, say so plainly instead of inventing a message.
