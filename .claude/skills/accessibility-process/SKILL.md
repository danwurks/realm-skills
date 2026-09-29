---
name: accessibility-process
description: Playbooks for the accessibility side of the design process. Creates disability-inclusive personas, inclusive user stories with accessibility acceptance criteria, and scenario maps across ability spectrums; maps design decisions to WCAG 2.2 and legal standards (ADA, EAA, Section 508, EN 301 549); writes accessibility decision records, runs tradeoff analysis when needs conflict, produces accessibility handoff specs for engineering, and reviews inherited features for undocumented decisions.
---

# Accessibility process

## Building a disability-inclusive persona set

Two standard failures: no disability anywhere, or a separate "accessibility persona" reduced to a disability and only considered on the accessibility slide. Disability belongs in ordinary personas, one dimension among age, technical confidence, and context.

Dimensions:

- Permanent — visual (blind, low vision, colour vision deficiency), hearing (deaf, hard of hearing), motor (limited dexterity, tremor, paralysis, limb difference), cognitive (dyslexia, ADHD, autism, memory difficulties), speech (stutter, non-verbal)
- Temporary — broken arm, eye surgery recovery, concussion, medication side effects, ear infection
- Situational — sunlight on screen, noise, carrying a child, gloves, driving, unfamiliar language, fatigue, distress
- Intersectional — barriers compound: low vision + limited broadband + second language at age 65

Process: list core tasks and environments → identify the ability dimensions those tasks depend on → list situational impairments the real contexts create → write 4–6 personas → give each assistive-technology user a step-by-step scenario on their actual setup, not a clean-room test.

Integrate, never a "Challenges" bullet:

- Bio: not "Sarah is blind" but "Sarah, a project manager blind since birth, uses JAWS at work and VoiceOver on her iPhone — fast with shortcuts, frustrated by interfaces that waste her time"
- Goals/frustrations: show how disability shapes what good looks like — "review team status in under 10 minutes; hates dashboards that need a mouse"
- Context: device + AT, environment (noisy/quiet, mobile/desktop), energy level, who's present

Quality bar for any set of 4+ (a floor, not a target): ≥1 permanent disability, ≥1 temporary impairment, ≥2 situational contexts, ≥2 levels of technical confidence, spread across age and language. Deliver: personas, AT scenarios, coverage matrix (ability × impairment type × context), named gaps.

## Writing inclusive user stories

Never write separate "accessibility stories" — add criteria to every story instead of filing new tickets. Keep "As a [user], I want [action] so that [outcome]" but name the user when it matters: "As a keyboard-only user, I want to filter results with arrow keys and Enter…"

Baseline acceptance criteria for every story:

- Keyboard: fully operable by keyboard alone; logical focus order; visible focus on every interactive element
- Screen reader: all controls have accessible names; state changes announced; dynamic updates use aria-live
- Visual: no information by colour alone; contrast ≥ 4.5:1 normal text / 3:1 large; readable at 200% zoom
- Motor: touch targets ≥ 44×44px; no time- or precision-dependent interaction without alternatives
- Cognitive: plain-language instructions; errors say what to do next, not just what went wrong; mistakes undoable

Add-ons by story type:

- Form: labels visible and associated; required fields marked visually and programmatically; errors inline next to the field, not only a banner; completable by keyboard, touch, or voice
- Dashboard: data not colour-only (patterns, labels, values); text summaries for charts; keyboard-navigable with logical tab order; key metrics announced
- Notification: visual AND announced; user-controllable; persists until read; doesn't block interaction

Backlog audit: per story, ask who it excludes; check against the five dimensions; flag anything assuming a single input method or sense; patch in place. Bar: accessibility criteria live in the definition of done.

## Mapping scenarios across the ability spectrum

For test planning or finding gaps before users do. List the 5–10 core tasks where failure means the product failed → rate each across vision, hearing, motor, cognitive; mark breakpoints where it degrades or fails → overlay situational contexts, find compounding effects → write narratives for the highest-risk combinations (core tasks failing at common ability levels; contexts hitting large populations; compounded impairments) → rank fixes by users unblocked × severity.

Deliver: task × ability matrix scored works / friction / fails, situational overlay, critical scenario narratives, gap analysis, ranked fixes.

## Mapping decisions to WCAG and law

Most conformance failures originate in design decisions made before code exists — check criteria before finalising, the cheapest fix point.

Targets: WCAG 2.2 AA is the global baseline (A = 29 criteria, AA +20, AAA +28; AAA cognitive criteria are worth adopting anyway). Law: ADA (US, courts reference WCAG 2.1 AA); EAA (EU, effective June 2025, via EN 301 549 ≈ WCAG 2.1 AA plus software/hardware/docs requirements); Section 508 (US government, WCAG 2.0 AA, update expected).

Decision-to-criteria map:

- Colour & visual: text contrast 1.4.3 AA, non-text contrast 1.4.11 AA, colour not sole indicator 1.4.1 A, resize to 200% 1.4.4 AA, reflow at zoom 1.4.10 AA, text spacing override 1.4.12 AA
- Interaction: keyboard operable 2.1.1 A, no keyboard traps 2.1.2 A, focus visible 2.4.7 AA, focus order 2.4.3 A, target size 2.5.8 AA, no motion-only input 2.5.4 A, gesture alternatives 2.5.1 A
- Content & structure: page titled 2.4.2 A, heading hierarchy 1.3.1 A, link purpose 2.4.4 A, page language 3.1.1 A, consistent navigation 3.2.3 AA, error identification 3.3.1 A, input labels 3.3.2 A
- Motion & timing: pause/stop/hide 2.2.2 A, three flashes 2.3.1 A, timing adjustable 2.2.1 A, animation from interaction 2.3.3 AAA

Use during design (check affected criteria before committing), review (flag failures), and audit prep (turn the map into a product-specific pre-audit checklist).

## Recording accessibility decisions

Barriers accumulate when redesigns, framework updates, or new team members undo decisions nobody remembers the reasons for. Documentation is the immune system.

Document when you: chose between accessibility approaches; traded accessibility in one area for another; decided NOT to fix something; deviated deliberately from WCAG techniques; chose a pattern specifically for accessibility; changed direction after user testing.

Fields:

- Title — searchable: "Form validation: inline errors instead of summary banner"
- Date and author
- Context — constraints and evidence: "3 of 5 participants with cognitive disabilities missed the summary banner; corrected fields but never scrolled up, so never learned the form hadn't submitted"
- Decision — exact behaviour: "errors inline below each field, announced via aria-describedby; banner removed"
- Alternatives considered — why rejected
- Accessibility impact — who benefits, how
- Risks and tradeoffs — what was sacrificed
- Evidence — test sessions (date, participant count), WCAG SC numbers

Store in the codebase beside the implementation (preferred) or a shared decision log — never only in someone's head or a Slack thread. Bar: a new team member can learn why it's built that way without asking.

## Analysing a tradeoff

Tradeoffs are real: conflicting needs (autoplay captions help deaf users, moving text distracts users with ADHD; simplified language can feel patronising; high contrast can strain migraine-prone eyes), accessibility vs performance/deadline/complexity/cost, and partial implementation — which 80% ships now, and who does the deferred 20% exclude?

Six questions, in order:

1. Who benefits from option A — groups, estimated numbers, severity if not chosen
2. Same for option B
3. Who is harmed by each — how severely; permanent or temporary harm
4. Severity asymmetry — blocked (cannot complete the task) outweighs friction (harder but possible); permanent disability outweighs situational impairment (situational users have other options)
5. Reversibility — cheap to change later: take the faster option, plan the improvement; expensive: take the more inclusive option, accept the delay
6. Precedent — an undocumented shortcut becomes the standard; a bad precedent costs more long-term than the saving

Record with the decision fields plus: who is excluded (named groups); severity (blocked vs friction); remediation plan with tracked ticket and date ("chart screen reader support deferred to sprint 14; workaround: data table below chart; JIRA-4521"); review date.

Red lines — never: ship a feature completely inaccessible by keyboard; remove existing accessibility to hit a deadline; deprioritise fixes that block task completion; accept "fix it later" without a tracked ticket and deadline.

## Handing off to engineering

"Make it accessible" is not a specification. Compile the feature's decision records, then specify:

- Per interactive element: HTML element or ARIA role; keyboard behaviour (which keys do what); focus management (where focus lands after actions); screen reader name, role, state; visual states (default, hover, focus, active, disabled, error)
- Per content element: heading level; exact alt text or strategy; link text; language attributes if multilingual
- Per adaptive behaviour: media query and expected response; which preference changes what; breakpoints and reflow

Ship executable tests, not intentions:

- Keyboard: "Tab to submit, press Enter, verify focus moves to the confirmation message"
- Screen reader: "Navigate to the error; verify it announces 'Error: email address is required'"
- Visual: "Body text ≥ 4.5:1 in both light and dark modes"
- Zoom: "At 200%, form reflows to single column, no horizontal scroll"

Flag risks: custom keyboard handling, inaccessible framework defaults, third-party components needing wrapping or replacement, issues automated testing won't catch.

Deliver: element-by-element spec, test cases, WCAG SC per requirement, risk register, definition of done. Bar: every requirement has a test an engineer can run without interpretation.

## Reviewing an inherited feature

Framework defaults and copied patterns are still decisions — capture them before they're lost. Inventory every accessibility-affecting choice (keyboard handling, screen reader behaviour, colour and contrast, error communication, motion, respected preferences) → mark each intentional or accidental; note who it serves and excludes; evidence or arbitrary? → surface undocumented tradeoffs — speed ("no time for keyboard"), complexity ("too hard to build"), design ("didn't look right"), ignorance ("didn't know") — with current user impact → map against WCAG 2.2 AA using the map above → log every issue as debt with severity, owner, timeline.

Deliver: decision inventory (intentional vs accidental), undocumented tradeoffs with impact, compliance gaps, debt register, ranked list of decisions to revisit first.
