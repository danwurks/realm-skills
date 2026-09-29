---
name: preflight
description: The launch gate. Runs before ANY project goes online, and again before any major redeploy - the owner's standing order, 2026-09-08, "always run for every single project of mine from now on before it goes online." A fixed sweep of twenty-one pre-launch checks (legal pages, secrets, HTTPS and headers, meta, share card, favicon, sitemap and robots, alt text, image weight and speed, contrast, responsive, 404, broken links, forms, analytics, one clear CTA, dev endpoints gated), each routed to the kit skill that owns it where one does, each verified by evidence against the live thing, never by notes. Trigger on "/preflight", "pre-launch", "launch checklist", "before it goes online", or the first production deploy of any project.
---

# Preflight - the launch gate

Before a project goes online, this sweep runs. All of it. The origin is
millee.md's twenty-item reel plus the owner's own 2026-09-08 sweep of his
portfolio, deduplicated against the kit: seven of the twenty were already
owned by existing skills, two pairs collapse into single checks, and the
sweep itself found two more the reel misses.

## Three laws of the sweep

1. **Evidence, not notes.** The portfolio sweep found two "open" defects
   that had been closed for weeks - a contrast failure killed by a ground
   flip, an alt-text gap killed by a deliberate alt="" decision. Project
   notes go stale; the deployed thing does not. Every check below names
   the evidence that closes it: a curl, a measured ratio, a rendered
   page. A checkbox with no evidence is not a pass. And a NULL is not
   evidence until the instrument has passed its own control: run it where
   the event is known to fire and watch it fire (2026-09-09, "no audio on
   touch" was read off a command that does not exist; the page's own
   `performance.getEntriesByType('resource')` was the instrument).
2. **Route to the owner.** Where a kit skill already owns a check, run
   that skill's discipline - do not restate it here and let two copies
   drift. This file owns only what no other skill does.
3. **Policy items are ASKED, never silently skipped or silently added.**
   Legal pages, consent banners and analytics are the owner's calls. A
   site that collects nothing needs no banner - and that is a feature to
   report, not a box to fail.

## The sweep

| # | Check | Owner | Evidence that closes it |
|---|---|---|---|
| 1 | Privacy policy page | ASK the owner | Exists, or the owner's recorded "collects nothing, skip" |
| 2 | Terms page | ASK the owner | Same as 1; portfolios and brochureware usually skip |
| 3 | Secrets off the frontend | `security-and-hardening` | Bundle grep: only NEXT_PUBLIC-class values; .env never in git history |
| 4 | HTTPS forced + security headers | `security-and-hardening` | curl -I the production URL: HSTS present; frame denial, nosniff, referrer policy set |
| 5 | Cookie consent banner | ASK the owner | Only owed if tracking exists; "no tracking, no banner" is a pass |
| 6 | Meta titles + descriptions | preflight | curl each route class: unique title, real description, canonical |
| 7 | Share card (OG image) | preflight | The image URL 200s on production at 1200x630, designed, not a renderer fallback - then RE-SCRAPE the platforms (LinkedIn Post Inspector), because they cache hard |
| 8 | Favicon set | preflight | favicon.ico + icon + apple-icon all served |
| 9 | Sitemap + robots.txt | preflight | Both 200 on production; held/in-progress routes disallowed; hidden-edition content absent by construction, not by memory |
| 10 | Alt text on images | `accessible-content` + image-fit gate | Every rendered img audited: a written alt, or a deliberate alt="" beside real text - never a CMS/layer-name leftover |
| 11 | Image weight + load speed | preflight | One pass: no served image over ~1MB without a reason, lazy-loading on below-fold plates, and a timing run (Lighthouse when the machine allows; navigation timing minimum) |
| 12 | Colour contrast | `craft-floor` | Measured ratios on the RENDERED page, worst pairs named; AA floor on client work, owner's call recorded on his own |
| 13 | Responsive / mobile | preflight | Key routes rendered at phone and tablet widths, screenshots read by eye; "another layout" decisions go to ux-first, not to CSS patches |
| 14 | Custom 404 | preflight (ux-first test 4 owns the principle) | A garbage URL returns status 404 AND the site's own page, with the way out on it |
| 15 | Broken links | preflight | Full internal crawl: every href and img src 200s; outbound spot-checked, bot-walled hosts labelled unverifiable, not broken |
| 16 | Forms: validation + spam | `security-and-hardening` | Every form validates at the boundary and has spam protection - or the honest N/A: no forms by design |
| 17 | Analytics | ASK the owner | Running, or the owner's recorded "none, on purpose" |
| 18 | One clear call to action | `ux-first` (logic test 2) | The page's one primary action named, everything else visibly below it |
| 19 | Dev endpoints gated in production | preflight | Every dev-only route probed ON PRODUCTION and answering 404; dev CMS-type write routes also refuse cross-origin (the 2026-09-08 lesson: a text/plain POST dodges the CORS preflight) |
| 20 | Dependency audit | `security-and-hardening` | Native audit clean or triaged by reachability, on the committed lockfile |
| 21 | Project addendum | the project's CLAUDE.md | Any per-project gates it names (the portfolio adds: AI-detector gate on shipped copy, edition parity across deploy targets). Read it; do not guess |

## How to run it

Work the table top to bottom against the PRODUCTION target (or the exact
build that will become it). Split the independent rows across idle peer
sessions when the machine has them - the crawl, the image pass and the
audit parallelise cleanly. Collect every row's evidence into one report:
pass with proof, open with what is missing, N/A with the owner's call
quoted. The owner reads ONE summary. Items 1, 2, 5 and 17 end in
questions when unset - ask them together, once.

## What this skill never does

- Never deploys. The gate reports; the owner's word ships.
- Never adds a consent banner, analytics, or legal boilerplate on its own
  judgment - those change what the site collects and says, and they are
  the owner's.
- Never marks a row passed from documentation, a previous run, or memory.
