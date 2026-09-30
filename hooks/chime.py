#!/usr/bin/env python3
"""Play a short sound when Claude Code finishes a turn or needs the operator.

Registered by scripts/install-hooks.py on two Claude Code hook events:

    Stop          -> chime.py done        the assistant finished responding
    Notification  -> chime.py attention   it is waiting: a permission prompt, idle

Why a hook and not the terminal bell: the bell is delivered through the
terminal, and terminals decide what to do with it. Ghostty's default is
bell-features = no-audio (it bounces the Dock icon and marks the tab, only
when unfocused), so "the session made a sound" was never a sound. A hook
runs regardless of which window is focused and regardless of terminal.

Platform: macOS plays a system sound with afplay; Linux tries the
freedesktop sounds, then the terminal bell; anything else rings the bell.
The player is spawned detached so the hook returns immediately - Claude
Code waits for hooks, and a sound must never slow a turn down.

Off switch: REALM_CHIME=0 in the environment.
Custom sounds, per person and per machine, never in the kit: drop a file at
~/.config/realm/chime-done.<ext> or chime-attention.<ext> (mp3,
m4a, aiff, wav, oga). The environment variables REALM_CHIME_DONE /
_ATTENTION override even that. Long clips are cut at MAX_SECONDS on macOS;
this plays at the end of every turn.
"""
import glob
import os
import shutil
import subprocess
import sys

EVENT = sys.argv[1] if len(sys.argv) > 1 else "done"
USER_DIR = os.path.expanduser("~/.config/realm")
MAX_SECONDS = 4


def user_sound(event):
    hits = sorted(glob.glob(os.path.join(USER_DIR, f"chime-{event}.*")))
    return hits[0] if hits else None

MAC_SOUNDS = {
    "done": "/System/Library/Sounds/Glass.aiff",
    "attention": "/System/Library/Sounds/Ping.aiff",
}
LINUX_SOUNDS = {
    "done": "/usr/share/sounds/freedesktop/stereo/complete.oga",
    "attention": "/usr/share/sounds/freedesktop/stereo/message.oga",
}


def detached(cmd):
    subprocess.Popen(
        cmd,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )


def bell():
    try:
        with open("/dev/tty", "w") as tty:
            tty.write("\a")
            tty.flush()
    except OSError:
        sys.stdout.write("\a")
        sys.stdout.flush()


def main():
    if os.environ.get("REALM_CHIME", "1") in ("0", "off", "false"):
        return 0
    custom = os.environ.get(f"REALM_CHIME_{EVENT.upper()}") or user_sound(EVENT)
    if sys.platform == "darwin":
        path = custom or MAC_SOUNDS.get(EVENT, MAC_SOUNDS["done"])
        if os.path.exists(path) and shutil.which("afplay"):
            detached(["afplay", "-v", "0.7", "-t", str(MAX_SECONDS), path])
            return 0
    elif sys.platform.startswith("linux"):
        path = custom or LINUX_SOUNDS.get(EVENT, LINUX_SOUNDS["done"])
        for player in ("paplay", "aplay", "ffplay"):
            if os.path.exists(path) and shutil.which(player):
                args = [player, path] if player != "ffplay" else [player, "-nodisp", "-autoexit", "-loglevel", "quiet", path]
                detached(args)
                return 0
    bell()
    return 0


if __name__ == "__main__":
    sys.exit(main())
