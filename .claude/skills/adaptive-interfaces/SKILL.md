---
name: adaptive-interfaces
description: Playbooks for interfaces that adapt to users — colour independence and colour blindness (status, charts, form errors), flexible typography and text scaling (rem, line height, 200%), information density (compact/comfortable/spacious), responsive accessibility (200% zoom reflow, orientation, touch targets), and user preference respect (reduced motion, contrast, dark mode, forced colors, font size). Use when designing, auditing, or writing an adaptive behaviour spec.
---

# Adaptive interfaces

Design, audit, and specify interfaces that flex to the user. One rule throughout: build the accessible version first — motion, transparency, colour, and compactness are enhancements layered on top, so honouring a preference removes an enhancement, never degrades the product.

## Responding to system preferences

Use when implementing dark mode, motion, contrast, or anything that changes rendering. The OS already knows what the user needs — detect and respond; never make users re-configure accessibility in the app. App settings layer on top of system preferences, never replace them.

| Preference | Detect with | Required response |
|---|---|---|
| Reduced motion | `@media (prefers-reduced-motion: reduce)` | Disable decorative animation, parallax, scroll-triggered effects, auto-advance. Slide/fade become instant state changes. Keep essential motion (loading spinners), simplified. Never override. |
| More contrast | `@media (prefers-contrast: more)` | Push contrast beyond WCAG minimums. Solid borders replace subtle shadows and gradients. Bolder focus indicators. Remove transparency and blur. Thicker borders on interactive elements. |
| Colour scheme | `@media (prefers-color-scheme: dark)` | Genuine dark mode, not inverted colours. Test images, charts, icons in both. A dark grey, never pure #000 — dark mode also serves light sensitivity, not just taste. `ui-design` owns the palette values; take the hex from there, not from here. |
| Forced colours | `@media (forced-colors: active)` | Don't fight the system override. Borders and outlines must define interactive elements (the system strips your colours) — add transparent borders that appear in this mode. Never indicate state by background colour alone. |
| Reduced transparency | `@media (prefers-reduced-transparency: reduce)` | Solid backgrounds, no backdrop blur or frosted glass, fully opaque overlays. |

Test each preference alone, then combined (reduced motion + more contrast + dark mode). Automated checks prove the media queries exist; only manual testing proves they work.

## Removing colour-only meaning

Use for status indicators, charts, form validation, alerts, badges, maps, links — anywhere colour encodes meaning. 8% of men and 0.5% of women have colour vision deficiency: roughly 1 in 12 male users. Colour may reinforce meaning; it must never be the only carrier. Every colour meaning gets a second encoding: icon, text label, pattern/texture, shape, or position.

| Element | Fails | Passes |
|---|---|---|
| Status dot | green = online, red = offline | green dot + tick + "Online"; grey dot + cross + "Offline" |
| Form error | red border only | red border + error icon + error message — the message does the real work, colour is reinforcement |
| Chart | 5 coloured lines, colour-swatch legend | solid/dashed/dotted line styles + direct labels; bar patterns (stripes, dots, solid) alongside colour |
| Link | colour differs from body text | colour + underline — the underline is the accessible indicator |
| Alert badge | red/yellow/green | colour + "Urgent"/"Warning"/"OK" label + warning/check/cross icon |
| Choropleth map | coloured regions, no labels | colour + pattern + value on each region; hover/focus values plus a data table alternative |

Palette rules: pick colours distinguishable under all CVD types, not just red-green — verify with a colour-blindness simulator. Blue/orange is the safest pair. Never use red/green as the only distinction between two states. Adjacent chart colours need contrast against each other.

Quality bar — the greyscale test: convert the UI to greyscale. Can you still operate it, tell statuses apart, read the chart, find the error fields? Any "no" means colour is carrying meaning alone.

## Building a flexible type system

Use when defining a type scale, setting sizes and line heights, or reviewing readability.

Units and floors:
- rem for font size, em for spacing that should scale with text. Never px for font size — it overrides user preferences. Keep the browser's default root (usually 16px); don't override it.
- Minimums: body 1rem; captions, labels, UI text 0.875rem — essential text readable without zooming.
- Line height: 1.5 minimum for body (WCAG requirement), 1.2–1.3 for headings. Unitless values (1.5, not 24px) so it scales with size.
- Paragraph spacing at least 1.5× font size. Never compress letter or word spacing below browser defaults. Layout must survive user spacing overrides — WCAG 2.1 AA, 1.4.12.

Scale: one relative ratio (1.25, 1.333, or 1.5), 4–6 perceptibly different sizes. Example: 0.875 / 1 / 1.25 / 1.5 / 2 / 2.5rem.

Override-safe CSS: min-height, never fixed height, on anything containing text; containers grow when text grows. Break test: 200% text size, 200% zoom, and extra letter/word spacing — if layout breaks at any, the CSS needs fixing.

Font selection: clear distinction between Il1, 0Oo, and rn/m; consistent x-height; adequate character spacing at defaults; a font-family stack that degrades gracefully; never block the user's own font override. Sans-serif tends to read better on screens — test with your audience, not a rule.

Dark mode type: reduce weight slightly (light-on-dark reads heavier than dark-on-light); 4.5:1 contrast minimum in both modes; off-white on dark grey, never #fff on #000 — the extreme contrast causes halation.

## Keeping layouts accessible across zoom, viewport, and orientation

Use when designing responsive layouts or reviewing zoom behaviour. A layout that works at 1440px but breaks at 200% zoom fails exactly the users who need zoom most.

Hard requirements:
- Reflow: at 200% zoom, content reflows to a single column with no horizontal scrolling — WCAG 2.1 AA, 1.4.10. Only data tables, maps, and diagrams may scroll horizontally, and only if nothing is lost.
- Text scaled to 200%: no clipping, truncation, or overlap. Relative units (rem, em, %) throughout; line height and spacing scale proportionally.
- Orientation: support both. Never lock unless the function demands it — a piano app might, a form never does. Some users mount devices in one orientation; locking blocks them entirely.

Patterns:
- Fluid over snapping: flexible grids; max-width on content for 45–75 characters per line; whitespace compresses before content reflows; no fixed-width elements forcing horizontal scroll.
- Content priority per breakpoint: core content visible on small screens, the rest reachable. No critical "desktop only" functionality; hamburger nav is fine but every destination stays accessible.
- Pointer adaptation: **44×44 CSS px minimum on touch** (48×48 recommended), 24×24 minimum for pointer at large viewports. Detect with `@media (pointer: coarse)`. Widen spacing between targets on touch. `inclusive-design` owns the full sizing table - defer to it rather than restating numbers here.
- Zoom-safe chrome: a sticky header eating 30% of the viewport at 200% zoom is a barrier — test every fixed element at 200%. Tooltips and popovers stay reachable at zoom; modals scroll when content exceeds the viewport.

Testing protocol: (1) 100%, 150%, 200% zoom at 1280px; (2) 320px viewport; (3) both orientations; (4) largest system font size. At each point: no horizontal scroll, no clipped text, no overlaps, all interactions functional.

## Designing density controls

Use for dashboards, data tables, feeds, inboxes, settings panels — any variable-content surface. The right density for a power user scanning 200 rows is wrong for someone who needs space to process each item.

Three levels: compact (power users, data-heavy tasks, large screens — overwhelms cognitive-disability users, hard to tap on touch, hard to scan for low vision), comfortable (the default — optimise this first), spacious (cognitive disabilities, low vision, touch, new users, stressful contexts — costs more scrolling).

Controls: 2–3 options; text labels, not bare icon toggles; instant apply, no reload; persist across sessions; placed next to the content they affect.

| May change with density | Must never change |
|---|---|
| Vertical spacing, item padding | Content meaning — nothing lost at any density |
| Metadata shown per item, preview length | WCAG compliance at every level |
| Thumbnail size, grid column count | Touch targets: 44×44 CSS px minimum (see `inclusive-design`) |
| Font size and line height, within floors (0.875rem, 1.5 body) | Heading structure and tab order |

Per surface: lists/feeds → row height + visible metadata; tables → row padding + visible columns; dashboards → card size + spacing; inboxes → preview length + row height; calendars → event detail.

Adaptive defaults, all user-overridable: 1440px+ comfortable or compact; 768–1439px comfortable; below 768px comfortable or spacious; touch devices never default to compact; enlarged system text → spacious; prefers-contrast → slightly more spacing; new users → comfortable.

## Writing the adaptive behaviour spec

Use at the start of a new interface — adaptability specified up front, not retrofitted. Run the five playbooks above in order; record every decision. Deliverable, five parts:

1. Preference response table — each of the five system preferences and exactly what changes.
2. Responsive behaviour map — what reflows at each breakpoint; 200% zoom behaviour; orientation support; touch target size per breakpoint.
3. Typography specification — scale, units, line height and spacing values, 200% scaling behaviour, dark mode adjustments.
4. Colour independence audit — every colour-encoded element with its second encoding; greyscale test result.
5. View and density options — density levels, simplified vs full view content, how users toggle, defaults per viewport and context.

Quality bar: a developer can implement every adaptation without asking a question, and every line is testable — "reflows per 1.4.10 at 200% zoom / 1280px", "chart legible in greyscale".
