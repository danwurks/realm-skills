---
description: "Pull new inspiration from the #design-inspiration Slack channel into the taste library, and refresh reaction scores."
argument-hint: ""
---
# /taste-pull
Sync the taste library from Slack via the Slack MCP connection. Requires the claude.ai Slack connector in this session.
## Steps
1. **State** — Read `taste/slack.json` for `channel_id` and `last_ts`. If the Slack MCP tools aren't available, say so and stop (fallback: `/taste-add` with the inbox).
2. **Fetch** — `slack_read_channel` with `oldest` = `last_ts` (detailed format, includes reactions). Ignore join/system messages, bot messages, and messages without image files.
3. **File each image post** — For each message with images (oldest first):
   - `slack_read_file` for each image (jpg/png/webp/gif, ≤10MB) — view it directly for analysis.
   - **Download the real file:** run `taste/scripts/slack-fetch.sh <file_id> taste/images/<id>.<ext>`. If it prints the path, set `image: images/<id>.<ext>` (a real local file, browsable + committed). If it exits with `no-token` (no `taste/.env` yet), fall back to `image: slack://<file_id>` and note in the report that images aren't downloading until the token is set up (`taste/.env.example`).
   - Write the library entry per the `taste` skill data model: frontmatter (id, date, source: slack, author = Slack display name, type, tags 3–6, score = 1 + thumbsup − thumbsdown from the message's reactions, status: active — or `anti` if score ≤ −1, `image:` per above, `image_permalink`, slack_ts = message ts) and body: "Their words" (message text verbatim), "Analysis" (≤5 bullets), "Steal this" (1 sentence). A message with N images makes N entries sharing "Their words".
   - `slack_add_reaction` with `white_check_mark` on the filed message.
4. **Refresh scores** — For existing entries with a `slack_ts` from the last 30 days, `slack_get_reactions` and update `score`/`status` in their frontmatter if changed.
5. **Save state** — Write the newest message ts back to `taste/slack.json`.
6. **Hand off** — Report entries created/updated in one line each. If 3+ entries changed, run `/taste-sync` and offer to post its ≤5-line digest to the channel via `slack_send_message` (ask before posting).
## Output
New/updated library entries, updated slack.json, and a one-line-per-entry report.
