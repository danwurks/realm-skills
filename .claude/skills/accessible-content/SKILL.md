---
name: accessible-content
description: Writes and reviews content for screen readers and diverse reading abilities. Covers alt text for images, charts, and icons; heading structure; link text that works out of context; form labels, instructions, and error messages; readable content and plain-language rewriting; page and content structure for assistive tech (landmarks, reading order, tables); and end-to-end accessible content review audits. Use when creating or auditing any of these, or when copy needs a readability pass.
---

# Accessible content

Playbooks for content that works with screen readers and across reading abilities.

## Writing alt text

Alt text answers one question: if this image disappeared, what information would be lost? Classify first, then write.

| Image type | Action | Example |
|---|---|---|
| Decorative — textures, dividers, images repeating adjacent text | `alt=""` so screen readers skip it | — |
| Functional — linked logo, icon button, image link | Describe the function, not the image | `alt="Search"`, not "magnifying glass icon"; linked logo: `alt="Company name — home"` |
| Informative — photos, illustrations, screenshots that add information | Describe the information conveyed | "Crack running along the bottom edge of the screen", not "Photo of a phone" |
| Complex — charts, graphs, diagrams, infographics, maps | Short alt stating type + key takeaway, plus a longer description or data table in the page text | "Line chart showing website traffic doubling between January and June 2026. Full data in the table below." |

Quality bar:

- Purpose over appearance: "3 unread notifications", not "Red circle with a number".
- Context changes the text. Same bowl photo — recipe page: "Finished risotto in a white bowl"; product page: "Round white ceramic serving bowl, 22cm diameter".
- One sentence, two at most. Never open with "Image of..." — screen readers already announce it.
- Icon with a visible text label → decorative (`alt=""`); icon as the only indicator → the alt carries the meaning.
- Screenshots: describe what matters to the reader ("Settings panel with the notifications toggle switched off").
- Images of text: avoid — use real text; if unavoidable, the alt contains the full text.

## Building a heading hierarchy

Screen reader users navigate by jumping heading-to-heading; headings are also the primary wayfinding for cognitive accessibility.

- Exactly one H1 — the page title, matching the title tag and the inbound link.
- Never skip down a level (H1 → H3 is broken). Going back up (H3 → H2 for a new section) is fine.
- Headings describe content: "Choose a delivery date", not "Step 3"; "Your account settings", not "Section 2".
- Tags define structure, CSS defines appearance. No heading tag just to make text big; no styled text posing as a heading — screen readers can't find fake headings.
- Depth: H1–H3 covers most pages; H4 is the ceiling. Needing H5/H6 means the page should be split.

Reference outlines: dashboard = H1 name → H2 per region (Key metrics, Recent activity, Tasks, Notifications); multi-part form = H1 form title → H2 per step (Personal information, Contact details, Preferences, Review and submit).

Test: someone reading only the headings understands the whole page.

## Writing link text

Screen readers list all links on a page out of context, so every link must make sense read on its own.

- Describe the destination: "View your order history", not "Click here".
- Banned out of context: click here, read more, learn more, here, this, more, link. If writing one, ask "more about what?" — that answer is the link text.
- Same text → same destination, always. Different destinations → different text: "View details for Standard Plan" / "View details for Pro Plan".
- File links state type and size: "Annual report (PDF, 3.1MB)".
- New tab or window: warn in the text — "View the policy (opens in new tab)" — or use a visible external-link icon with alt text.
- In body copy, link the meaningful phrase ("the full list of supported languages"), not the whole sentence. Don't link raw URLs unless the URL itself is the information.
- Image links: the alt text is the link text — describe the action, not the icon.

## Labelling a form

Missing or placeholder-only labels are the most common accessibility failure on the web.

- Every input gets a visible, persistent `<label>` associated via for/id, placed above the input. Placeholder text is never the label: it disappears on typing and many screen readers ignore it.
- Labels say what to enter, format included: "Date of birth (DD/MM/YYYY)", not "Date"; "Email address", not "Enter your info here".
- Required fields: visible "required" or *, with * explained at the top of the form ("* = required"), plus `aria-required="true"`. Better: make most fields required by design and mark only the exceptions — "Company name (optional)".
- Group with `<fieldset>` + `<legend>`: always for radio groups (legend "Preferred contact method"), for checkbox sets sharing one question ("Which topics interest you?"), and for address blocks ("Delivery address"). Multi-section forms get a heading or legend per section plus a progress indicator.
- Help text sits between label and input, one sentence, linked with `aria-describedby`: "Must be at least 8 characters with one number".
- Errors appear directly below the field — never only in a remote banner — linked via `aria-describedby`/`aria-errormessage`, and repeat the field label: "Email address: please enter a valid email".
- Every button has visible text or an aria-label — no icon-only controls without one. Labels never change based on input state and never sit far from their input.

## Writing readable content and plain-language rewrites

People scan before they read — structure for the scan first. Applies to long-form content, help docs, product copy, and policies.

Structure:

- Inverted pyramid: key message in paragraph 1, essential support in paragraph 2, background from paragraph 3 on. Assume the reader stops at any point.
- Chunking limits: one topic per section; one idea per paragraph; 3–4 sentences per paragraph max; 5–7 paragraphs per section max; a heading every 2–3 paragraphs.
- Scannable elements: descriptive headings, bulleted lists for 3+ related items (7 items max per list), tables for comparisons, callouts for critical info, bold sparingly — if everything is bold, nothing is.

Sentences and words:

- 15–20 words per sentence, one idea each. Front-load each paragraph's key point; no paragraph should require the previous one to make sense; transition words (However, For example, This means) carry the flow.
- Active voice ("We'll send your order"), direct address ("You can...", not "Users may..."), concrete values ("in 3 working days", not "shortly").
- Simplest word that carries the meaning. Define specialist terms and spell out acronyms on first use ("Web Content Accessibility Guidelines (WCAG)"). No idioms, no culturally specific references, no double negatives.

| Content type | Rules |
|---|---|
| Instructions | Numbered steps; one action per step; each step starts with a verb (Click, Enter, Select); state what the user sees after each step |
| Policies and legal | Plain-language summary at the top, full text below; define legal terms in context; use examples for abstract concepts |
| Errors and warnings | What happened (specific) + what it means + one clear next action; grade 4–6 reading level, always |
| Data and numbers | Round when precision isn't needed ("about 2 million", not "1,987,453"); add context ("40% — nearly half"); pair complex data with a text summary; don't assume numeracy |

Bar: grade 8 reading level for general content; scanning only headings and bold text yields the key message.

## Structuring a new page for assistive tech

Use when starting a new page, document, or template. Deliverable: a structural specification with six parts.

1. Document outline — heading hierarchy per the rules above; verify headings alone tell the full story.
2. Landmark map — banner (header/branding), navigation, main, complementary (sidebars), contentinfo (footer), search, form (aria-label to distinguish multiple forms). Minimum per page: banner, navigation, main, contentinfo.
3. Alt text strategy — classify every image per the alt table above.
4. Table structure — headers with proper scope, a caption describing the table's content, planned responsive behaviour for small screens.
5. Form labelling plan — label association, fieldset grouping, error association, required-field strategy.
6. Reading order — DOM order matches visual order; content reads sensibly top to bottom; tab order follows reading order; no CSS repositioning away from DOM order.

## Reviewing existing content

Run five passes, then report.

1. Structure — one H1, no skipped levels, headings describe their content.
2. Readability — reading level fits the audience; limits above hold; key information first; scannable via headings, bold, lists.
3. Images and media — alt text per the decision table; complex images have extended descriptions; video captioned; audio transcribed; media players keyboard-accessible.
4. Links — every link works out of context; no generic phrases; file links state type and size.
5. Tables and forms — table headers, captions, responsive behaviour; visible labels, fieldset grouping, error association; no placeholder-only labels.

Report format: 1) Summary — overall accessibility rating. 2) Issue list — each with location, type, severity, fix. 3) Quick wins — fixable in under 5 minutes each. 4) Structural issues — need redesign or rewriting.

| Severity | Meaning |
|---|---|
| Critical | Content is inaccessible to one or more user groups |
| Major | Content is difficult to access or understand |
| Minor | Could be improved but is functional |
