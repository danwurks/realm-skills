---
description: Prepare a model handover - draft the focused /compact message and kickoff prompt so the next model starts small, dense, and pointed instead of dragging the whole session.
argument-hint: "[target + task, e.g. 'fable: decide the API boundary' or 'sonnet: implement the spec']"
---
# /handover

The economics move behind model switching: a switch only pays off if the next
model starts in a SMALL context. Its premium (or its cheapness) applies to every
token it reads, so the handover is a few thousand tokens of exactly the right
things, never a hundred thousand of everything. This command PREPARES the switch;
the operator performs it.

## Steps

1. **Identify the target and the single task** from the argument. If either is
   missing, ask - a handover with a vague task defeats the point. Sanity-check
   the direction against `CLAUDE.md` section "Model routing" (judgment up,
   volume down) and say so in one line if the task seems mis-tiered.
2. **Distill the compact message.** Include ONLY:
   - the exact decision(s): already-fixed ones as constraints, open ones as the task
   - corrected findings, each with its provenance (measured / read from source / assumed)
   - the file paths that matter, as a plain list
   - standing constraints that bind the next model (repo rules, register, taste
     calls already made, anything on the ask-first list)

   Discard narration, dead ends, superseded drafts, resolved tangents. Target a
   few hundred words. If something was learned that the KIT should keep, note it
   for `docs/RULES-LOG.md` or `project/STATE.md` before it is compacted away.
3. **Draft the kickoff prompt.** One tight paragraph: the single task, its
   inputs by path, what "done" looks like, and what the next model must NOT
   re-litigate.
4. **Print both in copy-ready blocks**, followed by the operator's keystrokes:

   ```
   /compact <paste the compact message>
   /model <target>
   <paste the kickoff prompt>
   ```

5. **Stop there.** `/compact` and `/model` belong to the operator - never claim
   the switch happened, never simulate the target model's output. If the answer
   is "just continue here", continue at the current model.
