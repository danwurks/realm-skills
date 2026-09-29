---
name: ui-design
description: Builds visual UI foundations and their specs: color systems and palettes (tonal scales, semantic tokens, WCAG contrast), typography scales, spacing systems, layout grids, visual hierarchy, responsive design and breakpoints, dark mode adaptation, data visualization and chart selection, and illustration style guides. Use when creating or reviewing any of these, choosing chart types, auditing contrast or hierarchy, or adapting an interface across screen sizes, inputs, and color schemes.
---

# UI design foundations

Nine playbooks for visual foundations. Every deliverable is a spec a developer can implement without follow-up questions — token tables, breakpoint behavior, usage rules, not mood boards.

## Building a color system

For a new product, a rebrand, or replacing ad-hoc hex values with tokens.

1. Brand palette: primary, secondary, accent — each as a full tonal scale (50–950), never single swatches.
2. Neutral palette: one gray ramp covering text, backgrounds, borders, surfaces.
3. Semantic layer: success (green), warning (amber), error (red), info (blue) — each with background, foreground, border, and icon variants.
4. Extended layer: data-viz palette, illustration colors, gradient definitions.
5. Dark mode mapping for every token from day one (see dark mode below).

Contrast floors (WCAG):

| Element | Minimum |
|---|---|
| Body text on background | 4.5:1 AA / 7:1 AAA (SC 1.4.3, 1.4.6) |
| Large text (24px+, or 18.66px+ bold) | 3:1 |
| UI components vs adjacent colors | 3:1 (SC 1.4.11) |

Deliverable: token table — name, value, usage note, approved text pairings, dark equivalent. Include tint/shade ramps per hue, complementary pairs for contrast, analogous sets for harmony, neutral pairings for text on surfaces.

Quality bar: every foreground/background pair actually used in the UI passes its floor; palette survives deuteranopia and protanopia simulation; no meaning carried by hue alone — always paired with icon, label, or pattern.

## Setting the typography scale

Pick a ratio — 1.25 (major third) or 1.333 (perfect fourth) — and derive the ramp:

| Style | Size | Line height | Tracking |
|---|---|---|---|
| Caption | 12px | 1.5 | +0.05em if uppercase |
| Body small | 14px | 1.5 | 0 |
| Body (base) | 16px | 1.5 | 0 |
| Subheading | 20px | 1.5 | 0 |
| H3 | 24px | 1.2 | 0 |
| H2 | 32px | 1.2 | −0.02em |
| H1 | 40px | 1.2 | −0.02em |
| Display | 48–64px | 1.2 | −0.02em |

- Weights: 400 / 500 / 600 / 700. Line height 1.75 for long-form reading.
- Fonts: one primary for UI and body; optional secondary for headings or editorial; mono for code and data.
- Responsive: headings step down on mobile; body never below 16px; line length 45–75 characters.

Deliverable: this ramp plus a usage rule per style. Quality bar: 4–5 sizes cover regular use — needing more means the scale failed; tested with real content (longest live string), not lorem ipsum.

## Defining the spacing system

Base unit 4px or 8px. Scale: 2xs 2 · xs 4 · sm 8 · md 16 · lg 24 · xl 32 · 2xl 48 · 3xl 64.

Four application types: inset (padding — equal, squish, or stretch), stack (vertical), inline (horizontal), grid gap.

Rules: related items sm–md; distinct sections lg–xl; page margins fixed per breakpoint; component-internal spacing lives in the component spec. Density modes: compact = one step down (data-heavy views), comfortable = default, spacious = one step up (reading-focused).

Quality bar: zero off-scale values in shipped CSS; each token documents intent ("section separation"), not just a number; checked at several viewport widths.

## Defining the layout grid

| | Mobile | Tablet | Desktop |
|---|---|---|---|
| Columns | 4 | 8 | 12 |
| Gutters | 16px | 24px | 24–32px |
| Margins | 16px | 24px | 24–48px |

Breakpoints: 375 / 768 / 1024 / 1440px — same tiers as responsive below. Grid types: column (default), modular (columns + rows), baseline (4px or 8px vertical rhythm — match the spacing base unit), compound (overlaid grids for complex pages). Container behavior: fluid stretch, fixed max-width centered, adaptive layout per breakpoint, column dropping downward. Patterns: full-bleed, contained, asymmetric sidebar + main, auto-fill card grids.

Deliverable: per-breakpoint spec (columns, gutter, margin, max-width) developers can lift into CSS. Quality bar: everything aligns to a column or is a documented intentional break; checked at every breakpoint, not just the extremes.

## Making a design responsive

Mobile-first and content-first: stay fluid within a tier, adapt layout at tier boundaries, and let content — not devices — decide where those boundaries fall before snapping to standard tiers:

| Tier | Range | Devices |
|---|---|---|
| Small | 375–639px | phones |
| Medium | 640–1023px | tablets |
| Large | 1024–1439px | laptops |
| XL | 1440px+ | desktops |

Layout patterns: column drop, reflow (stack horizontal groups), off-canvas (secondary content behind a toggle), priority+ (show the most important items, overflow the rest).

Input adaptation: touch — 44px minimum targets, gesture support; mouse — hover states, precise targets; keyboard — visible focus, logical tab order; voice — clear labels, logical structure.

Media: fluid type between breakpoints; srcset for pixel density; art-direction crops per breakpoint.

Deliverable: per-tier spec of layout, input, and media behavior. Quality bar: verified on real devices, both orientations, on a throttled connection, with an accessibility pass at each tier — browser-window resizing alone does not count.

## Establishing visual hierarchy

For any screen where users must know what to look at first.

| Lever | Rule |
|---|---|
| Size | ≥1.5× difference between adjacent levels |
| Weight | bold text and filled icons outrank light variants |
| Color/contrast | highest contrast goes to the primary CTA; color also flags status and emphasis |
| Spacing | more surrounding whitespace = more perceived importance |
| Position | top-left first (LTR); F- and Z-pattern scanning; above the fold |
| Density | isolated elements pop; groups scan as one unit |

Cap at four levels per view: primary (page title, the one CTA) → secondary (section headings, key content) → tertiary (supporting text, metadata) → quaternary (fine print, timestamps).

Reference stacks: hero = large type + image + single CTA; card = image > title > description > action; form = label > input > helper > error; nav = current > available > disabled.

Deliverable: annotated mock numbering each element 1–4. Quality bar: squint test — blur the screen and the reading order still holds; exactly one primary action per view.

## Designing dark mode

A surface redesign, not an inversion. Reduce overall luminance; elevation comes from lighter surfaces, not shadows:

| Level | Use |
|---|---|
| Background #121212 | page |
| Surface 1 | elevated cards |
| Surface 2 | modals, dropdowns |
| Surface 3 (lightest) | tooltips, menus |

Color adaptation: desaturate primaries 10–20%; re-check error/warning contrast on dark; body text off-white #E0E0E0, never pure #FFFFFF; borders as low-opacity white. Media: dim photos slightly; ship dark-variant illustrations and light-on-dark logos; avoid large bright areas.

Mechanics: respect prefers-color-scheme and provide a manual toggle; route the entire switch through semantic tokens; the 4.5:1 body-text floor still applies.

Deliverable: light→dark mapping for every token. Quality bar: every component reviewed in dark mode, in an actually dark room; the mode switch transitions without flashing; screen readers announce the mode change.

## Designing a data visualization

Choose the chart from the question, then take the simplest form that answers it:

| Question | Chart |
|---|---|
| Compare categories | bar; grouped bar (multi-series); bullet (target vs actual) |
| Trend over time | line; area (volume); sparkline (inline) |
| Part of whole | pie/donut (few categories); stacked bar (many); treemap (hierarchy) |
| Distribution | histogram; box plot; scatter |
| Relationship | scatter; bubble; heat map |

Rules: maximize data-ink — strip decorative gridlines and borders; axes clearly labeled; bar chart y-axis starts at zero; label directly on marks instead of legends; annotate the key insight; show context (benchmark, target, trend line). Color encoding stays consistent across views: sequential (light→dark) for ordered data, diverging (two hues around a midpoint), categorical (distinct hues) — colorblind-safe, never red-green as the only distinction, reinforced with shapes, patterns, or labels.

Small screens: fewer data points, larger labels, a table fallback on mobile, touch-sized tooltips. Every chart gets a text alternative; interactive charts are keyboard-navigable; data marks meet the 3:1 non-text contrast floor.

Deliverable: chart type + encodings + annotations spec. Quality bar: designed against real, messy data — not idealized samples — with detail on demand rather than everything at once.

## Defining an illustration style

For products adding illustration (empty states, onboarding, marketing) that must stay consistent across contributors.

Decide a position on five axes: geometric↔organic; flat↔dimensional (2D, 2.5D isometric, 3D); detailed↔minimal; abstract↔representational; line style (stroke weight, corner treatment, endpoints).

Then lock:
- Color: fixed subset of the product palette (primary, secondary, accent for illustration), gradient and shadow rules, dark mode variants.
- Characters, if any: proportions, face-detail level, diversity and representation guidelines, a reusable pose and expression library.
- Usage per type — spot (small, inline UI support), hero (large, storytelling), empty states, onboarding, error states (soften the message) — with size constraints, grid alignment, and animation rules per context, plus explicit cases where illustration is not used.

Deliverable: style guide with the axis decisions, color rules, and usage table. Quality bar: a reusable element library exists; the creation process is documented for new contributors; artwork tested at actual display size; nothing is communicated only through the illustration.
