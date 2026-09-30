# How to write a taste entry

`/taste-add` writes the file for you. It asks one question — **"What made you save
this?"** — and everything else is generated. So the only thing you actually author is
that answer, and it is the entire signal. This page is how to write it well.

---

## The fast path

1. Drop the screenshot in `taste/inbox/`
2. Run `/taste-add`
3. Answer "what made you save this?" in one or two sentences
4. After 3+ entries, run `/taste-sync`

That's it. The rest of this page is about step 3.

---

## Writing the *why*

**The formula:**

> **[the specific element]** + **[what it does]** + **[why that beats the default]**

All three parts matter. "Element" stops it being vague, "does" makes it transferable,
"beats the default" is the actual opinion.

### Weak → strong

| Weak (teaches nothing) | Strong (a rule you can apply tomorrow) |
|---|---|
| "nice clean design" | "the gradient glow is contained to just the price and CTA zone — glow as spotlight, not wallpaper" |
| "love the typography" | "condensed uppercase display sits directly on the photo, no card, no scrim — the image *is* the layout" |
| "great colors" | "near-monochrome, one warm amber used only on live data points — the accent means something instead of decorating" |
| "good dashboard" | "the gauge is a bespoke arc, not a chart library default — a designed data object reads premium, a widget reads admin panel" |
| "clever layout" | "each bento tile is a mini-scene of the real product doing the thing, so the caption barely has to work" |

### The transfer test

**Could you apply this sentence to a completely different project tomorrow?**

If yes, it's a signal. If no, it's a compliment — and compliments produce a taste
profile full of "user likes clean design," which is worth nothing.

### Three shortcuts when you're stuck

- **Name what's *absent*.** "No shadows anywhere, borders do all the containment." Restraint is easier to name than presence, and it's usually the actual decision.
- **Describe the swap.** "They used weight instead of color for emphasis." Taste is mostly what got chosen *over* something else.
- **Say what surprised you.** "I didn't expect the nav to be that small." Surprise marks the edge of your own defaults, which is exactly where taste lives.

Typos and rough grammar are fine — the analysis pass cleans it up. Vagueness is not.

---

## Also file what you hate

Anti-taste is as useful as taste, and faster to write because dislike is easier to
articulate. Same flow — say it's a negative save, and the entry gets `score: -1`,
`status: anti`. The `taste` skill cites these only as counter-references.

> "The three-icon-card row again. Every feature given identical weight means nobody
> decided which one matters."

---

## The generated file, for reference

You don't write this — `/taste-add` does. Shown so you know what your sentence becomes:

```markdown
---
id: 2026-08-10-portline-coaching-dashboard
date: 2026-08-10
source: manual
author: your-handle
type: screen          # screen | component | page | flow | brand | motion | type | illustration
tags: [dashboard, light, data-viz, custom-components, editorial-numerals]   # 3–6
score: 1              # 1 = save, -1 = anti-save
status: active        # active | anti
image: taste/images/2026-08-10-portline-coaching-dashboard.png
---

## Their words
"[your sentence, kept verbatim — this is the part that matters]"

## Analysis
- Layout: …
- Type: …
- Color: …
- Mood: …

## Steal this
[one sentence — the transferable move]
```

**"Steal this" is the payoff.** One sentence, imperative, applicable to a project that
has nothing to do with the reference. If it can't be written, the entry was a
compliment and should be rewritten or dropped.

---

## How many, how often

- **Five good entries beat fifty vague ones.** The profile weights by repetition, so five references that share a real thread produce a sharper direction than fifty scattered saves.
- **Around 5 entries** the profile can name a direction. **Around 15–20** it gets genuinely opinionated.
- Save in **batches** — one sitting of five, rather than one a week. Patterns are visible across a batch and invisible one at a time.
- Run `/taste-sync` after each batch. Re-read what it wrote: if the profile claims a preference you don't actually hold, your *whys* were too vague, not the sync.
- Revisit quarterly. Entries with no reinforcement in 90 days surface under "Aging out" — confirm or drop them.

## Where it goes

`/taste-sync` distills `taste/library/` into `taste/TASTE.md`, which `no-slop` and every
design skill consult before proposing a direction. Nothing else writes `TASTE.md` —
don't hand-edit it.
