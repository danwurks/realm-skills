#!/usr/bin/env python3
"""Whatchamacallit enforcement hook - PreToolUse on Bash.

Two standing git rules, moved from prose into machinery:

1. `git add -A` / `git add --all` / `git add .` is BLOCKED, always.
   The rule exists because a stray .env pushed to GitHub is effectively
   permanent; staging by named path is the whole defence. There is no
   override - name the paths.

2. `git push` gets a SPEED BUMP. The standing rule is "ask before anything
   hard to reverse - pushing, deploying, deleting". The hook cannot know
   whether the user said yes, so it blocks the bare command and asks the agent
   to restate the approval by re-running with KIT_APPROVED_PUSH=1 in the
   command. That single bit stays on the honour system; everything else
   stops being one. Reflexive pushes - the actual failure mode - no longer
   happen.

Exit 0 = allow. Exit 2 = block, stderr goes back to the agent.
Fails OPEN on unparseable input: a broken hook must not brick the shell.
"""
import json
import re
import sys

try:
    payload = json.load(sys.stdin)
    command = payload.get("tool_input", {}).get("command", "") or ""
except Exception:
    sys.exit(0)

# Strip quoted strings so `grep "git add -A"` or a commit message never
# false-positives; we only care about the command structure itself.
bare = re.sub(r"""'[^']*'|"[^"]*"|`[^`]*`""", "", command)

# A git invocation at the start of the command or after a separator.
# `(?:\w+=\S*\s+)*` closes the env-prefix bypass (`FOO=1 git add -A`);
# `(` and newline in the separator set close `$(git push)` and multiline.
GIT_PREFIX = r"(?:^|[;&|(\n]\s*|\bthen\s+|\bdo\s+)\s*(?:\w+=\S*\s+)*git\s+(?:-C\s+\S+\s+)?"
GIT_ADD_ALL = re.compile(
    GIT_PREFIX + r"add\s+(?:[^;&|\n]*\s)?(?:-A\b|--all\b|\.(?:\s|;|&|\||\)|$))"
)
GIT_PUSH = re.compile(GIT_PREFIX + r"push\b")

if GIT_ADD_ALL.search(bare):
    sys.stderr.write(
        "BLOCKED by whatchamacallit (hooks/guard-git.py): `git add -A`, "
        "`--all` and `git add .` are banned in every repo - a stray .env "
        "staged once is permanent. Stage by NAMED PATH instead: "
        "`git add path/to/file other/path`. No override exists.\n"
    )
    sys.exit(2)

if GIT_PUSH.search(bare) and "KIT_APPROVED_PUSH=1" not in command:
    sys.stderr.write(
        "HELD by whatchamacallit (hooks/guard-git.py): pushing is on the user's "
        "ask-first list. If they have approved THIS push in THIS session, re-run "
        "the same command prefixed with KIT_APPROVED_PUSH=1 . If they have not, "
        "ask them - do not invent approval.\n"
    )
    sys.exit(2)

sys.exit(0)
