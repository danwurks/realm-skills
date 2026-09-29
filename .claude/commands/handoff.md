---
description: Prepare a developer handoff — spec, accessibility handoff, QA checklist, and Figma Code Connect pointers.
argument-hint: [feature, screen, or component to hand off]
---
# /handoff
Prepare a developer handoff package.
## Steps
0. **UX exit gate — blocking.** Run `/ux-audit` over the feature being handed off, live in a browser if it runs (`playwright-cli`). Handing a developer a flow with dead ends, undesigned states or unreachable exits just moves the rework downstream at a higher price. Any finding at severity 3–4 blocks the handoff until it is fixed or explicitly accepted in writing.
1. **Spec** — Write the handoff spec (measurements, tokens, states, assets) using `design-ops` skill. The state list comes from the UX spec's nine states, not from whatever the components happen to implement.
2. **Accessibility handoff** — Document ARIA, keyboard behavior, and compliance decisions using `accessibility-process` skill.
3. **QA checklist** — Build the design QA checklist for implementation review using `design-ops` skill.
4. **Figma** — If Figma is in play, map components to code using `figma-code-connect` skill (load `figma-use` first before any `use_figma` call).
## Output
Write to `project/handoff/<feature-name>/`: spec doc, accessibility requirements, QA checklist, and Code Connect mappings (if applicable). Blocked if the latest `/ux-audit` has an unresolved severity 3–4 finding, or if the latest `/slop-check` in `project/reviews/` failed. Update `project/STATE.md`.
