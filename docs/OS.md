# How this kit works

My operating manual. One page. Solo freelance — no team, no tracker, no approvals.

## The folder structure

```
.claude/            The brain — agents, skills, commands. Edit directly.
CLAUDE.md           Config Claude loads every session. Keep it lean.
docs/
  OS.md             This page.
  resources.md      Tools and sites worth remembering, with a "use when" for each.
project/            THE WORKSPACE — everything about the current project.
  STATE.md          Working memory between sessions. Honcho owns it.
  brief/            PRD, references. I put things here; everything else is output.
  research/         /discover outputs — findings, personas, journey maps.
  design-system/    /tokenize outputs — tokens + docs. Source of truth for every screen.
  screens/          /design-screen outputs — one spec or code folder per screen.
  reviews/          /slop-check and critique reports, dated.
  handoff/          /handoff packages — what the client's developers receive.
taste/              My taste memory. Read it; do not assume it is empty.
```

For a new client project: clone this repo, work on `main`, the `project/` folder is
that job's. Improvements to skills/agents/commands belong back here in the template.

## Session routine

1. **Open Claude Code and say hi to Honcho**, or just state the task. Honcho reads `project/STATE.md` and says where things stand.
2. Pick **instructor** (explains every step) or **operator** (just runs) when asked.
3. Work. Artifacts land in the `project/` folders automatically — commands know their output paths.
4. **Before stopping:** "update STATE.md" if it hasn't already, then `/commit`. STATE.md plus git is how tomorrow's me resumes without re-explaining anything.

## Per stage — Honcho drives this, I don't memorize it

| Stage | I say | What runs | Lands in |
|---|---|---|---|
| Intake | "here's the brief" | ux-strategy + `/discover` if research needed | `brief/`, `research/` |
| Design system | "let's build the system" | `/tokenize` (checks taste profile first) | `design-system/` |
| UI v1 | "design the dashboard screen" | `/design-screen` | `screens/` |
| Refine | "review this" | `/slop-check` + heuristics + a11y | `reviews/` |
| Ship | "prepare handoff" | `/handoff` | `handoff/` |

## Feeding the taste library

The taste profile is what stops output looking like everyone else's. A fresh clone starts
empty; this one is not - read `taste/TASTE.md` for the current state.

- **Offline (works now):** drop images or links into `taste/inbox/`, run `/taste-add` to file them with a note on *why* I like it, then `/taste-sync` to regenerate `taste/TASTE.md`. My words are the signal — "nice" teaches nothing.
- **Slack:** `/taste-pull` and `/taste-routine` read the channel configured in `taste/slack.json`. Read that file for the current channel rather than assuming; if it is unconfigured, use the `taste/inbox/` route instead.

Re-run `/taste-sync` after adding a batch. The profile gets more useful the more
entries it has and the more specific the *why* on each.

## Defaults, not rules

These are how I've chosen to work. Any of them can be overridden in the moment — say
so and Claude should just do it, without arguing.

- **No slop ships.** `/slop-check` failing is a real finding, not a style note. Generic AI-default output is a defect.
- **Client brand beats my taste; my taste beats model defaults.** The taste profile breaks ties — it never overrides a client's brand.
- **Tokens over raw values.** WCAG AA, keyboard, and reduced motion from the start — on paid client work that is legal exposure in the EU and US, not a preference.
- **STATE.md decisions are append-only.** Don't rewrite the thread.
- **Atomic commits, named paths when staging.** See `dev-conventions`.

## Working with models and limits

- **Match the model to the task's nature, not its size.** The tier table lives in
  `CLAUDE.md` section "Model routing": judgment and irreversible calls at the top
  tier, build-and-verify in the middle, mechanical volume at the small tier.
  Fan-outs set cheap models per stage on their own; switching the main session is
  my move, prepared by `/handover`.
- **Plan reality (Max 5x): tokens are the scarce resource.** Heavy multi-agent
  modes stay off by default and get switched on per task that earns them. Compact
  when a phase closes rather than when the context bursts. Before switching a
  session up-tier, `/handover` first - the expensive model reads a few hundred
  words, not the whole afternoon.
- Hit a session limit mid-task? Work is committed as I go and STATE.md holds the thread. Fresh session, say hi to Honcho, continue.

## Pulling upstream improvements

A launchd job checks the tracked `upstream` remote every 6 hours and notifies
when there is something new. Nothing merges automatically.

```bash
git fetch upstream
git log --oneline HEAD..upstream/main   # what changed
git merge upstream/main                 # take it
```

`.gitattributes` protects my personal files — `CLAUDE.md`, `README.md`, `taste/`,
`project/`, this page — so a merge takes skill improvements without
overwriting my setup. To see what upstream changed in a protected file anyway:
`git diff HEAD upstream/main -- CLAUDE.md`.

## Improving the setup itself

Found a routine that works, a missing skill, or slop that got through? Change it here.
The system is supposed to get better every project — same loop as taste, applied to
the tooling.
