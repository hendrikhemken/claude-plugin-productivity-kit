---
name: okr-friday
description: Weekly Friday OKR celebration and learning check-in (~15 min). Based on Wodtke's Weekly Cadence. Reviews what got done, celebrates wins, captures learnings, and updates KR progress. Triggers on 'OKR Friday', 'Friday review', 'Week review', 'Friday celebration', 'Wins and learning', 'End of week'.
---

# OKR Friday - Weekly Celebration & Learning

Friday wins and learning review based on Christina Wodtke's Weekly OKR Cadence. ~15 minutes.

**Never:** Change target numbers, edit OKRs themselves, skip weeks, put KR-Progress numbers in CURRENT_WEEK.md (those live in the quarterly file).

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

WEEK_OF_YEAR=$(date '+%V')
echo "Today: $TODAY | Day: $DOW | Quarter: Q$Q-$YEAR | ~Week $WEEK_OF_YEAR"
if [ "$DOW" -ne 5 ]; then
  echo "NOTE: Today is NOT Friday (day $DOW). Proceeding anyway."
fi
```

Trust the system date. Calculate: actual date, is it Friday, current quarter, week number.

### Step 2: Load Data Sources

1. **Find CURRENT_WEEK.md** in the project (typically in `okrs/` or `projects/*/okrs/`):
   ```bash
   find . -name "CURRENT_WEEK.md" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null
   ```
   Read it. This has Monday's commitments and the week's tasks.

2. **Load the quarterly OKR file** (e.g., `Q1-2026.md` in the same directory). This contains KRs, targets, and this week's Monday commitments.

3. **Find and load dashboards/OPPORTUNITIES.md** (typically in `projects/*/dashboards/` or `dashboards/`):
   ```bash
   find . -name "OPPORTUNITIES.md" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null
   ```

4. **Revenue data:**
   - If a revenue-tracking skill or tool is available, load current revenue data.
   - If not available, ask: "What's your current revenue status? Any changes since Monday?"

5. **Read `user_context/COMPANY_CONTEXT.md`** for business context (if it exists).

### Step 3: Check What Got Done

Compare Monday's commitments vs. what actually happened:

1. Go through CURRENT_WEEK.md checkboxes — what's checked, what's not?
2. For unchecked items: "Did this happen? Or should it carry over?"
3. Were there unplanned wins or activities not in the original plan?

Present a clear "committed vs. done" overview.

### Step 4: LinkedIn Stats (Optional)

Ask:

> "Have you exported your LinkedIn stats this week? (Impressions, followers, engagement)"

- If the user has stats: Process and include them in the weekly review. Note trends.
- If LinkedIn stats are available via a tool/integration: Load them automatically.
- If not available: Skip entirely. Don't dwell on it.

### Step 5: Celebrate & Learn

This is the heart of the Friday review. Ask these questions:

1. **"What are you celebrating this week?"** - Celebrate everything, even small wins! Got a reply? Win. Shipped something? Win. Had a good call? Win.

2. **"What worked?"** - What approaches, habits, or tactics produced results?

3. **"What didn't work?"** - No judgment. Just honest assessment.

4. **"What will you do differently next week?"** - Turn learnings into actions.

Be genuinely enthusiastic about wins. The Friday review should feel good!

### Step 6: Update Progress & Dashboards

For each Key Result:
1. **Did it move this week?** If yes, by how much?
2. **What's the new current value?** (Ask the user if unclear)
3. **Update the quarterly file** with new progress numbers

For the opportunity pipeline:
- Any new leads or opportunities?
- Any deals that advanced, stalled, or closed?
- Update OPPORTUNITIES.md if the pipeline changed

### Step 7: Update Files

#### Quarterly file (Q{X}-{YYYY}.md):
Add or update the weekly section with:
- Wins (what was accomplished)
- Learnings (what worked, what didn't)
- Updated KR progress values
- Confidence adjustments if needed

#### CURRENT_WEEK.md:
- Mark completed checkboxes (`[x]`)
- Add notes for incomplete items (carry-over? dropped?)
- Do NOT rewrite the whole file — just update completion status

**IMPORTANT:** KR-Progress numbers go in the quarterly file only. CURRENT_WEEK.md tracks tasks, not metrics.

### Step 8: Mental Toughness Reflection (Optional)

Ask:

> "Were there moments this week that tested your mental toughness?"

- If yes: Do a quick check using the framework from MENTAL_TOUGHNESS.md:
  - **Tolerance:** How long did you stay on track before it affected you?
  - **Resilience:** How fast did you bounce back?
  - Acknowledge the difficulty. Note the growth.
- If no: Skip entirely. Don't force it.

### Step 9: Summarize & Close

Present a clean summary:

1. **2-3 key wins** (the highlights of the week)
2. **1-2 key learnings** (what to carry forward)
3. **KR movement** (brief progress update per KR)
4. **Carry-overs** (if any important items didn't get done)

Close with:

> "Great week! See you Monday for fresh commitments. `/productivity-kit:okr-monday`"

## References

- MENTAL_TOUGHNESS.md (in this skill's directory) - Alex Hormozi's 4-component model
- Christina Wodtke's "Radical Focus" - Weekly OKR Cadence

*Weekly Friday Celebration & Learning - Based on Wodtke's OKR Cadence*
