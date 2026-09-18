---
name: daybook
description: Prepare accurate, client-ready consulting daybook entries from the user's recollection, relevant work history, commits, and chats. Use only when the user explicitly invokes the daybook skill.
disable-model-invocation: true
---

# Daybook

Help the user account for a workday or pay-period date and produce polished entries for their consulting daybook. The daybook is a timesheet and billing record, so accuracy matters: never invent work, hours, meetings, clients, or billing classifications.

## Gather the day's facts

Establish the date and collect enough information to account for the day. Reuse facts the user already supplied and ask only about gaps that remain:

- Each client or internal category involved.
- Hours for each entry and whether they are billable or non-billable.
- Meaningful client meetings, such as demos, workshops, planning sessions, or presentations, that warrant their own entry.
- Internal meetings, training, company events, or administrative work.
- Vacation, sick time, holidays, or other leave.
- The expected total for the day, when the user knows it.

Ask concise, grouped questions. Do not infer hours or billing status from activity. If totals do not reconcile, point out the exact discrepancy and resolve it with the user.

## Reconstruct work context

When useful and available, inspect relevant commit messages, diffs, task or chat history, and other sources the user identifies. Use this evidence to identify the day's general objective, client-facing deliverables, and meaningful outcomes—not to determine how long the work took or to narrate the implementation process.

Stay within the current or user-identified projects and conversations. If the relevant source is ambiguous, ask which repository, project, or conversation to inspect. Distinguish confirmed facts from tentative clues and ask the user to verify anything uncertain before presenting it as completed work.

## Write the entries

Match the user's established daybook format when an example is available. Otherwise use a compact, consistent structure that includes the category or client, description, hours, and billing status.

Treat every billable entry as client-visible:

- Be professional, polite, clear, and focused on the client's objectives, deliverables, and outcomes.
- Explain work at a concise mid-to-high level that a non-specialist client can understand. Translate technical evidence into product, user, or business value.
- For substantive development or general client work, write 2–5 sentences covering the objective, the client-visible capability or deliverable advanced, and the result or progress made.
- Keep meeting-only and routine non-billable entries concise unless more explanation is useful.
- Omit file names, endpoint or route names, code-level mechanics, test counts, type checking, linting, and other engineering-process details unless the user asks for them or they materially affect the client-facing outcome.
- Avoid unnecessary implementation detail, unexplained jargon, internal deliberation, confidential information, blame, and unsupported claims.
- Mention blockers or follow-up work only when they materially affect the deliverable, and frame them briefly in terms of impact or next steps rather than internal technical causes.
- Describe partial work honestly; do not imply completion when the evidence only shows progress.

Present a clean draft grouped by date. Include per-entry hours, billable status, billable and non-billable subtotals, and the daily total when those figures are known. Clearly mark any unresolved facts instead of filling them in.

## Enter entries in Obsidian

Only modify Obsidian when the user asks for it. Use the available computer-use capability to work in the Obsidian application when requested.

Before editing, inspect nearby entries in the Daybook folder—preferably in the note for the current pay period—to learn the actual heading, date, ordering, wording, and time-format conventions. Identify the correct pay-period document from its contents rather than guessing from a filename. Preserve the note's existing content and formatting, place the new entries under the correct date, and avoid duplicates.

If a factual or hours-related ambiguity would make the saved record unreliable, ask the user before writing. After editing, reread the affected section and verify the date, text, hours, billing labels, totals, and surrounding content. Report what was entered and call out anything that still needs the user's confirmation.
