# Credits

Third-party material bundled in this repo, and where it came from.

## Upstream template

This repo began as a clone of [hulusi-tunc/unicorn-skills](https://github.com/hulusi-tunc/unicorn-skills)
and is tracked as the `upstream` git remote. The original publishes no LICENSE file;
it is used here per the README's explicit "Clone, open, go" instructions.

```
git fetch upstream && git merge upstream/main
```

## Skill imported from @playwright/cli

Source: https://www.npmjs.com/package/@playwright/cli — Apache-2.0, (c) Microsoft.
Ships its own `skills/playwright-cli/`; imported into `.claude/skills/` unmodified
except for a source comment and a block of KIT NOTES under the frontmatter, which
record the things that bit on first use and are not in the upstream file (not on
PATH, writes into the CWD, `--raw`, the 1280x720 default viewport, the GPU check,
and video needing its own ffmpeg).

| Skill | Source | Notes |
|---|---|---|
| `playwright-cli` | `@playwright/cli/skills/playwright-cli/` | Needs `npm i -g @playwright/cli`, plus `npx playwright install chromium ffmpeg` once |

To update:

```bash
npm install -g @playwright/cli   # then re-copy skills/playwright-cli/, keeping the KIT NOTES
```

## Skills imported from Leonxlnx/taste-skill

Source: https://github.com/Leonxlnx/taste-skill — MIT licensed.

Imported into `.claude/skills/`, unmodified except for a one-line source comment
added below each file's frontmatter:

| Skill | Source folder | Notes |
|---|---|---|
| `redesign-existing-projects` | `skills/redesign-skill/` | Works today |
| `imagegen-frontend-web` | `skills/imagegen-frontend-web/` | Needs an image-generation tool |
| `imagegen-frontend-mobile` | `skills/imagegen-frontend-mobile/` | Needs an image-generation tool |
| `brandkit` | `skills/brandkit/` | Needs an image-generation tool |

Not imported (9 further skills exist upstream) — `design-taste-frontend`,
`design-taste-frontend-v1`, `high-end-visual-design` and `gpt-taste` were skipped as
overlapping with this repo's `no-slop` policy; `minimalist-ui`, `industrial-brutalist-ui`,
`image-to-code`, `stitch-design-taste` and `full-output-enforcement` were skipped as
out of scope for now.

To pull updates to an imported skill:

```bash
npx skills add https://github.com/Leonxlnx/taste-skill --skill "<install-name>"
```

### MIT License

```
MIT License

Copyright (c) 2026 Leonxlnx

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Motion skills imported from iart-ai/web-animation-skills

Source: https://github.com/iart-ai/web-animation-skills — MIT licensed, © 2026 iart.ai.

Imported into `.claude/skills/`, unmodified except for a source comment below each
file's frontmatter: `gsap-web`, `60fps-animation`, `page-transition-animation`,
`svg-animation`, `micro-interaction`, `lottie-animation`.

The 2026-08-10 import took only each skill's `SKILL.md` and left the rest upstream, so
every one of them cited files that were never on disk. Completed 2026-08-23 with the 8
`references/` files, gsap-web's 2 `examples/`, and the 3 verify-loop helpers now in this
repo's `scripts/` (`seek-shot.sh`, `contact-sheet.sh`, `probe-mp4.sh`). Same licence,
same terms, unmodified. Upstream's `scripts/README.md` was not taken — this repo's
`scripts/` holds its own tooling too, and the three are documented in `CLAUDE.md`.

Not imported: `glassmorphism` (it is banned pattern #2 in this repo's `no-slop`),
`accessible-animation` (duplicates the existing `motion-sensitivity` skill), and
`ascii-animation` (out of scope).

The MIT text reproduced below for taste-skill applies equally here, with copyright
held by iart.ai.

## Skills written for this repo

`webgl-shaders` and `typography-craft` are original to this repo — not imported from
anywhere. They exist because no comparable skill was findable: searches for WebGL,
three.js, shader and typography skills returned nothing credible.

## `craft-floor`, adapted from pbakaus/impeccable

Source: https://github.com/pbakaus/impeccable — Apache License 2.0, © Paul Bakaus.

`.claude/skills/craft-floor/SKILL.md` is an **adaptation, not a copy.** Nothing was
vendored: no files, no scripts, no npm package. What was taken is the substance of
impeccable's craft floor and its anti-pattern detector rule set —

- the measurable thresholds (contrast, line measure, display ceiling, tracking floor, card radius, elevation-declared-once)
- the browser-surface list (selection, caret, scrollbars, focus rings, underline offset, tabular numerals)
- current-generation machine fingerprints from the detector's 64-rule set
- the runtime defect classes that only a rendered page reveals, chiefly content-invisible-at-rest
- the bounded verification loop (build → one batched inspection → one fix batch → at most one confirming round → stop)

— rewritten in this repo's own words and structure.

**Deliberately excluded:** every direction-setting and aesthetic-opinion passage.
impeccable has its own taste, and this repo already has one. Its craft floor states
that "the floor holds the mechanics; it never picks the direction" — `craft-floor` is
scoped to exactly that half, and `CLAUDE.md` makes it subordinate to `no-slop` and
`taste` where they disagree.

The Apache-2.0 license requires this attribution notice be retained. Full text:
https://www.apache.org/licenses/LICENSE-2.0

Not adopted: the `impeccable` npm package, its Node anti-pattern detector, its
subagents, hooks, and its ~35 reference playbooks.

## Other bundled sources

Skills carrying their own upstream provenance, inherited from the template:
`frontend-design` (Anthropic), `vercel-web-design-guidelines`,
`vercel-react-best-practices`, `vercel-react-native-skills` (Vercel),
`emil-design-eng` (Emil Kowalski's published writing), `shadcn-ui` (shadcn/ui).

