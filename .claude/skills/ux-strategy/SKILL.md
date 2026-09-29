---
name: ux-strategy
description: Strategy playbooks for design work: design briefs and framing the problem, competitive analysis, design principles, experience maps, north star vision, opportunity framing and prioritization (impact-effort, RICE, Kano), UX metrics (HEART, SUS, NPS), and stakeholder alignment (stakeholder maps, RACI, decision rights, communication plans). Use at kickoff, when scoping, when choosing what to build next, when defining success measures, or when stakeholders disagree on direction.
---

# UX strategy

Playbooks for the strategy layer of a design engagement. The artifacts chain: a brief frames the problem, competitive analysis and experience maps supply evidence, the opportunity backlog gets prioritized, principles and a north star set direction, metrics define success, and stakeholder alignment makes decisions stick. Produce only the artifact the current task needs.

## Writing a design brief (framing the problem)

**When:** kickoff, before any screens exist; rewrite when scope shifts mid-project.

Seven sections:

| Section | Must contain |
|---|---|
| Project overview | name, one-paragraph summary, business context, accountable stakeholder |
| Problem statement | what is broken, for whom, evidence (data or research, not opinion), cost of not solving it |
| Target audience | primary and secondary users, defining characteristics, links to personas |
| Goals and success criteria | the design goal, 3-5 metrics with targets, qualitative indicators |
| Scope and constraints | explicit in/out-of-scope lists; technical, brand, timeline, legal constraints |
| Context and inputs | existing research, competitive references, prior attempts and why they failed |
| Deliverables and timeline | outputs, milestones, review points, hard deadline |

**Quality bar:** the problem statement names no solution ("users abandon checkout at step 3", not "we need a redesign"). Every success criterion is measurable — write it in the metric format below. Get stakeholder sign-off before design starts, then re-read the brief at every review; a brief nobody re-reads cannot stop scope creep.

## Running a competitive analysis

**When:** entering a market, benchmarking before a redesign, hunting for differentiation gaps.

1. Pick the set: direct competitors (same problem, same audience), indirect (same problem, different audience), plus 1-2 aspirational benchmarks from adjacent domains.
2. Evaluate everyone on the same dimensions: information architecture, interaction patterns, visual design, content strategy, performance, accessibility, mobile experience.
3. Build a feature comparison matrix — per key task per competitor: supported?, steps required, UX quality 1-5, unique approaches worth noting.
4. Synthesize: each competitor's strengths and friction points; across the set, table-stakes patterns (must match) vs unaddressed gaps (chances to lead).

**Deliverable:** one-page summary, comparison matrix, short competitor profiles, opportunity map, annotated screenshots.

**Quality bar:** judge UX quality, not feature presence — a supported-but-eight-step flow is a gap, not parity. Walk full journeys (signup → first success → repeat use), not homepage screenshots. Date the analysis; findings decay within months as competitors ship.

## Defining design principles

**When:** the same debates keep getting settled by opinion or seniority; design reviews lack shared criteria.

A principle earns its slot only if it is: opinionated (a reasonable competitor would take the opposite stance), actionable (resolves a live debate), memorable (recallable in review without looking), distinctive (about this product, not any product), testable, and ranked so conflicts between principles resolve.

Per principle: title (3-6 words), one-sentence statement, rationale, one application example, one counter-example (what it forbids), the trade-off it accepts.

Process: gather inputs (research, strategy, values) → workshop candidates → apply the disagreement test: if nobody could disagree ("be user-centered"), cut it → rank the set → replay 3-5 past contentious decisions and check the principles would have decided them → socialize in reviews, onboarding, team spaces.

**Quality bar:** 3-7 principles; each has a counter-example; the set has an explicit priority order; they get cited in design reviews or they are wall art. Revisit as the product evolves.

## Mapping the experience

**When:** new product ecosystems, omnichannel evaluation, gap analysis between channels, cross-team alignment. For one persona in one scenario use a journey map; the experience map is the systems view.

Columns are phases: awareness → evaluation → onboarding → regular use → advanced use → advocacy or departure. Rows are layers:

| Layer | Capture |
|---|---|
| User actions | what they do, key decisions |
| Touchpoints | website, app, email, support, community |
| Channels | desktop, mobile, in-person; automated vs human |
| Emotions | confidence, frustration, moments of delight |
| Pain points | friction, confusion, information gaps |
| Opportunities | fixes and new touchpoints — feed the opportunity backlog |

Map the seams explicitly: how touchpoints hand off, where data flows (or fails to) between channels, where human ↔ automated transitions happen. Most breakage lives at seams, not inside touchpoints.

**Quality bar:** current state before future state; physical touchpoints included, not just digital; every pain point traces to research or analytics, not assumption; built with stakeholders from each org that owns a touchpoint.

## Articulating a north star vision

**When:** teams optimize locally with no shared direction; before roadmap planning.

Four components:

- **Vision statement** — one sentence: who, what experience, why it matters.
- **Design pillars** — 3-5 strategic focus areas naming the differentiators; every project should map to one.
- **Vision scenarios** — short narratives of a user in the future state, concrete enough to storyboard.
- **Success criteria** — qualitative signals, quantitative metrics, milestones (use the metric format below).

Stage over horizons: near-term (1 yr, tangible improvements), mid-term (2-3 yrs, major experience shifts), long-term (5+ yrs, aspirational transformation).

Process: research synthesis → aspiration workshop → narrative writing → validate against observed user needs → communicate.

**Quality bar:** grounded in real needs, broad enough to survive unknowns. The pillars are the hook to daily work — a vision not cited in reviews and planning is dead.

## Prioritizing opportunities

**When:** candidate improvements exceed capacity; after research or a competitive analysis dumps new items into the backlog.

Harvest from: research findings, analytics anomalies, competitive gaps, new technology, stakeholder requests, support ticket themes.

Score with at least two frameworks and triangulate — where they disagree is the interesting conversation:

| Framework | Mechanics | Best for |
|---|---|---|
| Impact-effort 2x2 | quick wins / strategic bets / fill-ins / deprioritize | fast workshop triage |
| RICE | (Reach × Impact 1-3 × Confidence %) ÷ Effort in person-weeks | comparable scores across many items |
| Kano | must-be / one-dimensional / attractive / indifferent / reverse | separating hygiene from differentiators |
| Value vs complexity | user value 1-10 against complexity 1-10 | roadmap conversations with engineering |

**Deliverable:** ranked list with per-item rationale, theme groupings, dependencies, and a confidence level per score.

**Quality bar:** every rank has a written why — scores without rationale get re-litigated. Score as a group (design + engineering + product), and re-score when new evidence lands, not on an annual schedule.

## Defining UX metrics

**When:** the brief needs success criteria; leadership asks what design moved; before and after a redesign.

Pick 3-5 primary metrics mixing categories — behavioral-only misses sentiment, attitudinal-only misses behavior:

| Category | Examples |
|---|---|
| Behavioral | task completion rate, time on task, error rate, feature adoption |
| Attitudinal | SUS, NPS, CSAT, perceived ease of use |
| Business | conversion, retention, support volume, onboarding completion |
| Engagement | DAU/MAU, session duration, feature discovery, return visits |

Use HEART as a coverage check: Happiness (satisfaction, ease ratings), Engagement (frequency, depth), Adoption (activation, feature uptake), Retention (return rate, churn), Task success (completion, time, errors). You rarely need all five — but know which you are ignoring and why.

Define each metric fully: name, precise definition, measurement method, data source, target, review frequency, owner.

**Quality bar:** baseline captured before the change ships; every metric tied to a design hypothesis ("simplifying step 2 lifts completion 61% → 75%"); numbers reported alongside qualitative findings so they arrive with explanations. A metric without an owner and a target is dashboard decoration.

## Aligning stakeholders

**When:** kickoff, always — establish decision rights before conflict, not during it. Re-map when the org or project changes.

Build in order:

1. **Stakeholder map** — everyone who can influence or block; plot influence × interest; high-influence/high-interest get managed closely.
2. **RACI matrix** — per decision type: Responsible, Accountable (exactly one person), Consulted, Informed.
3. **Decision framework** — which decisions need input vs notification, who decides each class, named escalation path for disagreements.
4. **Communication plan** — who gets what, when; cadence, channel, and a feedback deadline per share-out.
5. **Feedback protocol** — feedback states the problem, not the prescription; due dates; how conflicting feedback gets prioritized.

Failure modes and counters:

| Failure | Counter |
|---|---|
| Stakeholder prescribes solutions | redirect to the problem via the brief |
| Departments with conflicting priorities | decide with principles + decision framework |
| Late-stage scope change | point to the signed brief |
| Stakeholder surfaces mid-project | onboard via the decision log; map wider at next kickoff |

**Quality bar:** decision rights documented before the first contested call; every decision logged with rationale so it is not re-argued; communication is push (send it), not pull ("it's in Figma").
