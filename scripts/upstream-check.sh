#!/bin/bash
# Checks the tracked `upstream` remote for new commits. Notifies, never merges.
#
# Lives in the kit so it TRAVELS: it resolves its own repo from its own path
# rather than hardcoding one. Installed as a launchd job by setup-machine.sh
# (§3g). Before 2026-08-23 this existed only on one machine while CLAUDE.md and
# docs/OS.md claimed the capability shipped - it did not.

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="$HOME/.cache/unicorn-upstream-last-seen"
LOG="$HOME/.cache/unicorn-upstream.log"

mkdir -p "$(dirname "$STATE")"
cd "$REPO" 2>/dev/null || { echo "$(date '+%F %T') repo missing at $REPO" >>"$LOG"; exit 1; }

# Offline or auth failure: stay quiet, try again next run.
git fetch upstream --quiet 2>>"$LOG" || { echo "$(date '+%F %T') fetch failed (offline?)" >>"$LOG"; exit 0; }

BEHIND=$(git rev-list --count HEAD..upstream/main 2>/dev/null) || exit 0
CURRENT=$(git rev-parse upstream/main 2>/dev/null) || exit 0
LAST=$(cat "$STATE" 2>/dev/null)

if [ "${BEHIND:-0}" -gt 0 ] && [ "$CURRENT" != "$LAST" ]; then
    SUBJECT=$(git log -1 --format='%s' upstream/main | cut -c1-90)
    osascript -e "display notification \"$BEHIND new commit(s). Latest: $SUBJECT\" with title \"upstream updated\" subtitle \"Nothing merged — review when ready\" sound name \"Ping\""
    echo "$(date '+%F %T') behind=$BEHIND sha=${CURRENT:0:7} :: $SUBJECT" >>"$LOG"
    echo "$CURRENT" >"$STATE"
else
    echo "$(date '+%F %T') up to date (behind=$BEHIND)" >>"$LOG"
fi
