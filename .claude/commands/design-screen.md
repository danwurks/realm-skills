---
description: Design one screen end to end — UX gate first, then layout, type, color, responsive, dark mode, interaction states, inclusive pass, and both closing gates.
argument-hint: "[screen description, e.g., 'user profile settings page']"
---
# /design-screen
Design a complete screen end to end. **UX is settled before anything visual is
proposed**, and checked again once it is built.

## Steps

### Entry gate — blocking
0. **UX gate** — Run `ux-first` in full: name the job, look the pattern up in `docs/ux-references.md` and fetch its primary source, write the flow, enumerate all nine states, answer the ten logic tests in writing, produce the spec at `project/screens/<screen-name>-ux.md`. **Do not proceed to step 1 until every test is answered.** A "no" on any test is a defect to fix here, where it costs a sentence, rather than after the UI is built, where it costs a rebuild.

### Build
1. **Coherence check-in** — If this screen joins an existing page or product, run `coherence` and inventory what is already in use *before* designing anything. The existing work is the specification; this screen conforms to it. If it seems to want to depart, name the axis and the cost and **ask the user** — never break the vocabulary unilaterally.
2. **Grid** — Define the layout grid using `ui-design` skill, serving the flow decided in step 0.
3. **Hierarchy** — Establish visual priority using `ui-design` skill. The primary action named in the UX spec is the one that must win.
4. **Type, color, spacing** — Apply type scale, color system, and spacing scale using `ui-design` skill.
5. **Responsive + dark mode** — Define breakpoint behavior and dark mode adaptation using `ui-design` skill.
6. **Interaction states** — Spec every state the UX gate enumerated, using `interaction-design` skill. The state list comes from the spec; do not shorten it to hover/focus/active.
7. **Image fit** — If the screen carries any image, run `image-fit`: index the supplied pool first if it hasn't been indexed, open each candidate, and match it to the specific heading it sits with. One line of justification per placement. If nothing in the pool fits a slot, say what's missing and ask — do not substitute the nearest-looking photo.
8. **Inclusive pass** — Check keyboard, touch targets, contrast, motion, and content using `inclusive-design` skill.

### Exit gates — blocking
9. **UX exit gate** — Run `/ux-audit` against what was actually built. The entry gate proves the thinking was right; this proves the thinking got built. If the screen runs, drive it in a browser (`playwright-cli`): complete the primary task, then break it deliberately.
10. **Slop gate** — Run `no-slop` over the result; fix anything generic before shipping.

## Order matters
Step 0 owns *what it does* and has no opinion on how it looks. Steps 1–8 own how it
looks and may not renegotiate the flow — if the UI needs something the spec did not
decide, go back to step 0 and decide it rather than improvising in the component.

## Output
Two artefacts. `project/screens/<screen-name>-ux.md` — the UX spec from step 0, with
its researched sources cited. `project/screens/<screen-name>.md` — grid, hierarchy,
typography, color, spacing, responsive, dark mode, interaction states, inclusive
notes, and both gate results. Use `project/design-system/` tokens only. Update
`project/STATE.md`.
