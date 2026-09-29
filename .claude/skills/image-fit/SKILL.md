---
name: image-fit
description: Every image must earn its place against the content it sits with. Use whenever a section, card, tile, hero, list row or grid needs an image; whenever a client supplies a folder of assets; whenever writing alt text; and when reviewing built UI for filler imagery. Index the pool before choosing, never place an image you have not looked at, justify each placement in one line, and report gaps instead of substituting the nearest-looking thing.
---

# Image fit

An image is **content**, not a box that needs filling. If it does not say something
about the thing it sits next to, it is filler — and filler is a defect at the same
severity as a broken state.

## The failure this prevents

An agent designs a blog card, needs a picture, opens the client's asset folder, and
takes one — by order, by index, by filename, by whatever is first. The result looks
finished and is arbitrary: a card headed "Settlement discipline" carrying a photo of
a drinks reception. Nobody catches it, because it *looks* fine.

The root cause is mundane: **client filenames carry no meaning.** Real folders are
`IMG_4821.jpg`, `DSC_0042.jpg`, `6D9A5663.jpg`. Selecting from a filename is guessing,
and an agent that guesses will guess plausibly and be wrong.

## The rule

**Never place an image you have not looked at.** You have a Read tool that displays
images. Use it. There is no acceptable version of choosing by filename.

## Step 1 — Index the pool, once, before choosing anything

Open every image in the supplied folder and write down what is actually in it. This
is a one-time cost that makes every later selection a lookup instead of a gamble.

Write to `project/brief/asset-index.md`:

| File | What it shows | Usable for | Not for |
|---|---|---|---|
| `6D9A5663.jpg` | Delegates at a registration desk, lanyards, daylight, wide | Registration, arrivals, networking, membership | Anything about data, policy, or a speaker |
| `6D9A5833.jpg` | Speaker at a podium mid-gesture, branded backdrop, tight | Keynote, speakers, single-voice topics | Group/community themes |

Record for each: subject, framing, orientation, whether there is usable negative
space for an overlay, whether faces are identifiable, and anything that constrains it
(a visible date, a sponsor logo, a season).

**Count the pool against the number of slots before you start.** If there are twelve
photos and fourteen places that need one, that is a finding to raise now, not a
problem to solve silently at placement time.

## Step 2 — Justify every placement in one line

Next to each image, in the code or the spec, state what it shows and why it belongs
*here*:

```ts
image: photo("6D9A5663"), // delegates at registration — card is "Membership"
```

The test: **would a reader who knows the subject find this apt, or arbitrary?**

If the justification reduces to "it is a photo and this needs a photo", the image is
filler. Two honest options: find one that fits, or drop the image and let the layout
work without it. A card with no image is better than a card with the wrong one.

## Step 3 — No silent reuse

The same image against two different topics is a **flag, not a solution**. Sometimes
it is genuinely fine — a texture, a brand shot, a repeated motif — but that has to be
a decision someone made, written down.

> The common shape: a pool one or two images short of the slots, and the same
> photo quietly carrying three unrelated contexts. Each placement gets annotated,
> which is the right habit, and still nobody says **"the pool is two short, here is
> what we need."** That sentence is the deliverable.

## Step 4 — Report gaps, never substitute

When the pool does not cover a topic, say so and ask. Name what is missing in terms
the client can act on:

> "Nothing in the supplied set reads as *data* or *analysis* — the twelve photos are
> all people at an event. The Facts section needs either a photograph of that kind, a
> commissioned graphic, or a deliberate decision to run it type-only. Which?"

Substituting the nearest-looking photo hides the gap and ships it. Raising it costs
one sentence and is the whole job.

## Step 5 — Alt text falls out for free

You described the image in order to select it, so the alt text is already written.
Rules live in `accessible-content`; the short version:

- **Content image** — alt describes what it shows, in context, without "image of".
- **Decorative image** — `alt=""`, deliberately. But first ask whether it belongs at
  all: an image that needs no description is often an image that needs no place.
- Never let the alt text and the placement justification disagree. If the alt says
  "delegates networking" and the heading says "Settlement discipline", the mismatch
  you just wrote down *is* the finding.

## When there is no client folder

- **Ask before generating or sourcing anything.** Stock and AI-generated imagery are
  direction decisions and belong to `taste` and `no-slop`, not to whoever is filling
  the slot.
- Do not ship a placeholder that looks like a real choice. A grey box labelled
  "photo needed: data/analysis, landscape, room for overlay" is honest; a random
  Unsplash landscape is a lie that survives to launch.
- Check `docs/resources.md` first — there may already be a listed asset source that
  fits.

## Reviewing built UI

Every image in scope gets one row: what it shows · what it sits next to · apt or
arbitrary · the alt text · reused elsewhere? Arbitrary placements are findings.
This runs inside `/slop-check`, and filler imagery is scored as slop, because that is
exactly what it is.
