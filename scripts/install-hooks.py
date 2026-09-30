#!/usr/bin/env python3
"""Merge the kit's enforcement hooks into ~/.claude/settings.json.

Idempotent: safe to re-run, never duplicates, never clobbers unrelated
settings. Called by setup-machine.sh; can be run directly.

Hooks are loaded by Claude Code at SESSION START - after installing,
they arm in the next session, not the current one.
"""
import json
import os
import sys

KIT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SETTINGS = os.path.expanduser("~/.claude/settings.json")

# (event, matcher, command). A matcher of None is an event that takes no
# matcher (Stop, Notification): the entry is written without the key.
WANTED = [
    ("PreToolUse", "Bash", f"python3 {KIT}/hooks/guard-git.py"),
    ("PreToolUse", "Bash", f"python3 {KIT}/hooks/guard-kit-counts.py"),
    ("PreToolUse", "Bash", f"python3 {KIT}/hooks/guard-memory.py"),
    ("PreToolUse", "Write|Edit", f"python3 {KIT}/hooks/guard-em-dash.py"),
    # A sound when a turn ends and another when the assistant is waiting, so
    # the operator can look away. Terminal-agnostic and focus-independent,
    # unlike the terminal bell. Off with WHATCHAMACALLIT_CHIME=0.
    ("Stop", None, f"python3 {KIT}/hooks/chime.py done"),
    ("Notification", None, f"python3 {KIT}/hooks/chime.py attention"),
]

settings = {}
if os.path.exists(SETTINGS):
    with open(SETTINGS, encoding="utf-8") as f:
        settings = json.load(f)

hooks = settings.setdefault("hooks", {})
added = 0
for event, matcher, command in WANTED:
    entries = hooks.setdefault(event, [])
    entry = next((e for e in entries if e.get("matcher") == matcher), None)
    if entry is None:
        entry = {"hooks": []} if matcher is None else {"matcher": matcher, "hooks": []}
        entries.append(entry)
    if not any(h.get("command") == command for h in entry["hooks"]):
        entry["hooks"].append({"type": "command", "command": command})
        added += 1

with open(SETTINGS, "w", encoding="utf-8") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")

print(f"  hooks: {added} added, {len(WANTED) - added} already present")
print("  arm at the NEXT session start (hook config loads at startup)")
sys.exit(0)
