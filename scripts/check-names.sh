#!/bin/sh

# Checks that a repository's names agree with CONTRIBUTING.md, "Names", in
# the current directory or the one given. It reads the types: and areas:
# lines of the section's fenced block, then fails when:
# - a type or area has no label (type:<word>, area:<word>), or a type: or
#   area: label is in neither list;
# - .gitmessage lists a type the section lacks, or leaves one out;
# - a type:<word> or area:<word> in .gitmessage, AGENTS.md, a skill, an issue
#   or pull request template, or .github/dependabot.yml is in neither list;
# - a file under "Where these names are used" does not exist or does not cite
#   the section, or one of the files above cites it or uses a label but is
#   not listed there. A file cites the section when it names both
#   CONTRIBUTING.md and "Names".
# It reads the labels with gh label list and never writes to GitHub.
# --print-label-commands also prints, for a person to run, gh label create
# for each missing label and gh label edit for each label whose description
# is not "Type: <word>" or "Area: <word>".
# --labels reads saved output of
#   gh label list --limit 1000 --json name,description --jq '.[] | [.name, .description] | @tsv'
# instead of calling gh, as the tests do.
# Usage: sh scripts/check-names.sh [--print-label-commands] [--labels <file>] [directory]
# Exit status: 0 the names agree, 1 a difference, 2 usage or read error.

set -eu

usage() {
  echo "Usage: sh scripts/check-names.sh [--print-label-commands] [--labels <file>] [directory]" >&2
  exit 2
}

print=no
labels_file=
while [ "$#" -gt 0 ]; do
  case $1 in
    --print-label-commands)
      print=yes
      shift
      ;;
    --labels)
      if [ "$#" -lt 2 ] || [ ! -f "$2" ]; then usage; fi
      case $2 in
        /*) labels_file=$2 ;;
        *) labels_file=$PWD/$2 ;;
      esac
      shift 2
      ;;
    -*) usage ;;
    *) break ;;
  esac
done
[ "$#" -le 1 ] || usage
[ -d "${1:-.}" ] || usage
cd "${1:-.}"

tab=$(printf '\t')
problems=0
problem() {
  echo "$1" >&2
  problems=$((problems + 1))
}

# in_list <word> <list...>: succeeds when the word is in the list.
in_list() {
  word=$1
  shift
  for w in "$@"; do
    if [ "$w" = "$word" ]; then return 0; fi
  done
  return 1
}

# cites <file>: succeeds when the file names CONTRIBUTING.md and "Names".
cites() {
  grep -q 'CONTRIBUTING\.md' "$1" && grep -q '"Names"' "$1"
}

if [ ! -f CONTRIBUTING.md ]; then
  echo "No CONTRIBUTING.md: there is no \"Names\" section to check against." >&2
  exit 1
fi

# names <key>: prints the words of the key's line in the fenced block of the
# "Names" section, one per line.
names() {
  awk -v key="$1:" '
    /^## / { inside = ($0 == "## Names"); next }
    inside && /^[ \t]*(```|~~~)/ { fenced = !fenced; next }
    inside && fenced && $1 == key { for (i = 2; i <= NF; i++) print $i }
  ' CONTRIBUTING.md
}
types=$(names types)
areas=$(names areas)
if [ -z "$types" ] || [ -z "$areas" ]; then
  echo "CONTRIBUTING.md: no \"Names\" section with types: and areas: lines in a fenced block" >&2
  exit 1
fi

# Labels: each type and area needs one; a type: or area: label needs a type
# or area.
if [ -n "$labels_file" ]; then
  labels=$(cat "$labels_file")
else
  labels=$(gh label list --limit 1000 --json name,description \
    --jq '.[] | [.name, .description] | @tsv') || {
    echo "Could not read the labels with gh label list." >&2
    exit 2
  }
fi
want=$(
  for t in $types; do printf 'type:%s\tType: %s\n' "$t" "$t"; done
  for a in $areas; do printf 'area:%s\tArea: %s\n' "$a" "$a"; done
)
commands=
while IFS="$tab" read -r name description; do
  if have=$(printf '%s\n' "$labels" |
    awk -v name="$name" 'BEGIN { FS = "\t" } $1 == name { print $2; found = 1 } END { exit !found }'); then
    [ "$have" = "$description" ] ||
      commands="$commands
gh label edit \"$name\" --description \"$description\""
  else
    problem "label $name is missing"
    commands="$commands
gh label create \"$name\" --description \"$description\""
  fi
done << EOF
$want
EOF
while IFS="$tab" read -r name description; do
  case $name in
    type:* | area:*)
      printf '%s\n' "$want" | awk -v name="$name" 'BEGIN { FS = "\t" } $1 == name { found = 1 } END { exit !found }' ||
        problem "label $name is in neither list in \"Names\""
      ;;
  esac
done << EOF
$labels
EOF

# .gitmessage lists the same types.
if [ -f .gitmessage ]; then
  listed=$(awk '
    { s = $0; sub(/^#[ \t]*/, "", s) }
    s ~ /^Types:/ {
      sub(/^Types:/, "", s)
      gsub(/[,.]/, " ", s)
      n = split(s, word, " ")
      for (i = 1; i <= n; i++) print word[i]
    }' .gitmessage)
  if [ -n "$listed" ]; then
    # shellcheck disable=SC2086 # the lists split into words
    for t in $listed; do
      in_list "$t" $types || problem ".gitmessage: type $t is not in \"Names\""
    done
    # shellcheck disable=SC2086
    for t in $types; do
      in_list "$t" $listed || problem ".gitmessage: type $t from \"Names\" is missing"
    done
  fi
fi

# The files that may apply the names.
candidates=$(
  for f in .gitmessage AGENTS.md .agents/skills/*/SKILL.md .github/dependabot.yml \
    .github/dependabot.yaml .github/ISSUE_TEMPLATE/*; do
    if [ -f "$f" ]; then printf '%s\n' "$f"; fi
  done
  for f in .github/* docs/* ./*; do
    name=$(basename -- "$f" | tr '[:upper:]' '[:lower:]')
    if [ -f "$f" ] && [ "$name" = pull_request_template.md ]; then
      printf '%s\n' "${f#./}"
    elif [ -d "$f" ] && [ "$name" = pull_request_template ]; then
      for g in "$f"/*.md; do
        if [ -f "$g" ]; then printf '%s\n' "${g#./}"; fi
      done
    fi
  done
)

# The paths in code spans under "Where these names are used".
used=$(awk '
  /^#+ / { inside = ($0 ~ /^#+ Where these names are used[ \t]*$/); next }
  inside {
    s = $0
    while (match(s, /`[^`]+`/)) {
      print substr(s, RSTART + 1, RLENGTH - 2)
      s = substr(s, RSTART + RLENGTH)
    }
  }' CONTRIBUTING.md)

# is_listed <file>: succeeds when a listed path or pattern matches the file.
is_listed() {
  while IFS= read -r p; do
    # shellcheck disable=SC2254 # a listed path may be a pattern
    case $1 in $p) return 0 ;; esac
  done << EOF
$used
EOF
  return 1
}

# Labels named in the candidate files.
while IFS= read -r f; do
  [ -n "$f" ] || continue
  tokens=$(awk '{
    s = $0
    while (match(s, /(type|area):[A-Za-z0-9][A-Za-z0-9-]*/)) {
      before = RSTART > 1 ? substr(s, RSTART - 1, 1) : ""
      if (before !~ /[A-Za-z0-9_-]/) print NR "\t" substr(s, RSTART, RLENGTH)
      s = substr(s, RSTART + RLENGTH)
    }
  }' "$f")
  while IFS="$tab" read -r line token; do
    [ -n "$token" ] || continue
    word=${token#*:}
    case $token in
      type:*) printf '%s\n' "$types" | grep -Fxq -- "$word" ||
        problem "$f: line $line: label $token is in neither list in \"Names\"" ;;
      area:*) printf '%s\n' "$areas" | grep -Fxq -- "$word" ||
        problem "$f: line $line: label $token is in neither list in \"Names\"" ;;
    esac
  done << EOF
$tokens
EOF
  if { [ -n "$tokens" ] || cites "$f"; } && ! is_listed "$f"; then
    problem "$f: applies the names but is not listed under \"Where these names are used\""
  fi
done << EOF
$candidates
EOF

# Each listed file exists and cites the section.
while IFS= read -r p; do
  [ -n "$p" ] || continue
  found=no
  # shellcheck disable=SC2086 # a listed path may be a pattern
  for f in $p; do
    [ -e "$f" ] || continue
    found=yes
    cites "$f" ||
      problem "$f: listed under \"Where these names are used\" but does not cite CONTRIBUTING.md, \"Names\""
  done
  [ "$found" = yes ] ||
    problem "CONTRIBUTING.md: $p, listed under \"Where these names are used\", does not exist"
done << EOF
$used
EOF

if [ "$print" = yes ] && [ -n "$commands" ]; then
  printf '%s\n' "${commands#?}"
fi
if [ "$problems" -gt 0 ]; then
  echo "Problems found: $problems" >&2
  exit 1
fi
echo "Names agree with CONTRIBUTING.md, \"Names\"."
