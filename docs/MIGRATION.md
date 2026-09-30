# New machine, or switching Claude accounts

The short version: **almost nothing is at risk, because almost everything lives in this
git repo.** What follows is the list of the exceptions, so none of them surprise you.

## One command on a new machine

**A Mac with nothing on it** — no Homebrew, no Ghostty, no Claude Code. Open the
repo on github.com in a browser you are signed in to, copy the block under
**"First step - For those who come after"** in `README.md`, and paste it into
Terminal. It installs Homebrew, Ghostty, Chrome, node, the GitHub CLI and Claude
Code, signs you in to GitHub, clones this kit, and runs everything below.

The block cannot be a bare `curl | bash` from this repo, because the repo is
private: signing in to GitHub has to come first, and that is the one step that
cannot live inside a repo you cannot yet read.

**A machine that already has the tools** — this is all you need:

```bash
# From an existing clone, `git remote get-url origin` is the address to use here.
gh repo clone <owner>/<this-repo> ~/realm-skills && bash ~/realm-skills/scripts/setup-machine.sh
```

That symlinks the kit's skills, commands, agents and the user-level `CLAUDE.md` into
`~/.claude/`, registers the browser MCP at user scope, and sets the `ours` merge driver.
It is idempotent — safe to re-run — and it backs up anything it would replace.

Then two things it cannot do for you, because they belong to your **Claude account**
rather than the machine (see the table below).

## What travels, and what does not

| | Where it lives | Survives an account switch? | Survives a new machine? |
|---|---|---|---|
| Skills, commands, agents | this repo | ✅ | ✅ via clone |
| Taste library and profile | this repo (`taste/`) | ✅ | ✅ |
| Reviews, briefs, `STATE.md` | this repo (`project/`) | ✅ | ✅ |
| User-level rules | this repo (`.claude/user-CLAUDE.md`, symlinked to `~/.claude/CLAUDE.md`) | ✅ | ✅ via setup script |
| Project code | their own GitHub repos | ✅ | ✅ |
| **MCP server approvals** | Claude account | ❌ **re-approve** | ❌ |
| **claude.ai connectors** — Figma, Mobbin, Slack, Google Drive, Atlassian | Claude account | ❌ **re-authorise** | ❌ |
| **Conversation history / session transcripts** | `~/.claude/projects/`, `~/.claude/sessions/` | ⚠️ local files, tied to the machine | ❌ unless copied |
| **Auto-memory** | `~/.claude/projects/<project>/memory/` | ⚠️ same | ❌ unless copied |
| **`taste/.env`** — Pinterest tokens | local only, **gitignored on purpose** | ✅ | ❌ **copy by hand** |
| **`~/.claude.json`** — MCP registrations, OAuth | local, account-scoped | ⚠️ partly | ❌ |
| **TypeWhisper settings** — workflows, dictionary, snippets, profiles, prompt actions, hotkeys, plugins | `~/Library/Application Support/TypeWhisper` + `~/Library/Preferences/com.typewhisper.mac.plist` | ✅ machine-local | ❌ **export by hand — see below** |
| **TypeWhisper API keys** (Groq / OpenAI / xAI) | macOS **Keychain**, not the plist — verified 2026-08-23 | ✅ | ❌ re-enter |

### TypeWhisper

`bootstrap-mac.sh` installs the **app** (`brew install --cask typewhisper`). It does not
install anything you configured in it.

**Do not copy the files by hand.** `~/Library/Application Support/TypeWhisper` holds
SQLite stores with live write-ahead logs (`.store` alongside `.store-wal` / `.store-shm`);
copying the `.store` on its own loses whatever is still in the WAL, and copying a live set
risks a torn snapshot. It is also **502 MB**, of which 482 MB is `PluginData` — the
downloaded Parakeet and WhisperKit models, which re-download on demand and must never
enter a git repo.

**Use the app's own Backup & Restore instead** (added in 1.6). It covers exactly the
customised surface: workflows, dictionary entries, snippets, profiles, prompt actions,
hotkeys, **installed community plugins**, history text, and supported preferences. Export
on the old machine, restore on the new one.

⚠️ **The backup includes history text** — every transcription you have ever made. If any
of it was dictated about client work, that file is confidential: keep it out of this repo,
out of any shared drive, and off anything synced by default. The settings themselves are
tiny (five stores at ~68 KB each), but there is no supported way to export them *without*
history, so treat the whole backup as sensitive.

## Account switch checklist

The kit itself is unaffected — it is files in a repo you own on **your** GitHub, not
anything belonging to the account you sign into Claude with.

1. **Before switching**, note which claude.ai connectors are authorised: `claude mcp list`.
2. Switch the account.
3. **Re-approve the MCP servers.** Start Claude Code; `chrome-devtools` and `figma`
   appear as *Pending approval* and must be accepted. Nothing works until you do.
4. **Re-authorise the connectors** in claude.ai connector settings: Figma, Mobbin,
   Slack, Google Drive, Atlassian.
5. Re-run `bash scripts/setup-machine.sh` if anything looks unlinked.
6. **Check the Slack workspace.** `taste/slack.json` points at `#design-inspiration`,
   which is a shared team channel — reachable through the account's Slack connector, so
   confirm the new account can still see it before running `/taste-pull`.

**Anything published to claude.ai under the old account — artifacts especially — stays
with that account.** Nothing in this kit depends on one, but if you have published
anything you care about, export it before switching.

## Working across several machines

The repo is the source of truth; the machines are caches.

- **Pull before you start, push when you stop.** The taste library and `project/STATE.md`
  are the two that actually hurt to lose, since they are the accumulated judgement.
- Session history and auto-memory are **per-machine** and do not sync. Anything worth
  keeping belongs in `project/STATE.md` or a taste entry — that is precisely why the
  handoff convention exists.
- `taste/.env` never leaves a machine (gitignored, correctly — it holds Pinterest
  credentials). Re-create it from `taste/scripts/pinterest-auth.py` rather than copying
  secrets around.

## Moving a repository between hosts (GitHub → GitLab, or anywhere)

A standing rule: **no loss of code or information in any
transfer, ever** — and it has to be verified by numbers, not by "push succeeded".
A plain `git push <new-remote>` moves ONE branch and silently drops the rest;
that is the failure mode this section exists to prevent.

**The transfer itself — always mirror, never plain push:**

```bash
git clone --mirror <source-url> repo-mirror   # every branch, tag, and ref
cd repo-mirror
git push --mirror <destination-url>
```

**Verify before calling it done** (measure-first applies to migrations too —
run these on BOTH ends and diff; they must match exactly):

```bash
git rev-list --all --count        # total commits reachable from all refs
git for-each-ref | sort           # every branch/tag with its sha
git lfs ls-files | wc -l          # only if LFS is in use — mirror does NOT move LFS objects
```

If LFS is in use: `git lfs fetch --all` from the source, then
`git lfs push --all <destination>` — a mirror push alone leaves every large file
behind as broken pointers.

**What a mirror does NOT carry — inventory these explicitly, never silently:**

- Uncommitted and untracked work, and stashes (commit or export them first)
- Gitignored files — `.env`, `taste/.env`, local settings. Correctly absent from
  git; name each one and move or re-create it deliberately (see the checklist above)
- Host-side metadata: issues, PRs/MRs, wikis, releases, CI variables and secrets,
  branch protections. Use the destination's importer for what it covers and write
  down what it does not
- Per-clone git config: the `merge.ours.driver`, hooks, remotes — re-run
  `setup-machine.sh` / re-add remotes on the new clone

**And the commit rule holds everywhere:** `/commit` discipline (atomic, typed,
why-bodies, named paths, push only on approval) applies to every repo on every
host — a migration is not an excuse for a "misc" commit. Do not retire the source
until the destination's numbers match and the not-in-git inventory is accounted for.

## Publishing a sanitised copy — the opposite job, and easy to confuse

**A transfer and a publish want opposite things, so the section above is the wrong
tool for this one.** A transfer's goal is that *nothing is lost*. A sanitised
publish's goal is that *something specific is deliberately removed* — and a mirror
is built to carry all of it across, faithfully, including the parts you meant to
strip. Reach for the transfer checklist when you meant to sanitise and it will do
its job perfectly and defeat yours.

**The test is who the destination is for**, not which host it is on:

| Destination | Job | Section |
|---|---|---|
| Same owner, different host | **Transfer** — lose nothing, verify by count | above |
| A client, a contractor, anyone outside | **Publish** — sanitise first, verify by absence | here |

**What usually needs removing**, none of which a mirror will drop for you:

- **Commit identities.** `<id>+<user>@users.noreply.github.com` encodes the GitHub
  numeric user ID and resolves straight to the account. Personal addresses and
  `user@machine.local` hostnames ride along the same way, on every commit.
- **Absolute local paths** — `/Users/<name>/...` in a tracked `CLAUDE.md`, README or
  config leaks the machine layout and whatever it points at.
- **Internal notes written for us**, not for them: what is endorsed, what was
  agent-built, review pointers, client politics. The test before any line goes into
  a repo someone else reads: *would I be relaxed if they read it out in a meeting?*
- **Identical commit SHAs**, which tie the two repos together by hash even when
  every name has been changed.

**Verification is the mirror image of a transfer's.** A transfer proves **presence by
count**; a publish proves **absence by search**, on the destination, across the whole
history — `git log --all -S "<string>"` and `git log --format='%ae %ce' | sort -u` for
every string and identity that was meant to go. `rev-list --all --count` will NOT match
after a rewrite, by design: state the expected delta rather than treating a mismatch as
a failure.

**Leave the source alone.** The un-rewritten repo, with real timestamps and real
authorship, is the provenance record — it is stronger evidence of who did the work than
the published copy, and it should stay private and intact rather than being "cleaned up"
to match.

**Do it once, then fix the cause.** History rewriting is remediation for content that
should not have been committed, not a routine step at every handoff. Routine rewriting
breaks every existing clone, needs a force-push many hosts refuse, and fails quietly
when one string is missed — believing you are clean is worse than knowing you are not.
The durable fix is upstream: keep personal and kit-specific content out of the repo, and
commit only what a stranger inheriting the codebase actually benefits from.


## When there is no kit at all

Pasting the repo link into a chat gives an agent the **rules** but not the machinery —
it can read `README.md` and `CLAUDE.md`, but the 56 skills are not installed and no
command will run. An agent in that position should say so plainly rather than pretending
the skills ran, apply the rules from what it can read, and offer the one-liner above.
