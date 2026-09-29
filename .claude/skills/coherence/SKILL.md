---
name: coherence
description: One visual vocabulary per page, enforced. Use when designing or building any second section (the first one sets the vocabulary), when sections were built across different sessions or by different agents, and when reviewing a page for consistency. Inventory what is actually used, treat any value appearing once as a suspect, and never break the pattern without the user's explicit say-so — a deviation is HIS call, not the agent's.
---

# Coherence

**A page has one vocabulary.** Sections are variations on it, not separate designs.

The user has said this plainly and means it: consistent by default, and if a section
goes explosive **that is his decision, not an agent's**. An agent that decides on his
behalf to make section four loud has not added flair; it has broken the page.

## Why this drifts

Nobody sets out to build an incoherent page. It happens because sections are designed
**one at a time**, often across different sessions, sometimes by different agents, and
each one is internally reasonable. Section 1 uses a bordered card; section 3 reaches
for a shadow; section 5 invents a new eyebrow treatment. Each decision is defensible
alone. Together they read as five designers and no art direction.

So coherence is not a taste judgement made at the end. It is an **inventory**, and it
is checkable.

## The vocabulary — what has to match

Take the inventory across the whole page, listing the actual values in use:

| Axis | What to list |
|---|---|
| **Radius** | Every corner value. A scale, not a collection |
| **Elevation** | Border, tint, or shadow — the page picks *one* idiom and repeats it |
| **Eyebrow / label** | Case, tracking, size, colour. This is the single most-drifted item |
| **Type steps** | Which steps of the scale actually appear; two headings a hair apart is drift |
| **Section rhythm** | Top/bottom padding per section, and how sections meet each other |
| **Card idiom** | How a card is constructed — surface, border, padding, hover |
| **CTA vocabulary** | Pill vs bordered vs text-and-rule, and which rank each signals |
| **Accent carriers** | Which colour carries energy, and how often it is allowed to appear |
| **Motion character** | Easing family, duration band, and what triggers it (scroll, hover, load) |
| **Image treatment** | Aspect ratios, colour vs grayscale, corner treatment, overlay style |
| **Copy register** | Sentence vs title case, voice, how headings are punctuated |

## The test

**Any value that appears exactly once is a suspect.** Not automatically wrong — but it
has to be either folded back into the vocabulary or explicitly justified. A page that
uses `rounded-2xl` eleven times and `rounded-lg` once is telling you about the once.

Worked example of the check passing, from real review in this workspace: an agent-built
Events module was accepted on this axis because "the radius scale matches the repo's
existing split, and every uppercase tracking value in the module — 0.22 / 0.16 / 0.14 /
0.12em — is drawn from the set the homepage already uses rather than invented." That is
what the inventory looks like when it comes back clean.

## Deviation is the user's call

**Never break the pattern unilaterally.** When a section seems to want to depart:

1. Say what the break would be, on which axis, and why the content asks for it.
2. Say what it costs — what the page loses in coherence.
3. **Ask.** Then build what he decides.

> "The facts band could go always-dark while the rest of the page stays light — it
> would give the numbers a moment of their own and break up a long light page. The cost
> is that it is the only inverted section, so it will read as the loudest thing on the
> page whether or not that is the intent. Want it, or keep it consistent?"

Silence is not consent. If he has not answered, build it consistent.

## Making an authorised break read as deliberate

Once he says yes, there is a craft rule that decides whether the break looks intentional
or accidental:

**Break exactly one axis and keep everything else.** A section that inverts its surface
but holds the same type scale, the same eyebrow treatment, the same spacing rhythm and
the same accent discipline reads as *deliberate emphasis*. A section that changes the
surface *and* the radius *and* the type *and* the motion reads as a different website.

Accidental incoherence is many small unrelated differences. Deliberate contrast is one
large difference against an otherwise unchanged vocabulary.

## When sections were built separately

This is the high-risk case — a page assembled over several sessions, or by more than one
agent. Neither will have seen the others' choices.

- **Before adding a section to an existing page, inventory the page first.** The
  existing sections are the specification; the new one conforms.
- **After the last section lands, re-inventory the whole page.** Drift is only visible
  in aggregate, and this pass is what catches it.
- Where an existing page already contains drift, report it rather than matching it —
  copying an inconsistency propagates it.

## Precedence

- `taste` and `no-slop` decide *what* the vocabulary is. This skill only enforces that
  there is **one** of it, and that the user authorises every exception.
- Where a design system exists (`project/design-system/`, or the project's own tokens),
  it *is* the vocabulary. Conform to it; do not invent a parallel one.
- This skill never argues for more variety. "It looks repetitive" is not a finding —
  repetition is the mechanism. Only the user calls for an explosive section.
