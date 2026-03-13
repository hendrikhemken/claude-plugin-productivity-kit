---
name: okr-monday
description: Weekly Monday OKR commitment check-in (~15 min). Based on Wodtke's Weekly Cadence. Reviews last week's vibe, loads KR progress, sets concrete weekly commitments per KR, and updates planning files. Triggers on 'OKR Monday', 'Monday commitments', 'Weekly planning', 'Start the week', 'Monday check-in'.
---

# OKR Monday - Weekly Commitment Check-in

Monday commitment setting based on Christina Wodtke's Weekly OKR Cadence. ~15 minutes.

**Never:** Change OKRs mid-quarter, change target numbers, skip weeks, put KR-Progress numbers in CURRENT_WEEK.md (those live in the quarterly file).

## Instructions

### Step 1: Verify Date & Week (CRITICAL!)

Always start by running the `date` command to get the actual system date. Never assume.

```bash
TODAY=$(date '+%Y-%m-%d')
DOW=$(date '+%u')  # 1=Monday, 7=Sunday
MONTH=$(date '+%-m')
YEAR=$(date '+%Y')

# Determine quarter
if [ "$MONTH" -le 3 ]; then Q=1; WEEK_OFFSET=0
elif [ "$MONTH" -le 6 ]; then Q=2; WEEK_OFFSET=13
elif [ "$MONTH" -le 9 ]; then Q=3; WEEK_OFFSET=26
else Q=4; WEEK_OFFSET=39; fi

# Calculate week number within quarter (approximate)
WEEK_OF_YEAR=$(date '+%V')
echo "Today: $TODAY | Day: $DOW | Quarter: Q$Q-$YEAR | ~Week $WEEK_OF_YEAR"
if [ "$DOW" -ne 1 ]; then
  echo "NOTE: Today is NOT Monday (day $DOW). Proceeding anyway."
fi
```

Trust the system date. Calculate: actual date, is it Monday, current quarter, week number, period format.

### Step 2: Quick Vibe-Check (Optional)

Ask the user:

> "Quick check: How did last week go overall? One word or phrase."

Keep SHORT. Purpose: emotional check-in, not a retrospective. One response, move on.

### Step 3: Calendar for the Week (OPTIONAL)

**If Google Calendar MCP is available:** Fetch this week's events from all available calendars. Show a summary of the week's commitments, meetings, and blocked time.

**If Google Calendar MCP is NOT available:** Ask:

> "What does your week look like? Any big commitments or blocked time?"

Show a summary either way so the user can plan around their schedule.

### Step 4: Load Data Sources

1. **Find CURRENT_WEEK.md** in the project (typically in `okrs/` or `projects/*/okrs/`):
   ```bash
   find . -name "CURRENT_WEEK.md" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null
   ```
   Read it. Extract the quarter reference (e.g., "Q1-2026").

2. **Load the quarterly OKR file** (e.g., `Q1-2026.md` in the same directory as CURRENT_WEEK.md). This contains KRs, targets, and weekly progress.

3. **Find and load dashboards/OPPORTUNITIES.md** (typically in `projects/*/dashboards/` or `dashboards/`):
   ```bash
   find . -name "OPPORTUNITIES.md" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null
   ```

4. **Revenue data:**
   - If a revenue-tracking skill or tool is available (e.g., `/productivity-kit:revenue`, accounting API), load current revenue data.
   - If not available, ask: "What's your current revenue status? Any invoices paid, sent, or expected?"

5. **Read `user_context/COMPANY_CONTEXT.md`** for business context (if it exists).

### Step 5: Ask For Each KR

For each Key Result in the quarterly file:

1. **Show current progress:** "KR1: [description] — currently at X/Y (Z%)"
2. **Ask confidence:** "What's your confidence NOW (0-10) that you'll hit this by end of quarter?"
3. **Ask for actions:** "What are 1-2 CONCRETE actions THIS WEEK to move this forward?"

**Push for specificity!** Examples:
- Bad: "Work on sales"
- Good: "Send follow-up proposal to Client X by Wednesday"
- Bad: "Post on LinkedIn"
- Good: "Write and publish 2 LinkedIn posts (Tuesday + Thursday)"

### Step 6: Update Files

#### Quarterly file (Q{X}-{YYYY}.md):
Add or update the weekly section with:
- Week number and date range
- Monday commitments per KR
- Confidence levels (0-10) per KR
- Any notes from the check-in

#### CURRENT_WEEK.md:
Create or update with:
- **Focus:** One sentence summary of this week's focus
- **Monday Commitments:** Concrete tasks organized by KR
- **Schedule:** Key dates/meetings this week
- **Notes:** Any relevant context

**IMPORTANT:** Do NOT put KR-Progress numbers in CURRENT_WEEK.md. Progress tracking lives in the quarterly file only. CURRENT_WEEK.md is for tasks and schedule.

### Step 7: Mental Toughness Check (Optional)

Ask:

> "Anything testing your mental toughness this week? Tough calls, financial pressure, rejection risk?"

- If yes: Acknowledge it. Reference MENTAL_TOUGHNESS.md for the framework (Tolerance, Fortitude, Resilience, Adaptability). Keep it brief — awareness is the goal.
- If no: Skip entirely. Don't force it.

### Step 8: Summarize & Close

Present a clean summary:

1. **This week's focus** (the one-sentence summary)
2. **Key actions** (4-8 concrete commitments across KRs)
3. **Confidence flags** (any KRs with confidence drops or blockers)
4. **Schedule highlights** (important meetings/deadlines)

Close with:

> "Commitments are set. See you Friday for Wins & Learning! `/productivity-kit:okr-friday`"

## References

- MENTAL_TOUGHNESS.md (in this skill's directory) - Alex Hormozi's 4-component model
- Christina Wodtke's "Radical Focus" - Weekly OKR Cadence

*Weekly Monday Commitment Check-in - Based on Wodtke's OKR Cadence*
