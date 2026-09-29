---
name: designer-toolkit
description: Playbooks for design communication and stewardship — writing design rationale, portfolio case studies, and presentation decks; UX writing and microcopy (buttons, error messages, empty states, CTAs, onboarding); design token audits (coverage, consistency, hard-coded values); and design system adoption strategy. Use when documenting or defending design decisions, presenting work to stakeholders, writing interface copy, or measuring and growing design system usage.
---

# Designer toolkit

## Pick the deliverable

| Situation | Deliverable |
| --- | --- |
| Decision departs from a pattern, was debated, or will be questioned later | Design rationale |
| Finished project needs packaging for a portfolio or hiring audience | Case study |
| Live audience must align, give feedback, or approve | Presentation deck |
| Screen needs labels, errors, empty states, CTAs | UX writing |
| Hard-coded values creeping in; token drift suspected | Token audit |
| System exists but teams are not using it | Adoption plan |

Rationale is the atomic unit — case studies, decks, and adoption arguments reuse it, so write it at decision time.

## Writing design rationale

When: major direction decisions, departures from established patterns, controversial or debated choices, changes from a previous approach, anything likely to be re-litigated later. Skip it for routine pattern application.

Seven parts, in order:

1. **Decision** — the specific choice made. Name the component, flow, or value.
2. **Context** — the problem that forced a decision; active constraints.
3. **Options considered** — each alternative in a sentence; two or three real ones ("do nothing" counts).
4. **Evidence** — what informed it: user research, analytics, usability test results, competitive analysis. Cite the artifact, never "research shows".
5. **Reasoning** — why this option beat the alternatives, connected to user needs, business goals, design principles, and technical feasibility.
6. **Trade-offs** — what was knowingly compromised or deprioritized, and why that is acceptable.
7. **Validation plan** — the metric or feedback signal that will confirm or refute the decision, and when you will check it.

Quality bar: grounded in user needs, not designer preference; references at least one piece of evidence or a named principle; admits at least one real alternative and one real trade-off; specific enough to be useful months later; written for the audience who will read it. Write it during the decision, not retroactively. Store it beside the design file; cite it in handoffs and reviews — rationale in a lost Slack thread does not exist.

## Writing a case study

Six sections:

1. **Overview** — title, one-line summary, your role vs. team composition, timeline and scope, and the single most impressive outcome as the hook (a metric if one exists).
2. **Challenge** — business context, problem statement, user pain points, constraints, why it mattered.
3. **Process** — research methods and key findings; ideation breadth (the options you did not ship); the 2–3 key decisions with rationale (depth); how testing or feedback changed the design.
4. **Solution** — final design walkthrough, key features and interactions, how it answers the original challenge, design-system and technical considerations.
5. **Impact** — quantitative results first, then qualitative (user quotes, team response), business impact, what you would do differently.
6. **Reflection** — learnings, pivots and challenges overcome, how the work influenced later projects.

Visuals: show the journey, not just the final product — sketches, wireframes, iterations, before/after pairs, annotated decisions, real production screenshots rather than only mockups.

Writing bar: first person for your own contributions, explicit about your role vs. the team's; every impact claim quantified or attributed; scannable (clear headings, short paragraphs); enough context for a reader who has never seen the product; ruthlessly cut — highlight insight moments and pivots, do not document every step. Tailor depth to the audience.

## Building a presentation deck

Match structure to goal:

| Type | Goal | Structure |
| --- | --- | --- |
| Stakeholder update | Inform and align | Context recap → progress → key decisions → next steps → asks |
| Design review | Get feedback | Objectives → walkthrough → rationale → open questions → specific feedback request |
| Final showcase | Approval | Problem → process → solution → evidence → impact → next steps |
| Portfolio | Demonstrate capability | Use the case study structure above |

Universal spine: **Hook** (why the audience should care — a problem, data point, or story) → **Context** (background, constraints) → **Journey** (process, key moments only) → **Solution** (the design, with rationale) → **Evidence** (research, testing, data) → **Ask** (the approval, feedback, or resources you need).

Slides: one idea per slide; show rather than tell; progressive disclosure for complexity; design for the back of the room — large text, high contrast; context goes in speaker notes, not on the slide.

Audience tuning: executives — lead with impact and business value, cut process; engineers — include interaction specs, technical detail, edge cases; designers — show process, rationale, system alignment; mixed — big picture first, layer detail progressively.

Bar: rehearse once with a colleague; keep backup slides for predicted questions; open with the audience's concern, not yours; end on one clear ask; follow up with a summary document so the decision survives the meeting.

## Writing UI copy

Content-first: write copy before designing the screen, so layout fits the words rather than the reverse.

| Surface | Rules |
| --- | --- |
| Buttons and CTAs | Start with a verb; name the outcome ("Create account", not "Submit"); match user intent, not business intent; the primary CTA is the most common action |
| Form labels | Plain words, no jargon; placeholder shows an example format, never instructions (placeholders vanish on focus) |
| Tooltips | Brief explanation of a genuinely complex feature — not a patch for an unclear UI |
| Error messages | Three beats: what happened (plain, no error codes) → why, only if brief and useful → the specific next action. Human tone; never blame the user |
| Empty states | Say what will appear here, then one clear CTA that makes it appear; encouraging tone |
| Confirmations | Confirm what just happened; next step if relevant; undo for reversible actions; brief and positive |
| Onboarding | One concept per step; action-oriented (do, not read); always skippable |

Voice vs. tone: voice is fixed — brand personality, vocabulary, perspective. Tone flexes with context: celebration, error, and instruction should not sound the same.

When principles conflict, this order wins: clear > clever, concise > exhaustive, helpful > promotional, consistent > creative, inclusive > casual.

Maintain a terminology dictionary — one name per concept across the product. Avoid idioms, abbreviations, and culture-bound references; they break in translation. Budget roughly 30% text expansion for localized strings when sizing buttons and labels.

## Auditing design tokens

Audit both design files and code — drift usually lives in the gap between them.

Three questions:

- **Coverage** — what percentage of visual properties resolve to tokens? Which properties are habitually hard-coded? Is the right tier used (global vs. semantic vs. component)?
- **Consistency** — same token for the same purpose everywhere? Redundant tokens (different names, identical values)? Deprecated tokens still referenced?
- **Gaps** — raw values that should be tokens; use cases the set does not cover; repeated custom values that indicate a missing scale step.

Process, six steps:

1. **Inventory** — extract every visual value from code and design files (grep hex codes and px values; pull Figma style and variable usage).
2. **Categorize** — group by type: color, spacing, typography, elevation, radius.
3. **Map** — match each value to an existing token.
4. **Flag** — hard-coded values, near-miss mismatches (`#333` where `color.text.primary` was meant), and gaps.
5. **Prioritize** — rank by frequency × impact; color and spacing first, as the highest-volume offenders.
6. **Recommend** — new tokens, migration list, deletions.

Report format: executive summary (adoption percentage, key findings) → findings by category → hard-coded value inventory with a suggested replacement token per value → proposed new tokens → migration plan in priority order. Every finding carries a value, its location, and its fix — actionable, not just informational. Automate detection afterward (lint rules) and re-run to track adoption over time.

## Driving design system adoption

Treat the system as a product whose users are designers and engineers. Adoption fails as a mandate and works as a funnel:

| Stage | Moves |
| --- | --- |
| Awareness | Launch announcement and demos; searchable docs site with examples; regular changelog communication; showcase teams using the system well |
| Education | Getting-started guides per role (designer, developer); component usage guidelines with examples; workshop series — introductory, advanced, contribution; recurring office hours |
| Enablement | Published Figma library with setup instructions; installable code packages; templates and starter kits; migration guides from each legacy pattern |
| Incentives | Celebrate teams that adopt well; publish adoption metrics; make system usage a code/design review criterion; make the system path easier than the custom path |

Measure — the token audit above supplies the first two:

- Component and token usage percentage in production
- Count of custom overrides and detached instances
- Support question volume (should fall over time)
- Time to implement new features (should fall)
- Consistency audit scores

Barrier → response:

- "It doesn't cover our needs" → a real gap: add it to a public roadmap and offer a contribution path
- Incomplete or confusing docs → invest in documentation as much as components
- Components too rigid → add escape hatches before teams fork
- Breaking changes too frequent → semver, deprecation windows, migration guides
- No clear contribution path → make contributing easy; objections are requirements

Sequence: start with willing teams, ship visible wins, show productivity gains with data, then expand. Support designers and developers equally — a system only half the org can use gets adopted by neither. Offer migration support, not mandates.
