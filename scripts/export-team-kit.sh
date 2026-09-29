#!/usr/bin/env bash
# Export the SHAREABLE part of the kit into a team repo.
#
# Written 2026-09-29, when the kit's owner joined a team and wanted colleagues
# to clone the skills without inheriting him: "there are a lot of personal
# parameters for me only ... i just simply want the skills to be pulled,
# similar to the state of whatchamacallit when i cloned it from unicorn skill".
#
# The destination is PUBLIC. That is the whole reason this file is an
# ALLOWLIST and not an ignore list. With an ignore list, the next personal
# file anyone adds ships by default and nobody notices until it is on the
# internet; with an allowlist, a new file is invisible until somebody adds it
# here on purpose. Ignore lists fail open. This fails closed.
#
#   scripts/export-team-kit.sh ../team-kit          copy, then show what changed
#   scripts/export-team-kit.sh ../team-kit --dry    list only, write nothing
#
# It never commits and never pushes. Look at the diff, then decide.
set -euo pipefail

DEST="${1:-}"
DRY=""
[ "${2:-}" = "--dry" ] && DRY=1
if [ -z "$DEST" ]; then
  echo "usage: $0 <destination-dir> [--dry]" >&2
  exit 2
fi
KIT="$(cd "$(dirname "$0")/.." && pwd)"

# --- what travels -------------------------------------------------------------
# Every path is relative to the kit root. Directories copy whole.
PATHS=(
  ".claude/skills"
  ".claude/commands"
  ".claude/agents"
  "CLAUDE.md"          # already generic: its first rule defers the address to user config
  "README.md"
  "CREDITS.md"         # attribution to hulusi-tunc/unicorn-skills travels with the work
  "docs/ux-references.md"
  "docs/resources.md"
  "docs/BROWSER-SAFETY.md"
  "docs/MIGRATION.md"
  "docs/OS.md"
  "docs/outreach.md"
  "docs/RULES.md"      # the de-personalised counter-rules, NOT RULES-LOG.md
  "hooks"
  "scripts/setup-machine.sh"
  "scripts/session-registry.py"
  "scripts/export-team-kit.sh"
)

# The team's user-level file is a TEMPLATE with the address left blank. The
# owner's own .claude/user-CLAUDE.md never travels: it opens by naming him.
TEMPLATE=".claude/user-CLAUDE.template.md"
TEMPLATE_AS=".claude/user-CLAUDE.md"

# --- what must never travel, asserted rather than assumed ----------------------
# A second, independent check on the DESTINATION. Note .claude/user-CLAUDE.md is
# not listed: the template is legitimately written to that name, and its contents
# are covered by the name scan below.
FORBIDDEN_PATHS=(
  "taste"                 # his eye, the thing that makes the work his
  "project"               # briefs, client reviews, working memory
  "docs/RULES-LOG.md"     # his diary: quotes, clients, mistakes
  ".mcp.json"             # hardcoded machine paths
  "config"                # his terminal
  "tools"                 # his machine's helpers
)
# Strings that mean "this is about one person, not about the work". They live in
# a file that is NOT exported: written inline, the scanner would match its own
# source and could never pass (found 2026-09-29, by the script refusing itself).
TRIPFILE="$KIT/scripts/export-tripwires.txt"
if [ ! -f "$TRIPFILE" ]; then
  echo "missing $TRIPFILE, refusing to export without a tripwire list" >&2
  exit 1
fi
TRIPWIRES="$(grep -vE '^\s*(#|$)' "$TRIPFILE" | paste -sd'|' -)"

say() { printf '  %s\n' "$*"; }

# --- the tripwire, run BEFORE anything is written -----------------------------
staged=()
for p in "${PATHS[@]}"; do
  [ -e "$KIT/$p" ] && staged+=("$p")
done
hits=0
for p in "${staged[@]}"; do
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    hits=$((hits + 1))
    echo "  TRIPWIRE  $line" >&2
  done < <(grep -rniE "$TRIPWIRES" "$KIT/$p" 2>/dev/null | head -40 || true)
done
if [ "$hits" -gt 0 ]; then
  echo >&2
  echo "REFUSING TO EXPORT: $hits line(s) in the allowlist name a person or a client." >&2
  echo "The destination is public. Fix those lines in the kit, then run again." >&2
  exit 1
fi

echo "Exporting to $DEST"
[ -n "$DRY" ] && echo "  (dry run, nothing will be written)"

for p in "${PATHS[@]}"; do
  if [ ! -e "$KIT/$p" ]; then
    say "MISSING   $p   (not exported)"
    continue
  fi
  say "$p"
  [ -n "$DRY" ] && continue
  mkdir -p "$DEST/$(dirname "$p")"
  rm -rf "${DEST:?}/$p"
  cp -R "$KIT/$p" "$DEST/$p"
done

if [ -f "$KIT/$TEMPLATE" ]; then
  say "$TEMPLATE  ->  $TEMPLATE_AS"
  if [ -z "$DRY" ]; then
    mkdir -p "$DEST/$(dirname "$TEMPLATE_AS")"
    cp "$KIT/$TEMPLATE" "$DEST/$TEMPLATE_AS"
  fi
else
  say "MISSING   $TEMPLATE   (the team has no user-level file without it)"
fi

# --- prove the exclusions held ------------------------------------------------
if [ -z "$DRY" ]; then
  echo
  echo "Checking the destination for anything personal:"
  leaked=0
  for f in "${FORBIDDEN_PATHS[@]}"; do
    if [ -e "$DEST/$f" ]; then
      echo "  LEAKED  $f" >&2
      leaked=$((leaked + 1))
    fi
  done
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    echo "  LEAKED  $line" >&2
    leaked=$((leaked + 1))
  done < <(grep -rliE "$TRIPWIRES" "$DEST" --exclude-dir=.git 2>/dev/null | head -20 || true)
  if [ "$leaked" -gt 0 ]; then
    echo "  $leaked problem(s). Do not push this." >&2
    exit 1
  fi
  say "clean: no personal paths, no personal names"
  echo
  echo "Nothing has been committed or pushed. Review the diff in $DEST, then decide."
fi
