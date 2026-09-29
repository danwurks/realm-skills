#!/usr/bin/env python3
"""Whatchamacallit hook - PostToolUse on Write/Edit.

Deterministic cleanup and a truth check, after the model writes rather than
before. Two jobs, in this order:

1. FORMAT, if the project has an opinion. Runs the project's OWN formatter
   on the one file that changed - prettier, biome, or eslint --fix,
   whichever is installed. Never installs one, never imposes a default: a
   repo with no formatter gets nothing done to it, because reformatting a
   codebase that never asked produces a diff nobody can review.

2. TYPE CHECK, and this is the one that earns its keep. It exists because,
   after a mid-refactor edit left `setXray` calling a method that did not
   exist and the tree sat broken for a whole message before anyone noticed:
   nothing was watching. `tsc --noEmit` on this project takes 1.3s, which is
   cheap enough to pay on every TypeScript edit.

It NEVER BLOCKS. A refactor legitimately passes through states that do not
compile, and a hook that stops that is a hook that gets disabled. It reports,
and the report is the point - the failure mode was not knowing.

Fails OPEN on anything unexpected: no project, no tooling, weird input, or a
tool that takes too long.
"""
import json
import os
import shutil
import subprocess
import sys

FORMAT_EXT = {".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs", ".css", ".scss", ".json", ".md", ".mdx"}
TS_EXT = {".ts", ".tsx"}
SKIP_DIRS = ("/node_modules/", "/.next/", "/dist/", "/build/", "/.git/")
TIMEOUT = 25


def run(cmd, cwd):
    try:
        p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=TIMEOUT)
        return p.returncode, (p.stdout or "") + (p.stderr or "")
    except Exception:
        return None, ""


def project_root(start):
    d = start
    while d and d != "/":
        if os.path.exists(os.path.join(d, "package.json")):
            return d
        d = os.path.dirname(d)
    return None


try:
    payload = json.load(sys.stdin)
except Exception:
    sys.exit(0)

if payload.get("tool_name") not in ("Write", "Edit", "MultiEdit"):
    sys.exit(0)

path = (payload.get("tool_input") or {}).get("file_path") or ""
if not path or not os.path.isfile(path):
    sys.exit(0)
if any(s in path for s in SKIP_DIRS):
    sys.exit(0)

ext = os.path.splitext(path)[1].lower()
root = project_root(os.path.dirname(os.path.abspath(path)))
if not root:
    sys.exit(0)

notes = []

# --- 1. the project's own formatter, on the one file that changed ---------
if ext in FORMAT_EXT:
    bins = os.path.join(root, "node_modules", ".bin")
    rel = os.path.relpath(path, root)
    if os.path.exists(os.path.join(bins, "biome")):
        run([os.path.join(bins, "biome"), "format", "--write", rel], root)
    elif os.path.exists(os.path.join(bins, "prettier")):
        run([os.path.join(bins, "prettier"), "--write", "--log-level", "warn", rel], root)
    elif os.path.exists(os.path.join(bins, "eslint")) and ext in (".ts", ".tsx", ".js", ".jsx"):
        run([os.path.join(bins, "eslint"), "--fix", "--no-warn-ignored", rel], root)

# --- 2. does it still compile ---------------------------------------------
if ext in TS_EXT and os.path.exists(os.path.join(root, "tsconfig.json")):
    tsc = os.path.join(root, "node_modules", ".bin", "tsc")
    if os.path.exists(tsc):
        code, out = run([tsc, "--noEmit"], root)
        if code not in (0, None):
            lines = [l for l in out.splitlines() if ": error TS" in l]
            if lines:
                shown = lines[:6]
                more = len(lines) - len(shown)
                notes.append(
                    "tsc --noEmit: %d error%s after this edit%s\n%s"
                    % (len(lines), "" if len(lines) == 1 else "s",
                       (" (showing %d)" % len(shown)) if more else "",
                       "\n".join("  " + l for l in shown))
                )
                if more:
                    notes.append("  ...and %d more" % more)

if notes:
    # Non-blocking: exit 0, say it on stderr, and let the model decide
    # whether it is mid-refactor or actually broken.
    print("after-write-check: " + "\n".join(notes), file=sys.stderr)

sys.exit(0)
