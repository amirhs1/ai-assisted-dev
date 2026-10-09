#!/bin/sh

# Checks skill metadata, in the current directory or the one given.
# Each .agents/skills/<name>/SKILL.md: the frontmatter name is <name>, the
# description says when to use the skill (a sentence starting "Use"),
# disable-model-invocation, which makes a skill user-invoked only, is true or
# false where it is set, and no placeholder or template comment is left. A
# placeholder is a <...> outside code, or a code span that holds only one,
# such as `<main>`. A fenced block closes only on a fence of its own
# character, at least as long; a line indented four or more spaces is never a
# fence.
# Each templates/SKILL-<name>-template.md (in this repository): the same
# frontmatter checks, with name equal to <name>.
# Usage: sh scripts/check-skills.sh [directory]
# Exit status: 0 valid or no skills, 1 a problem, 2 usage error.

set -eu

usage() {
  echo "Usage: sh scripts/check-skills.sh [directory]" >&2
  exit 2
}

[ "$#" -le 1 ] || usage
[ -d "${1:-.}" ] || usage
cd "${1:-.}"

# check <file> <expected name> <check the body: yes or no>
check() {
  awk -v file="$1" -v want="$2" -v body="$3" '
    function problem(msg) { print file ": " msg; bad = 1 }
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
    function value(s,    q) {
      q = "\047"
      sub(/^[ \t]+/, "", s)
      sub(/[ \t]+$/, "", s)
      if (length(s) > 1 && substr(s, 1, 1) == substr(s, length(s)) &&
          (substr(s, 1, 1) == "\"" || substr(s, 1, 1) == q))
        s = substr(s, 2, length(s) - 2)
      return s
    }
    function placeholders(line,    s, span, p) {
      s = line
      while (match(s, /`[^`]*`/)) {
        span = substr(s, RSTART + 1, RLENGTH - 2)
        if (span ~ /^<[^<>]*>$/) problem("line " NR ": placeholder " span)
        s = substr(s, 1, RSTART - 1) " " substr(s, RSTART + RLENGTH)
      }
      while (match(s, /<[^<>]*>/)) {
        p = substr(s, RSTART, RLENGTH)
        if (p !~ /^<(https?|mailto):/) problem("line " NR ": placeholder " p)
        s = substr(s, RSTART + RLENGTH)
      }
    }

    NR == 1 {
      if ($0 == "---") frontmatter = 1
      else { problem("no frontmatter: the first line must be ---"); skip = 1 }
      next
    }
    skip { next }
    frontmatter && /^---[ \t]*$/ { frontmatter = 0; closed = 1; next }
    frontmatter {
      if (sub(/^name:/, "")) name = value($0)
      else if (sub(/^description:/, "")) description = value($0)
      else if (sub(/^disable-model-invocation:/, "")) {
        sub(/^[ \t]+/, "")
        sub(/[ \t]+$/, "")
        if ($0 != "true" && $0 != "false")
          problem("disable-model-invocation is " $0 "; expected true or false")
      }
      next
    }
    body == "yes" {
      line = $0
      if (in_code(line)) next
      if (comment) {
        if (!index(line, "-->")) next
        comment = 0
        line = substr(line, index(line, "-->") + 3)
      }
      if (index(line, "<!--")) {
        problem("line " NR ": template comment")
        rest = substr(line, index(line, "<!--") + 4)
        line = substr(line, 1, index(line, "<!--") - 1)
        if (index(rest, "-->")) line = line substr(rest, index(rest, "-->") + 3)
        else comment = 1
      }
      placeholders(line)
    }

    END {
      if (skip) exit 1
      if (!closed) problem("the frontmatter is not closed with ---")
      if (name == "") problem("the frontmatter has no name")
      else if (name != want) problem("name is " name "; expected " want)
      if (description == "") problem("the frontmatter has no description")
      else if (description !~ /(^|[.!?][ \t]+)Use /)
        problem("the description does not say when to use the skill: add a sentence starting \"Use\"")
      exit bad
    }' "$1" >&2
}

found=0
status=0
for skill in .agents/skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  found=$((found + 1))
  name=${skill#.agents/skills/}
  check "$skill" "${name%/SKILL.md}" yes || status=1
done
for template in templates/SKILL-*-template.md; do
  [ -f "$template" ] || continue
  found=$((found + 1))
  name=${template#templates/SKILL-}
  check "$template" "${name%-template.md}" no || status=1
done

if [ "$found" -eq 0 ]; then
  echo "No skills to check: no .agents/skills/*/SKILL.md or templates/SKILL-*-template.md"
  exit 0
fi
[ "$status" -eq 0 ] || exit 1
echo "Skill metadata is valid: $found files"
