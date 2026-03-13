#!/usr/bin/env bash
# check-journal.sh - Check if today's journal needs attention
# Used by SessionStart hook

set -euo pipefail

TODAY=$(date '+%Y-%m-%d')
DOW=$(date '+%u')

# Find journal directory (portable - searches common locations)
JOURNAL_DIR=""
for dir in "./journal" "./journals" "../journal"; do
  if [ -d "$dir" ]; then
    JOURNAL_DIR="$dir"
    break
  fi
done

# Also search deeper
if [ -z "$JOURNAL_DIR" ]; then
  JOURNAL_DIR=$(find . -maxdepth 3 -type d -name 'journal' 2>/dev/null | head -1)
fi

if [ -z "$JOURNAL_DIR" ]; then
  echo "📓 No journal/ directory found. Run /productivity-kit:setup to get started."
  exit 0
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
