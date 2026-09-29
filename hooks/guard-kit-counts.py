#!/usr/bin/env python3
"""Whatchamacallit enforcement hook - PreToolUse on Bash, kit repo only.

Blocks `git commit` INSIDE THE KIT when the counts printed in README.md,
CLAUDE.md or project/STATE.md disagree with what is on disk. Exists because
the README described a 42-skill kit while 46 sat on disk for days
(fixed 2026-08-21) - drift is invisible exactly because nothing looks wrong.

Only fires for commits in this kit; every other repo is untouched.
Fails OPEN on any error - a broken counter must not block real work.
"""
import json
import os
import re
import sys

try:
    payload = json.load(sys.stdin)
    command = payload.get("tool_input", {}).get("command", "") or ""
    cwd = payload.get("cwd", "") or ""
except Exception:
    sys.exit(0)

if not re.search(r"(?:^|[;&|(\n]\s*)\s*(?:\w+=\S*\s+)*git\s+(?:-C\s+\S+\s+)?commit\b", command):
    sys.exit(0)

# Locate the kit: the hook lives in <kit>/hooks/.
kit = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Fire only when the commit targets the kit (cwd inside it, or -C <kit>).
in_kit = os.path.realpath(cwd).startswith(os.path.realpath(kit))
if not in_kit and kit not in command:
    sys.exit(0)

try:
    skills = len([d for d in os.listdir(os.path.join(kit, ".claude", "skills"))
                  if not d.startswith(".")])
    commands = len([f for f in os.listdir(os.path.join(kit, ".claude", "commands"))
                    if f.endswith(".md")])
    agents = len([f for f in os.listdir(os.path.join(kit, ".claude", "agents"))
                  if f.endswith(".md")])
except Exception:
    sys.exit(0)

problems = []
checks = [
    ("README.md", rf"\b(\d+) skills\b", skills, "skills"),
    ("README.md", rf"\b(\d+) (?:slash )?commands\b", commands, "commands"),
    ("README.md", rf"\b(\d+) agents\b", agents, "agents"),
    ("CLAUDE.md", rf"Skills \((\d+) active\)", skills, "skills"),
    # 2026-08-23: the four surfaces the original checks missed. honcho.md drifted to
    # "27 skills / 5 commands" against 48/14 and nothing caught it for weeks - it is
    # the first-contact router, so a stale inventory there is worse than in a doc.
    # STATE.md was named in this file's own docstring but never actually read.
    ("CLAUDE.md", rf"^## Commands \((\d+)\)", commands, "commands"),
    ("CLAUDE.md", rf"^## Agents \((\d+)", agents, "agents"),
    (".claude/agents/honcho.md", rf"\*\*(\d+) skills\*\*", skills, "skills"),
    (".claude/agents/honcho.md", rf"\*\*(\d+) commands\*\*", commands, "commands"),
    (".claude/agents/honcho.md", rf"\*\*(\d+) agents\*\*", agents, "agents"),
    ("project/STATE.md", rf"\*\*The kit:\*\* (\d+) skills", skills, "skills"),
    ("project/STATE.md", rf"\*\*The kit:\*\* \d+ skills · (\d+) commands", commands, "commands"),
    ("docs/MIGRATION.md", rf"the (\d+) skills are not installed", skills, "skills"),
]
for fname, pattern, truth, label in checks:
    path = os.path.join(kit, fname)
    try:
        text = open(path, encoding="utf-8").read()
    except Exception:
        continue
    for m in re.finditer(pattern, text, re.M):
        got = int(m.group(1))
        if got != truth:
            line = text[: m.start()].count("\n") + 1
            problems.append(f"{fname}:{line} says {got} {label}, disk has {truth}")

if problems:
    sys.stderr.write(
        "BLOCKED by whatchamacallit (hooks/guard-kit-counts.py): the kit's "
        "own docs miscount what is on disk - fix these before committing:\n  "
        + "\n  ".join(problems)
        + f"\nDisk truth right now: {skills} skills / {commands} commands / "
        f"{agents} agents.\n"
    )
    sys.exit(2)

sys.exit(0)
