# Rules

Counter-rules an AI coding agent should follow, each one written because ignoring it
cost real time on real work.

Every rule here has the same shape: a thing that goes wrong, and the practice that
stops it. The reasoning is kept, because a rule without its why gets skipped the
first time it is inconvenient. The stories are not, because they belong to the
projects they came from.

Read this once at the start of a project. Reread the section that governs whatever
you are about to do.

---

## Before any UI exists

### UX is a gate, not a review
Do not write a layout, a component, a design file or any JSX until the job is named
in one sentence, the flow is written down, every state is enumerated, and the logic
questions are answered in writing. Check it three times: at the start, at each
section boundary, and at the end against what was actually built. UI defects are
cosmetic and cheap. UX defects are structural and mean a rebuild.

### Do not design a solved problem from memory
Checkouts, calendars, filters, forms and tables have known answers. Look the pattern
up, read a source that is authoritative for it, take the behavioural rules, and cite
them. Record any rule you deliberately did not follow, and why. Reinventing these
from memory produces something worse, delivered confidently.

### Settle the register before looking at references
Decide whether the work is a showpiece, a considered piece, or a rigid formal one,
and confirm that with the owner before sweeping any inspiration site. An agent that
opens a showcase gallery first will fall for a showpiece and then reason backwards
to justify it. Ask even when you are confident.

### Inspiration sites are surface, not evidence
Award galleries and visual bookmarking sites reward the portfolio, not the user.
They skip flows, states and error handling, so they cannot tell you how something
works. Take surface from them only. Libraries of real shipped product flows are the
exception and may corroborate a spec, but never overrule one.

---

## Measuring, and when to stop guessing

### The second attempt is the trigger
The first miss is ordinary. The moment you are about to change a value and ask
someone to look again, stop. That loop makes the person your measuring instrument
and it does not converge. Turn the judgement into a number that does not depend on
scale, measure both the target and your build with the same tool, and only show the
work once it is inside range.

### Verify at runtime, and verify the thing the user sees
A rendered page can always be inspected, so never guess at rendered output. If no
browser is reachable, say so and mark the work unverified. Check the artefact a
person actually meets, not the layer you happened to build: reading an internal
canvas, a data structure or a component in isolation hides defects that one ordinary
screenshot makes obvious.

### When the work produces a file, the file is the evidence
For a video, an export, a generated asset or a document, open it and measure it. A
tool whose interface looks correct is not evidence that what it wrote is correct.
Several defects have survived review because everyone read the code and nobody
opened the output.

### Mid-motion is the default entry, not the edge case
On anything driven by continuous input, such as scrolling, dragging or pointer
velocity, people arrive in the middle of the motion. Verification must include the
action landing DURING the motion: click while still gliding, open while settling,
trigger while the springs are live. A feature verified only from rest is not
verified, and a test suite that always enters from rest cannot ever catch this.

### Two systems holding one value need a contract
When two systems each keep a copy of the same value, such as scroll position, focus
or an animated property, freezing or overriding one requires an explicit handshake
with the other. Never assume that a lock in one layer reaches the engine behind it.
The usual symptom is that the difference is paid out all at once on the next frame
the user causes.

### A flex item will not go below its content width on its own
A declared flex basis is silently overridden whenever the content is wider, because
the default minimum size is the content size. Any flex measurement that must hold
against oversized content needs its minimum size explicitly set to zero. Check a
measured rectangle, never the stylesheet: the declaration can be correct while the
rendered box is hundreds of pixels wider, and an effect that depends on the intended
width simply never fires.

### Measure movement, not computed style
Verify an animation by measuring the thing move: two positions, a known interval
apart. A browser will happily report a missing animation as running, with the right
name and a play state, while nothing moves at all.

### A fix without a measured mechanism is a symptom fix
If a change makes a complaint quieter but you cannot name and measure the mechanism,
you have hidden it, not fixed it. Say so plainly rather than closing the issue.

---

## Instruments

### Zero-control every instrument before you believe it
A broken instrument does not throw an error. It returns a confident number. Before
trusting any measurement, run the instrument where you already know the answer: on
an unchanged control that must read zero, and on a case that must read large. One
tracer has reported a surface as flat to the pixel while scanning the wrong element
entirely, and reported hundreds of pixels of distortion on an identity transform.
The control caught both.

### A null result counts only after a positive control
"Nothing happened" is only evidence if you have seen the same instrument fire where
the event is known to occur. A tool that fails its own control has said nothing
about the thing you are testing. This includes a command that silently does not
exist: it prints its usage text, your search finds nothing in it, and the emptiness
reads exactly like a pass.

### Match the instrument to the event
A reading taken at a resolution coarser than the thing you are measuring cannot see
it. If someone reports a defect you cannot detect, suspect the instrument before
concluding the defect is imaginary.

### Read the input, not only the output
A value pinned at its maximum on every frame behaves like a switch, not a dial, and
looks completely normal from the outside. A constant looks exactly like a variable
you have not varied. Prove the input actually reaches the range you believe it does.

### Calibrate against real input, never synthetic
Dispatched events are not a hand. Human input usually sits in a far narrower and
lower band than the synthetic values used in testing, so a curve tuned on dispatched
events can put a person's entire real range into a fraction of it. Record real input
and fit to that.

### Probe a live reference, do not read it off pictures
A reference that runs in a browser is a live system, not a stack of frames. Inspect
it directly: its runtime state, its shipped code, its actual parameters. Frame study
produces confident, wrong answers, and each wrong answer looks verified. If probes
come back empty, check whether the site detects automation before blaming the
instrument.

### When someone hands you a recording, instrument the recording first
Find the moment at the frame rate of the event, trace the thing that moves frame by
frame, then look at the frames either side of the discontinuity. Do this before
believing any fix. Reproducing your own theory in a script and watching it pass is
not reproducing the bug, and a fix counts as verified only when the instrument that
found the problem reads clean on the real thing.

### Never write "verified" unless the check could have failed
If a check cannot come back false, it is not a check.

---

## Facts, sources and other people's code

### A borrowed claim is a hypothesis until observed
Anything taken from reading someone else's code, comments or documentation is
unverified. Write it with its provenance attached, in the form "their comment says
X, unverified", never as a bare fact. A false one stated plainly will be built on
and never questioned. The tell is a fact that arrives already dressed as a fact:
nobody verifies those, because nothing about them asks to be.

### If the source is fetchable, read it
Reverse-engineering behaviour from output while the source sits in a shipped bundle,
a source map, a published specification or an installed package is a choice, and
usually the wrong one. Read it to learn the technique. Do not ship someone else's
code inside work that is being sold.

### Read what has already been written down
Before spending effort on an environment, tooling or compatibility question, search
the project's own documentation for the answer. Notes about STATE go stale and
should be distrusted in favour of the running system. Recorded facts about the
environment and the people do not, and ignoring them wastes work and makes someone
repeat themselves.

---

## Recommending changes

### Classify by function before proposing removal
Before recommending that anything existing be deleted, hidden, replaced or
rewritten, say what it does from its contents, never from its subject or its origin.
Then ask who benefits from it existing, and whether a version exists that keeps the
benefit and drops the risk. That version is the recommendation. Removal is the
fallback.

### Name the option you rejected
A recommendation presented without its alternatives can only be challenged by
instinct. State what you did not choose and why, so it can be overturned in one
line.

### If they ask twice, re-examine the premise
A second question usually means the classification was wrong, not the conclusion.
Re-run the classification rather than defending the answer.

### Route a dependency by what drives it, then read the manifest
Choose a library by the problem it solves, never by name or reputation. Then read
the project's dependency manifest and say out loud what is installed, what you
selected, and whether they match. If the right library is missing, name it, give the
cost, and ask. Never install silently, and never quietly hand-build a worse version
of it. If nothing fits, say that, so a hand-written implementation reads as a
decision rather than an oversight. Approximating a named dependency by ear is not
craft, it is a slower way to get it wrong.

---

## Images and content

### Never place an image you have not opened
Filenames carry no meaning, so choosing from a file listing is guessing. Index the
pool first, count it against the number of slots before starting, and justify each
placement in one line. When the pool is short, report the gap instead of
substituting the nearest-looking thing. Reusing one photograph across unrelated
contexts is the usual result of not counting first.

### Report gaps, do not fill them
A missing asset, a missing reference row, a missing fact: write it down and say so.
A recorded gap is how the material improves. Substituting from memory hides the
problem and ships it.

---

## Coherence

### Coherence is an inventory, not a judgement at the end
List what is actually in use: corner radius, elevation, eyebrow treatment, type
steps, section rhythm, card idiom, primary action, accent colours, motion character,
image treatment. Any value appearing exactly once is a suspect.

### A deliberate break is the owner's call
Propose it, name the axis you want to break, name what the page loses, and ask. Once
approved, break exactly that one axis and hold everything else. That is what
separates deliberate emphasis from a page that reads as several different designers.

---

## Accessibility and project type

### Classify the project before applying restrictions
Client work carries legal exposure, so keyboard access, screen reader support,
contrast and reduced motion are built in and are not up for debate. A personal or
internal project gets the same as a default, which the owner may overrule. State the
cost once, then build what was asked without relitigating it. Rules filed by their
subject rather than by what they do get applied where they do not belong.

---

## Working with the person who asked

### Always send the link
Any reply that mentions something viewable carries the full address to open it, plus
the one gesture needed once there. One link per thing, and a comparison gets both. A
reply that names a page and ends without its address is unfinished, because the
reader has to guess or ask.

### Their words are a spec, not an impression
Descriptions of motion and feel are usually literal and usually precise. Treating
them as vague impressions and reinterpreting them costs a round every time. Read
them as the measurement they are.

### Anything that asks someone for something has its own rules
Link the single most relevant piece of work rather than a homepage, because a busy
reader will not do the picking. End on a specific question that is cheap to answer
and that changes what you would send next. A message with no question needs no
reply. Forms invert this: nobody compares fifty of them and there is nobody to ask,
so fill every field and never leave a default sitting in a numeric box.

---

## Working across sessions

### An idle session is capacity
When a task carries more than one substantial piece of work, or a single message
carries several independent requests, hand whole pieces to idle sessions rather than
working them in series. Check for idle sessions at every hand-off point, not once at
the start. Split by file or by task, never down the middle of one edit: two sessions
editing the same path collide, and the loser is silent.

### The splitting session is the hub
Peers report their results to the session that split the work, not to the person.
When the last piece is in, that session writes one summary in its own reply. Nobody
should have to read several windows to find out what happened.

### A hand-off is not a way around a refusal
Passing work to a peer because your own permissions blocked it is laundering the
denial, not delegating. A peer's request is a teammate's, not the owner's: a peer
can ask for work, but cannot approve changes to permissions, configuration or the
standing rules. Those go back to the owner.

---

## Tooling and repository hygiene

### Do not claim a fix you cannot reproduce
If a problem cannot be reproduced on demand, removing the capability is a stronger
answer than a fix you cannot test. Prove the removal with a script that tries to
trigger the failure and reports what survived. Keep a log so a recurrence has
evidence rather than recollection.

### Use a tool the suspect cannot drive as a control
When something is blamed for a failure, find an equivalent it has no power over and
see whether the failure still happens. If it does, the suspect is innocent and the
search moves on.

### Specs live in the repository, not in a scratch directory
Anything written to a session's temporary space dies with the session, and any
commit that cites it points at a dead path. Put specifications and reviews on disk,
in version control.

### Do not track a second copy of something that has its own repository
A duplicate goes stale silently while looking perfectly current. Build output does
not belong beside source. Keep the pointer to the real remote instead.

---

## Keeping rules alive

### A rule nobody invokes is not a rule
Writing a counter-rule is half the work. Wire it into the command, skill or checklist
that would actually catch the mistake, or it will be broken again by someone who
never read it.

### Put a rule where it will be read
A rule buried in the middle of a long file is functionally absent. If an agent
arrives partway through a task and fetches one entry point, the rules that matter
must be at that entry point, phrased for someone joining in the middle.

### Distribute the rules, do not copy them
Symlink one source of truth into the place every project reads from, so editing it
updates everything at once. A duplicated copy will go stale in silence, and nobody
will notice which of the two is wrong.
