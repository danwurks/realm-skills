---
description: Reload the kit's rules mid-conversation and re-orient to them — for a chat that started before the kit was installed, or one that has drifted.
argument-hint: "[optional: a specific area to re-read, e.g. 'taste' or 'ux']"
---
# /kit
Re-read the kit and adjust behaviour for the rest of this conversation.

A running session loads its configuration once, at start. A chat begun before the kit
was installed — or one that has simply drifted over a long conversation — will not pick
it up on its own. This pulls it back in.

## Steps
1. **Locate the kit.** `readlink ~/.claude/skills` gives `<KIT>/.claude/skills`; take
   `<KIT>` from that. If it returns nothing the kit is not installed on this machine —
   say so plainly, do not pretend the skills are available, and offer:
   cloning this kit's own repository and running `scripts/setup-machine.sh` from it.
     If a clone already exists, its address is `git remote get-url origin`.
2. **Read** `~/.claude/CLAUDE.md` in full. If the working directory is inside the kit,
   read that repo's own `CLAUDE.md` instead — it supersedes.
3. **Read `<KIT>/docs/RULES.md` — this is the important one.** It logs each mistake
   the user has actually hit and the counter-rule written to stop it. Entries are dated:
   **anything newer than the start of this conversation is a rule you have been
   breaking without knowing.** Read those entries first and say which apply to the work
   in hand.
4. **Read the project's own `CLAUDE.md`** if there is one, for project-specific scoping.
5. If an argument was given, also read the matching skill under `<KIT>/.claude/skills/`
   and, for taste work, `<KIT>/taste/TASTE.md`.
6. **Confirm in three lines, then continue the work in hand.** Do not restate the whole
   config back — say what changes about how you are working from here.

## From this point in the conversation
- **Open every response with the address the user-level config names**, if it names
  one, starting with this one and for the rest of the session.
- **UX before UI.** If a build is already in progress and never went through the gate,
  say so and run the ten logic tests against what exists before adding more to it.
- **One visual vocabulary per page**, and a break is the user's call, not yours.
- **Images must fit the content beside them** — open them, never select by filename.
- **Ask** on the three: the register before hunting references, any vocabulary break,
  and anything hard to reverse. Silence is not consent.

## Output
Three lines: where the kit was found, **which rules-log entries postdate this
conversation**, and the one thing you will do differently from here. Then pick the work
back up — this command re-orients, it does not restart the task.
