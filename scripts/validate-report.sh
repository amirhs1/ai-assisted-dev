#!/bin/sh

set -eu

usage() {
  echo "Usage: sh scripts/validate-report.sh path/to/report.md" >&2
  exit 2
}

[ "$#" -eq 1 ] || usage
report=$1
[ -f "$report" ] || {
  echo "Report not found: $report" >&2
  exit 2
}

verdict_count=$(grep -Ec '^\*\*Verdict: (COMPLETE|NOT COMPLETE) — .+\.\*\*$' "$report" || :)
[ "$verdict_count" -eq 1 ] || {
  echo "Expected exactly one COMPLETE or NOT COMPLETE verdict." >&2
  exit 1
}

title_count=$(grep -Ec '^## [^#].+' "$report" || :)
[ "$title_count" -eq 1 ] || {
  echo "Expected exactly one level-two report title." >&2
  exit 1
}

headings='1 Problem
2 What changed
3 Verification
4 Unverified and risks
5 Decisions made
6 What I need from you
7 Close-out'

previous=0
printf '%s\n' "$headings" | while IFS= read -r heading; do
  count=$(grep -Fxc "### $heading" "$report" || :)
  [ "$count" -eq 1 ] || {
    echo "Expected exactly one heading: ### $heading" >&2
    exit 1
  }

  line=$(grep -Fnx "### $heading" "$report" | cut -d: -f1)
  [ "$line" -gt "$previous" ] || {
    echo "Heading is out of order: ### $heading" >&2
    exit 1
  }
  previous=$line
done

echo "Completion report structure is valid: $report"
