# Browser safety: "Claude shut down my browser"

A user's browser was closing during design work, across multiple projects, and a
previous fix did not hold. This is what was actually changed, what it does and does not
prove, and how to settle it for good the next time it happens.

## What I can and cannot prove

**Cannot:** that `chrome-devtools-mcp` caused it. It has not been reproduced here, and
"it was fixed" was claimed once already without evidence. Saying it again would be worth
nothing.

**Can:** that the browser MCP is now **incapable** of it. Different approach — instead of
diagnosing a bug I cannot reproduce, remove the capability entirely and give you a test
that proves the removal.

**Worth owning:** on 2026-08-12 I registered this server at **user scope**, which means
every project on the machine now starts one. If it *was* the cause, I made it more
frequent, not less.

## What changed

`~/.claude.json` and the kit's `.mcp.json` now run the server with these four flags, and only these four:

| Flag | Why |
|---|---|
| `--isolated` | Throwaway user-data-dir, deleted on exit. It can never open, share, or corrupt a real browser profile. |
| `--headless` | **The important one.** No visible window exists, so there is no window for it to close. A browser you can see is definitionally not the one it is driving. |
| `--executablePath ".../Google Chrome"` | Pins it to the Google Chrome binary. **The user may browse in another Chromium-based browser**, so without the pin there is at least a theoretical path to the wrong browser. Now there is none. |
| `--logFile ~/.claude/chrome-devtools-mcp.log` | So the next occurrence has evidence instead of recollection. |

## The test

```bash
bash scripts/test-browser-safety.sh
```

Open Dia (or Safari, or Chrome) with a few tabs first. The script launches a browser
exactly the way the MCP does, then **SIGKILLs it** — the worst-case shutdown, the one
suspected of taking the real browser down with it — and then counts what is still
running.

Verified passing 2026-08-14: Dia was open, the MCP's browser was launched and hard-killed,
Dia was untouched.

## If it happens again — the decisive diagnostic

**Use Safari for an hour.**

`chrome-devtools-mcp` speaks the Chrome DevTools Protocol. **Safari does not implement
CDP and cannot be driven or closed by this tool under any configuration.** So:

- **Safari dies too →** the browser MCP is *definitively innocent*. Stop looking at it.
- **Only Dia/Chrome dies, never Safari →** it is something Chromium-specific, and the log
  will show whether this server was even running at that moment.

Same logic applies now that the binary is pinned: the MCP only ever launches Google
Chrome, headless. **If Dia dies, it is not this.**

### Next suspects, in order

1. **Cursor or the Claude Code extension restarting.** Five `claude` processes were
   running at last check. An extension reload can take child processes with it.
2. **A dev-server or build script with `killall`/`pkill`.** Check the project's
   `package.json` scripts — `killall node`, a port-clearing one-liner, or a `predev`
   hook are common and they are indiscriminate.
3. **macOS memory pressure.** With several Chromium apps plus Cursor plus Electron
   helpers, the OS will terminate the largest consumer, which is usually the browser.
   This looks exactly like "something closed my browser" and nothing did.

### What to capture the moment it happens

1. The time, to the minute.
2. `cat ~/.claude/chrome-devtools-mcp.log` — was the server even active?
3. `log show --predicate 'eventMessage contains "Dia"' --last 10m` — macOS will say if it
   terminated the app and why.
4. Which browser, and whether Claude Code was mid-tool-call.

## If you want to watch the browser work

Headless is the safety guarantee, so it stays on by default. To watch a run, drop
`--headless` from `~/.claude.json` temporarily and restart the session — keep
`--isolated` and `--executablePath`, which are what stop it reaching your real browser.
Put it back afterwards.

Note the trade is small: screenshots, DOM inspection, console, network and the whole
`/ux-audit` live pass all work identically headless. The only thing lost is watching it
happen.
