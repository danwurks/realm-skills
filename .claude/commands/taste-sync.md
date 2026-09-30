---
description: Regenerate taste/TASTE.md from all library entries — the synthesized taste profile.
argument-hint: ""
---
# /taste-sync
Distill `taste/library/` into the user's taste profile. This command owns TASTE.md; nothing else writes it.
## Steps
1. **Read all entries** — Every `taste/library/*.md`: frontmatter (type, tags, score, status, date) and body.
2. **Weight** — weight = score × recency (half-life 90 days: an entry from 90 days ago counts half).
3. **Cluster** — Group recurring attributes across entries (not per-entry): layout habits, type choices, color moods, density.
4. **Write TASTE.md** — Regenerate in full, never append: Strong preferences (≥5 weighted entries), Emerging (2–4), Anti-taste (`status: anti` entries), Directions this maps to (use the `no-slop` direction vocabulary), Aging out (no new supporting entry in 90 days). Each preference cites its entry count. Update the header line (date, entry count, anti count).
5. **Report** — Report what changed since the last sync: new/strengthened/aging preferences, in ≤5 lines.
## Output
A regenerated `taste/TASTE.md` and a short change summary.
