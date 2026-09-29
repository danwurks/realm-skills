---
name: memory-headroom
description: Check memory headroom before starting anything expensive on a small Mac. Use before launching a browser or MCP server, before npm install / a build / docker, before spawning subagents or parallel jobs, and whenever the machine feels slow or the user mentions freezing, lag or beachballing. Runs the `headroom` CLI installed by scripts/setup-machine.sh. macOS only.
---

# Memory headroom

One command before anything expensive:

```sh
headroom
```

Read the **verdict**, not the numbers.

- **OK** - go.
- **TIGHT** - say the number out loud and either pick the cheaper path or ask.
- **STOP** - do not start it. Run `headroom --why` and report what is holding memory.

This matters on a small machine and is nearly free on a large one: the thresholds
are relative, so a roomy Mac reads OK permanently and the check costs ~10 ms.

## What is protected, and what is fair game

**Claude Code, Ghostty and Dia are fixed cost.** They hold live work.
`hooks/guard-memory.py` blocks kills against them and there is **no override** -
do not try to route around it with `sudo`, a pipeline into `xargs`, or
`osascript`. All of those are covered.

Fair game: Chrome (it is the MCP's disposable engine, not a browser here),
simulators, builds, idle dev servers, mounted images.

**The cheapest real relief is not killing anything.** It is `close_page` in the
session that owns the browser - a chrome-devtools tree accumulates a renderer per
page opened and closes none until the session ends.

## What the numbers mean, and what they do not

- `free=NN%` is `kern.memorystatus_level`. Its kernel formula is not public. Use
  it as a **trend**, never as "NN% of RAM is available".
- `swapout` is the one signal that separates a working machine from a freezing
  one. Zero on a healthy box; hundreds to thousands of pages/s during a freeze.
- `decomp` is corroboration only - healthy and freezing overlap in the low range.
- `compressed` is how oversubscribed the machine already is.
- **Swap percent-used is meaningless.** It sits around 80% on a perfectly healthy
  day, because macOS mints swapfiles on demand. Never quote it as a warning.
- **Free MB is meaningless.** The kernel regulates it to a setpoint, so it reads
  roughly the same whether the machine is idle or thrashing.

Never restate the thresholds here - `headroom --explain` owns them, and says
which were measured and which chosen. Two copies drift, and the docs copy is the
one that gets believed.

## Housekeeping

`headroom reap` lists reclaimable disk (orphaned browser profiles, an unrotated
MCP log); `headroom reap --apply` acts. It never kills a process, by design -
the process-reaper version was built, tested against the machine it was designed
for, and found zero orphans while mislabelling two live sessions as idle.

## When the baseline is stale

If `headroom` prints `(no baseline)`, say so and offer `headroom --baseline`
after the next reboot. Until then the thresholds are fitted to one machine on one
bad afternoon, and should be described that way rather than quoted as settled.
