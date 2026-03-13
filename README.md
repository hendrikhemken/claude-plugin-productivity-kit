# Productivity Kit — Claude Code Plugin

**OKR tracking + daily routines for solo entrepreneurs and small teams.**

Turn Claude Code into your daily business co-pilot. This plugin adds structured morning routines, weekly OKR check-ins, and journal tracking — all driven by markdown files in your project.

---

## What It Does

- **Morning routines** that review yesterday and plan today (sleep, calendar, priorities)
- **Weekly OKR rhythm** with Monday commitments and Friday celebrations
- **Journal tracking** to capture notes, wins, and learnings throughout the day
- **OKR expertise** grounded in Wodtke, Klau, and Cagan methodologies
- **One-command setup** that scaffolds your entire project structure

---

## Quick Start

### 1. Install

```bash
npx skills add hendrikhemken/claude-plugin-productivity-kit --agent "Claude Code" --copy --yes
```

### 2. Set up your project

```
/productivity-kit:setup
```

This creates your folder structure, templates, and CLAUDE.md snippet.

### 3. Start your day

```
/productivity-kit:good-morning
```

---

## Skills Overview

| Skill | Trigger | What It Does |
|-------|---------|--------------|
| `setup` | `/productivity-kit:setup` | Scaffolds project structure, creates templates, adds CLAUDE.md config |
| `good-morning` | `/productivity-kit:good-morning` | Reviews yesterday (git diffs, meetings, journal), plans today (sleep, calendar, priorities) |
| `okr-monday` | `/productivity-kit:okr-monday` | Monday commitment check-in: set weekly goals, update confidence levels |
| `okr-friday` | `/productivity-kit:okr-friday` | Friday celebration: review wins, capture learnings, update OKR progress |
| `journal` | `/productivity-kit:journal` | Quick journal update: add notes, check off todos, log activities |
| `okr-expert` | `/productivity-kit:okr-expert` | OKR coaching and best practices from 11 reference documents |

---

## Daily Rhythm

```
QUARTER (Q1-2026.md) -- KRs + Targets
  WEEK (CURRENT_WEEK.md) <-- /okr-monday (Mon) + /okr-friday (Fri)
    DAY (journal/YYYY-MM-DD.md)
      |-- /good-morning Phase 1: Review yesterday
      |     -> Git diffs, meetings, journal notes
      |     -> Wins, learnings, summary into YESTERDAY's journal
      |-- /good-morning Phase 2: Plan today
      |     -> Sleep, calendar, CURRENT_WEEK -> prioritization
      |-- Track activities in ## Notes throughout the day
      +-- /journal (optional, quick updates anytime)
```

### Weekly Flow

| Day | Action | Skill |
|-----|--------|-------|
| **Monday** | Set weekly commitments, update confidence | `/okr-monday` then `/good-morning` |
| **Tue-Thu** | Morning review + plan, track during day | `/good-morning` |
| **Friday** | Celebrate wins, capture learnings, review week | `/okr-friday` |

---

## Integrations (Optional)

The plugin works standalone with just markdown files. For richer context, it can optionally pull from:

| Integration | What It Adds | Requires |
|-------------|-------------|----------|
| **Google Calendar** | Today's meetings in morning routine | `google-calendar` MCP server |
| **Granola** | Yesterday's meeting transcripts for review | `granola` MCP server |
| **Gmail (GWS CLI)** | Email context for planning | GWS CLI installed |

These are detected automatically — if available, they're used. If not, the skills work without them.

---

## File Structure

After running `/productivity-kit:setup`, your project will have:

```
your-project/
├── CLAUDE.md                    # Updated with journal/OKR config
├── user_context/
│   └── COMPANY_CONTEXT.md       # Your business context (you fill this in)
├── okrs/
│   ├── Q1-2026.md               # Quarterly OKRs with weekly tracking
│   └── CURRENT_WEEK.md          # This week's focus, tasks, schedule
├── dashboards/
│   └── OPPORTUNITIES.md         # Pipeline & lead tracking
└── journal/
    └── YYYY-MM-DD.md            # Daily journal entries (auto-created)
```

---

## OKR Methodology

This plugin's OKR system is built on proven frameworks:

- **Christina Wodtke** ("Radical Focus") — Weekly rhythm with Monday commitments and Friday celebrations. Confidence scoring. The core operating model.
- **Rick Klau** (Google OKRs) — Grading system, quarterly cadence, ambitious target-setting.
- **Marty Cagan** — Prerequisites check: make sure your organization is ready for OKRs before adopting them.
- **Alex Hormozi** — Mental toughness framework integrated into Monday/Friday check-ins for resilience and focus.

The `okr-expert` skill includes 11 reference documents covering these methodologies in depth. Use it for coaching, grading help, or best-practice guidance.

---

## Templates

The `setup` skill installs these templates:

| Template | Purpose |
|----------|---------|
| `quarterly-okr-template.md` | Quarterly OKR structure with weekly tracking |
| `current-week-template.md` | Weekly focus, commitments, schedule |
| `journal-template.md` | Daily journal with frontmatter (mood, sleep, meetings) |
| `company-context-template.md` | Business context briefing for Claude |
| `opportunities-template.md` | Pipeline and lead tracking dashboard |
| `claude-md-snippet.md` | CLAUDE.md configuration snippet |

---

## SessionStart Hook

The plugin includes a hook that runs at session start to check if today's journal exists and is empty. Based on the result:

- **Journal empty** — Suggests running `/productivity-kit:good-morning`
- **Journal empty + Monday** — Suggests running `/productivity-kit:okr-monday` first, then `/productivity-kit:good-morning`
- **Journal filled** — No action needed

---

## Test Project

The `test-project/` directory contains a complete example setup with sample data (fictional "Acme Consulting" business). Use it to try out the skills before setting up your own project.

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Author

**Hendrik Hemken** — [Beyond7](https://beyond7.ai)
AI Consulting & Training | Hamburg, Germany

Built with love using Claude Code.
