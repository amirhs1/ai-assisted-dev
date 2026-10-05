#!/bin/sh

# Prints the AI provenance of a commit range as two Markdown tables. First
# the search form: each commit with an Assisted-by: line anywhere in its
# message. Then the trailer form: each Assisted-by:, Ground-truth-source:,
# and Checks-run: line, wherever it sits, so a line outside the final
# paragraph still counts. Merge commits are left out: one repeats the pull
# request body, which would count it twice.
# Usage: sh scripts/provenance-report.sh <range>      for example v1.0..v1.1
# Exit status: 0 printed, 2 usage error or a range git cannot read.

set -eu

usage() {
  echo "Usage: sh scripts/provenance-report.sh <range>" >&2
  exit 2
}

[ "$#" -eq 1 ] || usage
range=$1
case $range in -*) usage ;; esac
git rev-list --no-merges "$range" -- > /dev/null 2>&1 || {
  echo "Not a commit range in this repository: $range" >&2
  exit 2
}

# table <header row> <rule row>: prints tab-separated rows from stdin as a
# Markdown table, or "None." when there are none.
table() {
  awk -F '\t' -v header="$1" -v rule="$2" '
    function escape(s,    n, part, i, out) {
      n = split(s, part, "|")
      out = part[1]
      for (i = 2; i <= n; i++) out = out "\\|" part[i]
      return out
    }
    NR == 1 { print header; print rule }
    {
      row = "|"
      for (i = 1; i <= NF; i++) row = row " " escape($i) " |"
      print row
    }
    END { if (NR == 0) print "None." }'
}

echo "## Search form: commits with an Assisted-by: line"
echo
git log --no-merges --grep='^Assisted-by:' --format='%h%x09%ad%x09%s' \
  --date=short "$range" -- |
  table '| Commit | Date | Subject |' '| ------ | ---- | ------- |'
echo
echo "## Trailer form: provenance lines"
echo
git log --no-merges --format='%x1e%h%n%B' "$range" -- |
  awk 'substr($0, 1, 1) == "\036" { commit = substr($0, 2); next }
    /^(Assisted-by|Ground-truth-source|Checks-run):/ { print commit "\t" $0 }' |
  table '| Commit | Line |' '| ------ | ---- |'
