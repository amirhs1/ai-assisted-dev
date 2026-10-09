#!/bin/sh

# Checks the shape of a report: the chat report, short or full form, or the
# pull request body. Each section appears once, in order, and is not empty; a
# section that does not apply says None. A <...> placeholder outside code
# spans and fenced blocks is rejected. A fenced block closes only on a fence
# of its own character, at least as long, indented at most three spaces and
# followed by nothing but spaces; a line indented four or more spaces never
# opens or closes one. The full chat form has exactly one verdict line, right
# after its title; the pull request body has none.
# Usage: sh scripts/validate-report.sh --chat-short|--chat-full|--pr-body report.md
# Exit status: 0 valid, 1 invalid, 2 usage error.

set -eu

usage() {
  echo "Usage: sh scripts/validate-report.sh --chat-short|--chat-full|--pr-body path/to/report.md" >&2
  exit 2
}

[ "$#" -eq 2 ] || usage
mode=${1#--}
report=$2

# Section labels, in order, separated by "|".
case $mode in
  chat-short) sections='Based on:|Open:' ;;
  chat-full) sections='End product:|1 What changed|2 Checks run|3 Decisions I made that were yours|4 What I need from you|5 Close-out' ;;
  pr-body) sections='## Summary|## Related issues|## Problem|## What changed|## Checks run|## Decisions and risks|## Notes for review|## AI assistance' ;;
  *) usage ;;
esac

[ -f "$report" ] || {
  echo "Report not found: $report" >&2
  exit 2
}

awk -v mode="$mode" -v sections="$sections" -v file="$report" '
function problem(msg) { print file ": " msg; bad = 1 }

function placeholders(line,    s, p) {
  s = line
  gsub(/`[^`]*`/, "", s)
  while (match(s, /<[^<>]*>/)) {
    p = substr(s, RSTART, RLENGTH)
    if (p !~ /^<(https?|mailto):/) problem("line " NR ": placeholder " p)
    s = substr(s, RSTART + RLENGTH)
  }
}

# Returns the section this line starts, or 0. A pull request heading must
# match exactly. A chat label may be bold or a heading, and may carry its
# text on the same line, after " — " or ":"; that text goes into rest.
function label(line,    i, s) {
  for (i = 1; i <= n; i++) {
    s = line
    if (mode == "pr-body") {
      sub(/[ \t]+$/, "", s)
      if (s == name[i]) { rest = ""; return i }
      continue
    }
    sub(/^#+[ \t]+/, "", s)
    sub(/^\*\*/, "", s)
    if (index(s, name[i]) != 1) continue
    s = substr(s, length(name[i]) + 1)
    sub(/^\*\*/, "", s)
    if (s != "" && s !~ /^[ \t:]/) continue
    sub(/^[ \t]+/, "", s)
    if (index(s, "—") == 1) s = substr(s, length("—") + 1)
    sub(/^:/, "", s)
    sub(/^[ \t]+/, "", s)
    rest = s
    return i
  }
  return 0
}

# Returns the length of the run of backticks or tildes that makes this line a
# fence, or 0; sets fchar to the run character and after to the rest of the
# line.
function fence(line,    s, len) {
  match(line, /^ */)
  if (RLENGTH > 3) return 0
  s = substr(line, RLENGTH + 1)
  fchar = substr(s, 1, 1)
  if (fchar != "`" && fchar != "~") return 0
  len = 0
  while (substr(s, len + 1, 1) == fchar) len++
  if (len < 3) return 0
  after = substr(s, len + 1)
  return len
}

BEGIN { n = split(sections, name, "|"); current = 0 }

{
  line = $0
  sub(/\r$/, "", line)
  code = fenced
  run = fence(line)
  if (!fenced && run) {
    fenced = code = 1
    open_char = fchar
    open_len = run
  } else if (fenced && run && fchar == open_char && run >= open_len && after ~ /^ *$/)
    fenced = 0
  if (!code) placeholders(line)
  if (line ~ /^[ \t]*$/) next
  if (++lines == 1) first = line
  if (!code) {
    if (line ~ /^(\*\*)?Verdict:/) {
      verdicts++
      if (!verdict_at) verdict_at = lines
      if (line !~ /^\*\*Verdict: (COMPLETE|NOT COMPLETE) — .+\*\*$/)
        problem("line " NR ": the verdict must read **Verdict: COMPLETE — ...** or **Verdict: NOT COMPLETE — ...**")
    }
    i = label(line)
    if (i) {
      if (!seen[i]++) at[i] = NR
      current = i
      if (rest != "") filled[i] = 1
      next
    }
    if (mode == "pr-body" && line ~ /^## /) { current = -1; next }
  }
  filled[current] = 1
}

END {
  if (mode == "chat-full") {
    if (first !~ /^## [^ ]/) problem("the first line must be the title, a ## heading")
    if (verdicts == 0) problem("no verdict line")
    if (verdicts > 1) problem("expected exactly one verdict line, found " verdicts)
    if (verdicts && verdict_at != 2) problem("the verdict line must come right after the title")
  }
  if (mode == "pr-body" && verdicts) problem("a pull request body has no verdict line")
  if (mode == "chat-short" && !filled[0]) problem("the answer is missing before Based on:")
  last = 0
  for (i = 1; i <= n; i++) {
    if (!seen[i]) { problem("missing section: " name[i]); continue }
    if (seen[i] > 1) problem("section appears " seen[i] " times: " name[i])
    if (at[i] < last) problem("section out of order: " name[i])
    else last = at[i]
    if (!filled[i]) problem("empty section: " name[i] " (write None if it does not apply)")
  }
  exit bad
}
' "$report" >&2 || exit 1

echo "Report shape is valid ($mode): $report"
