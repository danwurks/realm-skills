---
description: File inspiration images from taste/inbox/ (or a pasted image) into the taste library.
argument-hint: "[optional: note about what you liked — otherwise you'll be asked per image]"
---
# /taste-add
File new inspiration into the taste library. Uses the `taste` skill's data model.
## Steps
1. **Collect** — List images in `taste/inbox/` (jpg/png/webp/gif). If empty and no image was pasted, say so and stop.
2. **Ask why** — For each image, Read it, then ask the one question that matters: "What made you save this?" Use $ARGUMENTS as the answer if provided. Their words are the highest-value signal — keep them verbatim.
3. **Analyze** — Write the entry to `taste/library/<YYYY-MM-DD>-<short-slug>.md` with frontmatter (id, date, source: manual, author, type, tags 3–6, score: 1, status: active, image path) and body sections: "Their words" (verbatim), "Analysis" (≤5 bullets: layout, type, color, mood), "Steal this" (1 sentence — the transferable move).
4. **File the image** — Move it from `inbox/` to `taste/images/<id>.<ext>`.
5. **Remind** — Do NOT touch TASTE.md. Suggest `/taste-sync` if 3+ new entries have accumulated since the last sync.
## Output
One library entry per image, images moved out of inbox, and a one-line list of created ids.
