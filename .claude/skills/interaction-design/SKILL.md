---
name: interaction-design
description: Specs interface behavior end to end — micro-interactions (trigger/rules/feedback/loops), animation principles (duration bands, easing, stagger, reduced motion), loading states (skeletons, progress, optimistic UI), error handling UX (prevention, messages, recovery), feedback patterns (toasts, status, notifications), gesture patterns (thresholds, conflicts), and component state machines. Use when designing or reviewing any interaction, motion spec, loading/error/feedback flow, or UI state model.
---

# Interaction design

Playbooks for speccing how interfaces behave: micro-interactions, motion mechanics, state machines, loading, feedback, errors, and gestures. Every deliverable is a spec an engineer can implement without follow-up questions — numbered sequences, thresholds, durations, and named states, not adjectives.

## Writing a micro-interaction spec

When a single component behavior needs handoff: toggle, like button, pull-to-refresh, swipe action, long-press with radial progress, inline validation, button press with depth/scale.

Structure every interaction in four parts:

| Part | Define |
|---|---|
| Trigger | User action (click, hover, swipe), system event (completion, notification), or condition (time-based, threshold) |
| Rules | What happens once triggered — sequence, conditions, branching |
| Feedback | How the result is perceived: visual (color, size, position), motion, audio, haptic |
| Loops and modes | Repeat behavior, first-time vs repeat, progressive disclosure, change over time |

Deliverable: one block per interaction with name, trigger, rules as a numbered sequence, feedback per channel, duration + easing token, loop behavior, and accessibility notes (keyboard equivalent, reduced-motion variant, non-color state cue).

Quality bar: durations 100–500ms; feedback starts on the trigger frame; the spec answers what happens on cancel, on repeat, and on first use.

## Setting animation durations and easing

Mechanical spec values only. For animation taste and whether to animate at all, defer to emil-design-eng. For vestibular safety, run motion-sensitivity alongside any motion work.

| Band | Duration | Use for |
|---|---|---|
| Micro | 50–100ms | button states, toggles |
| Short | 150–250ms | tooltips, fades, small movements |
| Medium | 250–400ms | page transitions, modals |
| Long | 400–700ms | multi-element choreography only |

Easing assignment: ease-out for entering elements (decelerate), ease-in for exiting (accelerate), ease-in-out for position changes, linear only for continuous motion (progress bars, spinners).

Choreography: stagger related items 30–50ms apart, lead with the most important element, keep one direction per related group, cap total sequence at 700ms. Anything tied to direct interaction stays under 400ms or the UI reads as slow.

Per-animation spec requirements: interruptible/cancellable mid-flight; animate transform and opacity (will-change sparingly) and verify on low-powered devices; define the prefers-reduced-motion variant explicitly (usually opacity-only crossfade or none).

## Mapping a component state machine

When a component or flow has async behavior, multiple modes, or "impossible state" bugs (loading and error rendered at once).

Vocabulary: states (idle, loading, success, error), events (click, submit, timeout, response), transitions (in state A, on event X, go to B), actions (side effects on transition — fetch, toast, log), guards (conditions like isValid, hasPermission).

Steps:
1. List all states.
2. List all events.
3. Define valid transitions — anything unlisted is invalid by default.
4. Name the impossible states this eliminates.
5. Add guards to conditional transitions.
6. Attach entry/exit actions per state.
7. Map each state to a UI representation.

Reference machines:
- Form: idle → editing → validating → submitting → success | error → idle
- Data fetch: idle → loading → success | error; error → retrying → success | error
- Auth: logged-out → authenticating → logged-in → logging-out → logged-out
- Wizard: step1 → step2 → step3 → review → submitting → complete

Quality bar: happy path first, then error states; every state has an exit (no dead ends); one machine per concern; deliver a diagram plus a transition table engineering can test against.

## Designing loading states

Choose treatment by expected wait:

| Wait | Treatment |
|---|---|
| Under 100ms | nothing |
| 100ms–1s | subtle: opacity change or skeleton |
| 1–10s | explicit loading state; determinate progress when measurable |
| Over 10s | detailed progress, time estimate, cancel or background option |

Patterns:
- Skeleton screen — known layout; shapes match real content proportions; shimmer disabled under reduced motion
- Spinner — unknown duration; small and unobtrusive; swap to a determinate bar the moment progress is measurable
- Progressive loading — critical content first, lazy-load below the fold, blur-up images (low-res placeholder to full)
- Optimistic UI — render the expected result immediately, reconcile with the server response, roll back visibly on failure
- Placeholder content — realistic proportions, smooth swap to real content

Transitions: fade content in (never pop), stagger list items 30–50ms, zero layout shift when content lands, preserve scroll position on refresh. Never a blank screen; never multiple competing indicators. Verify on a throttled connection.

## Designing action feedback

Acknowledge every user action at the lowest level that works. Placement hierarchy — prefer the first that fits: inline/contextual next to the action → component-level → page-level toast or banner → system notification outside the current view.

| Type | Examples | Persistence |
|---|---|---|
| Immediate | button state change, toggle response, drag position update, inline validation | during the interaction |
| Confirmation | success toast, checkmark animation, summary of what was done | auto-dismiss 3–5s, with undo window |
| Status | progress indicators, badges (pending/active/complete), activity (typing, uploading, syncing), system health | while relevant |
| Notification | in-app events, badge counts, banner alerts, push for time-sensitive items | until read or dismissed |
| Errors | inline message + summary | until resolved or dismissed |

Channels: visual (color, icon, animation, badge), text, audio, haptic — never color alone (WCAG 1.4.1). Match intensity to importance: no flow-interrupting dialogs for minor confirmations; for reversible actions, undo beats "Are you sure?".

## Designing error handling

Work the hierarchy in order — each layer makes the next cheaper:

1. Prevent — inline validation before submit, smart defaults and suggestions, constrained inputs (date pickers, dropdowns over free text), confirmation dialogs only for destructive actions, auto-save against data loss.
2. Detect — real-time field validation, form-level validation on submit, network and timeout detection, permission/auth checks.
3. Communicate — every message answers: what happened, why (only if it helps), what to do next. Human language, no error codes, never blame the user, never a bare "Something went wrong". Place the message at the source; pick a severity (error / warning / info) and style it consistently.
4. Recover — preserve all user input (never clear a form on error), retry for transient failures, auto-retry with backoff on network errors, undo for accidental actions, alternative paths when the primary is blocked.

Placement by context:

| Context | Treatment |
|---|---|
| Form | inline per-field + summary at top |
| Page failure | full-page error with retry and back options |
| Network | toast or banner with retry |
| Empty results | empty state with suggestions — not an error tone |
| Permission | state what access is needed and how to get it |

Test error paths as thoroughly as happy paths; log errors for debugging.

## Speccing gestures

Vocabulary: tap (select/activate/toggle), double tap (zoom, favorite), long press (context menu, reorder mode, preview), swipe (navigate, dismiss, reveal actions), pinch (zoom), rotate (maps, images), drag (move, reorder, adjust values), pull (refresh).

Thresholds — spec numbers, not adjectives:
- Activation distance: 10–15px before the gesture engages
- Tap vs long press: time threshold, 500ms typical
- Scroll vs swipe: direction lock after initial movement
- Pinch vs drag: disambiguate by touch-point count
- Flick vs slow swipe: velocity threshold
- Cancel zone: return to start point to abort
- System gestures (back swipe, notification pull) always take priority

Feedback during the gesture: visual response the moment it starts, live progress while it moves, threshold indicators (snap points, rubber-banding), completion confirmation.

Non-negotiables: every gesture has a visible non-gesture alternative (button or menu) and works with switch control and voice control; one or two fingers max, no precision timing; undo for destructive gesture actions; visual hints on first use; test one-handed; follow platform conventions and document any custom gesture; reduced-motion variant for gesture-driven animation.
