# UX reference map

The lookup table behind `ux-first` §2 and `/ux-audit`. Its job is to make "research
the pattern" **mechanical instead of inventive** — the agent should not be deciding
*where* to look, only reading what is there.

## How to use it

1. Name the pattern being built. If it is not in the table, pick the nearest row and
   say which one you used.
2. Fetch the **primary** source. Fetch a secondary only if the primary does not cover
   the question.
3. Take **behavioural rules only** — sequence, defaults, error handling, keyboard
   contract, what happens when it goes wrong. Ignore every visual recommendation;
   that is `taste`'s call and a reference has no standing there.
4. Cite what you read in the spec: source, what it said, and whether you followed it.
   A rule with no source is an opinion.
5. If a source is unreachable, say so in the spec rather than substituting memory.

## The roster — what each source is actually authoritative for

| Source | Authoritative for | Why it is trusted here |
|---|---|---|
| **GOV.UK Design System** · https://design-system.service.gov.uk/patterns/ | Forms, questions, errors, multi-step flows, confirmation, task lists | The most rigorously user-tested public design system in existence, and unusually explicit about *logic* rather than looks |
| **WAI-ARIA Authoring Practices** · https://www.w3.org/WAI/ARIA/apg/patterns/ | The keyboard and semantics contract for any widget | Canonical, normative, and written as **behaviour** — exactly the layer this gate cares about |
| **Baymard Institute** · https://baymard.com/blog | Checkout, cart, product pages, search, e-commerce forms | Large-sample empirical usability research, not opinion |
| **Nielsen Norman Group** · https://www.nngroup.com/articles/ | Heuristics, IA, navigation, error messaging, general patterns | Research-backed, and the origin of the severity scale this kit uses |
| **Inclusive Components** · https://inclusive-components.design/ | Building a specific component accessibly, pattern by pattern | Deep, per-pattern, construction-level |
| **Shopify Polaris** · https://polaris.shopify.com/ · **Atlassian** · https://atlassian.design/ · **IBM Carbon** · https://carbondesignsystem.com/ | Component behaviour and content rules in a real product context | Mature systems that publish their reasoning; use for behaviour and copy, never for style |
| **Laws of UX** · https://lawsofux.com/ | The named principle behind a decision (Fitts, Hick, Miller, Jakob) | Fast way to name *why* something works when writing rationale |
| **WebAIM** · https://webaim.org/ | Practical accessibility technique and testing | Plain, testable guidance |
| **Mobbin** (MCP) | Real shipped flows to compare against | Needs authorising in claude.ai connector settings — see `docs/OS.md` |

## Pattern → source

| Pattern | Primary | Secondary |
|---|---|---|
| Form, any | GOV.UK → *Question pages* | NN/g form articles |
| Field-level (name, address, email, phone, password, payment card, dates) | GOV.UK → the named pattern; it has one for each | Baymard for payment and address |
| Errors and validation | GOV.UK → *Error messages* + *Error summary* | NN/g error-message guidelines |
| Multi-step / wizard | GOV.UK → *Task list pages*, *Step by step navigation* | — |
| Confirm before submit | GOV.UK → *Check answers* | — |
| Success / confirmation | GOV.UK → *Confirmation pages* | — |
| Checkout, cart | Baymard | GOV.UK for the form mechanics inside it |
| Search + results | NN/g search articles | Baymard for e-commerce search |
| Faceted filtering | Baymard | NN/g for filter vs. sort |
| Data table, sorting, pagination | APG → *Table* / *Grid* | Carbon, Polaris |
| Date picker, calendar | APG → *Combobox* (date) + GOV.UK → *Dates* | GOV.UK is emphatic that three text inputs usually beat a picker — read it before building a calendar |
| Modal, dialog, drawer | APG → *Dialog (Modal)* | Inclusive Components |
| Dropdown, select, autocomplete | APG → *Combobox*, *Listbox* | Inclusive Components |
| Tabs, accordion, disclosure | APG → *Tabs*, *Accordion*, *Disclosure* | Inclusive Components |
| Menu, nav, breadcrumb | APG → *Menu*, *Breadcrumb* | NN/g navigation + IA |
| Toast, alert, status message | APG → *Alert*, and `aria-live` | NN/g feedback |
| **Member / partner / client roster, logo wall, organisation index** | NN/g → IA and navigation, for the gateway-vs-destination split: a teaser section must characterise the set and give one route in, not duplicate the directory's lookup job | APG → link semantics (each organisation is navigation, not a control). **Known trap, found 2026-08-13:** naming an organisation on hover only leaves touch users with a bare logo or monogram — names must be always-visible text, and `sr-only` does not cover this |
| Directory with filters (the destination, not the teaser) | NN/g → faceted search and filtering | Polaris, Carbon for the list mechanics |
| Empty states | NN/g empty-state articles | Polaris → *Empty states* |
| Loading, skeleton, progress | NN/g response-time articles | Polaris, Carbon |
| Onboarding | NN/g onboarding | — |
| Auth, sign-in, password | GOV.UK → *Passwords*, *Create a username* | WebAIM |
| File upload | GOV.UK → *File upload* | Inclusive Components |
| Settings, preferences | NN/g settings | Polaris |
| Pricing | Baymard | — |
| Notifications | NN/g | Polaris |
| Destructive actions, undo | NN/g → undo and confirmation | Polaris → *Destructive* |
| Infinite scroll vs. pagination | NN/g | Baymard |
| Mobile touch, gestures | NN/g mobile | APG for equivalents |

## Rules for using any of this

- **The brief and the client's own system outrank every source here.** A reference
  describes the pattern in general; the project is specific.
- **Never cite a reference for a look.** If a finding is visual, it belongs to
  `taste` and `no-slop`, and this map has no standing.
- **Prefer empirical over vendor.** Where Baymard or NN/g disagree with a design
  system's house style, the research wins unless the brief says otherwise.
- **Two to three sources is the budget.** This is a gate, not a literature review.
- **Record dissent.** If a rule was read and deliberately not followed, write down
  why. That is the most useful line in the whole spec six months later.
