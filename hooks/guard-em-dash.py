#!/usr/bin/env python3
"""Whatchamacallit enforcement hook - PreToolUse on Write/Edit.

The standing rule: "only AIs use double dash" - a single ASCII hyphen does
the job. This blocks the whole typographic dash family landing in UI code
across every project, not just the em dash: en dashes were slipping through
the first version (caught by the owner, 2026-08-21).

Scope, widened to .md by the owner on 2026-08-21:
- FIRES on .tsx .jsx .ts .js .css .html .svelte .vue .md .mdx - copy,
  code comments, and documentation alike. Legacy dashes already in a file
  do not trip anything; only what is being WRITTEN is checked, so docs
  migrate to hyphens as they are touched.
- STAYS SILENT on anything under a content/ directory (verbatim
  transcriptions keep their source punctuation, the stated exception)
  and on node_modules/build dirs.

Fails OPEN on unparseable input.
"""
import json
import sys

GUARDED_EXT = (".tsx", ".jsx", ".ts", ".js", ".css", ".html", ".svelte", ".vue",
               ".md", ".mdx")
EXEMPT_PARTS = ("/content/", "/node_modules/", "/.next/", "/dist/", "/build/")

try:
    payload = json.load(sys.stdin)
    tool_input = payload.get("tool_input", {})
    path = (tool_input.get("file_path", "") or "").replace("\\", "/")
    body = tool_input.get("content") or tool_input.get("new_string") or ""
except Exception:
    sys.exit(0)

if not path.endswith(GUARDED_EXT):
    sys.exit(0)
if any(part in path for part in EXEMPT_PARTS):
    sys.exit(0)

# The family: em U+2014, en U+2013, figure U+2012, horizontal bar U+2015,
# minus sign U+2212, non-breaking hyphen U+2011. Real code uses ASCII "-".
DASHES = "\u2014\u2013\u2012\u2015\u2212\u2011"

found = [c for c in body if c in DASHES]
if found:
    names = {"\u2014": "em dash", "\u2013": "en dash", "\u2012": "figure dash",
             "\u2015": "horizontal bar", "\u2212": "minus sign",
             "\u2011": "non-breaking hyphen"}
    kinds = ", ".join(sorted({names[c] for c in found}))
    sys.stderr.write(
        f"BLOCKED by whatchamacallit (hooks/guard-em-dash.py): {len(found)} "
        f"typographic dash(es) ({kinds}) in what you are writing to {path}. "
        "The standing rule: only AIs use fancy dashes - use a single ASCII "
        "hyphen, or restructure the sentence. (Verbatim transcriptions belong "
        "under content/, which this guard exempts.)\n"
    )
    sys.exit(2)

sys.exit(0)
