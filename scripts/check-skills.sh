#!/bin/sh

# Checks skill metadata, in the current directory or the one given.
# Each .agents/skills/<name>/SKILL.md: the frontmatter name is <name>, the
# description says when to use the skill (a sentence starting "Use"), and no
# placeholder or template comment is left. A placeholder is a <...> outside
# code, or a code span that holds only one, such as `<main>`.
# Each templates/SKILL-<name>-template.md (in this repository): the same
# frontmatter checks, with name equal to <name>.
# Usage: sh scripts/check-skills.sh [directory]
# Exit status: 0 valid, 1 a problem or no skills found, 2 usage error.

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
      next
    }
    body == "yes" {
      line = $0
      if (line ~ /^[ \t]*(```|~~~)/) { fenced = !fenced; next }
      if (fenced) next
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
  echo "No skills found: no .agents/skills/*/SKILL.md or templates/SKILL-*-template.md" >&2
  exit 1
fi
[ "$status" -eq 0 ] || exit 1
echo "Skill metadata is valid: $found files"
