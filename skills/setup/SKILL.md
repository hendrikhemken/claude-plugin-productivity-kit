---
name: setup
description: Interactive onboarding wizard for the productivity-kit. Creates folder structure, templates, and initial files for the OKR + Daily Routine system. Run this first! Trigger on 'setup', 'get started', 'initialize', 'onboarding', 'configure productivity kit'.
---

# Productivity Kit Setup

Interactive onboarding wizard. Creates your OKR + Daily Routine system in ~5 minutes.

## Overview

This skill guides the user through a 6-phase interactive setup:

1. **Welcome & Context Gathering** — Ask key questions about their business
2. **Create Folder Structure** — Set up `journal/`, `okrs/`, `dashboards/`, `user_context/`
3. **Create Initial Files** — Fill templates with user answers
4. **CLAUDE.md Integration** — Add daily rhythm instructions
5. **OKR Quick-Start** — Optionally create first OKRs
6. **Summary** — Show what was created and next steps

## Instructions

### PHASE 1: Welcome & Context Gathering

Start with a friendly welcome message:

```
Welcome to the Productivity Kit! This wizard sets up your personal OKR + Daily Routine system.

The productivity-kit gives you 6 skills:
- /productivity-kit:setup — This wizard (you're running it now!)
- /productivity-kit:good-morning — Daily kickoff: review yesterday, plan today
- /productivity-kit:okr-monday — Weekly commitment check-in
- /productivity-kit:okr-friday — Weekly celebration & review
- /productivity-kit:journal — Quick journal updates during the day
- /productivity-kit:okr-expert — OKR best practices advisor

Let's get you set up. I'll ask a few questions.
```

Then ask these questions ONE AT A TIME (wait for each answer before asking the next):

1. "What's your business or project name?"
2. "What do you do? (1-2 sentences is perfect)"
3. "What's your location/timezone?" (use for journal timestamps)
4. Auto-detect the current quarter from the system date. Confirm with user: "Looks like we're in Q{X} {YYYY} — correct?"
5. "Do you have a Google Calendar MCP server configured? (This lets the morning routine pull your calendar — totally optional, everything works without it)"
6. "Do you have a Granola MCP server configured? (This lets us pull meeting transcripts for daily reviews — also optional)"

Store all answers for use in later phases. Proceed to Phase 2 after all questions are answered.

### PHASE 2: Create Folder Structure

Create these directories relative to the project root:

```
journal/
okrs/
dashboards/
user_context/
```

Before creating each directory, check if it already exists. If it does, skip it and note that it was already present. Use `mkdir -p` to create directories safely.

Tell the user what you're creating:
```
Creating folder structure...
- journal/ — Daily journal entries
- okrs/ — Quarterly OKRs and weekly plans
- dashboards/ — Pipeline and opportunity tracking
- user_context/ — Business context for AI sessions
```

### PHASE 3: Create Initial Files from Templates

Read each template file from the plugin's `templates/` directory, replace `{{PLACEHOLDER}}` values with the user's answers, and write the result to the project root.

**Determine the plugin's template path:** The templates live at `templates/` relative to the plugin root (the directory containing the `skills/` folder). Resolve this path before reading templates.

**Files to create:**

#### 3a. user_context/COMPANY_CONTEXT.md
- Read: `templates/company-context-template.md`
- Replace placeholders:
  - `{{BUSINESS_NAME}}` — from question 1
  - `{{BUSINESS_DESCRIPTION}}` — from question 2
  - `{{LOCATION}}` — from question 3
  - `{{CURRENT_QUARTER}}` — e.g. "Q1 2026"
- Write to: `user_context/COMPANY_CONTEXT.md`
- If file already exists, ask user: "COMPANY_CONTEXT.md already exists. Overwrite, merge, or skip?"

#### 3b. okrs/CURRENT_WEEK.md
- Read: `templates/current-week-template.md`
- Replace placeholders:
  - `{{WEEK_NUMBER}}` — current ISO week number
  - `{{WEEK_DATE_RANGE}}` — e.g. "Mar 10-14"
  - `{{CURRENT_QUARTER}}` — e.g. "Q1"
  - `{{QUARTER_WEEK_NUMBER}}` — week within the quarter (1-13)
  - `{{BUSINESS_NAME}}` — from question 1
- Write to: `okrs/CURRENT_WEEK.md`

#### 3c. okrs/Q{X}-{YYYY}.md
- Read: `templates/quarterly-okr-template.md`
- Replace placeholders:
  - `{{QUARTER}}` — e.g. "Q1"
  - `{{YEAR}}` — e.g. "2026"
  - `{{QUARTER_DATE_RANGE}}` — e.g. "Jan 1 - Mar 31, 2026"
  - `{{BUSINESS_NAME}}` — from question 1
- Write to: `okrs/Q{X}-{YYYY}.md` (e.g. `okrs/Q1-2026.md`)
- Tell user: "I've created a quarterly OKR template. We can fill it in now or later."

#### 3d. dashboards/OPPORTUNITIES.md
- Read: `templates/opportunities-template.md`
- Replace placeholders:
  - `{{BUSINESS_NAME}}` — from question 1
  - `{{CURRENT_DATE}}` — today's date in YYYY-MM-DD format
- Write to: `dashboards/OPPORTUNITIES.md`

#### 3e. journal/{today}.md
- Read: `templates/journal-template.md`
- Replace placeholders:
  - `{{DATE}}` — today's date in YYYY-MM-DD format
  - `{{DAY_OF_WEEK}}` — e.g. "Thursday"
  - `{{WEEK_NUMBER}}` — current ISO week number
- Write to: `journal/{YYYY-MM-DD}.md` (today's date)

**If any template file does not exist yet**, inform the user: "Template file `templates/{name}` not found. You'll need to create it before this file can be generated. Skipping for now." Continue with the remaining files — do not abort the entire setup.

### PHASE 4: CLAUDE.md Integration

Read the file `templates/claude-md-snippet.md` from the plugin's template directory.

Replace any placeholders in the snippet:
- `{{BUSINESS_NAME}}` — from question 1
- `{{HAS_GOOGLE_CALENDAR}}` — if no, remove/comment out calendar-related lines
- `{{HAS_GRANOLA}}` — if no, remove/comment out Granola-related lines

Then ask the user:

```
I have a CLAUDE.md snippet that teaches Claude your daily rhythm (journal, OKRs, morning routine).

Would you like me to:
1. Append it to your existing CLAUDE.md
2. Create a new CLAUDE.md with this content
3. Just show it to me (I'll add it manually)
4. Skip this step
```

Act according to their choice:
- **Option 1:** Read existing CLAUDE.md, append the snippet at the end with a separator `---`
- **Option 2:** Write a new CLAUDE.md with the snippet as content
- **Option 3:** Display the full snippet in a code block
- **Option 4:** Move on

If CLAUDE.md does not exist and user picks option 1, inform them and offer option 2 instead.

### PHASE 5: OKR Quick-Start (Optional)

Ask: "Want to set up your first OKRs now? This takes about 5 minutes."

**If YES:**

Guide them through creating 1 Objective + 2-3 Key Results using OKR best practices:

1. "What's the ONE most important outcome you want to achieve this quarter?"
   - Help them frame it as an inspirational Objective (qualitative, ambitious, memorable)
   - Good: "Establish [business] as the go-to expert in [field]"
   - Bad: "Do more marketing" (too vague), "Get 50 clients" (that's a KR, not an O)

2. For each Key Result (aim for 2-3):
   - "How would you measure progress toward that objective?"
   - Ensure each KR is: measurable, has a number/target, time-bound to the quarter
   - Help reframe if needed: "Revenue of $X" is better than "Make more money"

3. Write the OKRs into `okrs/Q{X}-{YYYY}.md` in the appropriate section.

4. Ask about confidence levels (1-10 scale) for each KR. Ideal starting confidence is 5/10 (ambitious but possible).

**If NO:**

Say: "No problem! When you're ready, run `/productivity-kit:okr-expert` for guided OKR creation."

### PHASE 6: Summary

Show a completion summary:

```
Setup complete! Here's what was created:

Folders: journal/, okrs/, dashboards/, user_context/
Files:
  - user_context/COMPANY_CONTEXT.md
  - okrs/CURRENT_WEEK.md
  - okrs/Q{X}-{YYYY}.md
  - dashboards/OPPORTUNITIES.md
  - journal/{YYYY-MM-DD}.md
  - CLAUDE.md (updated/created)

Next steps:
  - Run /productivity-kit:good-morning to start your day
  - Run /productivity-kit:okr-expert to create or refine your OKRs
  - The daily routine will guide you from here!

The system works best when you:
  1. Start each day with /productivity-kit:good-morning
  2. Do Monday commitments with /productivity-kit:okr-monday
  3. Celebrate wins on Friday with /productivity-kit:okr-friday
  4. Use /productivity-kit:journal for quick notes during the day
```

Adjust the file list to reflect what was actually created (skip any that were skipped due to missing templates or user choice).

## Edge Cases

- **Folders already exist:** Skip creation, note "already exists" in output. Never delete existing content.
- **Files already exist:** Ask user whether to overwrite, merge, or skip. Default to skip if unsure.
- **CLAUDE.md already exists:** Always ask before modifying. Never overwrite without confirmation.
- **Missing template files:** Log which templates are missing, skip those files, continue with the rest. The setup should still complete successfully.
- **User wants to abort mid-setup:** Respect it. Say what was already created and how to resume later by running the setup again.
- **Quarter boundary:** If close to a quarter boundary (last week of quarter), ask user which quarter they want to set up for.

## Template Placeholder Reference

All templates use `{{PLACEHOLDER}}` syntax. Here is the full list of placeholders used across all templates:

| Placeholder | Source | Example |
|---|---|---|
| `{{BUSINESS_NAME}}` | User answer (question 1) | "Acme Corp" |
| `{{BUSINESS_DESCRIPTION}}` | User answer (question 2) | "AI consulting for enterprises" |
| `{{LOCATION}}` | User answer (question 3) | "Berlin, Germany" |
| `{{CURRENT_QUARTER}}` | Auto-detected | "Q1 2026" |
| `{{QUARTER}}` | Auto-detected | "Q1" |
| `{{YEAR}}` | Auto-detected | "2026" |
| `{{QUARTER_DATE_RANGE}}` | Computed | "Jan 1 - Mar 31, 2026" |
| `{{WEEK_NUMBER}}` | Computed (ISO week) | "11" |
| `{{WEEK_DATE_RANGE}}` | Computed | "Mar 10-14" |
| `{{QUARTER_WEEK_NUMBER}}` | Computed | "10 of 13" |
| `{{DATE}}` | Today | "2026-03-13" |
| `{{DAY_OF_WEEK}}` | Today | "Thursday" |
| `{{CURRENT_DATE}}` | Today | "2026-03-13" |
| `{{HAS_GOOGLE_CALENDAR}}` | User answer (question 5) | true/false |
| `{{HAS_GRANOLA}}` | User answer (question 6) | true/false |

## Important Rules

- All file paths are RELATIVE to the project root. Never use absolute paths in created files.
- Do NOT hardcode any personal data — all content comes from user answers or templates.
- Use `/productivity-kit:skill-name` namespace for ALL skill references in output text.
- Be conversational and encouraging. This is onboarding — make it feel easy, not overwhelming.
- Google Calendar and Granola integrations are OPTIONAL. Everything must work without them. If the user doesn't have them, simply omit calendar/meeting-related lines from templates rather than showing errors.
- When computing quarter boundaries: Q1=Jan-Mar, Q2=Apr-Jun, Q3=Jul-Sep, Q4=Oct-Dec.
- When computing ISO week numbers, use the system date command or equivalent.
