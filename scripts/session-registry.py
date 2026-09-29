#!/usr/bin/env python3
"""Who is running, where, and on which model: the session registry.

With several sessions open on one machine, work should go to the model that
suits it. A hub session cannot do that from ListAgents alone: it reports a
name and idle-or-busy and nothing else. Asking each peer costs a round trip
and goes stale the moment anyone changes model.

It does not have to be asked for. Every session already writes the two facts
in its own transcript, so this reads them rather than trusting anyone to
register:

  ~/.claude/projects/<project>/<session-id>.jsonl
    first line   {"type":"custom-title","sessionId":...,"customTitle":...}
                 the name ListAgents shows and SendMessage addresses
    every turn   {"message":{"model":"claude-opus-5",...},...}
                 the model that answered THAT turn, so the last one is live

Which means it survives a /model mid-session, needs no hook, no daemon and no
cooperation, and works for sessions that started before this file existed.

  python3 scripts/session-registry.py              the table, newest first
  python3 scripts/session-registry.py --json       the same as JSON
  python3 scripts/session-registry.py --hours 48   widen the window (default 24)
  python3 scripts/session-registry.py --all        every project, not just this one

A session is listed when its transcript has been written to inside the
window; that is activity, not liveness, and the table says so. ListAgents
remains the authority on who is actually reachable and idle: this answers
what they are, not whether they are there.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

PROJECTS = Path.home() / ".claude" / "projects"
# The tail is read, not the file: a long session's transcript runs to hundreds of MB.
TAIL_BYTES = 512 * 1024
FRIENDLY = {
    "claude-opus-5": "Opus 5",
    "claude-opus-5[1m]": "Opus 5 (1M)",
    "claude-fable-5": "Fable 5",
    "claude-fable-5[1m]": "Fable 5 (1M)",
    "claude-sonnet-5": "Sonnet 5",
    "claude-haiku-4-5-20251001": "Haiku 4.5",
}


def friendly(model: str) -> str:
    if not model:
        return "unknown"
    return FRIENDLY.get(model, model)


TITLE_MARK = b'"customTitle"'
# A rename is written where it happened, which can be anywhere: at creation
# (byte 23 in this session's own transcript) or a hundred megabytes in. So look
# at both ends and take the LATEST, rather than trusting either.
HEAD_BYTES = 256 * 1024
BACK_BYTES = 48 * 1024 * 1024


def _titles_in(chunk: bytes, base: int) -> list[tuple[int, str]]:
    found = []
    for raw in chunk.split(b"\n"):
        if TITLE_MARK not in raw:
            continue
        try:
            d = json.loads(raw)
        except json.JSONDecodeError:
            continue
        if d.get("customTitle"):
            found.append((base, str(d["customTitle"])))
    return found


def head_facts(path: Path) -> dict:
    """The name (the latest rename) and the session id."""
    out = {"title": "", "session": path.stem}
    try:
        size = path.stat().st_size
        with path.open("rb") as fh:
            head = fh.read(min(HEAD_BYTES, size))
            hits = _titles_in(head, 0)
            back_from = max(len(head), size - BACK_BYTES)
            if size > len(head):
                fh.seek(back_from)
                tail = fh.read()
                # Drop the first line: a seek lands mid-line.
                cut = tail.find(b"\n")
                if cut >= 0:
                    hits += _titles_in(tail[cut + 1 :], back_from)
            if hits:
                out["title"] = hits[-1][1]
            for raw in head.split(b"\n"):
                if b'"sessionId"' not in raw:
                    continue
                try:
                    d = json.loads(raw)
                except json.JSONDecodeError:
                    continue
                if d.get("sessionId"):
                    out["session"] = str(d["sessionId"])
                    break
    except OSError:
        pass
    return out


def tail_facts(path: Path) -> dict:
    """The live model and cwd, from the last turns."""
    out = {"model": "", "cwd": "", "turns": 0}
    try:
        size = path.stat().st_size
        with path.open("rb") as fh:
            fh.seek(max(0, size - TAIL_BYTES))
            chunk = fh.read()
    except OSError:
        return out
    lines = chunk.split(b"\n")
    # Drop the first, which a seek into the middle of a line leaves broken.
    for raw in reversed(lines[1:]):
        if not raw.strip():
            continue
        try:
            d = json.loads(raw)
        except json.JSONDecodeError:
            continue
        out["turns"] += 1
        if not out["cwd"] and d.get("cwd"):
            out["cwd"] = str(d["cwd"])
        model = (d.get("message") or {}).get("model")
        if model and not out["model"]:
            out["model"] = str(model)
        if out["model"] and out["cwd"]:
            break
    return out


def scan(hours: float, only_project: str | None) -> list[dict]:
    cutoff = time.time() - hours * 3600
    rows: list[dict] = []
    if not PROJECTS.is_dir():
        return rows
    for project in sorted(PROJECTS.iterdir()):
        if not project.is_dir():
            continue
        if only_project and project.name != only_project:
            continue
        for jsonl in project.glob("*.jsonl"):
            try:
                mtime = jsonl.stat().st_mtime
            except OSError:
                continue
            if mtime < cutoff:
                continue
            row = {"project": project.name, "mtime": mtime}
            row.update(head_facts(jsonl))
            row.update(tail_facts(jsonl))
            rows.append(row)
    rows.sort(key=lambda r: -r["mtime"])
    return rows


def project_key(cwd: str) -> str:
    """The directory name Claude Code gives a project: the path with slashes as dashes."""
    return cwd.replace("/", "-")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--hours", type=float, default=24.0, help="how far back a transcript counts as active (default 24)")
    ap.add_argument("--all", action="store_true", help="every project, not just the working directory's")
    ap.add_argument("--json", action="store_true", help="machine-readable")
    args = ap.parse_args()

    only = None if args.all else project_key(os.getcwd())
    rows = scan(args.hours, only)
    if not rows and only:
        # A working directory with no transcripts is more likely a wrong guess than an empty machine.
        rows = scan(args.hours, None)

    if args.json:
        print(json.dumps(rows, indent=1))
        return 0

    if not rows:
        print(f"no sessions written to in the last {args.hours:g}h")
        return 0

    mine = os.environ.get("CLAUDE_SESSION_ID", "")
    now = time.time()
    width = max(len(r["title"] or r["session"][:8]) for r in rows)
    print(f"{'name'.ljust(width)}  {'model'.ljust(12)}  {'last seen'.rjust(9)}  project")
    for r in rows:
        name = r["title"] or r["session"][:8]
        age = now - r["mtime"]
        seen = f"{age:.0f}s" if age < 90 else f"{age/60:.0f}m" if age < 5400 else f"{age/3600:.1f}h"
        mark = " <- this session" if r["session"] == mine else ""
        print(f"{name.ljust(width)}  {friendly(r['model']).ljust(12)}  {seen.rjust(9)}  {r['project']}{mark}")
    print()
    print("Activity, not liveness: ListAgents says who is reachable and idle. This says what they are.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
