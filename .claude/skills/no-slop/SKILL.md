---
name: no-slop
description: Anti-AI-slop guardrails for design, copy, and code. Apply while generating any UI, screen, Figma design, product copy, or frontend code — and as the review gate behind /slop-check. Bans the AI-default look (purple gradient heroes, glassmorphism, three-feature-card rows, Inter for everything, untouched shadcn defaults), hype vocabulary (unlock, seamless, elevate, delightful), and boilerplate code (dead abstractions, className soup, useEffect-for-everything). Ends with the pre-ship slop check.
---

# No slop

Slop is the recognizable output of a model regressing to the mean of its training data — millions of SaaS landing pages, Dribbble shots, and Tailwind templates averaged into one statistically safe, characterless result. It is not ugly. It is worse: it is interchangeable. If a design, a sentence, or a component could belong to any product, it belongs to no product.

Treat a slop pattern the same way you would treat a failing test: a defect that blocks ship. These rules apply to all client-facing work — UI, Figma designs, product copy, docs, and frontend code. When a client's own brand voice or codebase convention conflicts with a rule here, the client wins. Otherwise these are not suggestions.

## Visual slop — banned patterns

Never ship these without an explicit, project-specific reason written down. "It looks clean" is not a reason.

1. **Purple-to-blue (or indigo-to-violet) gradient heroes.** The single strongest AI fingerprint; it signals "no one made a color decision." Instead: derive the palette from the brand, the content domain, or a physical reference (paper, ink, signage, material), and commit to one dominant hue.
2. **Glassmorphism cards by default.** Blur-and-transparency is decoration borrowed from macOS, not a decision; it also wrecks contrast. Instead: flat fills, hairline borders, or real elevation with one consistent shadow style — chosen once, system-wide.
3. **Uniform grids of 12px-radius cards.** Rounding everything identically flattens hierarchy and screams template. Instead: vary containment — some content sits directly on the page, some in cards; pick a radius tied to the type scale and use fewer cards.
4. **Centered-everything layouts.** Center-aligning every heading, paragraph, and section is the layout of least resistance and kills reading rhythm. Instead: left-align body content by default; use asymmetry, offset columns, and a real grid with intent.
5. **Three feature cards with icons in a row.** The most-cloned section on the internet; it conveys "we had three things to say and no opinion about any of them." Instead: rank the features — give the most important one real estate, real UI screenshots, or a demonstration; compress the rest into a list.
6. **Emoji as section icons or bullet decoration.** Inconsistent across platforms, unreadable at small sizes, reads as filler. Instead: one icon set on one grid and stroke weight, or no icons at all.
7. **Sparkle, rocket, and magic-wand iconography for AI features.** The industry-wide cliché; it dates the product instantly. Instead: represent what the feature actually does — a summary, a draft, a search — not "magic."
8. **Fake testimonials, invented metrics, invented logos.** "10,000+ happy users" on an unshipped product is a lie the client has to catch. Instead: clearly marked placeholders the client must replace, or a design that works without social proof.
9. **Gratuitous gradient text.** Decoration applied to words that could not earn attention on their own; also breaks contrast checks. Instead: earn emphasis with scale, weight, and space.
10. **Untouched shadcn/Tailwind defaults.** Default slate palette, default `rounded-lg`, default `shadow-sm`, default focus ring — shipped as-is, it is a fingerprint anyone can spot. Instead: shadcn is a starting skeleton; retheme tokens (colors, radii, shadows, font) before building a single screen.
11. **Inter for everything.** A fine UI font and a terrible identity; display + body + code in Inter means no typographic decision was made. Instead: choose a display face with character and pair it deliberately.
12. **Dark hero with neon glow accents.** Black background, cyan/purple glow, dot-grid texture — the AI-startup uniform. Instead: if the project calls for dark, design a real dark palette with tonal layers and restrained accent use, not glow.

## Visual obligations

**Commit to one distinctive direction per project.** Before the first screen, name the direction in one sentence and hold every element to it. Example directions — pick one or define your own with the same specificity:

- **Editorial** — serif display (Tiempos, GT Sectra, Freight), asymmetric multi-column layouts, controlled line length, pull-quotes and rules borrowed from print.
- **Swiss modernist** — Neue Haas Grotesk or Helvetica Now, strict visible grid, flush-left ragged-right, one accent color, no ornament.
- **Brutalist utilitarian** — monospace or grotesque (JetBrains Mono, Space Grotesk), visible 1px borders, no shadows, no radius, honest density.
- **Warm humanist** — soft serif or rounded sans (Recoleta, or Söhne paired with a text serif), cream/paper backgrounds, ink-dark text, illustration over photography.
- **Industrial technical** — Univers/Söhne/IBM Plex, data-dense tables, hairline rules, uppercase micro-labels with tracking, engineering-drawing sensibility.
- **Luxury minimal** — high-contrast serif (Canela, GT Alpina), oversized whitespace, tiny caption type, near-monochrome palette, one image doing all the work.

Check the project's taste library (`taste/TASTE.md`, if present) before choosing — the direction should fit what the user already responds to.

**Typography with intent.** Two families maximum, a real scale (defined ratio, defined line heights), and at least one deliberate display moment per page — a size, weight, or width only this project would use.

**Real content over placeholder.** Write actual headlines, button labels, and empty-state copy for the client's domain. Lorem ipsum hides layout failures and postpones the hardest design work. If real data is unavailable, write realistic data.

**Restraint.** Every direction is defined by what it excludes. Before shipping, name three things you left out (gradients, icons, a second accent, animation, cards). If you cannot, you have accumulated defaults, not made choices.

**Break the grid with purpose.** One deliberate violation per key screen — an image bleeding off-canvas, a headline crossing a column boundary — placed where you want the eye to go. Everywhere is noise; nowhere is template.

## Copy slop

### Banned vocabulary

| Banned | Write instead |
|---|---|
| Unlock, Unleash, Elevate, Empower, Supercharge, Revolutionize, Transform | Say what the feature does: "Export reports as PDF", "Invite your whole team" |
| Seamless, effortless, frictionless | Delete it, or state the measurable fact: "Syncs in under 2 seconds", "No setup required" |
| Delightful, magical, beautiful (self-describing the product) | Never rate your own product; show the feature and let the user judge |
| Robust, powerful, cutting-edge, best-in-class | Name the specific capability: "Handles files up to 5 GB" |
| Leverage, utilize, harness | Use |
| Streamline, optimize (as marketing verbs) | Name the outcome: "Cuts invoice review from 20 minutes to 2" |
| Journey (for using software) | Setup, first week, workflow — whatever it actually is |
| Dive in, deep dive, explore | Read, open, see |
| Solution, ecosystem, platform (when it's an app) | App, tool, or the product's name |

### Banned constructions

- **"Welcome to the future of X."** Also "Say goodbye to Y", "X, reimagined", "X meets Y". Replace with a concrete claim: "Track every invoice in one table."
- **"It's not just X, it's Y."** And "more than just X". State the Y directly; cut the scaffolding.
- **Exclamation-mark enthusiasm.** Zero in confirmations, errors, and empty states. At most one, in a genuinely celebratory moment.
- **Em-dash chains.** More than one em dash per paragraph means the sentence needs restructuring. Prefer a period.
- **Rhetorical-question headers.** Headers state; they don't ask. "Pricing", not "How much does it cost?"
- **Title Case Everywhere.** Sentence case for headings, buttons, labels, menus. Title case only for proper nouns.
- **Emoji bullets.** No rockets or sparkles structuring lists — in UI, docs, or commit messages. Plain hyphens or the design system's list component.
- **Generic CTAs.** Each CTA names its action: "Create project", "Import contacts". "Get Started" on every button is slop; "Learn more" is banned as link text (it also fails accessible-content review).
- **Placeholder personas.** "Sarah, 34, marketing manager" signals zero research. Personas come from research data and include disability as a natural dimension (see accessibility-process); never stock names, round ages, "busy professional" framing.
- **Triads everywhere.** "Fast, simple, secure." Occasional is fine; every sentence is a tell. Vary rhythm.

### UX writing obligations

- **Sentence case** for every heading, button, tab, tooltip, menu item.
- **Verbs name the actual action.** "Delete 3 files", not "Confirm". Destructive confirmations repeat the object: "Delete project" / "Cancel", never "Yes" / "No".
- **Errors say what happened and how to fix it.** [What failed] + [why, if known] + [what to do]: "Couldn't save changes. You're offline — reconnect and try again." Never "Something went wrong". If retrying will work, offer the retry.
- **Microcopy word limits.** Buttons 1–3 words; tooltips 1 sentence; toasts ≤ 10 words; empty states 1 sentence + 1 CTA; onboarding steps ≤ 2 sentences. Needs more? Link to docs.
- **Numbers, not adjectives.** "Free for 14 days", not "generous free trial".
- **Second person, active voice.** "You can undo this", not "This action can be undone by the user".

## Code slop

- **Over-commenting the obvious.** `// increment counter` above `count++`. Comments explain *why*, never *what*; if the what needs explaining, rename or extract. Delete every comment that restates the line below it.
- **Dead abstraction layers.** A factory, interface, and provider wrapping code called from exactly one place. Inline it; abstract on the second use, not the first.
- **`utils.ts` dumping grounds.** Co-locate helpers with their only consumer; on the second consumer, promote to a named module (`format-currency.ts`), never a grab bag.
- **Wrapper-div pyramids.** Every wrapper must earn its place with a layout or semantic job. Prefer `nav`, `section`, `button` over `div` + handlers.
- **className soup.** Contradictory utilities (`p-4 p-2`), duplicated strings across siblings, arbitrary values (`w-[347px]`) where tokens exist. Resolve conflicts, extract repeats into a component or `cva` variant, use tokens.
- **Copy-pasted component variants.** `PrimaryButton`/`SecondaryButton`/`DangerButton` as three files of 90% shared JSX → one component, a `variant` prop, a variants map.
- **`console.log` leftovers.** None ship. Intentional logging goes through the project's logger with a level.
- **TODO litter.** Do it now, or file it and reference the ticket (`// TODO(#412): ...`). Bare TODOs don't ship.
- **Redundant state.** `isEmpty` mirroring `items.length === 0` — derive during render. State is only for what can't be computed from props or other state.
- **useEffect-for-everything.** Derived values compute in render; event responses go in handlers; effects only synchronize with external systems. Before writing `useEffect`, name the external system — if you can't, don't write it.

## Process slop

- **Sycophancy.** No "Great idea!" reflexes. If the idea has a problem, say the problem first, plainly, with the concrete cost. Clients pay for judgment, not applause.
- **Three options when one is right.** If the evidence points one way, recommend it and say why. Offer alternatives only when tradeoffs are genuinely balanced — then still say which you'd pick.
- **Restating the question before answering.** Start with the answer.
- **Summary sections that repeat what was just said.** End when the content ends.

## Pre-ship slop check

Run before shipping any screen, copy block, or component. Any "yes" on 1–9 or "no" on 10–14 blocks ship until fixed or justified in writing.

1. Could this screenshot be swapped into any other AI-generated product without anyone noticing?
2. Does the hero use a purple/blue/indigo gradient, or gradient text anywhere?
3. Is there a row of three feature cards with icons?
4. Is every card the same size, same radius, same shadow — every section centered?
5. Are there emoji, sparkles, or rockets standing in for real iconography?
6. Are any testimonials, metrics, logos, or avatars invented?
7. Is this shadcn/Tailwind with unmodified default tokens, or Inter doing every job on the page?
8. Does any copy use the banned vocabulary or constructions above?
9. Does the code contain dead abstractions, className soup, bare TODOs, or console.log?
10. Can you state the project's design direction in one sentence — and does this screen visibly obey it?
11. Is the content real (or realistic and domain-specific) rather than lorem/placeholder?
12. Can you name three things you deliberately left out?
13. Do errors and CTAs name their actual action and remedy?
14. Is every heading and button in sentence case?

When reviewing, report findings as a table: `# | pattern | where (file:line or screen) | severity | fix`. Anything matching a banned pattern is at least a Warning; an AI-default look on a key screen is a Blocker.

## Mechanical floor — add-on

Everything above is direction and judgment, and it is **mine**. The purely measurable
side of execution — contrast ratios, line measure, tracking, elevation, browser-surface
theming, runtime defects, and current-generation machine fingerprints — lives in the
`craft-floor` skill, adapted from an external source.

`craft-floor` is **subordinate to this file and to `taste`.** It verifies that a
decision was executed cleanly; it never proposes what the decision should be. Where it
disagrees with anything above, or with `taste/TASTE.md`, **this file wins and
`craft-floor` goes quiet** — no debate, no "balanced" compromise.

Run it *after* this skill, on built UI only. It has nothing useful to say about a
direction, a palette, or a mood.
