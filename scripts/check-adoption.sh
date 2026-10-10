#!/bin/sh

# Adoption check for a repository that adopted these templates; run it from
# the repository's root. It fails when:
# - a placeholder or template comment is left in a governance file; a
#   placeholder is a <...> outside code, or a code span holding only one; a
#   fenced block closes only on a fence of its own character, at least as
#   long, and a line indented four or more spaces is never a fence;
# - a relative link in a governance file does not resolve;
# - the README tier table and the AGENTS.md "Where you may write" table list
#   different paths or tiers;
# - the AGENTS.md "Skills" table and .agents/skills/ list different skills;
# - in AGENTS.md or a skill, a path in a code span does not exist, or a
#   section quoted with its file (AGENTS.md, "Git", or "Names" in
#   CONTRIBUTING.md) is not a heading in that file, found from the root or
#   the citing file's folder. A code span is a path when it holds a slash and
#   its first segment exists at the root, or, without a slash, when it is
#   more than an extension and ends in one a tracked file uses; so feat/,
#   .scss, and site.url are not paths. A path exists from the root or the
#   citing file's folder, or when git ignores it; one without a slash also
#   exists when a tracked file or folder anywhere has that name. A part
#   listed in the "Where you may write" table must exist, even one only
#   planned, when its first segment exists;
# - core.hooksPath is not set.
# When CLAUDE.md or .claude/ exists, it also fails when:
# - CLAUDE.md is missing, does not start with the line @AGENTS.md, or holds
#   anything but "## " sections after it;
# - .claude/settings.json lacks the attribution block.
# It warns, without failing, when AGENTS.md has more than 200 lines, the
# budget the AGENTS template's design rule 1 recommends.
# Governance files: AGENTS.md, CLAUDE.md, AI-POLICY.md, the pull request
# templates, and the AI sections of README.md and CONTRIBUTING.md. A pull
# request template, .md or .txt, in .github/, docs/, or the root, under any
# case, guides the person writing a pull request: its comments and <...>
# formats are kept, so only its links are checked. For skill metadata, run
# check-skills.sh.
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

# scan <file> [section heading] [guide]: prints "P<tab>problem" for each
# placeholder or template comment and "L<tab>line<tab>target" for each
# relative link, in the whole file or only in the given "## " section. With
# guide, comments and placeholders are kept and only links are printed.
scan() {
  awk -v section="${2-}" -v guide="${3-}" '
    # fence(line): the length of the run of backticks or tildes that makes the
    # line a fence, or 0; sets fchar to its character and after to the rest.
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
    # in_code(line): 1 when the line is a fence or inside a fenced block. A block
    # closes only on a fence of its own character, at least as long, followed by
    # nothing but spaces.
    function in_code(line,    run) {
      run = fence(line)
      if (!fenced && run) { fenced = 1; open_char = fchar; open_len = run; return 1 }
      if (fenced && run && fchar == open_char && run >= open_len && after ~ /^ *$/) {
        fenced = 0
        return 1
      }
      return fenced
    }
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
      if (in_code(line)) next
      if (comment) {
        if (!index(line, "-->")) next
        comment = 0
        line = substr(line, index(line, "-->") + 3)
      }
      if (index(line, "<!--")) {
        if (!guide) print "P\tline " NR ": template comment"
        rest = substr(line, index(line, "<!--") + 4)
        line = substr(line, 1, index(line, "<!--") - 1)
        if (index(rest, "-->")) line = line substr(rest, index(rest, "-->") + 3)
        else comment = 1
      }
      if (!guide) placeholders(line)
      links(line)
    }
    END { if (section != "" && !found) print "P\tno \"" section "\" section" }' "$1"
}

# check_text <file> [section heading] [guide]
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

# pr_templates: prints each pull request template GitHub reads: a file named
# pull_request_template.md or .txt, in any case, in .github/, docs/, or the
# root, or a .md or .txt file in a PULL_REQUEST_TEMPLATE/ directory there.
pr_templates() {
  for f in .github/* docs/* ./*; do
    name=$(basename -- "$f" | tr '[:upper:]' '[:lower:]')
    if [ -f "$f" ] && { [ "$name" = pull_request_template.md ] ||
      [ "$name" = pull_request_template.txt ]; }; then
      printf '%s\n' "${f#./}"
    elif [ -d "$f" ] && [ "$name" = pull_request_template ]; then
      for g in "$f"/*; do
        case $(basename -- "$g" | tr '[:upper:]' '[:lower:]') in
          (*.md | *.txt) if [ -f "$g" ]; then printf '%s\n' "${g#./}"; fi ;;
        esac
      done
    fi
  done
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

# refs <file>: prints "C<tab>line<tab>span" for each code span shaped like a
# path, one with a slash or with text before a final extension, and
# "S<tab>file<tab>section" for each section quoted with its file, outside
# fenced blocks and comments.
refs() {
  awk '
    # fence(line): the length of the run of backticks or tildes that makes the
    # line a fence, or 0; sets fchar to its character and after to the rest.
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
    # in_code(line): 1 when the line is a fence or inside a fenced block. A block
    # closes only on a fence of its own character, at least as long, followed by
    # nothing but spaces.
    function in_code(line,    run) {
      run = fence(line)
      if (!fenced && run) { fenced = 1; open_char = fchar; open_len = run; return 1 }
      if (fenced && run && fchar == open_char && run >= open_len && after ~ /^ *$/) {
        fenced = 0
        return 1
      }
      return fenced
    }
    function path(s) {
      sub(/:[0-9]+(-[0-9]+)?$/, "", s)
      if (s ~ /[] \t<>*?[{}$|="(),@#~!\\:;]/ || s ~ /^[-\/]/) return ""
      if (s ~ /^(origin|upstream|refs)\//) return ""
      if (s ~ /\// || s ~ /.\.[^.]+$/) return s
      return ""
    }
    {
      line = $0
      if (in_code(line)) next
      if (comment) {
        if (!index(line, "-->")) next
        comment = 0
        line = substr(line, index(line, "-->") + 3)
      }
      if (index(line, "<!--")) {
        rest = substr(line, index(line, "<!--") + 4)
        line = substr(line, 1, index(line, "<!--") - 1)
        if (index(rest, "-->")) line = line substr(rest, index(rest, "-->") + 3)
        else comment = 1
      }
      s = line
      while (match(s, /`[^`]+`/)) {
        p = path(substr(s, RSTART + 1, RLENGTH - 2))
        if (p != "") print "C\t" NR "\t" p
        s = substr(s, RSTART + RLENGTH)
      }
      text = text " " line
    }
    END {
      gsub(/`/, "", text)
      gsub(/[ \t]+/, " ", text)
      s = text
      while (match(s, /[A-Za-z0-9_.\/-]+\.md,? "[^"]+"/)) {
        m = substr(s, RSTART, RLENGTH)
        s = substr(s, RSTART + RLENGTH)
        file = m
        sub(/,? ".*/, "", file)
        sec = substr(m, index(m, "\"") + 1)
        sub(/"$/, "", sec)
        print "S\t" file "\t" sec
      }
      s = text
      while (match(s, /"[^"]+" in [A-Za-z0-9_.\/-]+\.md/)) {
        m = substr(s, RSTART, RLENGTH)
        s = substr(s, RSTART + RLENGTH)
        sec = substr(m, 2)
        sub(/" in .*/, "", sec)
        file = m
        sub(/.*" in /, "", file)
        print "S\t" file "\t" sec
      }
    }' "$1"
}

# heading <file> <text>: succeeds when the file exists and a heading in it
# reads text.
heading() {
  [ -f "$1" ] && awk -v want="$2" '
    /^#+[ \t]/ {
      s = $0
      sub(/^#+[ \t]+/, "", s)
      sub(/[ \t]+#*[ \t]*$/, "", s)
      if (s == want) found = 1
    }
    END { exit !found }' "$1"
}

# is_path <span>: succeeds when a span shaped like a path is one: with a
# slash, its first segment exists at the root; without, its extension is one
# a tracked file uses.
is_path() {
  case $1 in
    */*) [ -e "${1%%/*}" ] ;;
    *) printf '%s\n' "$extensions" | grep -Fxq -- "${1##*.}" ;;
  esac
}

# exists <path> <dir>: succeeds when the path exists from the root or from
# dir, or git ignores it, or, without a slash, a tracked file or folder
# anywhere has that name.
exists() {
  [ -e "$1" ] || [ -e "$2/$1" ] || git check-ignore -q -- "$1" 2> /dev/null ||
    case $1 in
      */*) false ;;
      *) printf '%s\n' "$names" | grep -Fxq -- "$1" ;;
    esac
}

# check_refs <file>
check_refs() {
  out=$(refs "$1" | awk '!seen[$0]++')
  dir=$(dirname -- "$1")
  while IFS="$tab" read -r kind where what; do
    case $kind in
      C)
        if is_path "$what" && ! exists "$what" "$dir"; then
          problem "$1: line $where: path $what does not exist"
        fi
        ;;
      S)
        if [ ! -f "$where" ] && [ ! -f "$dir/$where" ]; then
          problem "$1: $where, \"$what\": $where does not exist"
        elif ! heading "$where" "$what" && ! heading "$dir/$where" "$what"; then
          problem "$1: $where has no \"$what\" section"
        fi
        ;;
    esac
  done << EOF
$out
EOF
}

for f in AGENTS.md README.md; do
  [ -f "$f" ] || problem "$f is missing"
done
for f in AGENTS.md CLAUDE.md AI-POLICY.md; do
  [ ! -f "$f" ] || check_text "$f"
done
templates=$(pr_templates)
while IFS= read -r f; do
  [ -z "$f" ] || check_text "$f" '' guide
done << EOF
$templates
EOF
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

if [ -f AGENTS.md ]; then
  lines=$(awk 'END { print NR }' AGENTS.md)
  if [ "$lines" -gt 200 ]; then
    echo "warning: AGENTS.md has $lines lines; design rule 1 of the AGENTS template recommends at most 200" >&2
  fi

  # The skill names in the first column of the "Skills" table, and the
  # skills in .agents/skills/.
  table=$(awk -F '|' '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    /^## / { inside = ($0 == "## Skills"); next }
    inside && /^\|/ && trim($2) ~ /^`[^`]+`$/ {
      s = trim($2)
      print substr(s, 2, length(s) - 2)
    }' AGENTS.md | LC_ALL=C sort -u)
  skills=$(for s in .agents/skills/*/SKILL.md; do
    if [ -f "$s" ]; then s=${s#.agents/skills/}; printf '%s\n' "${s%/SKILL.md}"; fi
  done | LC_ALL=C sort -u)
  if [ -n "$skills" ] && ! grep -q '^## Skills[ \t]*$' AGENTS.md; then
    problem "AGENTS.md: no \"Skills\" section, though .agents/skills/ holds skills"
  else
    while IFS= read -r s; do
      [ -z "$s" ] || printf '%s\n' "$skills" | grep -Fxq -- "$s" ||
        problem "skills differ: only the AGENTS.md \"Skills\" table lists $s"
    done << EOF
$table
EOF
    while IFS= read -r s; do
      [ -z "$s" ] || printf '%s\n' "$table" | grep -Fxq -- "$s" ||
        problem "skills differ: only .agents/skills/ holds $s"
    done << EOF
$skills
EOF
  fi

  # The names of tracked files and the folders above them, and the
  # extensions tracked files use, for code spans without a slash.
  tracked=$(git ls-files -z 2> /dev/null | tr '\000' '\n')
  names=$(printf '%s\n' "$tracked" | awk -F / '{ for (i = 1; i <= NF; i++) print $i }' |
    LC_ALL=C sort -u)
  extensions=$(printf '%s\n' "$tracked" |
    awk -F / 'match($NF, /.\.[^.]+$/) { print substr($NF, RSTART + 2) }' | LC_ALL=C sort -u)
  check_refs AGENTS.md
  for s in .agents/skills/*/SKILL.md; do
    [ ! -f "$s" ] || check_refs "$s"
  done
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
