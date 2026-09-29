---
description: Stage and commit the current work as clean atomic commits — type(scope) + why, staged by named path.
argument-hint: [optional scope or note]
---
# /commit
Turn the working tree into clean, atomic commits following the `dev-conventions` skill. Load `dev-conventions` first.

No ticket tracker here — never ask for a Jira key, never add a ticket trailer.

## Steps
1. **Survey** — `git status` and `git diff` to see everything unstaged. Read it. Never stage a hunk you have not read.
2. **Group into atomic commits** — Split the changes into one logical change per commit (the revert test: each commit must be reversible on its own without dragging unrelated changes). Bundled work becomes several commits, not one. Flag anything that looks unrelated or accidental (a stray `.env`, key, build artifact, `console.log`) and leave it unstaged unless the user confirms.
3. **Per commit** — Stage that group's paths explicitly (`git add <path>` or `git add -p` to split hunks). Never `git add -A` or `git add .` — the one habit worth keeping, because a leaked credential is permanent. Then write the message:
   ```
   type(scope): what changed, imperative

   why this change was needed
   ```
   Pick `feat / fix / refactor / chore` by what the diff does — if unsure, say why you chose the type. Skip the body when the subject genuinely covers the change.
4. **Check** — Right type? Readable subject? Does the body give the reason rather than restate the what? Fix what's off, then commit.
5. **Commit.**

## Branch
Solo repo — committing to `main` is fine. If the change is large, speculative, or worth sitting on, suggest a branch, but do not insist and do not block on it. If the user asks to commit to `main`, just do it.

## Push
Only if asked. `git push` (or `git push -u origin <branch>` for a new branch). Do not push an empty or unreviewed commit.

Expect the hold: `hooks/guard-git.py` stops every push mechanically, even one the
user requested. That is the hook working, not an error. Re-run the same command
prefixed `KIT_APPROVED_PUSH=1` ONLY when the user approved this push in this
session - the marker restates a real yes, it never substitutes for one.

## Output
Report the commits made (one line each: `type(scope): summary`), what was intentionally left unstaged and why, and the branch. If a stack or architecture decision was part of this work, remind the user to record it in `project/STATE.md`.
