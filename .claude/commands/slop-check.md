---
description: Run the no-slop review gate over the current design, code, or copy — with craft-floor, WIG and Emil passes where relevant.
argument-hint: "[target: files, screen, or copy to check — defaults to current working set]"
---
# /slop-check
Review the target (default: the design/code/copy currently in play) for AI slop.

## Order matters
`no-slop` and `taste` run first and own the verdict on direction. `craft-floor` runs
after and only reports mechanics. If the two disagree, `no-slop` and `taste` win and
the craft-floor finding is dropped — never surfaced as a competing opinion.

## Steps
1. **Slop gate** — Run `no-slop` skill over the target: generic layouts, filler copy, default-y styling, hedge words. Consult `taste/TASTE.md` for what the user actually responds to; if it's empty, say so rather than inferring a direction.
2. **Coherence** — Run `coherence` across the whole page, not the section in hand: inventory radius, elevation, eyebrow treatment, type steps, section rhythm, card idiom, CTA vocabulary, accent carriers, motion character and image treatment. Any value appearing exactly once is a suspect — report it. Flag any section that departs from the vocabulary **without the user having authorised it**; an unauthorised break is a defect, not flair.
3. **Image fit** — If any image is in scope, run `image-fit`: open each one, check it against the heading and topic it sits with, and flag arbitrary placements, silent reuse across unrelated topics, and alt text that contradicts the placement. Filler imagery scores as slop.
4. **Craft floor** — Run `craft-floor` over built UI only: measurable thresholds (contrast, measure, tracking, radius, elevation), browser surfaces, current-generation fingerprints. Report measured values, not impressions. Skip entirely for copy-only or direction-only targets.
5. **Live pass** — If the target is a running page, open it in a browser (`playwright-cli`) and check the runtime-only defects from `craft-floor` §4: content invisible at rest, text overflow/occlusion, clipped containers, broken images, console errors. Test at desktop and mobile in one batched round with real copy. If no browser is reachable, say so and skip — do not guess at rendered output.
6. **Code pass** — If code (TSX/JSX/HTML/CSS) is in scope, audit it using `vercel-web-design-guidelines` skill.
7. **Motion pass** — If animation or motion is in scope, review it using `emil-design-eng` skill (Before | After | Why table).
8. **Verdict** — Consolidate all findings into a single pass/fail table.

## Bounded
One batched inspection round, one fix batch, at most one confirming round, then stop.
Do not re-audit rule by rule or loop on polish.

## Output
Pass/fail table: one row per finding — check, verdict, `file:line` or screen reference, measured value where there is one, fix. Mark each row's source (`no-slop` / `craft-floor` / `wig` / `emil`) so direction findings stay distinguishable from mechanical ones. End with overall PASS or FAIL. If run on project work, save the report to `project/reviews/slop-check-<YYYY-MM-DD>-<target>.md`.
