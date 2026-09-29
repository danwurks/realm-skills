---
name: craft-floor
description: The mechanical quality floor for built UI — measurable thresholds (contrast, measure, tracking, radius, elevation), browser-surface theming, current-generation AI fingerprints, and the runtime defects only a rendered page reveals. Use when verifying or reviewing built UI, running /slop-check, or before shipping a screen. Checks the built result, not the intention. This skill NEVER picks a visual direction, palette, or style — no-slop and taste own that and always win.
---

<!-- Adapted from pbakaus/impeccable (Apache-2.0) — craft floor and anti-pattern
     detector rule set. Direction-setting and aesthetic-opinion material was
     deliberately excluded. See CREDITS.md. -->

# Craft floor

**This skill holds mechanics. It never picks the direction.**

## Precedence — read before applying anything below

1. **`taste` (`taste/TASTE.md` + `taste/library/`) is the authority on what the work should look like.**
2. **`no-slop` is the authority on what counts as generic.**
3. **This skill is subordinate to both.** It checks whether a decision was *executed* well — never whether it was the right decision.

If anything here conflicts with `no-slop`, the taste library, or the project brief,
**they win and this skill goes quiet.** Do not argue the conflict, do not raise it as
a finding, do not "balance" the two. A user whose taste profile endorses something
listed below has made a decision; that ends it.

Never cite this skill to propose a palette, a typeface, a layout style, a mood, or a
direction. If asked "what should this look like", hand off to `taste` + `no-slop` and
say nothing further.

Do not announce this checklist while building. Apply it, then report only what failed.

---

## 1. Measurable floor

`no-slop` says "a real type scale." This says which numbers. Read computed values from
the rendered page, not the source — a token can be right and the output still wrong.

| Check | Threshold |
|---|---|
| Contrast — body + **placeholder** text | ≥ 4.5:1 |
| Contrast — large text | ≥ 3:1 |
| Body measure (line length) | 65–75ch optimum; flag below 45ch or above 85ch |
| Display size ceiling | 6rem |
| Letter tracking floor | −0.04em (−0.02 to −0.03em usually reads better) |
| Card radius | 12–16px; pills reserved for small controls |
| Heading rhythm | more space above a heading than below it |

**Elevation is declared once — border *or* shadow, not both.** A 1px border sitting
under a wide soft shadow is the ghost card, and it is the most reliable tell that a
component was assembled rather than designed.

**Shadows carry an offset and a blur.** A zero-offset colored halo is decoration, not
depth.

**Secondary text on a colored surface is tinted from that hue or the foreground —
never gray.** Gray-on-color is the fastest way to fail contrast without noticing.

## 2. Browser surfaces

The parts you did not draw still carry the design, and models skip these more
reliably than anything else on this page. Each one ships with a browser default that
belongs to no design system. Theme them from the project's own palette:

- Text selection (`::selection`)
- The text caret (`caret-color`)
- Scrollbars, where the project customises them
- Focus rings — visible, themed, and never removed
- Link underline offset and thickness
- Tabular numerals (`font-variant-numeric: tabular-nums`) in any table, price, or metric

This is the cheapest available signal that a page was *built* rather than assembled.
It costs a handful of CSS declarations.

## 3. Current-generation fingerprints

`no-slop` items 1–12 catch the previous generation of machine defaults — purple
gradients, glassmorphism, three-icon-card rows. These are additional, and they are
what current models reach for. **They flag machine defaults, not bad taste:** if the
taste library or the brief endorses one, it is a decision and this list is silent.

- **Ghost card** — 1px border under a wide soft shadow (see elevation, above).
- **Grid-overlay backgrounds** — two-axis grid or dot texture with no canvas, map, blueprint, or measuring surface in the concept underneath it.
- **Eyebrow / kicker chip above a heading** — a small pill or label sitting above the H1. The heading carries its own weight.
- **Numbered section labels** — 01 / 02 / 03 where the sequence carries no information the reader needs.
- **Nested cards** — a card inside a card. Pick one container.
- **Coloured `border-left` / `border-right` above 1px** on cards, list items, callouts, or alerts.
- **Hard offset shadows** (`box-shadow: 4px 4px 0`) where the project has not deliberately adopted zero-blur block shadows as its declared elevation system.
- **Repeating-stripe gradients** as a background texture with nothing in the concept to justify them.
- **Justified body text**, **all-caps body text**, **tiny text**, and **undersized UI text**.
- **Sparklines, progress rings, and soft-shadowed rounded rectangles** standing in for real content.

## 4. Runtime defects — only visible in a rendered page

These cannot be found by reading source. They need the page open in a browser —
`playwright-cli` first, `chrome-devtools` MCP where the DevTools protocol is what is
actually wanted. Run this pass on any built screen before shipping.

- **Content invisible at rest** *(error — ship blocker)*. A large share of page text sits at `opacity: 0` or `visibility: hidden` after every reveal handler has had its chance to run. The content shipped but never becomes visible. Make content visible by default and let JavaScript enhance its entrance rather than gate its existence.
- **Text overflow and occlusion** — real copy escaping or hidden behind its container at some breakpoint.
- **Clipped overflow containers** — content cut off by a parent's `overflow: hidden`.
- **First-viewport column overflow** — the above-the-fold layout breaking before anything else renders.
- **Broken images** — any request that 404s.
- **Console errors** — any uncaught script error on load.

Run real copy at every breakpoint and fix what overflows. A layout that only works
with the placeholder string is not finished.

**If the thing built produces a FILE, the file is the artefact — inspect it, not the
app.** A recorder, an exporter, a generator or a build step can present a flawless UI
while writing something broken, and the UI is where everyone looks. Open the output and
measure it:

- **Dimensions and framing** — is the content the whole frame, or is a third of it
  padding nobody asked for? Pull a frame and find the real content bounds.
- **Container correctness** — for video, `ffprobe` the codec, size and rate, and check an
  mp4 has `moov` before `mdat` or a browser will not paint until the file has fully
  downloaded.
- **Weight against purpose** — a file destined for a web page has a budget. State it in
  MB, not "looks fine".
- **The feature you cannot see in the UI** — an overlay, a watermark, a cursor, a
  timestamp. If a control claims to add something, find it in the output or call it
  unverified.

A defect here survives every review that only looked at the screen.

## 5. Bounded verification

Open-ended self-QA burns the whole budget on the last 5%. Verification is a bounded
number of passes, not a loop:

1. **Build fully.** Do not inspect mid-build.
2. **Inspect once**, batched — desktop and mobile in the same round, sharing one render.
3. **Fix everything that round surfaced in one batch.**
4. **Confirm with at most one more round.**
5. **Stop.**

The ceiling covers the whole cycle: screenshots, defect scans, micro-edits, and
rebuilds all count against the same budget.

## Reporting

Report only failures, as rows: `check | where (file:line or screen) | measured value | threshold | fix`.

State the measured number — "4.1:1 against a 4.5:1 floor" is actionable; "contrast
looks low" is not. If a finding is a direction call rather than a mechanical one, it
does not belong to this skill: drop it, or route it to `no-slop`.
