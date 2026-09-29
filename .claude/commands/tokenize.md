---
description: Stand up design system foundations — tokens, type scale, color, and spacing with adaptive-interface checks.
argument-hint: "[product or brand context, e.g., 'fintech dashboard, brand blue #0044CC']"
---
# /tokenize
Stand up design system foundations.
## Steps
1. **Direction first** — Check `taste/TASTE.md` (`taste` skill) and name the project's visual direction (`no-slop` direction list) before any token locks it in.
2. **Token architecture** — Define token tiers, naming, and structure using `design-systems` skill.
3. **Color** — Build the palette and semantic color mapping using `ui-design` skill.
4. **Typography** — Create the modular type scale using `ui-design` skill.
5. **Spacing** — Define the base-unit spacing scale using `ui-design` skill.
6. **Adaptive check** — Verify color independence and flexible typography (rem units, scaling, spacing) using `adaptive-interfaces` skill.
## Output
Write to `project/design-system/`: `tokens.json` (or `tokens.css`) plus `system.md` covering direction, naming, usage rules, and accessibility notes. Update `project/STATE.md`.
