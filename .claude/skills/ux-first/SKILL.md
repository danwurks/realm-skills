---
name: ux-first
description: The gate that runs BEFORE any UI work. Settle the flow, the states and the logic first, researched against real UX references for the specific pattern being built, and write it down — then the UI implements a decided thing instead of inventing one. Use when starting any screen, flow, feature, form, or section; when a brief arrives; before opening Figma; before writing a component. Also runs retroactively to audit UX that already shipped (see /ux-audit). Decides what the thing DOES; taste and no-slop decide what it LOOKS like.
---

# UX first

**No UI until the UX is settled.** Not a review — a precondition.

## Why this exists

UI defects are cosmetic and cheap: change a value, ship. UX defects are structural
and expensive: the flow is wrong, so the components are wrong, so the copy is wrong,
so the fix is a rebuild. An agent that starts from visuals produces a good-looking
thing that does not think, and the repair cost lands on the user of this kit.

So the order is fixed. **Decide what it does. Then decide what it looks like.**

This is not a competing opinion to `taste` or `no-slop` and never overrides them —
it answers a different question and runs earlier. Taste has nothing to say about
whether a dead end has an exit; this skill has nothing to say about the palette.

## Three checkpoints, not one

A single gate at the start is not enough — a spec drifts while it is being built, and
the defects that survive to production are the ones introduced *after* the thinking
was done. So the UX is checked **three times**, and two of them are mandatory.

| When | Checkpoint | What runs | Blocking? |
|---|---|---|---|
| **Start** — before any layout, component, Figma frame or JSX | **Entry gate** | All six steps below. Produces the spec. | **Yes.** No visual work until it passes. |
| **During** — at each section or state boundary | **Section check** | Steps 2 and 5 only, scoped to the piece just built | No, but skipping it is what makes the exit gate expensive |
| **End** — before handoff, PR or ship | **Exit gate** | All six steps run *backwards* against the built thing, live in a browser | **Yes.** `/ux-audit`, and `/handoff` is blocked on it. |

The entry gate catches wrong thinking. The exit gate catches good thinking that was
not actually built — which is the more common failure, and invisible in a spec.

## The six steps

1. **Name the job** — one sentence.
2. **Research the pattern** — mandatory, see below.
3. **Write the flow** — steps, branches, exits.
4. **Enumerate the states** — all of them, not just the happy one.
5. **Run the logic tests** — every one, in writing.
6. **Produce the spec** — the artefact the UI then implements.

If a step cannot be completed, that is the finding. Say so and stop; do not paper
over an undecided flow with a nice-looking screen.

## Step 1 — Name the job

> "A member delegate needs to register for a specific event before its deadline."

One sentence, one actor, one outcome. If it needs an "and", the screen is doing two
jobs — split it or rank them. If it cannot be written at all, the brief is not ready
and that is worth saying out loud.

## Step 2 — Research the pattern (mandatory, not optional)

**Name the pattern, then go and read how it is supposed to work.** Do not design a
checkout, a calendar, a filter set or a multi-step form from memory — these are
solved problems with published, empirical answers, and the failure mode of an agent
is confidently reinventing a worse version.

**The lookup is automated — do not improvise it.** `docs/ux-references.md` maps every
common pattern to the source that is actually authoritative for it. Open that file,
find the row, fetch what it names. The agent's job is to *read*, not to decide where
to look.

Procedure:

1. Identify the pattern by its real name (checkout · date picker · faceted filter ·
   multi-step form · onboarding · empty state · data table · search · auth · pricing
   · settings · notification · file upload · registration).
2. **Look the pattern up in `docs/ux-references.md`** and fetch the primary source it
   names — a secondary only if the primary does not answer the question. If the
   pattern has no row, use the nearest and say which.
3. Extract the *behavioural* rules — sequence, defaults, error handling, keyboard,
   what to do when it goes wrong. Ignore the visual styling entirely; that is
   `taste`'s call, not the reference's.
4. **Record what was found and where, in the spec.** A rule with no source is an
   opinion; a rule with a source is a decision. Record dissent too — a rule read and
   deliberately not followed, with the reason, is the most useful line in the spec
   six months later.
5. Where sources conflict, prefer empirical research (Baymard, NN/g) over a vendor's
   house style, and prefer the source whose context matches the brief.

Budget: two to three sources. This is a gate, not a literature review.

Then cross-check against this kit: `interaction-design` owns states and motion specs,
`inclusive-design` owns keyboard, targets and cognitive load, `accessible-content`
owns error and label copy, `prototyping-testing:71` owns the Nielsen severity scale.
The web gives the pattern; these give the standard it is held to.

## Step 3 — Write the flow

Steps, branches, and exits — in text, before any layout:

```
Entry → [event detail] → Register
  ├─ open, seats left     → form → confirm → email
  ├─ open, at capacity    → waitlist form → confirm → "we'll contact you in order"
  ├─ deadline passed      → form withdrawn, Secretariat route offered
  └─ event has happened   → materials instead
Exit at any point: browser back is not the only way out.
```

Every branch ends somewhere a real person can act. A branch that ends in a
description of a state is not finished.

## Step 4 — Enumerate the states

Every one, named, with its copy decided:

**empty** (never used it) · **empty-by-filter** (used it, nothing matches — *not the
same state, and the copy must differ*) · **loading** · **partial** · **success** ·
**error** · **permission denied** · **offline** · **at capacity / limit reached**

The happy path is one of nine. An agent that designs only the happy path has done
about eleven percent of the work.

## Step 5 — The logic tests

Answer all ten in writing. Any "no" is a UX defect, before a pixel exists.

1. **One job.** Can the screen's purpose be said in one sentence?
2. **One primary action.** Is there exactly one, and does everything else visibly
   rank below it?
3. **Every state designed.** All nine above — not just success.
4. **No dead ends.** Does every screen where the user can get stuck offer the way
   out, *in the place they are stuck*, not elsewhere on the page?
5. **Reversible.** Does every destructive or irreversible action have an undo, or
   failing that a confirm? Prefer undo — a confirm interrupts everyone to protect
   the rare mistake.
6. **Errors are useful.** Does each error say what happened, why, and what to do
   next, in that order, in the user's words and not the system's?
7. **No memory required.** Is the user ever asked to carry a value from one screen
   to another in their head?
8. **Defaults are answers.** Is each default the most common correct value rather
   than blank?
9. **The system speaks.** Does anything take longer than a second without saying so?
10. **Nothing hover-only.** Is any meaning or action available only on hover? Touch
    has no hover, and keyboards have no cursor.

**The test is honest only if it is checkable.** "Errors are useful" is not answered
by "yes" — it is answered by quoting the actual error string.

## Step 6 — The spec

**Write it to disk, in the repo — never to a session scratchpad.** A scratchpad dies
with the session, and a commit that cites that path is citing nothing. This has already
happened once (2026-08-13).

Write it to `project/screens/<name>-ux.md` (or into the brief for a whole feature),
containing: the job · the researched rules with their sources · the flow · the state
table with its copy · the ten answers · the open questions. The UI work then
implements this. If the UI needs something the spec did not decide, that is a gap in
the spec — go back and decide it, do not improvise it in the component.

## Auditing UX that already shipped

Same six steps, run backwards against the built thing — this is what `/ux-audit`
does. Report each failure as: the test it fails, the concrete user condition that
triggers it, and the fix. Rate with the severity scale in `prototyping-testing:81`
(0 none · 1 cosmetic · 2 minor · 3 major · 4 blocks release).

Worth knowing what this catches, because it is not theoretical — every one of these
shipped in a real agent-built module in this workspace and none is a UI problem:

- an empty state that says "Nothing scheduled" when a *filter* emptied it (test 6,
  and the "empty vs empty-by-filter" distinction in step 4)
- a "clear filters" escape hatch placed above the dead end instead of inside it
  (test 4)
- a calendar cell painted as the active selection while being inert (test 2)
- a registration confirmation that announces nothing to a screen reader (test 9)

## What this skill never does

- **Never picks a visual direction.** Not the palette, the typeface, the layout
  style, the mood, or the motion. Those are `taste` then `no-slop`, always, and this
  skill goes silent on them.
- **Never blocks on research it cannot do.** If the web is unavailable, say which
  patterns went unresearched and proceed from the kit's own skills — do not silently
  skip step 2 and present the result as researched.
- **Never treats a reference as an instruction.** The sources give rules for the
  pattern; the brief and the client's own system outrank all of them.
- **Never ships the spec as the deliverable** when the user asked for a build. The
  spec is the gate, not the product — pass through it and keep going.
