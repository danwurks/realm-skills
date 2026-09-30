#!/usr/bin/env bash
# Realm Skills - machine setup.
#
# Makes the kit apply to EVERY project on this machine, not just this repo.
# Safe to re-run: it is idempotent and never overwrites without a backup.
#
#   bash scripts/setup-machine.sh
#
# Run this after: a fresh clone, a new machine, or switching Claude accounts.
# See docs/MIGRATION.md for what a Claude account switch does and does not carry.

set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

say() { printf '  %s\n' "$1"; }

echo
echo "Realm Skills setup"
echo "  kit: $KIT"
echo

mkdir -p "$CLAUDE_DIR"

# --- 1. symlink skills, commands, agents, and the user-level rules --------------
# Symlinks rather than copies, so the kit stays the single source of truth:
# edit once here, every project sees it immediately.
echo "1. Linking kit into $CLAUDE_DIR"
for item in skills commands agents; do
  target="$CLAUDE_DIR/$item"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.backup-$STAMP"
    say "moved existing $item -> $item.backup-$STAMP"
  fi
  ln -sfn "$KIT/.claude/$item" "$target"
  say "$item -> $(readlink "$target")"
done

# The user-level CLAUDE.md loads in EVERY project on this machine. Keeping it in
# the repo and symlinking it means it is version-controlled like everything else.
target="$CLAUDE_DIR/CLAUDE.md"
if [ -e "$target" ] && [ ! -L "$target" ]; then
  mv "$target" "$target.backup-$STAMP"
  say "moved existing CLAUDE.md -> CLAUDE.md.backup-$STAMP"
fi
ln -sfn "$KIT/.claude/user-CLAUDE.md" "$target"
say "CLAUDE.md -> $(readlink "$target")"

# --- 1b. playwright-cli, the first-reach browser -------------------------------
# The routing rule in .claude/user-CLAUDE.md sends runtime verification here
# BEFORE the MCP: headless, so it does not leave windows sitting in RAM, and
# `eval` runs real JS in the page, which is what measuring actually needs. A
# machine without it makes that rule point at a tool that is not there.
echo
echo "1b. Installing playwright-cli (first-reach browser)"
if command -v npm >/dev/null 2>&1; then
  if [ -x "$(npm config get prefix 2>/dev/null)/bin/playwright-cli" ]; then
    say "already installed — skipping"
  else
    npm install -g @playwright/cli >/dev/null 2>&1 && say "installed" || say "FAILED — install by hand: npm i -g @playwright/cli"
  fi
  # Chromium is the browser; ffmpeg is what lets it record video, which is how
  # a transition gets frame-stepped without anyone screen-recording by hand.
  npx playwright install chromium ffmpeg >/dev/null 2>&1 && say "chromium + ffmpeg ready" || say "browsers NOT installed — run: npx playwright install chromium ffmpeg"
  say "NOTE: it is not on PATH. Call it as \"\$(npm config get prefix)/bin/playwright-cli\""
else
  say "npm MISSING — cannot install playwright-cli"
fi

# --- 2. browser MCP at user scope ----------------------------------------------
# Registered at USER scope on purpose: a browser is not project-specific, and
# without it no agent can inspect a rendered page — which is where most UX and
# runtime defects actually live.
echo
echo "2. Registering chrome-devtools MCP (user scope)"
if command -v claude >/dev/null 2>&1; then
  if claude mcp list 2>/dev/null | grep -q '^chrome-devtools'; then
    say "already registered — skipping"
  else
    # These flags are load-bearing, not decoration - see docs/BROWSER-SAFETY.md.
    # --isolated       throwaway profile, so it can never touch a real one
    # --headless       no window exists, so no window can be closed
    # --executablePath pins it to Chrome. A daily browser may ALSO be Chromium, so
    #                  links Chromium 151), so without this pin there is a real
    #                  path to driving the browser holding the user's live work.
    # --logFile        so a recurrence has evidence rather than recollection
    # NB: --allowFileAccessFromFiles was here and is a DEAD FLAG - it does not
    # exist anywhere in chrome-devtools-mcp v1.7.0, and the tool does not use
    # strict parsing, so it was silently ignored. Removed rather than left to
    # look load-bearing.
    claude mcp add --scope user chrome-devtools -- \
      npx -y chrome-devtools-mcp@latest \
      --isolated --headless \
      --executablePath "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
      --logFile "$HOME/.claude/chrome-devtools-mcp.log" >/dev/null
    say "registered"
  fi
else
  say "SKIPPED: 'claude' CLI not on PATH — register it manually."
  say "Copy ALL of it. The four flags are the browser-safety contract (docs/BROWSER-SAFETY.md);"
  say "without --headless and --executablePath this can reach a browser holding live work."
  say "  claude mcp add --scope user chrome-devtools -- \\"
  say "    npx -y chrome-devtools-mcp@latest \\"
  say "    --isolated --headless \\"
  say "    --executablePath \"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome\" \\"
  say "    --logFile \"$HOME/.claude/chrome-devtools-mcp.log\""
fi

# --- 3. git merge driver --------------------------------------------------------
# .gitattributes marks personal files 'merge=ours' so pulling upstream never
# clobbers them. Git needs the driver defined locally for that to take effect.
#
# KNOWN SHARP EDGE, verified rather than assumed: 'merge=ours' does not know who is
# merging. It fires on EVERY merge, so on a branch merge where both main and the
# branch touched a protected file, the branch's version is discarded silently -
# no conflict, no warning. It is the guard you want against upstream and a trap
# against your own long-running branches. See CLAUDE.md "Merge policy".
echo
echo "3. Git 'ours' merge driver"
git -C "$KIT" config merge.ours.driver true
say "set"

# --- 3b. one-way upstream -------------------------------------------------------
# Skills flow IN from Hulusi's repo; your refinements flow OUT only to origin.
# Nothing of yours is ever pushed back. The fetch URL is left alone; only pushing is
# disabled, and it is per-clone config, so it has to be set on every machine.
if git -C "$KIT" remote get-url upstream >/dev/null 2>&1; then
  echo
  echo "3b. Upstream is fetch-only"
  git -C "$KIT" remote set-url --push upstream no_push
  say "push to upstream disabled (fetch still works)"
fi

# --- 3c. enforcement hooks ------------------------------------------------------
# Moves the sharpest rules from prose into machinery: git add -A blocked,
# git push held for stated approval, kit doc counts checked on commit, em
# dashes blocked in UI code. Idempotent merge into ~/.claude/settings.json.
# Hooks load at session start, so they arm in the NEXT Claude session.
echo
echo "3c. Enforcement hooks"
python3 "$KIT/scripts/install-hooks.py"

# --- 3d. upstream watcher -------------------------------------------------------
# CLAUDE.md and docs/OS.md both claimed "a launchd job polls upstream every 6h".
# It existed on exactly one machine and was never installed by this script, so the
# capability did not travel (found by the 2026-08-23 audit). It does now.
PLIST="$HOME/Library/LaunchAgents/com.realm-skills.unicorn-upstream.plist"
if git -C "$KIT" remote | grep -qx upstream; then
  mkdir -p "$HOME/Library/LaunchAgents" "$HOME/.cache"
  cat > "$PLIST" <<PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.realm-skills.unicorn-upstream</string>
    <key>ProgramArguments</key>
    <array>
        <string>$KIT/scripts/upstream-check.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>21600</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>$HOME/.cache/unicorn-upstream.err</string>
</dict>
</plist>
PLISTEOF
  launchctl unload "$PLIST" 2>/dev/null
  launchctl load "$PLIST" 2>/dev/null && say "upstream watcher: loaded (every 6h, notifies only)" \
    || say "upstream watcher: plist written, launchctl load failed - run it by hand"
else
  say "upstream watcher: SKIPPED (no 'upstream' remote on this clone)"
fi

# --- 4. verify ------------------------------------------------------------------
echo
echo "4. Verify"
say "skills:   $(ls "$CLAUDE_DIR/skills" 2>/dev/null | wc -l | tr -d ' ')"
say "commands: $(ls "$CLAUDE_DIR/commands" 2>/dev/null | wc -l | tr -d ' ')"
say "agents:   $(ls "$CLAUDE_DIR/agents" 2>/dev/null | wc -l | tr -d ' ')"
command -v node >/dev/null 2>&1 && say "node:     $(node --version)" || say "node:     MISSING (chrome-devtools MCP needs it)"
[ -d "/Applications/Google Chrome.app" ] && say "chrome:   found (MCP engine, not a browser)" || say "chrome:   MISSING (chrome-devtools MCP needs it)"

# bootstrap-mac.sh prints a fuller version of this list, so it suppresses ours
# rather than showing the user two overlapping checklists.
if [ "${SETUP_TRAILER:-1}" = "1" ]; then
cat <<'EOF'

Done. Two things this script cannot do for you — they are tied to your Claude
ACCOUNT, not this machine, so they must be redone after an account switch:

  1. Approve the MCP servers. Start Claude Code and accept the prompts for
     chrome-devtools and figma (they appear as "Pending approval").
  2. Re-authorise the claude.ai connectors: Figma, Mobbin, Slack, Google Drive,
     Atlassian. Connector settings on claude.ai.

EOF
fi
echo
