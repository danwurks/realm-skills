---
description: Save every Ghostty window, pane and Claude session, close Ghostty, and stop the Claude daemon so the memory actually comes back. Wake it with `moshi moshi`.
---
# /oyasumi

Goodnight. Hibernation in the literal sense: write the whole state to disk, power everything
down, and come back to it exactly as it was.

Plain **Cmd+Q does not do this.** Ghostty panes are *views*; Claude sessions live
in a daemon (`claude daemon run`), so quitting the terminal closes the viewer and
leaves the sessions running — around 900 MB of them on this machine. That is why
quitting to reclaim memory reclaims almost none of it, and why `resurrect` warns
that sessions are "already running" every time.

## First, check they actually need this

**Cmd+Q Cmd+Q already does the fast version, for free.** The daemon stops the
Claude daemon on quit and auto-restores on the next Ghostty launch, with no
command and no tokens spent. If the user just wants to close the laptop, tell
them that and stop - do not burn a turn running something a keystroke does.

/oyasumi earns its cost only when they are mid-task, because it adds two things
the automatic path cannot have: it WAITS for every session to finish, and it
VERIFIES every transcript before the running copy is destroyed. Cmd+Q closes
instantly, so neither is possible afterwards.

## What to run

```sh
resurrect quit
```

That is the whole command. It:

1. **Force-saves** a snapshot — every window, tab, pane, working directory,
   session id, and window geometry.
2. **Verifies every session resolves** to a real transcript on disk, and
   **refuses to continue** if any does not. This runs BEFORE anything closes:
   once the daemon stops, the snapshot and those transcripts are the only way
   back, so the check must never happen afterwards.
3. Shows what is about to close and how much memory the daemon holds, then asks.
4. **Waits for every session to finish.** A session whose transcript was written
   to in the last 60s is still working; one parked at a prompt writes nothing.
   If anything is busy it says so, then holds - and closes on its own once
   everything has been quiet for two consecutive checks. **The user does not
   have to run the command again.** A notification fires when it does.
5. **Closes Ghostty**, waits for it to actually exit, then runs
   `claude daemon stop --any`.

The wait runs in a DETACHED watcher, and it has to: the session running
/oyasumi is busy by definition, so an inline wait would hang waiting on itself.

`resurrect stop-quit` cancels an armed shutdown.

## Your job around it

- **Report which sessions are still working**, if any, so they know why it has
  not closed yet and that they need do nothing.
- **Report what it captured** — windows, panes, session count — so the user can
  see their work is recorded before anything closes.
- **If the pre-flight fails, stop.** Do not offer to force past it. A session
  whose transcript is missing is a session that will not come back, and the whole
  point of the gate is that it fires before the running copy is destroyed.
- **Say plainly what does not survive**: splits are rebuilt left-to-right, so a
  vertically stacked arrangement returns side by side, and only agent panes
  resume — a pane running a dev server comes back as a plain shell in the right
  directory.
- Window position and size DO come back, across multiple displays, unless a
  display has been unplugged since the snapshot or that window has never been
  frontmost (System Events cannot see windows on an inactive Space).

## Coming back

Open Ghostty and run:

```sh
moshi moshi
```

(`resurrect` still works and does exactly the same thing - `moshi` sits on top of
it. The second "moshi" is an argument the script swallows, because a command name
cannot contain a space.)

Every window returns with its panes, directories and geometry, each pane doing a
clean cold resume from its transcript. Close the leftover window you typed in.

`resurrect list` shows older snapshots, `resurrect prev` steps back one, and
`richest.json` holds the most complete state seen in the last day if something
has gone wrong.

Full detail: `tools/resurrect/README.md`. See also the `session-resurrect` skill.
