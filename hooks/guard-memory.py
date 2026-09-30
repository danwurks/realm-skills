#!/usr/bin/env python3
"""Realm Skills enforcement hook - PreToolUse on Bash.

Two halves that share a file and nothing else. Keeping their reasoning separate
is deliberate: merging them is how the memory half got a wrong threshold once.

HALF A - the kill guard. BLOCKS (exit 2). Not a memory feature at all: it is a
working-set guard. Claude, Ghostty and Dia hold live work and are never a
legitimate source of reclaimed memory. Blocks at 90% free too. No override.
Chrome is explicitly NOT protected - it is the MCP's disposable engine.

HALF B - the memory warning. NEVER BLOCKS. Before a known-expensive command,
asks the `headroom` CLI whether there is room, and if not, tells the agent the
number. The operator decides; the hook states a fact. No memory condition has
ever justified refusing to run a command the user asked for.

Exit 0 = allow. Exit 2 = block, stderr goes back to the agent.
Fails OPEN on anything unexpected - a broken guard must not block real work.
"""
import json
import os
import re
import subprocess
import sys

PROTECTED = r"(?:claude(?:code)?|ghostty|dia)"

# Prefixes that must not smuggle a kill past the matcher. `sudo pkill -f claude`
# is the first thing reached for after a refusal, and an env-assignment-only
# prefix group let every one of these through.
PREFIX = r"(?:(?:sudo|command|exec|nohup|time|env)\s+(?:-\S+\s+)*)*(?:\w+=\S*\s+)*"
VERBS = [PREFIX + r"(?:kill|pkill|killall)\b"]
# xargs is judged over the WHOLE pipeline, not per statement: in
# `pgrep -f ghostty | xargs kill -9` the target names its victim upstream of the
# pipe, so a per-statement scan sees only a harmless-looking `xargs kill -9`.
XARGS_KILL = re.compile(PREFIX + r"xargs\s+(?:-\S+\s+)*kill\b")

HUNGRY = re.compile(
    r"\b(?:(?:npm|pnpm|yarn|bun)\s+(?:install|ci|run\s+build)"
    r"|next\s+build|vite\s+build|tsc\s+-b|xcodebuild|cargo\s+build"
    r"|docker\s+(?:build|run)|expo\s+(?:start|run)|playwright|puppeteer"
    r"|chrome-devtools)\b", re.I)


def mask_quotes(s):
    """Blank quoted spans IN PLACE, preserving length, so offsets still index
    the raw command. Statement text is sliced from the raw string afterwards, so
    `osascript -e 'quit app "Ghostty"'` is still judged on its real content."""
    return re.sub(r"""'[^']*'|"[^"]*\"|`[^`]*`""",
                  lambda m: " " * len(m.group(0)), s)


def mask_heredocs(s):
    """Blank heredoc BODIES, preserving length.

    A heredoc body is data being written to a file, not commands being run.
    Without this the guard blocks writing a SCRIPT that contains a protected
    command - which it did on 2026-08-21, refusing to let the resurrect tooling
    be edited because the file it was writing contained an `osascript ... quit`
    line. The quit was text inside a file, never a thing about to execute.

    Same principle as mask_quotes: judge what is being RUN, not what is being
    quoted or written. Length is preserved so offsets still index the raw string.
    """
    out = list(s)
    for m in re.finditer(r"<<-?\s*[\"']?([A-Za-z_][A-Za-z0-9_]*)[\"']?", s):
        delim = m.group(1)
        nl = s.find("\n", m.end())
        if nl == -1:
            continue
        end = re.search(r"^[\t ]*" + re.escape(delim) + r"[\t ]*$",
                        s[nl + 1:], re.M)
        stop = nl + 1 + (end.start() if end else len(s) - nl - 1)
        for i in range(nl + 1, min(stop, len(s))):
            if out[i] != "\n":
                out[i] = " "
    return "".join(out)


try:
    payload = json.load(sys.stdin)
    command = payload.get("tool_input", {}).get("command", "") or ""
except Exception:
    sys.exit(0)

if not command:
    sys.exit(0)

# ---------------------------------------------------------------- HALF A ----
# TWO views of the same command, because quotes mean opposite things depending
# on what they wrap:
#   masked - quotes blanked. Used to find the VERB and the statement boundaries,
#            so `echo \'pkill claude\'` and `git commit -m "never pkill claude"`
#            never register a verb at all.
#   named  - quotes KEPT. Used to find the target name, so `pkill -f "claude"`,
#            where the quotes ARE the target, is still caught.
# Comment spans are computed on the masked view so a `#` inside quotes is not
# mistaken for a comment, then blanked in both. All blanking is length-preserving
# so offsets index either view interchangeably.
q = mask_quotes(mask_heredocs(command))
spans = [m.span() for m in re.finditer(r"#[^\n]*", q)]
masked, named = list(q), list(command)
for a, b in spans:
    for i in range(a, b):
        masked[i] = named[i] = " "
masked, named = "".join(masked), "".join(named)
# `.claude/` is a CONFIG DIRECTORY, never a process. Without this, reclaiming
# something legitimate - `pkill -f ~/.claude/chrome-devtools-mcp.log` - is
# blocked with a message asserting it targets Claude, which is simply untrue.
# Both replacements are exactly 8 characters, so length is preserved.
for lit in (".claude/", '.claude"'):
    masked = masked.replace(lit, " " * len(lit))
    named = named.replace(lit, " " * len(lit))

hit = None
for verb in VERBS:
    for m in re.finditer(verb, masked):
        end = m.end()
        stop = len(masked)
        for ch in ";&|\n)":                       # judge one statement at a time
            i = masked.find(ch, end)
            if i != -1:
                stop = min(stop, i)
        if re.search(r"\b" + PROTECTED + r"\b", named[m.start():stop], re.I):
            hit = command[m.start():stop].strip()
            break
    if hit:
        break

if not hit:
    for a, b in [(mm.start(), mm.end()) for mm in re.finditer(r"[^;\n]+", masked)]:
        pipeline = named[a:b]
        if XARGS_KILL.search(masked[a:b]) and re.search(r"\b" + PROTECTED + r"\b", pipeline, re.I):
            hit = pipeline.strip()
            break

if not hit:
    for m in re.finditer(r"\bosascript\b", masked):
        stop = len(masked)
        for ch in ";&|\n":
            i = masked.find(ch, m.end())
            if i != -1:
                stop = min(stop, i)
        stmt = command[m.start():stop]            # RAW: the app name is quoted
        if re.search(r"\bquit\b", stmt, re.I) and re.search(PROTECTED, stmt, re.I):
            hit = stmt.strip()
            break

if hit:
    sys.stderr.write(
        "BLOCKED by Realm Skills (hooks/guard-memory.py): this targets Claude, "
        "Ghostty or Dia, which hold live work:\n  " + hit[:200] + "\n"
        "Never kill these to reclaim resources - a lost session costs more than "
        "the memory it frees, and there is no override for this rule.\n"
        "Reclaim from Chrome, simulators, builds or idle dev servers instead. "
        "Run `headroom --why` to see what is actually holding memory; the "
        "cheapest relief is usually close_page in the session owning the browser.\n"
        "Known gap: `kill -9 <pid>` with a bare PID cannot be matched without "
        "running ps on every command, which is unaffordable. Check the PID first.\n")
    sys.exit(2)

# ---------------------------------------------------------------- HALF B ----
# Cheapest test first: this runs on EVERY Bash call.
if not HUNGRY.search(masked):
    sys.exit(0)

gate = os.environ.get("HEADROOM_FAKE_GATE")
if gate is None:
    binary = os.environ.get("HEADROOM_BIN") or os.path.expanduser("~/.local/bin/headroom")
    try:
        gate = subprocess.run([binary, "--gate"], capture_output=True,
                              timeout=2).returncode
    except Exception:
        sys.exit(0)                # headroom absent or slow: silence, never a block
else:
    try:
        gate = int(gate)
    except ValueError:
        sys.exit(0)

if gate == 0:
    sys.exit(0)

state = "STOP" if gate == 20 else "TIGHT"
try:
    detail = subprocess.run(
        [os.environ.get("HEADROOM_BIN") or os.path.expanduser("~/.local/bin/headroom")],
        capture_output=True, text=True, timeout=2).stdout.strip()
except Exception:
    detail = ""

print(json.dumps({"hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext":
        "WARNING from Realm Skills (hooks/guard-memory.py): headroom says "
        + state + ". " + detail + "\nNot blocked - this is a fact, not a refusal. "
        "Claude, Ghostty and Dia cannot be reclaimed from, so a freeze here costs "
        "live work. Consider `headroom --why` first, closing browser pages, or "
        "saying plainly that you are starting anyway."}}))
sys.exit(0)
