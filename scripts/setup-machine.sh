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
    # --executablePath pins it to Chrome. Dia is ALSO Chromium (ArcCore statically
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

# --- 3d. resurrect: Ghostty session survival ------------------------------------
# Snapshots every Ghostty window/pane and the Claude Code sessions inside them, so
# quitting Ghostty to reclaim RAM - or a hard restart after a freeze - costs
# nothing. macOS + Ghostty only; skipped cleanly anywhere else.
#
# This edits the shell rc file rather than installing a LaunchAgent, and that is
# not a preference. macOS grants Automation permission per RESPONSIBLE PROCESS: a
# process spawned from a Ghostty shell counts as Ghostty scripting itself and needs
# no approval, while a launchd agent is its own responsible process, cannot display
# an Automation prompt from a background context, and its osascript hangs forever -
# which then wedges Ghostty's Apple Event handler for every client. Verified by
# building it that way first. See tools/resurrect/README.md.
echo
echo "3d. resurrect (Ghostty session survival)"
if [ "$(uname -s)" != "Darwin" ]; then
  say "SKIPPED: macOS only"
elif [ ! -d "/Applications/Ghostty.app" ] && [ ! -d "$HOME/Applications/Ghostty.app" ]; then
  say "SKIPPED: Ghostty not installed (brew install --cask ghostty), re-run then"
else
  mkdir -p "$HOME/.local/bin"
  for b in resurrect resurrect-daemon moshi; do
    ln -sfn "$KIT/tools/resurrect/bin/$b" "$HOME/.local/bin/$b"
  done
  say "resurrect, moshi -> $HOME/.local/bin/"
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) say "NOTE: $HOME/.local/bin is not on PATH - add it to use 'resurrect'" ;;
  esac

  RC="$HOME/.zshrc"
  [ "$(basename "${SHELL:-/bin/zsh}")" = "bash" ] && RC="$HOME/.bash_profile"
  if grep -q 'resurrect-daemon' "$RC" 2>/dev/null; then
    say "shell hook already present in $(basename "$RC")"
  else
    if [ -f "$RC" ]; then
      cp "$RC" "$RC.backup-$STAMP"
      say "backed up $(basename "$RC") -> $(basename "$RC").backup-$STAMP"
    fi
    cat >> "$RC" <<'RESURRECT_HOOK'

# the kit / resurrect - keep the Ghostty session snapshot fresh.
# Must be started from a Ghostty child process; see tools/resurrect/README.md.
# The banner prints from THIS shell - the bare first pane the user is staring
# at after a relaunch - which is the one place Ghostty lets us write.
if [ -n "${GHOSTTY_RESOURCES_DIR:-}" ] && [ -f "$HOME/.config/ghostty-resurrect/autorestore" ]; then
  printf '\033[1m● resurrect: bringing your sessions back - new window incoming.\033[0m\n'
  printf '\033[2m  no need to type anything; moshi moshi is only for when this fails.\033[0m\n'
fi
[ -n "${GHOSTTY_RESOURCES_DIR:-}" ] && [ -x "$HOME/.local/bin/resurrect-daemon" ] \
  && "$HOME/.local/bin/resurrect-daemon" --ensure
RESURRECT_HOOK
    say "shell hook added to $(basename "$RC")"
  fi
fi

# --- 3e. Ghostty config ---------------------------------------------------------
# Terminal looks and behaves the same on every machine: theme, font, cell metrics,
# WASD split keybinds, and the `theme` switcher command.
#
# Symlinked file by file rather than as a directory, because other things write
# into ~/.config/ghostty/ that do not belong in version control. `theme <name>`
# edits the config THROUGH the symlink (it writes with `cat tmp > config`, not
# `mv`, which is what keeps the link intact) - so switching theme makes the kit
# repo dirty by one line, deliberately.
echo
echo "3e. Ghostty config"
if [ "$(uname -s)" != "Darwin" ]; then
  say "SKIPPED: macOS only"
else
  mkdir -p "$HOME/.config/ghostty"
  for item in config theme.zsh themes; do
    target="$HOME/.config/ghostty/$item"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      mv "$target" "$target.backup-$STAMP"
      say "moved existing $item -> $item.backup-$STAMP"
    fi
    ln -sfn "$KIT/config/ghostty/$item" "$target"
  done
  say "config, theme.zsh, themes -> $KIT/config/ghostty/"

  RC="$HOME/.zshrc"
  if grep -q 'ghostty/theme.zsh' "$RC" 2>/dev/null; then
    say "theme command already sourced in .zshrc"
  else
    [ -f "$RC" ] && [ ! -f "$RC.backup-$STAMP" ] && cp "$RC" "$RC.backup-$STAMP"
    cat >> "$RC" <<'THEME_HOOK'

# the kit - Ghostty theme switcher: theme | theme light | theme dark | theme browse
[ -s "$HOME/.config/ghostty/theme.zsh" ] && source "$HOME/.config/ghostty/theme.zsh"
THEME_HOOK
    say "theme command sourced in .zshrc"
  fi
fi

# --- 3f. headroom: memory awareness ---------------------------------------------
# Answers "is there room to start this?" on a machine where the obvious signals
# lie - free MB is a setpoint the kernel regulates to, and swap percent-used sits
# near 80% on a healthy day. The thresholds are relative, so a roomy Mac reads OK
# permanently and this costs nothing; it only speaks on a machine under real
# pressure. Paired with hooks/guard-memory.py, which also blocks kills aimed at
# Claude, Ghostty or Dia.
echo
echo "3f. headroom (memory awareness)"
if [ "$(uname -s)" != "Darwin" ]; then
  say "SKIPPED: macOS only"
else
  mkdir -p "$HOME/.local/bin"
  ln -sfn "$KIT/tools/headroom/bin/headroom" "$HOME/.local/bin/headroom"
  say "headroom -> $HOME/.local/bin/headroom"
  if [ ! -f "$HOME/.claude/headroom-baseline.json" ]; then
    say "no baseline yet - run 'headroom --baseline' on a quiet machine"
  fi
fi

# --- 3g. upstream watcher -------------------------------------------------------
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
[ -d "/Applications/Dia.app" ] && say "dia:      found (daily browser)" || say "dia:      MISSING (daily browser)"
[ -x "$HOME/.local/bin/resurrect" ] && say "resurrect: installed" || say "resurrect: not installed (needs Ghostty)"
[ -L "$HOME/.config/ghostty/config" ] && say "ghostty:  config linked" || say "ghostty:  config NOT linked"
[ -x "$HOME/.local/bin/headroom" ] && say "headroom: $("$HOME/.local/bin/headroom" 2>/dev/null | head -1)" || say "headroom: not installed"

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

Then check taste/.env for the Pinterest credentials — it is gitignored, so it
does not travel with the repo. See docs/MIGRATION.md.
EOF
fi
echo
