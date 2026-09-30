<h1 align="center">Realm Skills</h1>

<p align="center">
  <em>A Claude Code setup for design engineering - brief to handoff, without the
  AI-default look.<br>
  <strong>54 skills</strong> · <strong>13 commands</strong> · <strong>5 agents</strong></em>
</p>

---

> # 🤠 If you are an AI agent reading this
>
> Read **[`CLAUDE.md`](CLAUDE.md)** in this repo before doing any design or
> frontend work. It carries the rules that matter: **UX is settled before any UI**,
> **one visual vocabulary per page**, **every image must fit the content beside it**,
> and **three decisions belong to the design lead alone** — the register before
> hunting visual references, any break in a page's visual vocabulary, and anything
> hard to reverse. On those three: propose, give your evidence, and **ask**.
> Silence is not consent.
>
> **Address the person you are working with the way their user-level config
> says — every response, the whole conversation.** The address is personal
> configuration, not kit policy; every rule here binds identically for everyone
> the kit is set up for.
>
> **If the skills are not installed on this machine** — `readlink ~/.claude/skills`
> returns nothing — say so plainly rather than pretending they ran, and offer the
> one-liner below.

---

**Install on a new machine** — makes the kit apply to *every* project, not just this repo:

```bash
# Clone THIS repository, then run setup. From an existing clone the address is
# `git remote get-url origin`, so the line below is true wherever it came from.
gh repo clone <owner>/<this-repo> ~/realm-skills && bash ~/realm-skills/scripts/setup-machine.sh
```

Idempotent, backs up anything it replaces. Switching Claude accounts or machines:
[`docs/MIGRATION.md`](docs/MIGRATION.md).

---

Claude Code knows how to write code. It does not know how to run a design project, and left alone it produces interfaces that look like every other AI-generated interface — purple gradient hero, three feature cards, Inter everywhere.

This repo fixes both. It gives Claude a design process to follow, a set of practitioner-grade reference material to follow it with, and a standing set of rules about what not to ship. Everything is Markdown in `.claude/` — no plugins, no install step, no marketplace.

## What it's for

Taking a project from a brief to a developer handoff, one stage at a time:

| Stage | You say | What runs | Lands in |
|---|---|---|---|
| Intake | "here's the brief" | `ux-strategy`, `/discover` if research is needed | `project/brief/`, `research/` |
| Design system | "let's build the system" | `/tokenize` | `project/design-system/` |
| UI | "design the dashboard screen" | `/design-screen` | `project/screens/` |
| Refine | "review this" | `/slop-check` + accessibility passes | `project/reviews/` |
| Ship | "prepare handoff" | `/handoff` | `project/handoff/` |

You do not need to memorise any of it. Describe the task and Claude routes to the right skill.

## First step - For those who come after

A brand new Mac with nothing on it. Open **Terminal**, paste this, and go and make
a coffee. It installs Homebrew, Chrome, node, the GitHub CLI and Claude
Code, clones this kit, and applies every setting it carries.

```bash
# Homebrew - skipped if it is already there
command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

# GitHub CLI, then sign in - this opens a browser
brew install gh
gh auth login

# The kit, then everything else
gh repo clone <owner>/<this-repo> ~/realm-skills
bash ~/realm-skills/scripts/setup-machine.sh
```

You will be asked for three things along the way: your **Mac password** (Homebrew
needs it), a **GitHub sign-in** (`gh auth login`), and possibly an **Xcode dialog**
to click through. That is the lot.

When it finishes it prints the short list of things no script can do for you -
signing in to Claude Code, approving the MCP servers, re-authorising the
claude.ai connectors, and copying `taste/.env` across by hand.

It is safe to re-run: every step checks before it acts, and nothing is
overwritten without a timestamped backup.

> **On a company-managed Mac**, MDM policy commonly blocks Homebrew, cask installs
> and sudo. The script reports which step was refused rather than failing
> obscurely, but it cannot grant itself rights the device policy withholds.

## Start here

Say **hi** to **🤠 Honcho**, the project director.

Honcho reads the brief from `project/brief/`, asks whether you want **instructor** mode (explains each step and which skill is running) or **operator** mode (just runs the workflow), tracks where the project is in `project/STATE.md`, and pulls in the right specialist at each stage.

If you already know what you want, skip it and just ask — the skills trigger on their own.

## Setup

```bash
gh repo clone <owner>/<your-project> my-project   # private repo - gh, not bare git clone
cd my-project        # then open in Claude Code
```

Work on `main`. The `project/` folder belongs to whatever job you are on; everything else is the toolkit.

One dependency, once per machine — it powers the live browser checks in `/slop-check`:

```bash
npm install -g chrome-devtools-mcp
```

Figma is wired up in `.mcp.json` but needs authorising in Claude Code before the Figma skills work.

## How it decides things

Skills are ordered, and the ordering is the useful part:

```
taste             what the work should look like
 └ no-slop        what counts as generic
    └ craft-floor       whether it was executed cleanly
       └ implementation how to actually build it
```

A skill lower in the chain never overrules one above it. `craft-floor` measures contrast ratios and line length but has no opinion on your palette. `gsap-web` knows ScrollTrigger inside out but not whether the page should move at all. When a lower skill disagrees with a higher one, the higher one wins and the lower one goes quiet — no debate, no split difference.

This matters because 54 skills will happily hand you a direction if you let them, and a direction you did not choose is how work ends up looking generic.

## What's inside

```
.claude/
  skills/        54 skills, bundled
  commands/      13 commands
  agents/        5 agents — Honcho directs, 4 specialists support
.mcp.json        Chrome DevTools + Figma
CLAUDE.md        Loaded every session: house rules, inventory, routing
docs/OS.md       Session routine and defaults
project/         The workspace — brief in, STATE.md as memory, each command's
                 output in its own folder
taste/           The taste library. Starts empty — see below
```

## The 54 skills

| Family | Skills |
|---|---|
| **Core (3)** | `taste` — the taste library, read before any visual direction · `no-slop` — the anti-AI-slop rules · `craft-floor` — measurable checks on built UI |
| **Gates & process (5)** | `ux-first` - the UX settled in writing before any UI · `coherence` - one visual vocabulary per page · `image-fit` - no image placed unseen · `measure-first` - a second attempt triggers an instrument, not another guess · `preflight` - the launch gate: 21 evidence-verified checks before anything goes online |
| **Designer craft (8)** | `design-research` · `ux-strategy` · `design-systems` · `ui-design` · `interaction-design` · `prototyping-testing` · `design-ops` · `designer-toolkit` |
| **Inclusive design (5)** | `inclusive-design` · `accessible-content` · `adaptive-interfaces` · `accessibility-process` · `motion-sensitivity` |
| **Engineering quality (11)** | `dev-conventions` · `emil-design-eng` · `frontend-design` · `vercel-web-design-guidelines` · `vercel-react-best-practices` · `vercel-react-native-skills` · `shadcn-ui` · `api-and-interface-design` · `debugging-and-error-recovery` · `security-and-hardening` · `test-driven-development` |
| **Motion & craft (8)** | `gsap-web` · `60fps-animation` · `page-transition-animation` · `svg-animation` · `micro-interaction` · `lottie-animation` · `webgl-shaders` · `typography-craft` |
| **Visual generation (4)** | `redesign-existing-projects` · `imagegen-frontend-web` · `imagegen-frontend-mobile` · `brandkit` |
| **Figma (7)** | `figma-use` (load this before any Figma write) + generate-design, implement-design, generate-library, code-connect, design-system-rules, create-new-file |
| **Machine & tooling (1)** | `playwright-cli` — the first-reach browser for verifying anything that runs: headless, `eval` for real measurement, records video|
| **Decision & prose (2)** | `llm-council` - blind council, blind ranking, Chairman synthesis, fired only by name · `humanizer` - the edit pass for AI tells in prose that ships |

Each craft skill covers a whole discipline rather than a single task — `design-research` alone handles interviews, personas, journey maps, JTBD, usability tests, and synthesis. Fewer, denser skills keep routing obvious and context light.

Two worth calling out: **`webgl-shaders`** covers three.js/OGL/react-three-fiber, GLSL, the 16.7 ms frame budget, and the fallback rules that keep a canvas shippable. **`typography-craft`** covers variable font axes, self-hosting, CLS-free loading — and web font licensing, which is the one that bites on client work, since a desktop licence does not cover a website and the web licence belongs to the client.

The three `imagegen`/`brandkit` skills assume the agent can generate images. `.mcp.json` ships Chrome DevTools and Figma only, so they stay dormant until an image-generation server is added.

## The 13 commands

| Command | What it runs |
|---|---|
| `/discover` | Research cycle: plan → interview → synthesise → personas + journey map |
| `/tokenize` | Design system foundations: tokens, type scale, colour, spacing, accessibility checks |
| `/design-screen` | One screen end to end: grid → hierarchy → states → inclusive pass → slop check |
| `/handoff` | Developer handoff: spec, accessibility notes, QA checklist, Figma Code Connect |
| `/slop-check` | The review gate — `no-slop` first, then `craft-floor`, then a live browser pass |
| `/commit` | Atomic commits: `type(scope)` + why, staged by named path |
| `/handover` | Draft the focused compact + kickoff so a model switch starts small and dense |
| `/taste-add` | File inspiration from `taste/inbox/` into the library |
| `/taste-sync` | Regenerate `taste/TASTE.md` from the library |
| `/taste-pull` · `/taste-routine` | Slack variants — need a workspace configured in `taste/slack.json` |
| `/ux-audit` | Audit whether a built screen *works* — job, states, logic, dead ends — before any visual critique |
| `/kit` | Reload the kit rules mid-conversation and re-orient a drifted chat |

## The 5 agents

Talk naturally; Claude routes to them on its own.

| Agent | What it does |
|---|---|
| **🤠 honcho** | Project director — talk to it first. Reads the brief, tracks the stage, instructor or operator mode |
| **designer-copilot** | Senior design partner — challenge → explore → specify |
| **ui-designer** | Colour, typography, grids, responsive, dark mode |
| **design-system-architect** | Tokens, components, theming |
| **design-reviewer** | Heuristics + accessibility + slop check |

## How skills pair

Build with one, check with the other:

| Build with… | …then check with |
|---|---|
| `ui-design` (colour system) | `adaptive-interfaces` (colour independence) |
| `emil-design-eng` (whether to animate) | `motion-sensitivity` (vestibular safety — always) |
| `gsap-web` / `webgl-shaders` (how to animate) | `60fps-animation` (frame budget) |
| `design-research` (personas) | `accessibility-process` (disability-inclusive) |
| `design-systems` (components) | `inclusive-design` (keyboard navigation) |
| anything built | `/slop-check`, then `craft-floor` on the rendered page |

## Teaching it your taste

`taste/` is where the toolkit learns what you actually like, so it stops guessing. **A fresh clone starts empty**, and while it has no entries Claude will say so rather than presenting its own defaults as your preferences.

To add an entry:

1. Drop a screenshot or reference into `taste/inbox/`
2. Run `/taste-add` — it asks *what made you save this*
3. Answer in one sentence
4. Run `/taste-sync` to regenerate the profile

That sentence is the whole signal. "Nice clean design" teaches nothing; "the glow is contained to just the CTA zone — glow as spotlight, not wallpaper" is a rule that applies to the next project too. **[taste/TEMPLATE.md](taste/TEMPLATE.md)** covers the format, the difference between a compliment and a reusable rule, and how to file things you dislike.

Around 5 entries the profile can name a direction. Around 15–20 it gets genuinely opinionated.

## House rules

Three defaults that hold unless you override them:

- **No slop ships.** Generic AI-default output is treated as a defect, not a style note. `/slop-check` is the gate.
- **WCAG AA minimum.** Keyboard, screen reader, and reduced motion from the start — on paid client work in the EU and US this is legal exposure, not a nicety.
- **Tokens over raw values.** And record stack or architecture decisions in `project/STATE.md` so the reasoning survives the session.

Everything in `CLAUDE.md` is a default you can override by saying so. None of it blocks you.
