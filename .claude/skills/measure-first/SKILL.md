---
name: measure-first
description: How to converge on a target you can only judge by eye — matching a reference site, hitting a look the user has in their head, chasing "it's close but not quite", or fixing a defect only they can see. Build an instrument and take the reading yourself instead of shipping a guess and waiting to be told. Covers instrument controls, verifying the artefact the user actually sees, reading the source when the source exists, probing a reference's live WebGL runtime instead of trusting frames, recording the user's own input on the reference and replaying the identical train into ours until the overlays agree, and the tell that separates a wrong NUMBER from a wrong MECHANISM. Use whenever a second attempt at the same thing is about to be made. This skill NEVER picks a direction — taste and no-slop own that and always win.
---

# Measure first

**The person reviewing the work is not a measuring instrument. Stop using them as one.**

This skill exists because of a loop that really ran six times: build the effect, the
user records their screen, sends the file, says "not quite", a number gets adjusted,
repeat. Six rounds, and the numbers were never the problem. Recording every attempt
and sending it back to be debugged is the user doing the measuring, which is the job
they asked for. Find a way to view the work yourself, compare it to the reference
yourself, and keep doing that until it is right.

That is the whole brief. Everything below is how.

## Precedence

Subordinate to `taste` and `no-slop`, exactly as `craft-floor` is. This skill answers
**"have we got there yet"**, never **"where should we be going"**. Never cite it to
argue for a palette, a typeface, a layout or a direction. Once the user has named the
target, this is how you reach it without spending his afternoon.

Pairs with `craft-floor` (which holds the thresholds) and extends the artefact rule in
`docs/RULES-LOG.md` — *when the thing built produces a file, the file is the evidence*.

## When this fires

The trigger is **the second attempt**. The first miss is ordinary. The moment you are
about to change a value and ask him to look again, stop and build the instrument
instead.

Also fires on: matching a reference site · "it's close but not quite" · a defect only he
can see · any target with a number attached (contrast, frame budget, weight, timing).

---

## 1. Turn the judgement into a number that survives two screenshots

"Does it look like theirs?" cannot be answered. Find the quantity that can, and make it
**scale-invariant**, because his recording and your screenshot are never the same size.

In one case the judgement "the bend is too strong" became *how far does the plate's
edge deviate from the straight line joining its ends, as a percentage of the plate's own
width*. Percentages of the thing's own size compare across any two captures. Absolute
pixels do not.

Then the argument ends:

| | side bow |
|---|---|
| theirs | 1.15% · 1.19% · 1.78% |
| ours, before | 2.73% and an 11.9% top edge where theirs is 0.0% |

Two eye-based settings of that number had already been shipped and rejected — one far
too timid, one a full fisheye. **No eye-based setting was ever right; no measured one
was ever wrong.**

## 2. Give every instrument a control, before you believe a single reading

A broken instrument does not error. It returns a confident number, and a confident wrong
number is worse than no number, because it gets built on. Every instrument in that
session lied at least once:

- An edge tracer reported the reference's top edge **"flat to the pixel"** on every
  frame. It was starting its scan inside the *neighbouring* plate, 20px away, and never
  moving. Exactly 0.00px of bow, six times, read as a finding.
- The same tracer reported **376px of bow on an identity transform** — a shader that
  provably does nothing — because the plate's own dark banner is indistinguishable from
  a black background.
- An edge trace caught the browser **scrollbar** and called it the plate.

**Run the zero control first.** Set the effect to nothing and confirm the instrument
reads nothing. Then set it to something known and confirm it reads that. In the same
session, `split.js` measured the reference's at-rest frame at **exactly 0px** of channel
separation — that control is what made its 1px reading on a moving frame trustworthy.

The tell for a broken instrument: **a suspiciously round result**, an exact zero, or the
same value repeating where real data would jitter.

## 3. Verify the artefact the person actually sees

Not the layer you built. Not the component. The composited, shipped thing.

Every check in that session read the WebGL canvas directly — a surface nobody ever sees
on its own. It hid a chromatic split that was **four times too strong**, because on the
canvas alone there was nothing to judge it against. One screenshot of the ordinary page
mid-scroll made it obvious.

- Built a page? Screenshot the viewport, not the component.
- Built a video, an export, a generated asset? Open the file and measure it.
- Built a layer that composites? Composite it.

## 4. Read the INPUT, not just the output

The single worst bug in that whole effort was invisible for four rounds: the distortion
strength was **pinned at its maximum on every frame**, at every scroll speed. The effect
was a switch — full, or off. Nobody could see it because everyone was looking at the
output, where a constant looks exactly like a variable you have not varied.

It took one call reading the intermediate value out of the running page.

> **A number that never varies cannot be tuned. If you are adjusting a value, first
> prove it is reaching the range you think it is.**

Build the debug handle. A dev-only `window.__thing.readX()` costs one line and ends this
class of bug permanently.

## 5. Calibrate against a recording of the person, never against synthetic input

Then that fix was recalibrated — against dispatched wheel events firing every 10ms,
which drive a smooth-scroll library to 300–500px per frame. **No hand does that.**
Measured off the user's own screen recording:

| | px per frame |
|---|---|
| his peak, one or two frames in eleven seconds | 232 |
| his 90th percentile | 80 |
| **his median while moving** | **24** |

His entire range sat in the bottom sixth of the curve that had been built for him. At his
median the effect came out under one pixel. "i think you broke the animation." Nothing
was broken; it was scaled for a gesture no hand makes.

**A dispatched event is not a hand.** If he sent a recording, the recording contains his
real speeds, his real viewport, his real hardware — measure them out of it.

## 6. His words are a specification, not an impression

Three times his phrasing turned out to be a literal description of a specific term in the
reference's shader, and each time treating it as a vague feeling to be reinterpreted cost
a round:

| what he said | what it was |
|---|---|
| "i feel like it got a bit closer to my face" | displacement in depth under perspective |
| "the tube actually moves up and down smoothly, it doesnt stay in the same place" | a `+ uTime * 0.8` drift term |
| "it has its position on scroll down and up, but once i start to scroll down again it changes" | slow drift, with amplitude gated on scroll |

He is describing what he sees, accurately, in his own vocabulary. **Take it literally
first and only reinterpret when the literal reading fails a measurement.**

## 7. When plausible attempts fail in a row, the error is structural

Three consecutive versions failed on the *family* of thing, not on its constants. The
tell is a sentence you can actually check:

> **"No value of these constants could reach the reference."**

If that is true, tuning is wasted and has been for a while. In that session: a radial
barrel bowed the top edge 11.9% of height where the reference bows 0.0% — it had a
vertical term at all, and no setting removes a term.

Symptom to watch for: each round fixes the last complaint and produces a new one of
equal size. That is not convergence, it is a wrong model being pushed around.

## 8. Read the source when the source exists

Five rounds were spent inferring a shader from screen recordings. The shader was a
string literal in a public JavaScript bundle the whole time. **The user suggested looking,
not the session.**

Reverse-engineering from output when the source is fetchable is a *choice*, and usually
the wrong one. Check first: shipped JS, source maps, a published spec, the actual
stylesheet, `node_modules`, the tool's own docs.

**Reading it to understand the technique is normal engineering. Shipping someone else's
code inside work that is being sold is not**, and on client work that is a real exposure.
Take the mechanism and the measurable constants; write the implementation.

## 9. Before declaring a contradiction, compute the magnitude

Their shader had a vertical term. My measurement said their top edge was pixel-flat.
That looks like a contradiction and would have sent the next round somewhere wrong.

It wasn't one: the term's maximum is 0.375% of height — about 1.5px on that plate, below
the resolution of the trace. Both were right.

**"My measurement disagrees with the source" is not the same as "one of them is wrong."**
Work out how big the disagreement should be before treating it as one.

## 10. Write the wrong versions down, where the next person will hit them

Not in the chat. In the repo, next to the thing:

- Each wrong version, what it looked like, and **why no tuning could have saved it**
- Every constant with its history — the reference's channel split was wrong five times running
  (0.002px, 39px, 2.5px, 6.5px, 3px) and the list is what stopped a sixth
- The instruments, and the specific way each one lied

A conversation is not durable and a summary drops the detail that mattered. The failed
attempts are the most valuable thing produced, and they are the first thing lost.

## 11. The reference's runtime beats the reference's pixels

Two frame studies "confirmed" a reference homepage used a fisheye lens; a barrel pass was
built, measured and shipped on that confirmation. Then the reference was loaded in the
automated browser with its WebGL context hooked before its bundle ran (shaderSource,
uniformMatrix4fv, bindFramebuffer), and ten minutes settled what two days of frames
could not: every vertex shader stock three.js, zero offscreen passes per frame, one
rectilinear camera whose exact fov sat in the projection matrix (fov = 2*atan(1/P[5])),
and the ring geometry recoverable to two decimals by circle-fitting the translations
the matrix uploads carry each frame.

If the reference runs on this machine, hook it. What a probe returns is a fact; what a
frame suggests is a reading. And "verified" is only worth writing when the check that
produced the word could have come back false: both frame "verifications" would have
confirmed whatever was already believed.

When the probe returns NOTHING, suspect the reference before the probe: one reference's bundle
checks navigator.webdriver and the user agent for "headlesschrome" and skips its
entire loader for automated browsers, so three runtime probes of their entrance came
back empty while the loader played fine in the user's own browser. An empty result from a
headless session is a tell to search the shipped JS for "webdriver" and, if it is
there, to read the component's source instead: its class names locate it in seconds
(grep the CSS for the same prefix), and the constants come out exact where frames had
drifted three builds running.

## 12. His hand, on their page

A dispatched event is not a hand (rule 5), but the real thing can be captured at the
source. A ten-line recorder pasted into the console of HIS browser on THEIR site logs
every wheel event and, per frame, every object position their WebGL uploads carry,
then downloads itself as a file when he stops scrolling. His trackpad's real delta
train through their real response: the whole transfer law fell out of one 25-second
free scroll. Idle, gain per px, SIGN, lag, decay half-life, saturation, each a fitted
number with an R^2 attached. (His "messed up" free-form session beat the scripted
gestures he was asked for: what matters is his hand and their response on one clock,
not tidy conditions.)

Check the automated browser before promising him a window: ps aux, look for
--headless. One session asked him five times to look at a window that could not
exist. His own browser is always visible; the console paste is the instrument that
reaches it.

## 13. Same input, both engines, one overlay

A law fitted from the reference is still only a hypothesis about ours. Close the loop:
replay the identical recorded input train against our build, extract our response with
the same script, and overlay the two series on one clock. Correlation and residual are
the finish line: 0.986 (spin) and 0.993 (ride) ended one long motion chase in one
calibrated round, where six eye-rounds had never converged. Calibrate by making the
two FITS agree, fitted the same way on both sides; comparing our configured constant
against their fitted one smuggles the fitting method's own attenuation into the gain.

Keep the recorded train and the reference's response series in the project repo
(project/research/<ref>-<date>/), and leave the recorder wired (?debug&rec plus a
dev-only sink route): the next "not exactly the same" is then one scroll away from
being a number.

---

## The loop, in order

1. Second attempt about to happen? Build the instrument instead.
2. Pick a scale-invariant quantity.
3. Zero-control the instrument. Do not skip this.
4. Reference runs in a browser? Hook its runtime before trusting any frame reading.
5. Measure theirs. Measure yours. Same tool, same units.
6. Measure your own inputs and intermediates, not only the output.
7. For motion: record his hand on theirs, fit the law, replay the train into ours,
   and converge on the overlay.
8. Check the artefact he actually sees.
9. Difference structural or numerical? Structural means stop tuning.
10. Fix, re-measure, and only then show him.
11. Write down what was wrong and how you know, next to the thing.

## What to say when reporting

Lead with the number and its provenance. "Their bow is 1.15–1.78% of width across three
frames; ours was 2.73% and is now 1.48%" is worth more than a paragraph of description,
and it lets him disagree with something specific.

State plainly when an instrument was wrong and what it cost. He would rather know the
measurement was broken than be handed a clean story.
