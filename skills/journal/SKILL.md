---
name: journal
description: Quick update for the daily journal. Add notes, check off todos, or log quick info. Triggers on 'Journal', 'Journal update', 'write to journal', 'Note', 'Check off todo', 'Log this', 'Quick note'.
---

# Journal - Quick Update

Lightweight skill for updating the journal throughout the day. **1-2 minutes max.**

The daily review (Wins, Learnings, Summary) happens in the morning via `/productivity-kit:good-morning`.

## Instructions

### 1. Load today's journal

```bash
date '+%Y-%m-%d %A'
```

**Journal file:** Find and load `journal/{YYYY-MM-DD}.md`.

If the file does not exist -> create it using this template:

```markdown
---
date: {YYYY-MM-DD}
weekday: {Weekday}
mood:
sleep_hours:
sleep_quality:
summary: ""
meetings: []
---

## Todos


## Notes


## Wins


## Learnings

```

### 2. React based on context

Depending on what the user says:

**"Note" / info to log:**
- Add to `## Notes` with timestamp
- Format: `- {HH:MM}: {What}`
- If something is relevant for tomorrow: `- {HH:MM}: tomorrow: {What}`

**"Check off" / completed task:**
- Show `## Todos`
- Update checkboxes (`- [ ]` -> `- [x]`)
- If the task also exists in `CURRENT_WEEK.md` (find via glob: `**/okrs/CURRENT_WEEK.md` or `**/CURRENT_WEEK.md`) -> offer to check it off there too

**Free input (user just says what happened):**
- Decide whether it's a note, a win, or a learning
- Write to the appropriate section

### 3. Confirm briefly

"Done!" - Nothing more, nothing less.

---

## File Reference

**Read from:**
- `journal/{today}.md` - Today's journal

**Write to:**
- `journal/{today}.md` - Notes, Todos, Wins, Learnings
- `CURRENT_WEEK.md` - Check off tasks (optional, find via glob: `**/okrs/CURRENT_WEEK.md`)

---

*Journal Skill - Quick update throughout the day*
*Part of the productivity-kit plugin*
