# Browser safety: "Claude shut down my browser"

If your everyday browser closes by itself during a session, this is the safeguard that
makes the browser MCP incapable of causing it, what that does and does not prove, and
how to settle the question the next time it happens.

## What this does and does not prove

**Cannot:** that `chrome-devtools-mcp` caused it. The failure is intermittent and has
never been reproduced on demand, and a fix nobody can test is a claim, not a fix.

**Can:** that the browser MCP is now **incapable** of it. That is the whole approach:
rather than diagnose a bug that will not reproduce, remove the capability and prove the
removal.

**Worth knowing:** this server is registered at **user scope**, so every project on the
machine starts one. If it ever was the cause, that made it more frequent, not less.

## What changed

`~/.claude.json` and the kit's `.mcp.json` now run the server with these four flags, and only these four:

| Flag | Why |
|---|---|
| `--isolated` | Throwaway user-data-dir, deleted on exit. It can never open, share, or corrupt a real browser profile. |
| `--headless` | **The important one.** No visible window exists, so there is no window for it to close. A browser you can see is definitionally not the one it is driving. |
| `--executablePath ".../Google Chrome"` | Pins it to the Google Chrome binary. **Your everyday browser may also be Chromium-based**, so without the pin there is at least a theoretical path to the wrong browser. Now there is none. |
| `--logFile ~/.claude/chrome-devtools-mcp.log` | So the next occurrence has evidence instead of recollection. |

## The test

This repo does not ship a script for it; the check is short enough to run by hand.

Open your everyday browser with a few tabs first. Launch a browser with exactly the four
flags above, then **SIGKILL it**: the worst-case shutdown, the one suspected of taking
the real browser down with it. Then count what is still running.

The method has been run and passed: an everyday Chromium browser stayed open while the
MCP's own browser was launched and hard-killed beside it.

## If it happens again — the decisive diagnostic

**Use Safari for an hour.**

`chrome-devtools-mcp` speaks the Chrome DevTools Protocol. **Safari does not implement
CDP and cannot be driven or closed by this tool under any configuration.** So:

- **Safari dies too →** the browser MCP is *definitively innocent*. Stop looking at it.
- **Only your Chromium browser dies, never Safari →** it is Chromium-specific, and the log
  will show whether this server was even running at that moment.

Same logic applies now that the binary is pinned: the MCP only ever launches Google
Chrome, headless. **If your own browser dies, it is not this.**

### Next suspects, in order

1. **The editor or the Claude Code extension restarting.** With several `claude`
   processes running, an extension reload can take child processes with it.
2. **A dev-server or build script with `killall`/`pkill`.** Check the project's
   `package.json` scripts — `killall node`, a port-clearing one-liner, or a `predev`
   hook are common and they are indiscriminate.
3. **macOS memory pressure.** With several Chromium apps plus Cursor plus Electron
   helpers, the OS will terminate the largest consumer, which is usually the browser.
   This looks exactly like "something closed my browser" and nothing did.

### What to capture the moment it happens

1. The time, to the minute.
2. `cat ~/.claude/chrome-devtools-mcp.log` — was the server even active?
3. `log show --predicate 'eventMessage contains "<YourBrowser>"' --last 10m`, which says if macOS
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
