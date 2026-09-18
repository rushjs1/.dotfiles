---
name: pr-summary
description: Draft a copy-ready pull request summary from the current conversation, branch diff, and commits, following the user's preferred PR format. Use when explicitly invoked to prepare or refresh a PR description.
---

# PR summary

Create a useful starting draft for the current pull request. Return only the PR
description in a fenced Markdown code block so it is easy to copy. Do not create,
edit, or publish a pull request.

## Gather evidence

Use the current conversation for intent and product context, then inspect the
repository with read-only Git commands. Determine the most likely base branch
without assuming it is always `main`, and review:

- the commits on the current branch that are not on the base branch;
- the complete diff from the merge base to the current working state;
- staged, unstaged, and relevant untracked work when it belongs to the PR.

Prefer describing behavior, motivation, and user impact over listing files or
retelling commits. Do not invent requirements, test results, or implementation
details. If the available evidence is ambiguous, produce the best honest draft
and mark only genuinely unresolved details with concise `[TODO: ...]` notes.

## Format

Always begin with this heading:

```markdown
### Summary
```

Follow it with a short, plain-language paragraph in this general style:

```markdown
This PR adds ... Here are some high-level things you might need to know about it. Changes include:
```

Adapt that wording naturally to fixes, refactors, removals, and other kinds of
work. Do not claim that the PR "adds" something when another verb is more
accurate.

Then include a concise bulleted list of the meaningful changes:

```markdown
- Thing one
- Thing two
- Thing three
```

Keep small PRs brief. For a substantial PR, or whenever manual verification is
important, add:

```markdown
#### How to test

1. Go here.
2. Go there.
3. Do this.
4. Verify the expected result.
```

Use standard Markdown numbering (`1.`, `2.`, and so on), actionable steps, and
observable expected results. Omit this section when the change is too small or
the evidence does not support meaningful instructions. Never imply that tests
were run unless the conversation or repository evidence confirms it.

## Writing conventions

- Write for reviewers at a high level while preserving important technical or
  operational details.
- Use clear, conversational prose and short bullets.
- Explain why a change matters when that context is available.
- Group closely related changes rather than producing a file-by-file inventory.
- Mention migrations, configuration, permissions, compatibility concerns, and
  rollout risks when they materially affect review or testing.
- Treat the result as an editable scaffold: complete enough to be useful, but
  concise enough for the user to adjust quickly.
