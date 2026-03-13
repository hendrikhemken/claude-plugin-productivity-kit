## 📓 Daily Journal & OKR System

**Powered by [productivity-kit](https://github.com/hendrikhemken/claude-plugin-productivity-kit)**

### Daily Rhythm

| When | Skill | What |
|------|-------|------|
| Morning (Mon) | `/productivity-kit:okr-monday` → `/productivity-kit:good-morning` | Weekly goals + day start |
| Morning (Tue-Sun) | `/productivity-kit:good-morning` | Yesterday review + plan today |
| During day | automatic | Claude tracks activities in journal `## Notes` |
| Anytime | `/productivity-kit:journal` | Quick update: add note, check off todo |
| Friday | `/productivity-kit:okr-friday` | Celebrate wins, capture learnings |

### File Structure

```
{{PROJECT_ROOT}}/
├── journal/                          # Daily journal files
│   └── {YYYY-MM-DD}.md
├── okrs/                             # OKR tracking
│   ├── CURRENT_WEEK.md               # This week's focus
│   └── Q{X}-{YYYY}.md               # Quarterly OKR file
├── dashboards/
│   └── OPPORTUNITIES.md              # Pipeline tracking
└── user_context/
    └── COMPANY_CONTEXT.md            # Business context
```

### Key Principles

- **Outcomes > Outputs** — measure impact, not activity
- **Weekly Cadence** — Monday commitments, Friday celebrations (Wodtke method)
- **5/10 Confidence** — OKRs should be ambitious (0.6-0.7 = success!)
- **Journal tracking** — after notable work, add entry to `## Notes`
