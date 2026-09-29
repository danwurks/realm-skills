#!/usr/bin/env python3
"""Close the automation browser when a turn ends.

An automation browser left running after a turn ends costs memory for nothing.
On a machine under pressure that is the difference between smooth and not, and
starting one again for the next task is cheap.

WHAT THIS KILLS, and what it deliberately does not. The chrome-devtools MCP
runs two separate things. The SERVER is three idle node processes costing
almost nothing, and it is left alone: killing it would break the tool for the
session rather than just freeing memory. The BROWSER is a full Chrome under a
throwaway profile, and on this machine it was seven processes that stayed
resident long after the last screenshot. That is what goes.

It is matched on the puppeteer profile path, so the user's own Chrome, and
any other Chrome, cannot be caught by it. The MCP relaunches the browser on
the next browser call, which costs a couple of seconds and is the trade the user
asked for.

Silent, and always exits 0: a housekeeping hook must never fail a turn.
"""
import os
import subprocess
import sys

PROFILE = "puppeteer_dev_chrome_profile"
# A process only qualifies if it is ACTUALLY the browser. Matching the profile
# string alone is not enough and was a real bug: the first version killed the
# shell that ran it, because that shell's own command line happened to contain
# the string. Anything that merely mentions the profile - a grep, a script, a
# terminal command - must survive.
# The APP BUNDLE, not a bare word. The executable path is
# "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome", which
# contains a space, so testing the first whitespace token finds only
# "/Applications/Google" and matches nothing. Ask for the bundle.
BROWSER = ("Google Chrome.app", "Chromium.app", "Google Chrome Helper")


def main() -> int:
    try:
        ps = subprocess.run(["ps", "axo", "pid=,command="], capture_output=True, text=True, timeout=10)
    except Exception:
        return 0
    mine = {str(os.getpid()), str(os.getppid())}
    pids = []
    for line in ps.stdout.splitlines():
        line = line.strip()
        if PROFILE not in line or "--user-data-dir=" not in line:
            continue
        if not any(b in line for b in BROWSER):
            continue
        head = line.split(None, 1)
        if not head or not head[0].isdigit() or head[0] in mine:
            continue
        # A shell, a grep or a script that merely mentions the profile is
        # never the browser, whatever else its command line contains.
        cmd = head[1] if len(head) > 1 else ""
        first = cmd.split()[0] if cmd.split() else ""
        if first.rsplit("/", 1)[-1] in ("zsh", "bash", "sh", "python3", "python", "grep", "ps", "node"):
            continue
        pids.append(head[0])
    for pid in pids:
        for sig in ("-TERM", "-KILL"):
            try:
                subprocess.run(["kill", sig, pid], capture_output=True, timeout=5)
            except Exception:
                pass
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception:
        sys.exit(0)
