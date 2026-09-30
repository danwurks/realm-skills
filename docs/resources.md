# My resources

Tools, sites, and references I trust. Claude checks this list when a task needs an
external resource and suggests one **only if it genuinely fits the need** — not by
default. Add a row whenever something proves worth keeping; include the *use when* so
the suggestion is targeted, not generic.

| Resource | What it is | Use when |
|---|---|---|
| [Wannathis — Abstract 3D vol.2](https://abstract-vol2.wannathis.one/) ([vol.1](https://abstract.wannathis.one/) · [main site](https://wannathis.one/)) | 54 crafted abstract 3D elements — foil, chrome, inflatable material language, same family as the noth.in object style in `taste/library/`. Vol.2 full pack is **$39** (the page's "free" is a demo zip); genuinely free items live under the main site's Freebies. Licence terms on wannathis.one — settle before a client ship. | A page needs playful CG objects for a hero, preloader, or brand moment and there's no budget/time for custom renders (matches the `2026-08-11-nothin-3d-objects` taste entry) |
| **The UI reference ladder** — [Awwwards](https://www.awwwards.com/) → Mobbin → [Dribbble](https://dribbble.com/) → [Savee](https://savee.it/) → [Behance](https://www.behance.net/) | My standing order for visual references. Awwwards for whole sites and scroll choreography, Mobbin for real shipped flows, Dribbble for screen-level surface, Savee for art direction and editorial, Behance for case studies and corporate work, . | Hunting a visual direction — **but run the WOW gate in the `taste` skill first and ask me to confirm the register.** Surface treatment only; never take flow or UX from these (Mobbin excepted, below). |
| Mobbin | Real mobile/web UI screenshots, captured screen-by-screen through whole flows of shipped products (MCP — needs authorising in claude.ai connector settings) | Rung 2 of the ladder, and the **only** rung that is fair evidence for flow as well as surface, because these are products in production rather than portfolio shots. Use it to corroborate a UX spec, never to overrule one |
| [motionsites.ai](https://motionsites.ai/) | Motion reference for web | A motion direction is needed — **only after `emil-design-eng` has agreed motion belongs at all.** Answers *how*, never *whether* |
| **TypeWhisper** ([repo](https://github.com/TypeWhisper/typewhisper-mac), GPL-3.0, Swift, macOS 14+) | Speech-to-text and AI text processing for the Mac. Runs **on-device models so audio never leaves the machine**, or optionally cloud APIs (Groq, OpenAI, xAI) for speed. Transcribes, then reshapes the result through reusable workflows. A dictation input method; v1.6 current at the time of writing, actively maintained. | **Interview and call transcripts.** `design-research` covers summarising interview transcripts, diary studies and usability sessions but has no tool for *producing* them — this is that tool. Also voice notes into `project/` docs while watching a running page. **Use the local models for anything under client NDA**; the cloud providers send audio off-device, which is a confidentiality decision, not a speed one. |

| **Framework7 Icons** ([repo](https://github.com/framework7io/framework7-icons), MIT) | The standing icon set for my projects, picked 2026-09-08. SF Symbols aesthetic drawn legally: Apple's license confines the real SF Symbols to Apple-platform software, and a public site - especially a hiring surface - is not one. F7 is the same look, MIT, 56x56 grid, by Vladimir Kharlampidi. | Any project needs icons. Vendor the needed glyphs as inline SVG paths with their F7 names kept (the portfolio's `components/icons/icon.tsx` is the worked pattern); never ship the whole ligature font for a handful of icons, and NEVER ship actual SF Symbols on the web. |

<!-- Add real rows above this line. Keep "use when" specific. Drop anything the team stops reaching for. -->
<!-- Checked 2026-08-23 (re-verified, was 2026-08-11): abstract-vol3.wannathis.one still does not resolve — no vol.3 yet. -->

