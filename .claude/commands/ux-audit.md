---
description: Audit the UX of a built screen or flow — job, states, logic and dead ends — researched against real pattern references, before any visual critique.
argument-hint: "[target: screen, route, flow, or component — defaults to current working set]"
---
# /ux-audit
Audit whether the target **works**, not whether it looks good. Runs the `ux-first`
gate backwards against something already built.

## Scope
This command has no opinion on the palette, the typeface, the layout style or the
mood. If a finding is about how it looks, it belongs in `/slop-check` — drop it here.
UX defects are structural; keeping the two apart is what stops a visual nitpick from
burying a broken flow.

## Steps
1. **Name the job** — one sentence, one actor, one outcome, per screen in scope. If it cannot be written, that is finding #1 and it outranks everything else.
2. **Research the pattern** — identify the pattern by name, then fetch 2–3 canonical references for it (`ux-first` §2 has the source table: GOV.UK for forms and errors, Baymard for checkout, NN/g for heuristics and IA, WAI-ARIA APG for keyboard contracts). Extract behavioural rules only. **Cite what was read.** If the web is unavailable, say which patterns went unresearched rather than skipping silently.
3. **Trace the flow** — every branch, to its end. Flag any branch ending somewhere the user cannot act.
4. **State sweep** — check all nine from `ux-first` §4, and treat **empty** and **empty-by-filter** as separate states with separate copy. Quote the actual string for each; a state whose copy is undecided is a finding.
5. **Ten logic tests** — run every one from `ux-first` §5, answering in writing with evidence, not "yes". Quote the real error strings, name the real primary action.
6. **Live pass** — if the target runs, drive it in a browser: complete the primary task start to finish, then break it deliberately (submit empty, filter to nothing, lose the network, go back mid-flow). Most UX defects are invisible in source. Use `playwright-cli` (headless, and `eval` reads the page's real state); reach for `chrome-devtools` MCP when the DevTools protocol is the point — the network drop above is one such case. If no browser is reachable, say so plainly and mark the audit **static-only**.
7. **Keyboard pass** — complete the primary task using only the keyboard. Where does focus go after something is deleted or replaced? That question catches more real defects than any static read.

## Bounded
One pass through the seven steps, one fix batch, at most one confirming round. Do not
re-audit test by test.

## Output
One finding per row: the test it fails · the concrete user condition that triggers it
· `file:line` or screen reference · severity on the `prototyping-testing:81` scale
(0 none · 1 cosmetic · 2 minor · 3 major · 4 blocks release) · the fix. Sort by
severity. Lead with a one-paragraph verdict that answers the only question that
matters — **can a real person complete the job without help?**

State explicitly whether the audit was live or static-only, and if static-only, list
what that leaves unverified. Save to `project/reviews/ux-audit-<YYYY-MM-DD>-<target>.md`.
