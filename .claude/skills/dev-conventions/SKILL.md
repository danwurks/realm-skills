---
name: dev-conventions
description: Git defaults for commits, branching, and stack choice. Apply when staging, committing, branching, pushing, or writing any commit message, and when choosing a framework for a new app or page. Covers atomic commits (one logical change each), the type(scope) + why message format, and the "does a stranger need to find this on Google?" stack test (Next.js vs plain React/Vite vs React Native + Expo). These are defaults, not gates — the user overrides any of them on request without argument. Pairs with no-slop for code-level review.
---

# Git conventions

Solo repo, freelance work. Everything here is a **default, not a gate.** If the user
says "just commit it to main" or "skip the body," do that — do not quote this file
back at them. Nothing below blocks a commit.

There is no ticket tracker, no merge request, and no reviewer. Do not ask for a Jira
key, invent one, or add a ticket trailer.

## Atomic commits — one logical change each

The one habit worth keeping. One commit is one reversible decision. Bundling five
unrelated changes under a single `update` means that next month, when a client says
"drop the button effect, keep the hero," you cannot roll back the button without
losing the hero too.

The test: **can this commit be reverted on its own without taking anything unrelated
with it?** If reverting it would also undo something unrelated, it is two commits.

One real 54-file, 1,684-line change, split so it survives a client edit:

```
feat(hero):        fluid layer replaces static artwork
feat(button):      two variants, pixel-fill effect
feat(talent):      paginate showcase, 6 cards per page
fix(talent-card):  skills overflow in narrow column
refactor(ai):      drop duplicated role list
```

Client says "lose the pixel-fill." Revert `feat(button)`. The rest stands.

Stage with intent: `git add path/to/file` for the paths this commit owns, or
`git add -p` to split a file's hunks. Read the diff before staging (`git diff --staged`).

**Prefer named paths over `git add -A`.** Not ceremony — one stray `.env` or key file
pushed to GitHub is effectively permanent, and freelance repos accumulate client
credentials. This is the single default worth being stubborn about.

## Commit message format

```
type(scope): what changed, in the imperative

why this change was needed — the reason, not the diff
```

Scope is the area touched (`hero`, `button`, `talent-card`). Summary says what, in the
imperative, under ~60 characters. Body says *why* — what the diff cannot show. Skip
the body when the subject genuinely covers it.

### Types

| Type | Use for |
|---|---|
| `feat` | something new the user can see or do |
| `fix` | something broken now works |
| `refactor` | cleanup with no user-visible change (UI identical before and after) |
| `chore` | assets, config, dependencies, tooling — no product logic |

### Message quality

- No emoji or sparkles in the subject or body.
- No `WIP`, `stuff`, `update`, `fixes` as a whole message. If you cannot name what changed, the commit is not ready.
- Body explains why, never restates the what. "Change color to blue" above a one-line color diff is noise; "brand refresh — matches the new logo palette" is the reason.
- AI co-author trailers are the user's call, not a rule. Ask once per repo if it matters to them; default to whatever they said last.

## Branching

Solo repo — branch when it helps, commit straight to `main` when it does not.
Branch when the change is large, speculative, or you want to sit on it. Otherwise
`main` is fine. Client repos follow the client's contribution guide, which always
wins; note it in `project/STATE.md`.

## Picking the stack

One question decides the framework for a new app or page: **does a stranger need to
find this on Google?**

| Answer | Stack | For |
|---|---|---|
| Yes, rich public content | Next.js (SSR) | landing, marketing, blog, e-commerce |
| No, behind login | Plain React (Vite) | admin, back-office, dashboard, portal |
| Throwaway prototype | Plain React | quick demos, spikes |
| Mobile app | React Native + Expo | native iOS / Android |

Why it matters: SSR bills per visit and adds build complexity; static files are nearly
free, and a page behind login needs no SEO. Left alone, an AI defaults to Next.js for
everything — so state the constraint out loud: "this page is behind a login" gets you
plain React and a cheaper, simpler build.

Propose the choice with the reasoning, take the user's answer, and record it in
`project/STATE.md` so the reasoning survives. Once the stack is set, hand off to
`vercel-react-best-practices` (React/Next.js) or `vercel-react-native-skills` (RN/Expo),
and `shadcn-ui` for components.

## Where this fits

- Stack and architecture decisions go in `project/STATE.md`, same log Honcho keeps for design-stage calls.
- Code-level review of what a commit contains — dead abstractions, className soup, bare TODOs, `console.log` — is `no-slop`'s Code slop section. This skill governs the git envelope; `no-slop` governs the payload.
- `/commit` runs this end to end: stage intentionally, split into atomic commits, write the message.
