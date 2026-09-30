#!/usr/bin/env python3
"""Realm Skills enforcement hook - PreToolUse on Bash.

Blocks any command that would kill or quit Claude itself. A session holds live
work that cannot be recovered, so "free up memory by closing things" must never
reach it, and there is no override.

It reads the command two ways, because quotes mean opposite things depending on
what they wrap: one view with quotes blanked, to find the verb and the statement
boundaries, and one with quotes kept, to find the target name. Comments and
heredoc bodies are data, not commands, and are exempt.

Fails OPEN on any error: a broken guard must not block real work.
"""
import json
import os
import re
import subprocess
import sys

PROTECTED = r"(?:claude(?:code)?|cursor)"
# Cursor joins Claude because a team running Claude Code INSIDE Cursor has two
# processes holding the same live work, and "free up memory" aimed at the editor
# takes the session with it (added 2026-09-30, on the kit owner's call).

# Prefixes that must not smuggle a kill past the matcher. `sudo pkill -f claude`
# is the first thing reached for after a refusal, and an env-assignment-only
# prefix group let every one of these through.
PREFIX = r"(?:(?:sudo|command|exec|nohup|time|env)\s+(?:-\S+\s+)*)*(?:\w+=\S*\s+)*"
VERBS = [PREFIX + r"(?:kill|pkill|killall)\b"]
# xargs is judged over the WHOLE pipeline, not per statement: in
# `pgrep -f claude | xargs kill -9` the target names its victim upstream of the
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
    `osascript -e 'quit app "Claude"'` is still judged on its real content."""
    return re.sub(r"""'[^']*'|"[^"]*\"|`[^`]*`""",
                  lambda m: " " * len(m.group(0)), s)


def mask_heredocs(s):
    """Blank heredoc BODIES, preserving length.

    A heredoc body is data being written to a file, not commands being run.
    Without this the guard blocks writing a SCRIPT that contains a protected
    command, which once refused a legitimate edit to a script that merely
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
for lit in (".claude/", '.claude"', ".cursor/", '.cursor"'):
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
        "BLOCKED by Realm Skills (hooks/guard-memory.py): this targets a process "
        "which holds live work:\n  " + hit[:200] + "\n"
        "Never kill these to reclaim resources - a lost session costs more than "
        "the memory it frees, and there is no override for this rule.\n"
        "Reclaim from Chrome, simulators, builds or idle dev servers instead. "
        "Known gap: `kill -9 <pid>` with a bare PID cannot be matched without "
        "running ps on every command, which is unaffordable. Check the PID first.\n")
    sys.exit(2)
