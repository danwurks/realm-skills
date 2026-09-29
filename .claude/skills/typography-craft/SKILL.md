---
name: typography-craft
description: The technical craft of shipping real typography on the web — variable font axes, self-hosting and subsetting, loading strategy, killing CLS with fallback metric overrides, fluid type scales with clamp(), OpenType features, and web font licensing for paid client work. Use when choosing, licensing, self-hosting, loading, or tuning a typeface, when type causes layout shift, or when setting a type scale. Execution only — which typeface fits the project is a direction call owned by taste and no-slop.
---

# Typography craft

**Execution only.** *Which* typeface suits a project is a direction call owned by
`taste` and `no-slop`. This skill covers getting the chosen face onto the page
correctly, licensed, fast, and without layout shift.

`no-slop` bans Inter-for-everything and untouched defaults; `craft-floor` holds the
measurable thresholds (65–75ch measure, 6rem display ceiling, −0.04em tracking floor).
Neither covers the mechanics below.

## Licensing — read this before anything else on client work

This is the part freelancers get wrong, and the invoice arrives later.

- **A desktop licence is not a web licence.** Buying a face for Figma does not permit `@font-face` on a client site. They are separate licences, usually separately priced.
- **Webfont licences are typically metered** — by monthly pageviews, by domain, or as a one-off per-site fee. Check the tier against the client's actual traffic, not their current traffic.
- **The licence belongs to the client, not to you.** Buy it in their name or have them buy it. A face licensed to your studio does not transfer when you hand off, and that is a real liability on a handover.
- **Self-hosting is often prohibited** even when webfont use is allowed; some foundries require their CDN. Read the EULA, not the marketing page.
- **Genuinely free and good:** [Fontshare](https://fontshare.com) (Indian Type Foundry, free for commercial use), Google Fonts (SIL OFL — self-hosting explicitly allowed), [Velvetyne](https://velvetyne.fr), [Collletttivo](https://collletttivo.it). These are how you get character without a licence conversation.
- Record the licence and its tier in `project/STATE.md` at handoff, and put the receipt in `project/handoff/`.

## Variable fonts

One file, continuous axes. Usually smaller than three static weights and far more expressive.

| Axis | Tag | Notes |
|---|---|---|
| Weight | `wght` | Use `font-weight: 450` directly — any value in range, not just the named stops |
| Optical size | `opsz` | The one that makes type look *designed*. Set `font-optical-sizing: auto` and let display sizes get tighter apertures automatically |
| Width | `wdth` | Condensed display without a second file |
| Slant / Italic | `slnt` / `ital` | `slnt` is a slope; `ital` is a true separate design |
| Grade | `GRAD` | Changes weight **without changing metrics** — the correct tool for dark-mode compensation, because it will not reflow text |

Prefer the standard CSS properties (`font-weight`, `font-stretch`,
`font-optical-sizing`) over `font-variation-settings`, which is a low-level override
that does not inherit or animate predictably. Reach for
`font-variation-settings` only for custom axes.

Dark mode makes light text on dark backgrounds appear heavier. Drop one grade step
(`GRAD` if available, otherwise ~25 weight units) rather than leaving it optically bolder.

## Self-hosting and subsetting

Self-hosting beats any third-party CDN: no extra DNS + TLS handshake, no third-party
cache (browsers partition caches per-site now, so shared CDN caching is a myth), and
no GDPR question about Google Fonts logging EU visitor IPs.

- **woff2 only.** Every browser in support has had it for years. Shipping woff/ttf/eot is dead weight.
- **Subset aggressively.** Latin-only typically cuts 60–80%. Use `glyphhanger`, `subfont`, or `pyftsubset` from fonttools.
- **Split by `unicode-range`** so the browser downloads only the blocks a page actually renders.
- **Do not subset a variable font down to one weight** and then ship three of them — that defeats the point.

## Loading strategy and CLS — the biggest lever

Uncontrolled font loading is the most common source of layout shift on an otherwise
clean site, and it is the one thing that quietly wrecks a Core Web Vitals score.

```html
<link rel="preload" href="/fonts/display.woff2" as="font" type="font/woff2" crossorigin>
```

Preload **only** the one or two faces used above the fold. Preloading everything
competes with the LCP image and makes things worse. `crossorigin` is mandatory even
same-origin, or the file downloads twice.

- `font-display: swap` — text is visible immediately in the fallback, then swaps. The default choice for body.
- `font-display: optional` — no swap at all; if the font is not ready in ~100ms the fallback is kept for that pageview. **Zero CLS.** The right choice when the face is nice-to-have.

**Match the fallback's metrics or the swap will shift the page.** This is the technique
most sites skip:

```css
@font-face {
  font-family: "Display Fallback";
  src: local("Arial");
  size-adjust: 105.2%;
  ascent-override: 92%;
  descent-override: 24%;
  line-gap-override: 0%;
}
body { font-family: "Display", "Display Fallback", sans-serif; }
```

Generate the numbers with the Fontaine tool or `@next/font`'s built-in adjustment —
Next.js `next/font` does preload, self-host and metric-matching automatically, which
makes it the correct default in a Next project.

## Fluid type

```css
--step-0: clamp(1rem, 0.91rem + 0.43vw, 1.25rem);
--step-4: clamp(2.99rem, 1.62rem + 6.87vw, 6rem);
```

- **Never `font-size` in raw `vw` alone** — it does not respond to the user's browser zoom or font-size preference, which fails WCAG 1.4.4. `clamp()` with a `rem` component does.
- Cap the display step at the `craft-floor` ceiling (6rem) rather than letting it scale forever.
- Generate a real scale from a ratio (1.2 minor third for dense UI, 1.333 perfect fourth for editorial) — do not hand-pick sizes per element.
- Pair with `adaptive-interfaces` for flexible-type and user-preference requirements.

## Details that separate built from assembled

- `text-wrap: balance` on headings; `text-wrap: pretty` on body to kill orphans.
- `font-variant-numeric: tabular-nums` on every table, price, timer and metric — proportional digits jitter as they change. `craft-floor` checks this.
- Enable the face's real OpenType features: `font-feature-settings: "ss01", "liga", "kern"`. Stylistic sets are why you paid for the font; most sites never turn them on.
- Set `hyphens: auto` with `lang` on `<html>` for justified or narrow columns — and note `craft-floor` flags justified body text.
- `-webkit-font-smoothing: antialiased` is not a default to apply reflexively; it *thins* text and on light backgrounds usually makes it worse. Decide per palette.
- Style link `text-underline-offset` and `text-decoration-thickness` — browser defaults belong to no design system.

## Where this hands off

- Which typeface, what mood → `taste` + `no-slop`
- Measured thresholds on the built result → `craft-floor`
- Type scale within a design system → `design-systems`, `ui-design`
- Flexible type and user preferences → `adaptive-interfaces`
- Text reveal animation → `gsap-web` (SplitText)
