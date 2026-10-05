#!/bin/sh

# Adoption check for a repository that adopted these templates; run it from
# the repository's root. It fails when:
# - a placeholder or template comment is left in a governance file; a
#   placeholder is a <...> outside code, or a code span holding only one;
# - a relative link in a governance file does not resolve;
# - the README tier table and the AGENTS.md "Where you may write" table list
#   different paths or tiers;
# - core.hooksPath is not set.
# When CLAUDE.md or .claude/ exists, it also fails when:
# - CLAUDE.md is missing, does not start with the line @AGENTS.md, or holds
#   anything but "## " sections after it;
# - .claude/settings.json lacks the attribution block.
# Governance files: AGENTS.md, CLAUDE.md, AI-POLICY.md,
# .github/pull_request_template.md, and the AI sections of README.md and
# CONTRIBUTING.md. For skills, run check-skills.sh.
# The maintainer still reviews both tier tables: a script cannot compare
# prose.
# Usage: sh scripts/check-adoption.sh
# Exit status: 0 passed, 1 a problem, 2 usage error.

set -eu

if [ "$#" -ne 0 ]; then
  echo "Usage: sh scripts/check-adoption.sh   (from the repository's root)" >&2
  exit 2
fi

tab=$(printf '\t')
problems=0
problem() {
  echo "$1" >&2
  problems=$((problems + 1))
}

# scan <file> [section heading]: prints "P<tab>problem" for each placeholder
# or template comment and "L<tab>line<tab>target" for each relative link, in
# the whole file or only in the given "## " section.
scan() {
  awk -v section="${2-}" '
    function placeholders(line,    s, span, p) {
      s = line
      while (match(s, /`[^`]*`/)) {
        span = substr(s, RSTART + 1, RLENGTH - 2)
        if (span ~ /^<[^<>]*>$/) print "P\tline " NR ": placeholder " span
        s = substr(s, 1, RSTART - 1) " " substr(s, RSTART + RLENGTH)
      }
      while (match(s, /<[^<>]*>/)) {
        p = substr(s, RSTART, RLENGTH)
        if (p !~ /^<(https?|mailto):/) print "P\tline " NR ": placeholder " p
        s = substr(s, RSTART + RLENGTH)
      }
    }
    function links(line,    s, target) {
      s = line
      gsub(/`[^`]*`/, "", s)
      while (match(s, /\]\([^)]*\)/)) {
        target = substr(s, RSTART + 2, RLENGTH - 3)
        s = substr(s, RSTART + RLENGTH)
        sub(/[ \t].*/, "", target)
        sub(/^</, "", target)
        sub(/>$/, "", target)
        sub(/#.*/, "", target)
        if (target != "" && target !~ /^[A-Za-z][A-Za-z0-9+.-]*:/)
          print "L\t" NR "\t" target
      }
    }
    section != "" {
      if ($0 == section) { inside = found = 1; next }
      if (/^## /) inside = 0
      if (!inside) next
    }
    {
      line = $0
      if (line ~ /^[ \t]*(```|~~~)/) { fenced = !fenced; next }
      if (fenced) next
      if (comment) {
        if (!index(line, "-->")) next
        comment = 0
        line = substr(line, index(line, "-->") + 3)
      }
      if (index(line, "<!--")) {
        print "P\tline " NR ": template comment"
        rest = substr(line, index(line, "<!--") + 4)
        line = substr(line, 1, index(line, "<!--") - 1)
        if (index(rest, "-->")) line = line substr(rest, index(rest, "-->") + 3)
        else comment = 1
      }
      placeholders(line)
      links(line)
    }
    END { if (section != "" && !found) print "P\tno \"" section "\" section" }' "$1"
}

# check_text <file> [section heading]
check_text() {
  out=$(scan "$@")
  dir=$(dirname -- "$1")
  while IFS="$tab" read -r kind where target; do
    case $kind in
      P) problem "$1: $where" ;;
      L)
        case $target in
          /*) path=.$target ;;
          *) path=$dir/$target ;;
        esac
        [ -e "$path" ] || problem "$1: line $where: link target $target does not exist"
        ;;
    esac
  done << EOF
$out
EOF
}

# tiers <file>: prints "path<tab>tier" for each path in the first table whose
# second column is Tier.
tiers() {
  awk -F '|' '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    !table && /^\|/ && trim($3) == "Tier" { table = 1; next }
    table && !/^\|/ { exit }
    table && $2 !~ /^[ \t:-]+$/ {
      n = split($2, paths, ",")
      for (i = 1; i <= n; i++) {
        p = paths[i]
        gsub(/`/, "", p)
        print trim(p) "\t" trim($3)
      }
    }' "$1" | LC_ALL=C sort -u
}

for f in AGENTS.md README.md; do
  [ -f "$f" ] || problem "$f is missing"
done
for f in AGENTS.md CLAUDE.md AI-POLICY.md .github/pull_request_template.md; do
  [ ! -f "$f" ] || check_text "$f"
done
[ ! -f README.md ] || check_text README.md '## AI assistance'
[ ! -f CONTRIBUTING.md ] || check_text CONTRIBUTING.md '## AI-assisted contributions'

if [ -f README.md ] && [ -f AGENTS.md ]; then
  readme=$(tiers README.md)
  agents=$(tiers AGENTS.md)
  [ -n "$readme" ] || problem "README.md: no tier table (a table whose second column is Tier)"
  [ -n "$agents" ] || problem "AGENTS.md: no \"Where you may write\" table (a table whose second column is Tier)"
  if [ -n "$readme" ] && [ -n "$agents" ]; then
    while IFS= read -r row; do
      printf '%s\n' "$agents" | grep -Fxq -- "$row" ||
        problem "tier tables differ: only README.md lists ${row%%"$tab"*} as ${row#*"$tab"}"
    done << EOF
$readme
EOF
    while IFS= read -r row; do
      printf '%s\n' "$readme" | grep -Fxq -- "$row" ||
        problem "tier tables differ: only AGENTS.md lists ${row%%"$tab"*} as ${row#*"$tab"}"
    done << EOF
$agents
EOF
  fi
fi

if [ -f CLAUDE.md ] || [ -d .claude ]; then
  if [ ! -f CLAUDE.md ]; then
    problem "CLAUDE.md is missing, though .claude/ exists"
  elif ! awk 'NR == 1 { ok = ($0 == "@AGENTS.md"); next }
    /^[ \t]*$/ { next }
    !seen++ && !/^## / { ok = 0 }
    END { exit !(NR > 0 && ok) }' CLAUDE.md; then
    problem "CLAUDE.md: must start with the line @AGENTS.md and hold only ## sections after it"
  fi
  attribution=
  if [ -f .claude/settings.json ]; then
    attribution=$(tr -d ' \t\r\n' < .claude/settings.json |
      sed -n 's/.*"attribution":{\([^}]*\)}.*/,\1,/p')
  fi
  case $attribution in *',"commit":"",'*) commit=off ;; *) commit=on ;; esac
  case $attribution in *',"pr":"",'*) pr=off ;; *) pr=on ;; esac
  if [ "$commit" = on ] || [ "$pr" = on ]; then
    problem '.claude/settings.json: no attribution block turning off both lines: "attribution": { "commit": "", "pr": "" }'
  fi
else
  echo "No CLAUDE.md or .claude/: Claude Code checks skipped."
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  problem "not a git repository"
elif [ -z "$(git config --get core.hooksPath || :)" ]; then
  problem "core.hooksPath is not set: run git config core.hooksPath .githooks"
fi

if [ "$problems" -gt 0 ]; then
  echo "Problems found: $problems" >&2
  exit 1
fi
echo "Adoption check passed."
