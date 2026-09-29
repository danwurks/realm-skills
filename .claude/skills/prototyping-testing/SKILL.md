---
name: prototyping-testing
description: Plans and specs design validation work — wireframe specs, user flow diagrams, prototype strategy and fidelity choice, heuristic evaluation (Nielsen's 10, severity 0-4), usability test scenarios, first-click and click tests, A/B test design with hypothesis and sample size, and accessibility test plans across assistive technologies. Use when creating any of these artifacts, choosing how to validate a design, or planning evaluative research before or after build.
---

# Prototyping and testing

Playbooks for deciding what to build to learn something, speccing it (wireframes, flows), and evaluating it (heuristics, usability scenarios, click tests, A/B tests, accessibility testing).

## Picking the method

Match the method to the question, not the deadline:

| Question | Method |
|---|---|
| Is the structure/flow right? | Lo-fi prototype + user flow diagram |
| Can users find this? | First-click test (quant, 20-50 people) |
| Why do users struggle here? | Moderated scenarios on a prototype |
| Does it break known usability rules? | Heuristic evaluation — cheapest, run before user testing |
| Which variant performs better? | A/B test — needs live traffic and a sensitive metric |
| Does it work with assistive tech? | Accessibility test plan |

Prototype the riskiest assumption first. Don't A/B test when traffic can't reach the sample size, when the change is foundational (touches everything), or when the real question is *why* — go qualitative instead.

## Choosing prototype fidelity

| Fidelity | Form | Answers |
|---|---|---|
| Low | Paper, sticky notes, rough wireframes | IA, flow validation, early exploration — fast to discard |
| Medium | Digital wireframes, clickable gray-box | Interaction patterns, navigation, stakeholder alignment |
| High | Pixel-perfect, coded, motion prototypes | Visual design, micro-interactions, usability testing, dev handoff |

Methods beyond click-through hotspots: coded prototypes (HTML/CSS/JS for realistic behavior), Wizard of Oz (real frontend, human-faked backend), video walkthroughs (concept communication).

Decide by asking: what question is this answering, who is the audience (users vs stakeholders vs developers), how many iterations are expected, and what decision it informs. Keep early prototypes visibly unpolished — polish invites feedback on the wrong layer. Build to throw away.

## Speccing a wireframe

Wireframes decide content hierarchy and behavior, not visual design. Conventions: grayscale only; X-box = image; wavy lines = text block; but real labels on nav and buttons — labels are design decisions and are testable.

Spec each screen with:

- Content blocks: header/nav, hero, content sections, forms, footer
- Content priority numbers — what appears or loads first
- Heading hierarchy (H1/H2/H3) and approximate character counts per block
- Image aspect ratios; required vs optional content; source (static / CMS / API)
- Interaction annotations: what happens on click/hover; flags for dynamic or personalized content
- All states: empty, loading, populated, error
- Responsive behavior notes or breakpoint versions per block
- Accessibility notes (focus order, labels)

Fidelity ladder: sketch → low-fi (gray boxes + labels) → mid-fi (realistic layout, placeholder content) → annotated (mid-fi + behavior specs). Get content strategy input before mid-fi; placeholder text hides layout problems.

## Diagramming a user flow

One flow per user goal. Notation:

| Shape | Meaning |
|---|---|
| Oval | Entry point |
| Rectangle | Screen/page |
| Diamond | Decision |
| Rounded rectangle | User action |
| Rectangle with side bars | System process |
| Bordered circle | End point |

Steps: (1) define the goal; (2) mark entry point(s); (3) map the happy path end to end; (4) add decision points, writing the criteria at each branch; (5) add error paths and recovery; (6) mark exits; (7) note background system events, notifications, and async delays.

Label every arrow with its trigger or action. If a diagram gets too branchy to read, split it. Variants: task flow (single linear path), user flow (branches by user type or choice), wire flow (flow + wireframe thumbnails — good for handoff).

## Running a heuristic evaluation

Cheapest evaluation available; run it before spending user-testing budget. 3-5 evaluators find far more issues than one — evaluate independently, then merge.

Nielsen's 10: (1) visibility of system status; (2) match to the real world; (3) user control and freedom (undo, exit); (4) consistency and standards; (5) error prevention; (6) recognition over recall; (7) flexibility and efficiency (expert shortcuts); (8) aesthetic and minimalist design; (9) error recognition and recovery; (10) help and documentation.

Process: define scope → walkthrough as a new user → as an experienced user → per task flow → log issues → rate severity → merge and prioritize.

Log per issue: heuristic violated, description, location, severity, screenshot, recommendation — find *and* fix, don't just find.

Severity scale: 0 not a problem · 1 cosmetic · 2 minor · 3 major (important to fix) · 4 catastrophe (blocks release).

Evaluate real user tasks, not edge cases. Findings are expert predictions — confirm severity 3-4 items with actual users.

## Writing usability test scenarios

A scenario = context + task + success criteria + observation guide.

- **Context**: one-sentence realistic backstory that gives motivation, not instructions, and doesn't lead
- **Task**: action-oriented goal in the participant's language, never product jargon. Never name UI elements or reveal the path. Bad: "Use the account menu to update your address." Good: "You've moved — make sure orders ship to your new place."
- **Success criteria per task**: completion (y/n), time, error/wrong-path count, assistance requests, self-reported difficulty (1-5)
- **Observation guide**: hesitations, verbal comments, facial expressions, navigation choices, error-recovery behavior

Task types: exploratory (find information — "find the return policy"), specific (defined goal — "add a blue shirt, size M, to your cart"), comparative (choose between options), open-ended (multiple valid paths).

Session design: warm-up task first, then order easy → hard; one goal per task; mix simple and complex; prepare follow-up questions per task; write more scenarios than the session needs; pilot the full set before real sessions.

## Planning a click test

For findability questions on static screens — quantitative, unmoderated, fast.

Types: first-click (where do they click first?), click-path (full sequence to complete a task), navigation test (can they find items via the nav structure?), five-second test (what do they remember after 5 seconds of exposure?).

Plan: objective → stimuli (which screens/states) → tasks → success criteria → participants (20-50 for quantitative confidence).

Rules:

- Define the correct click target area *before* testing
- One task per screen; reuse the same tasks across design alternatives to compare them
- Realistic content, never lorem ipsum
- No UI hints in wording — "Where would you click to change your email address?"

Measure: first-click success rate (above 65% generally indicates good findability), time to first click (hesitation = confusion), click-distribution heat map, and confidence rating vs accuracy — confident-but-wrong is the dangerous quadrant.

## Designing an A/B test

Hypothesis format: "If we [change], then [metric] will [improve/decrease] because [rationale]." One hypothesis, one variable per test.

| Element | Spec |
|---|---|
| Variants | A = control (current), B = treatment; keep the change isolated |
| Primary metric | One measure — measurable, relevant, sensitive to the change |
| Secondary/guardrail metrics | Catch unintended damage (refunds, support volume) |
| Sample size | From minimum detectable effect + baseline conversion rate, at 95% significance and 80% power — calculate before launch |
| Duration | Until sample size is reached; run in full weeks; minimum 1-2 weeks |

Document the whole design before starting. Pitfalls: peeking or stopping early on a positive blip; too many variants at once; a metric too coarse to detect the change; novelty effects; reading segments before the overall result (segment analysis comes after). Share results regardless of outcome — a null result kills a bad idea cheaply.

## Planning accessibility testing

Four layers — automated alone catches only ~30-40% of issues:

1. **Automated**: Axe, Lighthouse, WAVE — on every page/state, wired into CI
2. **Manual**: keyboard-only pass, screen reader walkthrough, zoom at 200% and 400%, high contrast mode, reduced motion mode
3. **Assistive technology**: VoiceOver (Mac/iOS), NVDA (Windows), TalkBack (Android); Voice Control and Dragon; switch control; screen magnification
4. **Users with disabilities**: recruit across vision, motor, cognitive, and hearing; test on their own devices and settings; real tasks, not compliance walkthroughs

Test matrix: each key flow × {keyboard only, VoiceOver, NVDA, zoom 200%, high contrast, reduced motion}.

Checklist structure: WCAG organized by principle (Perceivable, Operable, Understandable, Robust) and level (A, AA, AAA). AA is the working floor.

Report per issue: description, WCAG criterion number, severity, assistive tech affected, steps to reproduce, remediation. Prioritize by user impact, not conformance level. Accessibility testing belongs in the definition of done, not a pre-launch sweep.
