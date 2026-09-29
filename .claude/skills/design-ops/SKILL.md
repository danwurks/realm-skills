---
name: design-ops
description: Operational playbooks for design delivery: facilitating design critiques, running design reviews with staged quality gates and approval workflows, building design QA checklists to verify implementation, writing developer handoff specs, planning design sprints (5-day and compressed), defining team workflow and rituals, and setting design version control strategy for files, component libraries, and tokens. Use for any critique, review, QA, handoff, sprint planning, workflow, or versioning task.
---

# Design ops

Playbooks for the process side of design: critique, review gates, implementation QA, handoff, sprints, team workflow, versioning. Each section stands alone — jump to the task at hand.

## Running a design critique

Use when work-in-progress needs structured feedback. Pick the format first:

| Format | Use for |
|---|---|
| Desk crit | Informal 1-on-1, quick unblock |
| Team crit | Scheduled weekly, structured, full team |
| Cross-team crit | Fresh eyes from outside the project |
| Stakeholder review | Decision- and approval-oriented — not a crit |

Setup: the designer states goals, constraints, target audience, stage of work, and what feedback is wanted (layout? flow? copy? everything?). Label the session exploration or refinement — never critique exploration work for polish, or near-final work for direction.

Agenda: **Present** (5 min, designer walks the work and goals) → **Clarify** (5 min, questions to understand, not judge) → **Feedback rounds** (grouped by category or priority) → **Discuss** key tensions → **Capture** decisions.

Force feedback into these sentence frames — they strip judgment:

- "I notice…" — observation
- "I wonder…" — question or exploration
- "What if…" — suggestion or alternative
- "I think… because…" — opinion with rationale

Close: the designer (not the facilitator) summarizes takeaways; every action item gets an owner and a deadline. Rotate the facilitator role; make critique a weekly ritual, not an event. Failure modes: designing by committee, personal-preference feedback untied to user goals, ending without next steps.

## Setting up review gates

Use when a project needs quality checkpoints without endless review cycles. Four gates — skip gates for small or low-risk projects; scale the process rather than applying all four by default.

| Gate | Exit criteria |
|---|---|
| 1 Concept | Problem defined; user needs backed by research; multiple concepts explored; strategic alignment confirmed; stakeholder input gathered |
| 2 Design | Meets brand standards; interaction patterns consistent; responsive behavior defined; content strategy applied; design system components used |
| 3 Pre-handoff | All states designed (empty, loading, error, success); edge cases addressed; accessibility met; handoff spec complete (below); developer walkthrough done |
| 4 Implementation QA | Run the QA checklist below |

Every gate answers five questions: Does it solve the user problem? Consistent with the design system? Accessible (WCAG AA)? All states and edge cases covered? Feasible to build?

Approval chain: designer self-review against checklist → peer design review → design lead sign-off → stakeholder approval (only if required) → developer acceptance. Time-box each review to prevent endless cycles; record decisions and rationale where the team will find them.

## Running design QA

Use after development, before ship. Process: (1) developer self-reviews against the checklist, (2) designer visual QA pass, (3) file bugs with side-by-side screenshots (design vs build), (4) prioritize by severity, (5) verify fixes.

| Category | Check |
|---|---|
| Visual | Colors, typography, spacing match tokens, not approximations; border radius, shadows, opacity exact; icon size and color; image aspect ratio and quality |
| Layout | Grid alignment; behavior at every breakpoint; content reflows; no overflow or clipping; min/max widths respected |
| Interaction | All five states render (default, hover, focus, active, disabled); transition duration and easing match spec; touch targets ≥44px; keyboard tab order correct; focus indicators visible |
| Content | Real content, no lorem ipsum in production; truncation as specified; empty, error, and loading states present |
| Accessibility | Screen reader announces correctly; WCAG AA contrast; focus management works; ARIA labels and roles correct; prefers-reduced-motion respected |
| Cross-platform | Required browsers and devices; OS text-size settings; screen densities |

Quality bar: QA against the spec file, never memory; verify exact values in browser dev tools; test edge cases, not just the happy path; log recurring bug patterns as prevention items for the next handoff.

## Writing a handoff spec

Use at gate 3, before development starts. A full spec has six blocks:

| Block | Contents |
|---|---|
| Visual | Spacing/sizing as token references (exact px only as fallback); colors as token names, never raw hex; typography as style name + size, weight, line-height; radius, shadow, opacity; behavior at each breakpoint |
| Interaction | Definitions for default/hover/focus/active/disabled; animations as duration + easing + animated properties; gestures (swipe, drag, pinch); keyboard tab order and shortcuts |
| Content | Character limits and truncation behavior; dynamic content min/max rules; localization (text expansion, RTL); copy for empty, loading, and error states |
| Assets | SVG icons named per convention; images with resolution, format, responsive variants; font files or service links; custom illustrations |
| Edge cases | Minimum and maximum content scenarios; browser/device-specific notes; ARIA, keyboard, screen-reader requirements |
| Implementation notes | Component reuse suggestions; data structure assumptions; API dependencies; performance constraints |

Quality bar: annotate behavior, not just appearance — a static redline is half a spec. Redline complex layouts. The spec isn't done until you've walked the developer through it live and answered their questions.

## Planning a design sprint

Use when a big question needs a tested answer in a week. Classic 5-day structure:

| Day | Focus | Key activities |
|---|---|---|
| 1 Understand | Frame | Challenge + sprint questions; expert interviews and lightning talks; map the user journey; pick a target area |
| 2 Diverge | Options | Lightning demos; individual sketching (Crazy 8s, solution sketches); silent critique + heat-map voting; decide direction |
| 3 Decide | Commit | Review solutions; storyboard the prototype flow; assign build roles; plan what to test |
| 4 Prototype | Build | Realistic facade prototype; divide screens/content/flow; stitch together and rehearse; confirm test logistics |
| 5 Test | Learn | 5 user interviews with the prototype; debrief after each session; synthesize patterns; decide next steps |

Variants: mini sprint (2–3 days, compressed for smaller challenges), remote sprint (digital whiteboard, shorter blocks), discovery sprint (days 1–2 only, understanding-focused).

Don't start until every box is checked:

- [ ] Challenge statement written
- [ ] Decision maker identified and committed to attend
- [ ] Team of 5–7, cross-functional
- [ ] Room and materials booked
- [ ] 5 users recruited for day 5
- [ ] Whole week cleared on calendars

Rules that make sprints work: decision maker in the room; no devices in working sessions; follow the process even when it feels slow; photograph and document everything; plan the follow-up before the sprint ends.

## Defining a team workflow

Use when starting a team, onboarding into one, or fixing a broken process. Work moves through six stages: Discovery → Exploration → Refinement → Handoff → QA → Iteration. Define what "done" means at each.

Rituals and cadence:

| Ritual | Cadence | Purpose |
|---|---|---|
| Standup | Daily or async | Current work, blockers |
| Design critique | Weekly | Structured feedback (playbook above) |
| Design review | Per milestone | Quality gates (above) |
| Retrospective | Per sprint or monthly | Process fixes |
| Show and tell | Bi-weekly | Visibility beyond the team |

Also define, in writing:

- Task tracking: statuses (backlog → in progress → in review → done), priority levels and who assigns them, capacity planning
- Communication norms: sync vs async rules, response-time expectations per channel, how to request feedback, where decisions get documented
- Design–dev interface: which sprint ceremonies designers attend, handoff timing, who owns design QA, how design bugs get reported, who maintains the shared component library
- Tooling: one named tool per job — design, prototyping, project management (Jira/Linear/Asana), communication, documentation, version control

Quality bar: the workflow document exists, is visible, and is revisited at every retro — optimize for how the team actually works, not the theoretical ideal. Automate repetitive steps.

## Versioning design work

Use when multiple people touch the same files, libraries, or tokens. Version design files, component libraries, design tokens, icon sets, and documentation — at meaningful milestones, not every save.

Design files — pick one model:

- Named milestone versions: v1-exploration, v2-refinement, v3-final
- Branch-based: main = approved designs; feature branches = work-in-progress; review before merge
- Page-based: version history as pages within the file

Component libraries and tokens — semantic versioning (major.minor.patch):

| Level | Trigger |
|---|---|
| Major | Breaking change: renamed component, removed prop |
| Minor | New component or feature, backward compatible |
| Patch | Bug fix or refinement |

Version tokens alongside the library. Every release gets a changelog entry: what changed and why, link to the design decision, breaking changes flagged prominently, migration instructions for anything breaking.

Rules: name versions descriptively; archive old versions, never delete; announce changes to consumers (developers and other designers) — an unannounced library update is a broken build waiting to happen.
