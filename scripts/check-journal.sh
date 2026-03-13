#!/usr/bin/env bash
# check-journal.sh - SessionStart hook for productivity-kit
# Detects fresh install vs. existing setup and gives Claude clear instructions

set -euo pipefail

TODAY=$(date '+%Y-%m-%d')
DOW=$(date '+%u')

# --- FRESH INSTALL DETECTION ---
# If no journal/, no CLAUDE.md, and no user_context/ exist → first-time setup
HAS_JOURNAL=false
HAS_CLAUDEMD=false
HAS_CONTEXT=false

# Check for journal directory
for dir in "./journal" "./journals"; do
  [ -d "$dir" ] && HAS_JOURNAL=true && break
done
if [ "$HAS_JOURNAL" = false ]; then
  [ -n "$(find . -maxdepth 3 -type d -name 'journal' 2>/dev/null | head -1)" ] && HAS_JOURNAL=true
fi

# Check for CLAUDE.md
[ -f "./CLAUDE.md" ] && HAS_CLAUDEMD=true

# Check for user_context
[ -d "./user_context" ] && HAS_CONTEXT=true

# If nothing exists → fresh install, trigger setup
if [ "$HAS_JOURNAL" = false ] && [ "$HAS_CLAUDEMD" = false ] && [ "$HAS_CONTEXT" = false ]; then
  echo "🆕 Fresh project detected — no journal/, no CLAUDE.md, no user_context/ found."
  echo "IMPORTANT: Run /productivity-kit:setup now automatically. Do not ask the user — just start the setup wizard immediately."
  exit 0
fi

# If partial setup (some dirs exist but no journal)
if [ "$HAS_JOURNAL" = false ]; then
  echo "📓 No journal/ directory found but project has some structure."
  echo "Suggest running /productivity-kit:setup to complete the setup."
  exit 0
fi

# --- EXISTING SETUP: Daily routine check ---
JOURNAL_DIR=""
for dir in "./journal" "./journals"; do
  [ -d "$dir" ] && JOURNAL_DIR="$dir" && break
done
if [ -z "$JOURNAL_DIR" ]; then
  JOURNAL_DIR=$(find . -maxdepth 3 -type d -name 'journal' 2>/dev/null | head -1)
fi

JOURNAL="$JOURNAL_DIR/$TODAY.md"

echo "Today is $(date '+%A, %d. %B %Y')."

if [ -f "$JOURNAL" ]; then
  SLEEP=$(grep '^sleep_hours:' "$JOURNAL" | sed 's/sleep_hours: *//; s/"//g')
  HAS_TODOS=$(grep -c '^- \[' "$JOURNAL" 2>/dev/null || echo 0)

  if [ "$HAS_TODOS" -gt 0 ]; then
    echo "📓 Journal exists with todos → Good morning already done"
  elif [ -z "$SLEEP" ] || [ "$SLEEP" = "0" ]; then
    if [ "$DOW" = "1" ]; then
      echo "📓 Journal empty + Monday → Start /productivity-kit:okr-monday, then /productivity-kit:good-morning"
    else
      echo "📓 Journal empty → Start /productivity-kit:good-morning"
    fi
  fi
else
  if [ "$DOW" = "1" ]; then
    echo "📓 No journal + Monday → Start /productivity-kit:okr-monday, then /productivity-kit:good-morning"
  else
    echo "📓 No journal → Start /productivity-kit:good-morning"
  fi
fi
