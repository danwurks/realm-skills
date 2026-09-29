---
description: "One-shot taste routine: pull new inspiration from Slack, analyze, regenerate the profile, commit, and push to GitHub."
argument-hint: ""
---
# /taste-routine
The whole taste loop in one command. Run it daily (or whenever). Requires the claude.ai Slack connector in this session.
## Steps
1. **Pull** — Run the `/taste-pull` flow: read new `#design-inspiration` messages since `taste/slack.json` last_ts, file each image post as a library entry (verbatim words + analysis + "steal this"), ✅ each filed message, refresh recent reaction scores, advance last_ts.
2. **Sync** — If any entry was created or changed, run the `/taste-sync` flow: regenerate `taste/TASTE.md` (weighted score × 90-day half-life). If nothing changed, skip and say so.
3. **Push** — Stage everything under `taste/`, commit as `taste: routine sync <YYYY-MM-DD> (<n> new, <m> updated)`, and `git push`. If nothing changed, do not create an empty commit.
4. **Digest (ask first)** — If ≥3 entries changed, offer to post the `/taste-sync` change summary to `#design-inspiration` via `slack_send_message`. Never post without confirmation.
## Output
One-line report: N new entries, M rescored, profile updated yes/no, pushed yes/no. If the Slack connector is missing, say so and stop (fallback: `/taste-add` from `taste/inbox/`).
