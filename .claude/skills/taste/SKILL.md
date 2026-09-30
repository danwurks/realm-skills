---
name: taste
description: The user's taste memory. Use whenever choosing or proposing a visual direction, hunting for inspiration or references, building a moodboard, or answering "what do we like" / "what's our style". Reads the synthesized profile in taste/TASTE.md and retrieves relevant saved inspiration from taste/library/ by tag. Pairs with no-slop — no-slop removes the generic, taste pulls toward what the user actually responds to.
---

# Taste

Inspiration is saved by dropping files in `taste/inbox/` and filing them with `/taste-add`. A Slack channel can also feed it via `/taste-pull`, but only if one is configured in `taste/slack.json` — read that file rather than assuming, and fall back to the inbox route if it is unconfigured. Each save becomes an entry in `taste/library/` with the user's own words, an attribute analysis, and a "steal this" line. `/taste-sync` distills the library into `taste/TASTE.md` — the profile this skill reads. If the profile looks stale and the Slack MCP is connected, suggest `/taste-pull` first.

## Before proposing any visual direction

1. Read `taste/TASTE.md`. If it has real content, the direction you propose must either fit a strong preference or explicitly say why this project departs from it. Never contradict an anti-taste item without flagging it.
2. If TASTE.md is empty or missing, say so and proceed with the `no-slop` direction list — then suggest saving some inspiration to build it up.

## Fit the taste to the project — never spray it

The profile is a menu, not a checklist. Before applying any of it, read `project/brief/`
(PRD/WBS) and take the user's stated project type as a hard input. Then select the
clusters that serve **this** brief and leave the rest unapplied:

- A quiet brief — institutional, information-dense, utility — gets the restraint
  clusters: monochrome discipline, micro-typographic hardware, type doing hierarchy.
  Motion stays purposeful (transitions, reveals with full fallbacks), never showpiece.
- A brand-forward brief — studio site, campaign, launch — is what earns the
  choreography cluster: scroll-driven set pieces, per-letter play, scale reveals.
- The same designer's fingerprints show up at both volumes. Volume is a
  **project decision**, not a preference.

When proposing, name both lists out loud: *"applying: X, Y — withheld: Z (brief calls
for quiet)."* Withholding is a taste decision and must be visible, not silent.

## The UI reference sweep — and the WOW gate in front of it

The user's own ritual, and agents should run it for him. But **the register is decided
and confirmed before the sweep, not after** — because an agent that opens Awwwards
first falls for a showpiece and then reasons backwards to justify it. Decide the
volume, ask, then look.

### Step 1 — Read the register off the brief

| Register | What it looks like | Does WOW help? |
|---|---|---|
| **Showpiece** | Studio site, campaign, launch, portfolio, brand moment | Yes — this is what the sources below are *for* |
| **Considered** | Product marketing, SaaS, editorial, agency work with substance | Partly — craft visible, restraint still dominant. One moment of energy, not a set piece |
| **Rigid / formal** | Institutional, financial, regulated, enterprise, government, healthcare, legal | **No — it actively costs credibility.** |

Evidence comes from `project/brief/`, the stated project type, the client's sector,
and the audience. Not from what would be fun to build.

### Step 2 — Rationalise, then ASK. Always.

**Never pick the register silently, and never assume WOW is wanted.** State the read,
the evidence, and the recommendation — then ask the user to confirm before sweeping:

> "Reading this as **considered**, not showpiece — it's a regulated-sector audience and
> the brief's own words are 'clear and concise'. So I'd weight Savee and Behance over
> Awwwards, and keep motion to purposeful transitions. Want me to go louder, or is
> that the right register?"

The user has said outright that some projects are rigid and formal and the WOW sources
will not work for them. Deciding that for him is the failure this gate exists to
prevent. **Ask even when confident** — the answer takes him three seconds and it is his
call, not the agent's.

### Step 3 — Sweep, in this order

Stop as soon as the direction is clear; this is a ladder, not a checklist.

| # | Source | Best for | Weight it when |
|---|---|---|---|
| 1 | **[Awwwards](https://www.awwwards.com/)** | Whole sites, scroll choreography, motion-led direction | Showpiece |
| 2 | **Mobbin** (MCP) | Real shipped app and web flows, screen by screen | **Any register** — and the one rung that is fair evidence for *flow* as well as surface, because these are products in production rather than portfolio shots. Needs authorising in claude.ai connector settings |
| 3 | **[Dribbble](https://dribbble.com/)** | Component and screen-level surface treatment | Any register — but see the warning below |
| 4 | **[Savee](https://savee.it/)** | Art direction, typography, editorial, image-led composition | Considered and rigid — its work is quieter than Awwwards |
| 5 | **[Behance](https://www.behance.net/)** | Full case studies, brand systems, the *reasoning* behind a direction | Rigid and formal — it carries corporate and institutional work the others don't |
| — | **[motionsites.ai](https://motionsites.ai/)** | Motion reference specifically | **Only after `emil-design-eng` has agreed motion belongs at all** — this answers *how*, never *whether* |

### The warning that matters most

**With one exception, these sources are evidence for how something LOOKS, never for how
it WORKS.** Awwwards, Dribbble, Savee and Behance reward the portfolio, not
the user — shots are frequently non-functional, flows are omitted, states beyond the
happy path do not exist, and a scroll-jacked hero that wins an award can be genuinely
hostile to use.

So: take surface treatment, composition, typography, colour and motion character from
them. **Never take flow, IA, form logic, error handling or state design from them** —
that comes from `ux-first` and `docs/ux-references.md`, and `ux-first` runs first and
outranks anything found here. A beautiful reference does not reopen a settled UX
decision.

**Mobbin is the exception, and that is why it sits at rung 2.** It captures products
that actually shipped, screen by screen through a whole flow, so it is legitimate
evidence for sequence, state coverage and what a real team decided under real
constraints. Use it to *corroborate* a UX spec — never to overrule one, and never as a
substitute for the pattern research in `docs/ux-references.md`, which carries the
empirical work Mobbin's screenshots cannot show.

Everything swept is still subject to `no-slop` and to the profile in `taste/TASTE.md`.
A reference is a candidate, not a verdict.

## Existing work the user is satisfied with

In-progress or shipped design the user says they are happy with is **reference
material, not a target**:

- Read it and learn from it — extract taste entries from it where it is strong.
- Apply changes **only where explicitly requested**, matching the existing system's
  tokens and patterns when you do.
- Never propose a redesign of it unsolicited. Satisfaction stated once covers the whole
  artefact until the user says otherwise.
- **Satisfaction is scoped to the artefact named, not the repo it lives in.** One
  approved page does not bless its siblings. Agent-generated pages the user has not
  yet directed or endorsed carry **no taste signal** — never extract taste from them,
  and treat them as open for revision rather than canon. The usual shape: one page the
  user directed is canon, and its agent-built siblings are not.

## Entries extracted from a live codebase

An entry taken from the user's own in-flight project describes a **moving target**. The
work keeps shipping, so specific values in the entry — a timing, an ease, which sections
are locked to a colour — go stale without anyone editing the entry.

- Record `source_path` and the **commit** the extraction was made from, so drift is
  checkable rather than assumed.
- **Before citing a specific value from such an entry in a proposal, open the file.**
  Cite the entry for the *decision*; cite the source for the *number*.
- When drift is found, **correct in place with a dated note** rather than silently
  rewriting. The fact that a value moved is itself signal — it shows which decisions were
  provisional and which held.
- A revision the user made to their own work is usually **stronger** signal than the
  original, because it was made against a real failure they could see. Extract the
  revision *and* what it fixed.

## When asked for inspiration or references on a topic

1. Grep `taste/library/*.md` frontmatter for matching `tags`, `type`, and body text (e.g. `grep -l "dashboard" taste/library/`).
2. Surface the 3–5 highest-`score`, `status: active` matches. For each: the saver's own words, the "Steal this" line (verbatim), and the image — open the local file if `image:` is a path under `images/` (the browsable moodboard), else `slack_read_file <file_id>` from an `image: slack://<id>` field.
3. If nothing matches, say so; do not invent library entries. Offer adjacent tags that do exist.

## Precedence rules

- **Client brand wins.** Taste never overrides a client's brand guidelines or an existing design system. Taste breaks ties when the brief leaves a choice open.
- **Anti-taste is a warning, not a law.** If the best design answer conflicts with an anti-taste item, present it with the conflict named.
- Entries with `status: anti` are examples of what the user dislikes — cite them only as counter-references.

## What this skill never does

- Never edits `taste/TASTE.md` (only `/taste-sync` regenerates it) and never edits library entries except through `/taste-add`.
- Never treats one entry as a trend — the profile (TASTE.md) carries the weight, single entries carry the specifics.
