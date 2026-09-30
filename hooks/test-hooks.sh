#!/usr/bin/env bash
# Test harness for the enforcement hooks. Synthetic PreToolUse payloads in,
# exit codes asserted. Zero controls included on purpose: a guard that
# blocks nothing AND a guard that blocks everything both look "done".
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT="$(dirname "$HERE")"
pass=0; fail=0

bash_case() { # hook, expected_exit, description, command
  local hook="$1" want="$2" desc="$3" cmd="$4"
  printf '{"cwd":"%s","tool_name":"Bash","tool_input":{"command":%s}}' \
    "${CWD_OVERRIDE:-$KIT}" "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$cmd")" \
    | python3 "$HERE/$hook" >/dev/null 2>&1
  local got=$?
  if [ "$got" = "$want" ]; then pass=$((pass+1));
  else fail=$((fail+1)); echo "FAIL [$hook] want=$want got=$got : $desc"; fi
}

file_case() { # expected_exit, description, file_path, body
  local want="$1" desc="$2" path="$3" body="$4"
  printf '{"tool_name":"Write","tool_input":{"file_path":%s,"content":%s}}' \
    "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$path")" \
    "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$body")" \
    | python3 "$HERE/guard-em-dash.py" >/dev/null 2>&1
  local got=$?
  if [ "$got" = "$want" ]; then pass=$((pass+1));
  else fail=$((fail+1)); echo "FAIL [em-dash] want=$want got=$got : $desc"; fi
}

mem_case() { # expected_exit, description, command, [env assignments]
  local want="$1" desc="$2" cmd="$3" envs="${4:-}"
  # shellcheck disable=SC2086 -- envs is a deliberate word-split of VAR=val pairs
  printf '{"cwd":"%s","tool_name":"Bash","tool_input":{"command":%s}}' \
    "$KIT" "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$cmd")" \
    | env $envs python3 "$HERE/guard-memory.py" >/dev/null 2>&1
  local got=$?
  if [ "$got" = "$want" ]; then pass=$((pass+1));
  else fail=$((fail+1)); echo "FAIL [guard-memory] want=$want got=$got : $desc"; fi
}

json_case() { # description, command, env - stdout must be empty or ONE json object
  local desc="$1" cmd="$2" envs="${3:-}"
  local out
  # shellcheck disable=SC2086
  out=$(printf '{"cwd":"%s","tool_name":"Bash","tool_input":{"command":%s}}' \
    "$KIT" "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$cmd")" \
    | env $envs python3 "$HERE/guard-memory.py" 2>/dev/null)
  if [ -z "$out" ] || echo "$out" | python3 -c 'import json,sys; json.load(sys.stdin)' 2>/dev/null; then
    pass=$((pass+1))
  else
    fail=$((fail+1)); echo "FAIL [guard-memory] stdout not pure JSON : $desc"
  fi
}

G=guard-git.py
# --- git add: must BLOCK ---
bash_case $G 2 "bare add -A"                 'git add -A'
bash_case $G 2 "add --all"                   'git add --all'
bash_case $G 2 "add dot"                     'git add .'
bash_case $G 2 "add dot then commit"         'git add . && git commit -m "x"'
bash_case $G 2 "after cd"                    'cd /tmp/repo && git add -A'
bash_case $G 2 "with -C"                     'git -C /tmp/repo add -A'
bash_case $G 2 "env prefix bypass"           'FOO=1 git add -A'
bash_case $G 2 "files then dot"              'git add src/a.ts .'
bash_case $G 2 "in subshell"                 'echo $(git add -A)'
# --- git add: must ALLOW (zero controls) ---
bash_case $G 0 "named paths"                 'git add src/app.ts docs/x.md'
bash_case $G 0 "dotfile is a named path"     'git add .env.example'
bash_case $G 0 "dot-slash path"              'git add ./src/app.ts'
bash_case $G 0 "quoted in grep"              'grep "git add -A" notes.md'
bash_case $G 0 "quoted in echo"              "echo 'git add .'"
bash_case $G 0 "in commit message"           'git commit -m "stop using git add -A"'
bash_case $G 0 "unrelated"                   'git status && ls -la'
# --- git push: must BLOCK ---
bash_case $G 2 "bare push"                   'git push'
bash_case $G 2 "push origin main"            'git push origin main'
bash_case $G 2 "cd then push"                'cd /x && git push origin main'
bash_case $G 2 "env prefix, wrong var"       'FOO=1 git push'
# --- git push: must ALLOW ---
bash_case $G 0 "approved push"               'KIT_APPROVED_PUSH=1 git push origin main'
bash_case $G 0 "quoted push"                 'echo "git push"'
bash_case $G 0 "pushd builtin"               'pushd /tmp'
# --- counts guard ---
C=guard-kit-counts.py
bash_case $C 0 "commit outside kit ignored"  'git commit -m "x"' # cwd overridden below
CWD_OVERRIDE=/tmp bash_case $C 0 "commit in /tmp ignored" 'git commit -m "x"'
bash_case $C 0 "non-commit in kit ignored"   'git status'
# counts guard vs the kit RIGHT NOW (docs just fixed, so: allow)
bash_case $C 0 "kit commit with true docs"   'git commit -m "x"'
# --- memory guard, half A: kills aimed at live work must BLOCK ---
mem_case 2 "pkill claude"                   'pkill -f claude'
mem_case 2 "killall Ghostty"                'killall Ghostty'
mem_case 2 "killall Dia"                    'killall Dia'
mem_case 2 "case insensitive"               'pkill GHOSTTY'
mem_case 2 "after cd"                       'cd /tmp && pkill -9 ghostty'
mem_case 2 "env prefix"                     'FOO=1 killall Dia'
mem_case 2 "in subshell"                    'echo $(pkill claude)'
mem_case 2 "quoted target is still target"  'pkill -f "claude"'
mem_case 2 "command substitution pgrep"     'kill -9 $(pgrep -f ghostty)'
mem_case 2 "sudo walk-through"              'sudo pkill -f claude'
mem_case 2 "sudo killall"                   'sudo killall Ghostty'
mem_case 2 "xargs names victim upstream"    'pgrep -f ghostty | xargs kill -9'
mem_case 2 "nohup prefix"                   'nohup pkill claude'
mem_case 2 "time prefix"                    'time killall Dia'
mem_case 2 "command prefix"                 'command killall Ghostty'
mem_case 2 "exec prefix"                    'exec pkill claude'
mem_case 2 "ClaudeCode.app bundle name"     'pkill -f ClaudeCode.app'
mem_case 2 "osascript quit"                 "osascript -e 'quit app \"Ghostty\"'"
# --- memory guard, half A: zero controls, must ALLOW ---
mem_case 0 "chrome is not protected"        'killall "Google Chrome"'
mem_case 0 "simulator is not protected"     'killall Simulator'
mem_case 0 "judged per statement"           'killall Simulator && open -a Dia'
mem_case 0 "quoted verb in grep"            'grep "killall Ghostty" notes.md'
mem_case 0 "quoted verb in echo"            "echo 'pkill claude'"
mem_case 0 "commit message"                 'git commit -m "never pkill claude"'
mem_case 0 "reading is not killing"         'ps aux | grep -i ghostty'
mem_case 0 "measuring is fine"              'vm_stat && memory_pressure -Q'
mem_case 0 "resurrect drives ghostty"       "osascript -e 'tell app \"Ghostty\" to write text \"ls\"'"
mem_case 0 "word boundary: diagrams"        'ls -la ~/diagrams'
mem_case 0 "unrelated"                      'ls -la'
mem_case 0 "trailing comment names app"     'killall Xcode  # keep ghostty alive'
mem_case 0 "comment mentions dia"           'killall Simulator # dia stays up'
mem_case 0 "config dir is not a process"    'pkill -f /Users/example/.claude/chrome-devtools-mcp.log'
# Heredoc bodies are DATA being written to a file, not commands about to run.
# Without this the guard blocks editing the resurrect tooling, because the script
# it writes legitimately contains a quit line. Caught 2026-08-21.
mem_case 0 "heredoc body: kill is data"     $'cat > /tmp/x.sh <<\'XEOF\'\npkill -f claude\nXEOF'
mem_case 0 "heredoc body: quit is data"     $'cat > /tmp/x.sh <<\'XEOF\'\nosascript -e "tell application \\"Ghostty\\" to quit"\nXEOF'
mem_case 0 "unquoted heredoc too"           $'cat > /tmp/x.sh <<XEOF\nkillall Dia\nXEOF'
# ...but a real command AFTER the heredoc closes must still be judged.
mem_case 2 "real kill after a heredoc"      $'cat > /tmp/x.sh <<\'XEOF\'\nharmless\nXEOF\npkill -f claude'
mem_case 0 "config path in substitution"    'kill $(lsof -t /Users/example/.claude/tmp/x)'
# --- memory guard, half B: warns, NEVER blocks ---
mem_case 0 "OK gate stays silent"           'npm install'  'HEADROOM_FAKE_GATE=0'
mem_case 0 "TIGHT warns, never blocks"      'npm install'  'HEADROOM_FAKE_GATE=10'
mem_case 0 "STOP warns, never blocks"       'npm ci'       'HEADROOM_FAKE_GATE=20'
mem_case 0 "not hungry, no gate call"       'ls -la'       'HEADROOM_FAKE_GATE=20'
mem_case 0 "missing headroom fails open"    'npm install'  'HEADROOM_BIN=/nonexistent'
mem_case 0 "real machine never blocks"      'npm ci'
json_case  "stdout pure when silent"        'ls -la'       'HEADROOM_FAKE_GATE=20'
json_case  "stdout pure when warning"       'npm install'  'HEADROOM_FAKE_GATE=10'

# --- em-dash guard ---
file_case 2 "em dash in tsx"        "/x/app/page.tsx"        "const t = 'a — b'"
file_case 2 "en dash in tsx"        "/x/app/page.tsx"        "const t = '2019–2024'"
file_case 2 "minus sign in ts"      "/x/lib/math.ts"         "const d = a − b"
file_case 2 "figure dash in css"    "/x/components/a.css"    "/* p ‒ q */"
file_case 2 "em dash in css cmt"    "/x/components/a.css"    "/* nice — bad */"
file_case 0 "hyphen in tsx"         "/x/app/page.tsx"        "const t = 'a - b'"
file_case 2 "em dash in md now blocked" "/x/docs/notes.md"   "docs — not fine anymore"
file_case 2 "en dash in md now blocked" "/x/docs/notes.md"   "2019–2024 not fine"
file_case 0 "hyphen in md"          "/x/docs/notes.md"       "2019-2024 - correct"
file_case 0 "md under content ok"   "/x/content/notes.md"    "verbatim — kept"
file_case 0 "arrow is not a dash"   "/x/app/page.tsx"        "// brief → handoff"
file_case 0 "content dir exempt"    "/x/content/work.ts"     "verbatim — kept"
file_case 0 "node_modules exempt"   "/x/node_modules/a.js"   "lib — whatever"
file_case 0 "clean write"           "/x/components/b.tsx"    "export const B = 1"

# --- chime: must exit 0 and return fast (Claude Code waits for hooks), silent under the off switch ---
chime_case() { # description, event
  local desc="$1" ev="$2" t0 t1 got
  t0=$(python3 -c 'import time;print(int(time.time()*1000))')
  REALM_CHIME=0 python3 "$HERE/chime.py" "$ev" >/dev/null 2>&1; got=$?
  t1=$(python3 -c 'import time;print(int(time.time()*1000))')
  if [ "$got" = 0 ] && [ $((t1 - t0)) -lt 1000 ]; then pass=$((pass+1));
  else fail=$((fail+1)); echo "FAIL [chime] exit=$got ms=$((t1 - t0)) : $desc"; fi
}
chime_case "done, silenced, fast"       done
chime_case "attention, silenced, fast"  attention
chime_case "unknown event still exits 0" whatever

echo; echo "pass=$pass fail=$fail"
[ "$fail" = 0 ]
