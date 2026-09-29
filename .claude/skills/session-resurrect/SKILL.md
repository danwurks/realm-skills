---
name: session-resurrect
description: Save and restore Ghostty windows, panes and the Claude Code sessions inside them. Use when the user says they need to restart, reboot, quit Ghostty, or free up RAM; when they ask to back up, save, or protect their sessions; when they ask to get their sessions, tabs or windows back after a restart; or when they worry about losing work to a freeze. Runs the `resurrect` CLI installed by scripts/setup-machine.sh. macOS and Ghostty only.
---

# Session resurrect

The user restarts often — a small machine under memory pressure freezes, and
quitting Ghostty is how RAM gets reclaimed. This makes that free.

**Full detail: `tools/resurrect/README.md` in the kit. Read it before changing
anything.**

## Say this first, because they will assume the opposite

**Quitting Ghostty does not lose conversation context.** Claude Code writes every
session to `~/.claude/projects/` continuously; a hard power-off cannot lose it,
and `--resume` picks the conversation back up mid-thought. What a restart loses
is only the *map* — which session sat in which pane, in which directory. That is
what `resurrect` restores.

Never let them believe their work is gone. It almost certainly isn't.

## Usually there is nothing to run

**Cmd+Q Cmd+Q, reopen Ghostty, done.** Quitting stops the Claude daemon and arms
an auto-restore; the next launch brings every pane back on its own. No command,
no tokens. Say so rather than running something on their behalf.

## The commands

```sh
moshi moshi          # bring everything back (alias for `resurrect`)
resurrect            # the same thing, spelled plainly
resurrect save       # snapshot right now
resurrect status     # is auto-save on, how fresh, what's in it
resurrect list       # snapshots, including hourly history
resurrect prev       # restore the one before latest
resurrect quit       # goodnight: save, close Ghostty, stop the Claude daemon
resurrect open <words>   # find ONE past chat by words you remember and open it
                         # in a new split - refuses if it is already open
                         # (--id <session-id> for exact, --dry-run to preview)
```

The user's words for these are **`/oyasumi`** (goodnight - the full shutdown) and
**`moshi moshi`** (answering the phone - the restore). Use his words back to him.

Auto-save already runs every 60s while Ghostty is open, so a snapshot is normally
current within a minute. `resurrect save` is for the moment before a deliberate
quit, when the last minute mattered.

## When to run what

- **"I need to restart" / "I'm going to quit Ghostty"** → `resurrect save`, then
  report what it captured so they can see their sessions are recorded.
- **"Get my sessions back" / just restarted** → first: WAIT a breath -
  auto-restore fires seconds after launch with no visible sign. If nothing
  appears, run `resurrect`; a "restore already ran Ns ago" refusal means the
  restored window exists - find it instead of forcing. Do not run it yourself while agent sessions are live: restoring
  on top of running sessions opens a **second copy of every one of them**, which
  on a constrained machine can cause the freeze it was meant to prevent.
- **"Did it save?" / "is this working?"** → `resurrect status`.
- **Snapshot looks wrong or thin** → `resurrect list`, then `resurrect prev` or an
  hourly snapshot from `history/`.

## Two things not to get wrong

- **Never rebuild the auto-save as a LaunchAgent.** It cannot work: macOS grants
  Automation permission per responsible process, a launchd agent cannot display
  the approval prompt from a background context, and its `osascript` hangs
  forever — which then wedges Ghostty's Apple Event handler for every client and
  looks exactly like a Ghostty bug. The daemon must stay a child of a Ghostty
  shell, started from the shell rc hook, where it counts as Ghostty scripting
  itself. This was learned by failing at it.
- **Never `npm install -g ghostty-resurrect` over the vendored copy.** It carries
  a local patch that tail-reads transcripts instead of loading whole files
  (293 MB → 51 MB peak on a 61 MB transcript). npm would silently undo it and the
  symptom would be the freezing this tool exists to avoid. See
  `tools/resurrect/vendor/PATCHES.md`.

## What it will not do

Splits come back left-to-right regardless of the original arrangement, and only
agent panes resume - a pane running a dev server returns as a plain shell in the
right directory. Window position and size ARE restored, across multiple displays,
unless a display has been unplugged since the snapshot. Say so plainly rather
than letting them expect a pixel-perfect restore.
