---
name: design-research
description: Plans and synthesizes qualitative UX research. Use for user interviews and interview scripts, summarizing interview transcripts, usability test plans, diary studies, card sorting analysis, affinity diagrams, user personas, empathy maps, journey maps, jobs-to-be-done (JTBD), and research synthesis. Provides per-task playbooks — discussion guides with timed sections, task scenarios and metrics, bottom-up theming, and models that turn findings into design implications.
---

# Design research

Playbooks for planning qualitative research and turning raw data into design decisions. Covers the full loop: write the instrument (interview script, usability test plan, diary study), process the data (interview summaries, affinity diagrams, card sort analysis), and build the models that carry insight into design (personas, empathy maps, journey maps, jobs-to-be-done).

## Ground rules for every task

- Read every file the user provides (transcripts, notes, survey exports, analytics, prototypes) before producing anything. If a product URL is mentioned, research the product first.
- Ground artifacts in actual research data. If only assumptions are available, label the output as assumption-based and list the research that would validate it.
- Mark each insight as stated (participant said it) or inferred (deduced from behavior or context).
- Use verbatim quotes; paraphrase loses the signal.
- End every artifact with design implications and open research gaps. An artifact without a "so what" is decoration.
- Save substantial artifacts as markdown in the workspace.

## Writing an interview script

Confirm research goals, target participants, and session length first. Structure as a funnel: broad context before specific features (Portigal, *Interviewing Users*).

| Section | Time | Content |
|---|---|---|
| Introduction | 2–3 min | Welcome, purpose, expectations, recording consent |
| Warm-up | 3–5 min | Easy background and role questions |
| Core exploration | 20–30 min | Questions grouped by research theme, each with follow-up probes |
| Specific scenarios | 10–15 min | Walk through a recent, concrete task or experience |
| Wrap-up | 3–5 min | Summarize, "anything we missed?", next steps, thanks |

Question rules:

- Anchor in past behavior, never hypotheticals: "When did you last…?", "What were you trying to accomplish?", "What happened next?"
- No leading questions, no yes/no questions.
- Embed standard probes inline: "Tell me more about that", "Why was that important?", "What happened next?"
- Add facilitator notes: staying neutral, redirecting tangents, time checkpoints.

Deliverable: a read-aloud-ready script with timings and probes inline.

## Planning a usability test

1. Research questions: 3–5 specific questions the test must answer — not "is it usable?".
2. Methodology: moderated vs unmoderated, remote vs in-person, think-aloud protocol.
3. Participants: 5–8 per segment, screening criteria, recruitment approach.
4. Tasks: 5–8 realistic scenarios. Each needs goal-framed wording (no UI vocabulary that reveals the path), success criteria, and expected completion time.
5. Metrics: task success rate, time on task, error rate, SUS or SEQ score, satisfaction rating.
6. Facilitation guide: introduction script, task delivery, neutral probing, debrief.
7. Data collection: what to record, observation template, note-taking framework.
8. Analysis plan: how findings will be synthesized and prioritized.
9. Pilot checklist before real sessions: prototype paths work, tasks are understood as written, timing fits the slot, recording works.

## Planning a diary study

For behavior over time in natural context — what a lab session can't capture. State the longitudinal research goal first, then spec:

- Duration: 1–4 weeks.
- Participants: 8–15, with screening criteria and a compensation plan.
- Entry prompts: daily or event-triggered; mix structured fields with open-ended prompts.
- Capture methods: photo, video, text, voice — specify what to document per prompt.
- Check-ins: mid-study interviews or pulse surveys.
- Onboarding: participant briefing, a practice entry, tool setup.
- Attrition plan: reminders, escalating incentives, a low-effort entry option for busy days.
- Analysis framework decided upfront: how entries are coded, themed, and synthesized across participants.

## Summarizing an interview

Turn one transcript into a scannable summary:

- Participant profile: role, context, experience level.
- Key themes: 3–5, each with supporting quotes.
- Jobs-to-be-done: what they were trying to accomplish.
- Pain points, each with a severity rating.
- Workarounds currently in use.
- Delighters: what works well or exceeds expectations.
- Notable quotes: 5–8 verbatim.
- Surprises: findings that contradict team assumptions.
- Action items: specific design or research follow-ups.
- Confidence per insight: stated vs inferred.

## Building an affinity diagram

For synthesizing many sources at once (multiple interviews, observations, open survey responses):

1. Extract atomic data points — one observation or quote per note.
2. Cluster bottom-up. Never start from predefined categories.
3. Name each cluster with a descriptive theme label.
4. Roll clusters into 3–5 top-level themes.
5. Write one insight statement per theme — the "so what", not a topic label.
6. Note frequency, intensity, and cross-theme connections.
7. Rank insights by impact on design decisions.

Deliverable: theme → cluster → data-point hierarchy with insight statements and supporting evidence.

## Analyzing a card sort

1. Confirm the study: open vs closed sort, participant count, card set.
2. Identify common grouping patterns and the category names participants used.
3. Build a similarity matrix: how often each pair of cards was grouped together.
4. Propose an IA/navigation structure that follows the observed mental models.
5. Flag ambiguous cards (inconsistently sorted) — candidates for renaming, cross-linking, or further research.
6. Recommend next steps: tree-test the proposed structure, then iterate the design.

## Writing jobs-to-be-done

People hire products to get a job done — analyze the job, not the product (Christensen, Ulwick). Job statement format:

**When [situation], I want to [motivation], so I can [expected outcome].**

- Map three dimensions per job: functional (the practical task), emotional (how they want to feel or avoid feeling), social (how they want to be perceived).
- Map the job lifecycle: define, locate, prepare, confirm, execute, monitor, modify, conclude.
- Define outcome expectations — what success looks like — for each dimension.
- List what users currently hire for the job and where those solutions underserve it. Opportunities live in the underserved gaps.

## Creating personas

2–4 personas, each built from a cluster of behavioral patterns in the data — behavior defines a persona, demographics only color it (Cooper, *About Face*). Per persona:

- Name, photo description, one-line quote capturing the mindset.
- Demographics: age range, occupation, tech comfort, relevant context.
- Goals: end, experience, and life goals — or functional/emotional/social to align with JTBD.
- Frustrations and unmet needs.
- Current behaviors and approach to the problem.
- A short day-in-the-life scenario.
- Design implications.

Then name the primary persona — the one the design must satisfy first — and justify the choice. Include disability as a natural dimension of the persona set (repo convention; pair with the inclusive-personas skills). Note research gaps that would strengthen the set.

## Building an empathy map

Fast alignment artifact for one user type (Dave Gray, XPLANE). Four quadrants plus two extensions:

| Section | Content |
|---|---|
| Says | Direct verbatim quotes from research |
| Thinks | Beliefs and concerns inferred from behavior and context |
| Does | Observable actions, behaviors, workarounds |
| Feels | Emotional states, anxieties, motivations |
| Goals | What they are trying to achieve |
| Pain points | Barriers, frustrations, unmet needs |

Close with design implications and what the team still needs to learn.

## Mapping a journey

Persona-specific, with an explicit scenario and start/end boundaries (Kalbach, *Mapping Experiences*). Define 5–7 stages from awareness through post-use/advocacy. Per stage capture:

| Row | Content |
|---|---|
| Goals | What the user wants at this stage |
| Actions | Behaviors and steps taken |
| Touchpoints | Channels and interfaces used |
| Thoughts | Questions and internal monologue |
| Emotion | Rated on a positive/negative scale |
| Pain points | Friction and failures |
| Opportunities | Design improvements |

Then: draw the emotional curve across stages; mark the moments of truth that make or break the experience; rank the top 3–5 opportunities by impact and feasibility. Map the current (as-is) state and flag future-state opportunities separately.

## Choosing the artifact

| Situation | Artifact |
|---|---|
| One transcript to process | Interview summary |
| Many data sources to synthesize | Affinity diagram |
| Team needs fast shared understanding | Empathy map |
| Design needs target users | Personas |
| Experience unfolds over stages | Journey map |
| Reframing features around motivation | Jobs-to-be-done |
| Navigation or IA question | Card sort, then tree test |
| Behavior over days or weeks | Diary study |
| Evaluating a design or prototype | Usability test |

Canon: Portigal, *Interviewing Users* · Hall, *Just Enough Research* · Kalbach, *Mapping Experiences* · Cooper, *About Face* · Krug, *Rocket Surgery Made Easy* · Tullis & Albert, *Measuring the User Experience* · Gray, *Gamestorming*.
