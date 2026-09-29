---
name: design-systems
description: Builds and maintains design systems end to end. Covers defining design tokens (color, spacing, typography, elevation, motion), writing component specs, establishing naming conventions, documenting pattern library entries, architecting theming systems (dark mode, multi-brand, high contrast, density), speccing icon systems, structuring design system documentation, and running design system accessibility audits against WCAG 2.2 with severity-rated findings and remediation steps.
---

# Design systems

Playbooks for the eight recurring design system jobs: tokens, naming, component specs, pattern entries, theming, icons, documentation, accessibility audits. Common thread: define values once at the token layer, name things predictably, document with a fixed template, audit against WCAG 2.2. Adapt every deliverable to the project's existing stack; WCAG AA is the floor.

## Defining design tokens

When: founding a system, extracting one from an existing UI, or adding a category (motion, elevation).

Three tiers, built in this order. Components consume alias tokens only — never raw values, never globals directly.

| Tier | Example | Rule |
|---|---|---|
| Global | `blue-500: #3B82F6` | Raw values; no usage semantics |
| Alias (semantic) | `color-action-primary` | References a global; encodes purpose; themes override at this layer |
| Component | `button-color-primary` | References an alias; scoped to one component |

Categories and what each must define:

- Color — global palette; alias roles for surface, text, border; component overrides
- Spacing — base unit (4px or 8px), scale xs through 3xl, contextual variants: inset, stack, inline
- Typography — font families, size scale, weights, line heights
- Elevation — shadow levels plus a z-index scale
- Border — radius scale, width scale, style options
- Motion — duration scale, easing functions

Deliverable: one table per category — name, value, tier, usage context ("use for X, not Y"). Quality bar: every alias name is abstract enough to survive a theme swap; tokens versioned with each system release.

## Establishing naming conventions

When: before the first token or component ships, or when an audit shows drift.

Five tests for any name: predictable (guessable without lookup), consistent, scalable, scannable, unambiguous.

| Asset | Pattern | Example |
|---|---|---|
| Tokens | `{category}-{property}-{concept}-{variant}-{state}` | `color-background-action-primary-hover` |
| Components (design) | `[category]/[name]/[variant]/[state]` | `forms/button/primary/disabled` |
| Files | `[type]-[name]-[variant].[ext]` | `logo-acme-mono.svg` |
| Icons | `icon-[category]-[name]-[variant]` | `icon-action-delete-filled` |
| Illustrations | `illust-[scene]-[variant]` | `illust-empty-inbox-dark` |
| Code | kebab-case CSS, PascalCase React components, camelCase props | `.btn-primary`, `Button`, `isDisabled` |
| Figma pages | numbered + descriptive; PascalCase components | `03 Components` |

Reject in review: abbreviations only the author understands; mixed separators; names describing appearance instead of purpose (`blue-button` breaks the moment theming lands — `button-primary` doesn't).

Deliverable: a single reference page with pattern plus examples per asset type. Automate enforcement with a name linter; use prefixes for free sorting and grouping.

## Writing a component spec

When: any new component, or retrofitting specs onto an undocumented library.

Eight sections, in order:

1. Overview — name, one-line description, when to use / when not to use
2. Anatomy — labeled visual breakdown; mark each element required or optional
3. Variants — size (sm/md/lg), style (primary/secondary/ghost), layout
4. Props/API — table: name, type, default, required?, description
5. States — default, hover, focus, active, disabled, loading, error; visual and behavioral definition for each
6. Behavior — interactions, animation, responsive behavior, edge cases (text overflow, empty data, slow network)
7. Accessibility — ARIA role, full keyboard map (Tab/Enter/Esc/arrows), screen reader announcements, focus management
8. Usage — do/don't pairs, content rules, related components

Quality bar: an example for every variant and state; behavior specified, not just appearance ("focus ring on `:focus-visible`, 2px offset" — not "has focus state"); covers mouse, keyboard, and touch; a developer can implement without asking follow-up questions. When published as a docs page, add status, tokens used, and changelog.

## Writing a pattern library entry

When: a UX solution recurs across two or more products or flows. Usual categories: navigation, input, display, feedback, onboarding.

Structure — problem first, solution second:

- Problem statement — the user need and the contexts where it appears
- Solution — the pattern, key principles, visual and interaction description
- Anatomy — constituent components, layout, required vs optional elements
- Variants — context-specific implementations, responsive adaptations
- Behavior — user flow, state changes, error handling
- Examples — at least one good implementation and one anti-pattern, each with the why
- Accessibility — assistive tech behavior, inclusive considerations
- Related patterns — similar to / commonly combined with / builds upon

Quality bar: entries link into a graph (related-pattern links are two-way); anti-patterns come from real shipped work, not hypotheticals; entries get revised when research contradicts them.

## Architecting a theming system

When: dark mode, multi-brand or white-label, high contrast, or density variants are required.

A theme is a set of token overrides at the semantic (alias) layer. Globals and component tokens stay stable across themes. If a theme needs widespread component-token overrides, the alias layer is too thin — fix that first.

Theme axes:

- Color modes: light, dark, high contrast, dimmed
- Brand: primary, sub-brands, white-label, seasonal
- Density: comfortable, compact, spacious

Dark mode is a redesign, not an inversion:

- Reduce brightness deliberately; pure white on pure black causes halation
- Elevation = lighter surface color, not larger shadows
- Desaturate accent colors against dark backgrounds
- Re-test text contrast per surface level
- Provide dark variants of images and illustrations

Implementation: CSS custom properties, one token file per theme, Figma variable modes mirroring code, runtime switching. Respect `prefers-color-scheme` and `prefers-contrast` by default.

Deliverable: token mapping table (semantic token → value per theme) plus an explicit list of fixed, non-themeable tokens. Quality bar: every component renders correctly in every theme with zero component-level changes.

## Speccing an icon system

When: founding an icon set or reconciling inconsistent icons.

Foundations:

- Grid: 24x24px base with keylines; fixed stroke width; consistent corner radius
- Size ramp: XS 12–16px, S 20px, M 24px, L 32px, XL 48px+
- Style: stroke, filled, duotone — document when each applies (e.g. filled = selected/active state)

Naming: `icon-[category]-[name]-[variant]`. Categories: action, navigation, content, communication, social, status, file, device.

Delivery: SVG as source of truth → sprite sheet, component wrappers, Figma library.

Accessibility, non-negotiable:

- Every icon has an accessible label or `aria-hidden="true"` — never neither
- Icon-only critical actions get paired visible text or a tooltip
- 3:1 contrast minimum against background (WCAG 1.4.11)
- 44x44px minimum touch target

Maintenance: contribution workflow for new icons, periodic audit to remove unused ones, versioned with the system, rendering tested at every supported size.

## Structuring system documentation

When: standardizing docs across components, patterns, and foundations.

Three templates:

- Component page — the eight-section spec above, plus status, tokens used, changelog
- Pattern page — the pattern entry structure above
- Foundation page (color, type, spacing, motion) — purpose, principles, rules/specs, examples, exceptions, resources

Standards: consistent heading hierarchy; table of contents on long pages; tables for anything comparative; code snippet beside every visual; status indicator (draft/beta/stable/deprecated) on every page.

Quality bar: written in second person; most-needed information first on the page; freshness audited quarterly; props and token tables generated from code where possible; validated by watching a new team member use the docs unaided.

## Running an accessibility audit

When: pre-release gate, periodic system health check, or after user complaints.

Audit against WCAG 2.2 across POUR:

- Perceivable — text alternatives, captions, adaptable structure, contrast (1.4.3: 4.5:1 text, 3:1 large text; 1.4.11: 3:1 UI components)
- Operable — full keyboard access (2.1.1) with no traps, adjustable time limits, no seizure-inducing flashing (2.3.1), navigation aids, target size (2.5.8: 24x24px minimum)
- Understandable — readable language, predictable behavior, input assistance and error identification
- Robust — semantic markup, valid ARIA, assistive tech compatibility

Method: check static and interactive states (hover, focus, open, error), across devices and browsers, with real assistive tech (VoiceOver or NVDA minimum) — automated scanners alone don't count. Include users with disabilities when possible.

Report each issue as: description | location | WCAG criterion | severity | user impact | remediation steps | code example.

Severity scale: 1 Critical (blocks access entirely) · 2 Major (significant difficulty) · 3 Minor (workaround exists) · 4 Enhancement (beyond compliance). Fix order = severity × user impact, not page order.
