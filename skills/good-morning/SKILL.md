---
name: good-morning
description: Daily morning routine. Reviews yesterday (git diffs, meetings, journal notes) and plans today (sleep, calendar, prioritization). Triggers on 'Good Morning', 'Morning', 'Start the day', 'What's on today?', 'Daily planning', 'How was yesterday?', 'Review', or when the user obviously starts a new morning session.
---

# Good Morning - Daily Kickoff

Morning routine with two phases: **Yesterday Review** + **Today Planning**. ~10 minutes.

## Instructions

### Phase 1: Yesterday Review

#### 1.1 Date calculation + Weekend logic

```bash
TODAY=$(date '+%Y-%m-%d')
DOW=$(date '+%u')  # 1=Monday, 7=Sunday

# On Monday: review Friday (not Sunday)
if [ "$DOW" -eq 1 ]; then
  YESTERDAY=$(date -v-3d '+%Y-%m-%d' 2>/dev/null || date -d '3 days ago' '+%Y-%m-%d')
  echo "Today: $TODAY (Monday) | Last workday: $YESTERDAY (Friday)"
  echo "GIT_SINCE=last friday 00:00"
else
  YESTERDAY=$(date -v-1d '+%Y-%m-%d' 2>/dev/null || date -d 'yesterday' '+%Y-%m-%d')
  echo "Today: $TODAY | Yesterday: $YESTERDAY"
  echo "GIT_SINCE=yesterday 00:00"
fi
```

On Monday, review the entire period since Friday (git, meetings, journal). Weekend work will show up automatically.

#### 1.2 Read yesterday's journal

Find `journal/{yesterday}.md` in the project:
- Read `## Notes` (what was tracked during the day?)
- Read `## Todos` (what was planned, what got done?)
- Read Frontmatter (mood, meetings, etc.)

If entries with "tomorrow:" prefix exist in Notes -> highlight them.

If no journal exists: no problem, continue with git data. Do not mention it's missing.

#### 1.3 Git activity since last workday

**Two-step approach (token-efficient!):**

Use the GIT_SINCE variable calculated in 1.1 (Monday = "last friday 00:00", otherwise = "yesterday 00:00"):

```bash
# Step 1: Overview (cheap)
git log --oneline --since="$GIT_SINCE" --until="today 00:00"
```

```bash
# Step 2: Files + scope
git log --stat --since="$GIT_SINCE" --until="today 00:00"
```

Only deep-dive into relevant/larger commits with `git show <hash>`. Do not load the full diff of all files!

**Create summary:** What was concretely worked on? (2-5 bullet points)

#### 1.4 Meeting transcripts (OPTIONAL)

**IF Granola MCP is available** (`mcp__granola__list_meetings`):
- Fetch meetings from the date range calculated in 1.1
- For each relevant meeting, get details via `mcp__granola__get_meeting_transcript`
- Extract per meeting: Title, Participants, Key Takeaways (2-3 bullet points max)

**IF Granola MCP is NOT available:**
- Ask: "Did you have any notable meetings yesterday worth capturing?"
- If yes, note them down for the journal

If no meetings found either way: skip this step, don't mention it.

#### 1.5 Emails (OPTIONAL)

**IF GWS CLI is available** (`gws` command works):
```bash
gws gmail messages list --params '{"maxResults": 15, "q": "is:unread newer_than:1d"}'
```
On Monday use `newer_than:3d` instead.

Extract:
- Action-required emails (invoices, requests, deadlines)
- Skip informational (newsletters, notifications)
- If nothing relevant: skip, don't mention

**IF GWS CLI is NOT available:** Skip entirely, don't mention it.

#### 1.6 Present yesterday's review

Show the user a structured review:

```
Yesterday ({weekday}, {date}):

Git Activity:
- [concrete work item 1]
- [concrete work item 2]

Meetings:
- [Meeting title] ([participants]): [key takeaway]

Journal Notes:
- [notable entries from yesterday's journal]
```

#### 1.7 Ask for wins, learnings + sleep in one question

Combine everything to minimize back-and-forth:

"Here's your review. Any wins or learnings I'm missing?
And: How did you sleep? (hours + quality) How are you feeling today?"

User responds, e.g.: "Looks good. 7h, good, feeling great."

- Write Wins to `## Wins` of **yesterday's** journal
- Write Learnings to `## Learnings` of **yesterday's** journal
- Remember sleep/mood data for Phase 2

#### 1.8 Close yesterday's journal

In **yesterday's** journal (`journal/{yesterday}.md`):

1. Fill `## Wins` (from diffs, meetings, user input)
2. Fill `## Learnings` (if any)
3. Set frontmatter `summary:` (1 sentence, from the overall picture)
4. Set frontmatter `meetings:` (from meeting data)

#### 1.9 Update CURRENT_WEEK.md

Find the `CURRENT_WEEK.md` file in the project (typically in `okrs/` or `projects/*/okrs/`).

Check off tasks that were completed based on the review. For obviously completed tasks (workshop delivered, post published, call happened) check them off directly and inform the user: "Checked off X and Y in CURRENT_WEEK."

For unclear items, ask before checking off.

---

### Phase 2: Today Planning

#### 2.1 Create today's journal

If `journal/{today}.md` does not exist -> create it using the template below.

#### 2.2 Write sleep data to journal

The sleep/mood data was already collected in Step 1.7. Write to today's journal frontmatter:

Example mapping:
- "7h, good, great" -> sleep_hours: 7, sleep_quality: good, mood: great
- "5.5h, bad, tired" -> sleep_hours: 5.5, sleep_quality: bad, mood: tired

```yaml
sleep_hours: {X}
sleep_quality: {great/good/ok/bad}
mood: {great/good/ok/tired/bad}
```

#### 2.3 Check calendar (OPTIONAL)

**IF Google Calendar MCP is available** (`mcp__google-calendar__list-events`):
- Fetch today's events
- Use `timeMin`: "{today}T00:00:00", `timeMax`: "{today}T23:59:59"
- Show events chronologically

**IF Google Calendar MCP is NOT available:**
- Ask: "What's on your schedule today?"

Display events clearly:
```
Your calendar today:
09:00 - Client call
12:00 - Lunch
14:00 - Workshop prep
```

If calendar is empty or the call fails: say "No events today" and continue.

#### 2.4 Load today's plan from CURRENT_WEEK.md

Find and read the `CURRENT_WEEK.md` file.

**Collect ALL relevant tasks:**
1. **Schedule tasks:** Find today's weekday in the `## Schedule` section
2. **Monday Commitments:** Scan ALL open `- [ ]` items from Monday Commitments
3. **Carry-overs:** Check the `## Upcoming` section for urgent items

#### 2.5 Suggest prioritization

**Combine** calendar + schedule + Monday Commitments and suggest a prioritization.

**Format:**

```
TOP 3 - Really important today:
1. [Task] - [why important today]
2. [Task]
3. [Task]

If time allows:
- [Task]
- [Task]

Still open this week (not today):
- [Task] -> more like [Wednesday/Thursday/...]
```

**Prioritization logic:**
- Appointments/calls = always top priority (time-bound)
- Revenue-relevant tasks before admin
- Tasks blocking others before independent tasks
- Deadlines this week > carry-overs
- On delivery days (full-day workshop/client): only mini admin tasks as "if time allows"

**Ask the user:** "Does this work as your focus, or do you want to shift anything?"

#### 2.6 Fill journal Todos section

Write the prioritized tasks to `## Todos` of today's journal:

```markdown
## Todos

### Top 3
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

### Nice to have
- [ ] Task 4
- [ ] Task 5
```

#### 2.7 Daily commit

At the end of the morning routine, commit all changes (journal entries, CURRENT_WEEK updates, etc.):

```bash
git add -A && git commit -m "chore: daily sync - $(date '+%Y-%m-%d') good morning"
```

This ensures tomorrow's review works cleanly - each day has its own commit with timestamp.

#### 2.8 Close

"Let's go! Your day is planned."

---

## Journal Template (if file is missing)

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

**Frontmatter `meetings` format:**
```yaml
meetings:
  - title: "Client Follow-up"
    participants: ["Person A"]
  - title: "Workshop Day 1"
    participants: ["Person B"]
```

---

## File Reference

**Read from:**
- `journal/{yesterday}.md` - Yesterday's journal (Notes, Todos, Frontmatter)
- `journal/{today}.md` - Today's journal
- `CURRENT_WEEK.md` - Weekly schedule + Monday Commitments (find via glob: `**/okrs/CURRENT_WEEK.md` or `**/CURRENT_WEEK.md`)
- `user_context/COMPANY_CONTEXT.md` - Business context (if available)
- Google Calendar (via MCP `mcp__google-calendar__list-events`, if available)
- Git Log (via `git log --stat --since="yesterday"`)
- Granola Meetings (via MCP `mcp__granola__list_meetings`, if available)
- GWS CLI / Gmail (via `gws gmail messages list`, if available)

**Write to:**
- `journal/{yesterday}.md` - Wins, Learnings, Summary, Meetings (Frontmatter)
- `journal/{today}.md` - Sleep data + Prioritized Todos
- `CURRENT_WEEK.md` - Check off tasks (after confirmation)

---

*Good Morning Skill - Yesterday review + Today planning*
*Part of the productivity-kit plugin*
