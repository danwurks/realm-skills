---
name: inclusive-design
description: Design and review interfaces for cognitive and motor accessibility. Covers keyboard navigation and focus management, touch target sizing, gesture alternatives, multi-modal input, feedback and status design, cognitive load assessment, plain language, wayfinding and navigation, memory load reduction, error prevention and recovery, flow simplification, and inclusive interaction audits. Use when designing or reviewing forms, multi-step flows, navigation, error messages, or any interactive UI.
---

# Inclusive design

Playbooks for interfaces that hold up under cognitive strain and across input abilities. Motion safety (vestibular triggers, flashing, prefers-reduced-motion) lives in `motion-sensitivity`; run it alongside for any motion work.

## Assessing cognitive load

Use on any multi-step process, complex form, dashboard, or decision flow.

Three load types: **intrinsic** (the task itself — can't remove; chunk it, explain terms), **extraneous** (added by the design — confusing nav, unclear labels, clutter; every instance is fixable, eliminate ruthlessly), **germane** (effort on the real goal — the load you want; maximise by removing the other two).

Walk the flow as a tired, stressed, first-time user. Rate every screen:

| Dimension | Low (good) | Medium (review) | High (redesign) |
|---|---|---|---|
| Decisions required | 0–1 | 2–3 | 4+ |
| Items to remember | None | 1–2 | 3+ |
| New concepts | None | 1 | 2+ |
| Steps to complete | 1–2 | 3–5 | 6+ |
| Reading complexity | Plain | Some jargon | Dense/technical |
| Visual complexity | Focused | Moderate | Cluttered |

Any High rating means redesign before launch. Note where you pause or re-read — those are load spikes; classify each as intrinsic or extraneous.

Reductions: progressive disclosure (show only what the current step needs), smart defaults (pre-select the most common option), chunking into 3–5 related items, recognition over recall (show options, don't make users remember), one primary action per screen, secondary actions de-emphasised.

Deliverable: screen-by-screen ratings table, then recommendations sorted by impact.

## Writing plain language

Use for interface copy, errors, instructions, onboarding, help, legal/medical content. Plain language is clear, not dumbed down.

Five tests every string must pass:

1. **5-second test** — understood on first read within 5 seconds, or rewrite.
2. **Jargon test** — would someone outside the industry know every word? Replace or define inline.
3. **Action test** — is the next step unambiguous? "Save and continue" beats "Next"; "Delete this item" beats "Remove".
4. **Passive voice test** — passive hides the actor. "Your application has been rejected" → "We could not approve your application. Here's what to do next."
5. **Length test** — 15–20 words per sentence max (flag anything over 25), one idea per sentence, one instruction per paragraph.

Swap list: utilise→use, facilitate→help, implement→set up, terminate→end, prior to→before, in order to→to, at this point in time→now, in the event that→if, with regard to→about, commence→start, sufficient→enough, subsequent→next, indicate→show, modify→change.

Reading-level targets: general public grade 6–8; buttons, labels, and error messages grade 4–6 always; specialist audiences still get short sentences with terms defined; critical content (medical, legal, financial) gets a plain-language summary alongside the full text.

Review method: read every string aloud (stumbles reveal complexity), count sentence words, flag jargon/acronyms/idioms, verify each instruction is single-action. Deliverable: table of original | issue | rewrite; when writing fresh copy, state the reading level achieved.

## Designing wayfinding and navigation

Users must answer three questions in under 1 second each: Where am I? Where can I go? How do I get back? Anything slower is a navigation failure.

- **Signpost** — breadcrumbs in hierarchies deeper than 2 levels; step indicators ("Step 2 of 4"); active section highlighted; page title matches the link text that led there.
- **Minimal path** — important actions within 1–2 clicks of any screen; breadth over depth; "Back to [last meaningful location]" always available.
- **Multiple routes** — search AND browse AND shortcuts to all important content; never one forced path; "jump to" links on long pages; recently visited sections reachable.
- **Chunking** — headed sections of 3–5 paragraphs max; table of contents when a page exceeds 3 screens; related form fields in labelled fieldsets.

Checklist: descriptive page titles; navigation identical in position and order on every page; current location visually indicated; breadcrumbs or back links in hierarchies; multi-step flows show progress and allow backward movement; search available on every page; headings describe content, not categories; link text names the destination (no "click here").

## Reducing memory load

Working memory holds roughly 4 items. If the system can remember it, the user shouldn't have to. Apply to any flow spanning screens or sessions.

- **Persistent context** — chosen product/plan/date visible on every step; running totals in commerce; search query visible in results; summary sidebar of completed steps.
- **Forward carry** — never re-ask what the system already knows; pre-fill from earlier steps and prior sessions; if they picked "Business", don't ask "Personal or Business?" again.
- **External memory aids** — compare features, recently-viewed lists, copy-to-clipboard for reference codes, print-friendly views.
- **Save and resume** — auto-save any flow longer than 3 steps; show when last saved; send a resume link for abandoned tasks; never force a restart when a session expires.
- **Chunked process** — 3–7 labelled steps, one decision per step, movement in both directions, a review screen before final submission.

Audit questions: must the user remember anything across screens? Manually transfer anything (write down a code)? Can they leave and return without loss? Does the system re-ask known information?

## Preventing errors and designing recovery

Use on forms, checkout, account creation, settings — anywhere mistakes happen.

Prevention:

- **Forgiving input** — accept every plausible date and phone format, auto-format as the user types, match case-insensitively, trim whitespace, show a format example beside the field ("e.g., 15/03/2026").
- **Smart defaults** — pre-select the most common option; pre-fill known information (address from postcode); default irreversible settings to the safest choice.
- **Progressive validation** — validate on blur, show success states on completed fields, never validate mid-typing, never clear the user's input on error.
- **Minimal demands** — ask only what you strictly need; mark optional fields, not required ones (if a field isn't needed, delete it).

Every error message answers three questions — what happened (specific), why (plain language), what now (one clear action):

| Bad | Good |
|---|---|
| "Invalid input" | "Please enter a date as DD/MM/YYYY — for example, 15/03/2026" |
| "Error 403" | "You don't have permission to view this page. Contact your team admin to request access." |
| "Password does not meet requirements" | "Your password needs at least 8 characters and one number. You have 6 characters." |

Never blame ("You entered an invalid email") — state neutrally ("We need a valid email to continue") and offer an alternative path.

Recovery: undo available for at least 10 seconds after any action; destructive confirmations carry useful detail ("Delete 'Project Alpha'? This removes all 23 files. This cannot be undone."); preview before consequential submissions; auto-save long flows; alternative path when the primary fails ("Can't upload a photo? Describe what you see instead.").

## Speccing keyboard navigation

Non-negotiable foundation: every task completable by keyboard alone. Serves motor disabilities, switch and mouth-stick users, screen reader users (keyboard is their primary input), and power users.

Three rules:

1. **Reachable** — every interactive element focusable via Tab; focus order matches visual reading order; nothing available only on hover or click; custom components get explicit tabindex and key handlers.
2. **Visible** — focus indicator on every element: minimum 2px solid outline at 3:1 contrast against the background; never `outline: none` without a visible replacement; one consistent style throughout.
3. **Managed** — modal opens → focus moves inside; modal closes → focus returns to the trigger; content deleted → focus moves to a logical neighbour; trap focus only inside open modals.

| Component | Keyboard behaviour |
|---|---|
| Menus | Tab between top-level items; arrows within a dropdown; Enter/Space activates; Escape closes and returns focus |
| Tabs | Tab lands on the active panel, not each tab; arrows switch tabs; Enter/Space activates |
| Modals | Focus to first focusable element on open; Tab cycles inside; Escape closes; focus returns to trigger |
| Forms | Logical Tab order; errors focusable or announced; Enter submits; required state never colour-only |
| Drag and drop | Keyboard alternative required: move up/down buttons or arrow-key reordering, position announced |
| Carousels | Arrows between items; visible prev/next buttons; autoplay pauses on focus or hover; announce "Item 2 of 5" |

Every page gets a "Skip to main content" link as the first focusable element, visible on focus; add "Skip to search" or "Skip to footer" on long pages.

## Sizing touch targets

| Context | Minimum | Recommended |
|---|---|---|
| Touch (mobile/tablet) | 44×44 CSS px | 48×48 (Material); 56×56+ for high-stakes or frequent targets |
| Pointer (desktop) | 24×24 CSS px (WCAG 2.2 SC 2.5.8 AA) | 32×32 for common actions; larger for destructive ones |
| Gap between adjacent targets | 8px | 12–16px for frequent side-by-side elements |

WCAG 2.2 AA only mandates 24×24 — treat 44×44 as the practical floor on touch anyway.

- Hit area larger than the visible element: pad icons; make the whole list row tappable, not just its text; link text long enough to form a real target ("Read the full report", not "here").
- Trigger on touch-up, not touch-down, so users can slide away to cancel.
- Destructive actions: never adjacent to common actions; require a deliberate second tap or confirmation.
- Avoid double-tap and long-press-only interactions — unreliable with tremor.
- Keep mobile primary actions in the thumb zone (bottom half of the screen).
- Never disable pinch-to-zoom; pair sliders and colour pickers with text inputs; add search to long dropdowns.

## Guaranteeing input alternatives

People use keyboards, pointers, touch, voice, switches, eye tracking, head pointers, and sip-and-puff — often combined. Rules: every action works via keyboard AND pointer at minimum, voice where practical; gestures are shortcuts, never gatekeepers.

| Gesture | Required alternative |
|---|---|
| Swipe to delete / navigate | Visible delete button / prev-next buttons |
| Drag to reorder | Move up/down buttons or numbered input |
| Pinch or double-tap zoom | +/− buttons plus zoom-level text input |
| Two-finger rotate | Rotation buttons or degree input |
| Two- or three-finger scroll/swipe | Single-finger scroll, visible scrollbar, or button |
| Shake to undo | Visible undo button, always |
| Tilt / device-motion controls | On-screen directional controls; manual toggle for rotation |
| Long press for menu | Visible menu trigger (⋮) |
| Press-and-hold to record | Toggle start/stop buttons |
| Draw a shape | Pick from a shape menu |

Build the button version first, layer gestures on top — progressive enhancement guarantees the alternative exists. Hint gestures on first use ("You can also swipe to delete"), document them in settings, and let users disable or remap them.

Text and selection: never disable paste (password managers and assistive tools depend on it); support dictation, autocomplete, and OCR/scan for reference codes; make radio and checkbox labels clickable; type-ahead in long dropdowns; a text field beside every date picker; hex/RGB input beside colour pickers; address search beside map selection; text description as an alternative to drawing.

## Designing feedback and status

Never communicate status through one sense alone — every message works through at least two channels, and screen reader announcement is a mandatory third.

| Type | Visual | Text | Sound | Haptic |
|---|---|---|---|---|
| Success | Green tick | "Saved successfully" | Confirmation tone | Short vibration |
| Error | Red field highlight | Specific message | Alert tone | Double vibration |
| Loading | Spinner/bar | "Loading..." | — | — |
| Warning | Yellow banner | Warning text | Optional | Optional |

Colour is never the sole indicator — red/green is invisible to 8% of men; pair colour with icon + text or pattern/position, and check that the greyscale render says the same thing.

Timing: pressed state within 100ms of a button press; loading indicator within 1 second of submission; success message within 2 seconds of completion; errors highlight the specific field, not just a banner at the top.

Transient vs persistent: toasts only for non-critical confirmations, shown at least 5 seconds, with a way to review missed messages; errors and anything actionable stay inline and never auto-dismiss. Announce updates with aria-live="polite" (non-urgent) or "assertive" (critical); tie errors to fields with aria-describedby; a moved kanban card needs a text announcement, not just a new position.

Progress: known duration → percentage or step count; unknown → spinner plus text ("Loading your results..."); over 10 seconds → estimated time remaining; very long → background processing with a completion notification.

## Designing a new flow inclusively

Build inclusion in from the start, not retrofitted:

1. List every interaction point (tap, text entry, selection, navigation, gesture, prompt response).
2. Assign at least keyboard, pointer/touch, and — where practical — voice to each; flag any single-input interaction.
3. Define the keyboard layer: tab order, focus management for modals/dropdowns/dynamic content, skip links, documented shortcuts.
4. Annotate target sizes, spacing, and thumb-zone placement.
5. Specify feedback per interaction: visual state, screen reader announcement, and success/error/loading behaviour using colour + icon + text.

Deliverable: flow diagram with interaction points marked, input-method matrix (task × keyboard/pointer/touch/voice), focus order map, target size annotations, feedback spec per interaction.

## Simplifying an existing flow

1. Run the cognitive load table; classify high-load elements as intrinsic or extraneous.
2. Rewrite all text to grade 6–8 (grade 4–6 for critical strings), 15–20-word sentences, single-action instructions.
3. Cut interface load: one primary action per screen, remove decorative elements that don't serve the task, flatten navigation to the minimum effective depth.
4. Present before/after with an annotated change log so the team can adopt changes selectively.

## Running an inclusive design audit

Combine cognitive and interaction passes over the same flow:

1. **Context** — who uses this, their likely cognitive state, the stakes.
2. **Keyboard pass** — complete every task keyboard-only; log unreachable elements, focus order breaks, invisible focus, traps, missing skip links.
3. **Touch/pointer pass** — measure every target against the size and spacing table; log precision-dependent interactions.
4. **Alternatives pass** — verify at least two input methods per interaction; log disabled paste and gesture-only features.
5. **Cognitive pass** — load table per screen, plain-language tests, wayfinding checklist, memory audit questions, error message anatomy.
6. **Feedback pass** — colour-only indicators, missing announcements, auto-dismissing errors. Run motion-sensitivity here too.

Report format: executive summary with overall rating and top 3 issues; input-method matrix; screen-by-screen issue table with severity; fixes ranked by users unblocked versus effort; population impact per issue.

Severity: **critical** — a task cannot be completed with a common input method or by users with cognitive disabilities; **major** — significant difficulty or confusion; **minor** — friction without blocking.
