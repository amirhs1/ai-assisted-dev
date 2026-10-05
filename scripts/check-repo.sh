#!/bin/sh

# This repository's self-check. It runs each tool on its passing fixtures
# under tests/ (exit 0) and its failing fixtures (exit 1, printing exactly the
# fixture's .out file), and checks that CLAUDE.md imports AGENTS.md.
# ShellCheck runs separately.
# Usage: sh scripts/check-repo.sh

set -eu

repo_root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

checks=0
failures=0

# expect <exit status> <expected output file, or -> <command...>
expect() {
  want=$1
  expected=$2
  shift 2
  checks=$((checks + 1))
  status=0
  "$@" > "$tmp/output" 2>&1 || status=$?
  if [ "$status" -ne "$want" ]; then
    echo "FAIL: exit $status, expected $want: $*" >&2
    sed 's/^/  /' "$tmp/output" >&2
    failures=$((failures + 1))
  elif [ "$expected" != - ] && ! diff -u "$expected" "$tmp/output" >&2; then
    echo "FAIL: output differs from $expected: $*" >&2
    failures=$((failures + 1))
  fi
}

# CLAUDE.md is "@AGENTS.md" on its first line, optionally followed by
# Claude-only sections, each starting with a "## " heading.
claude_md() {
  awk 'NR == 1 { ok = ($0 == "@AGENTS.md"); next }
    /^[ \t]*$/ { next }
    !seen++ && !/^## / { ok = 0 }
    END { exit !(NR > 0 && ok) }' "$1" || {
    echo "$1: must be @AGENTS.md, optionally followed by Claude-only sections" >&2
    return 1
  }
}

expect 0 - claude_md CLAUDE.md
for f in tests/check-repo/pass/*.md; do expect 0 - claude_md "$f"; done
for f in tests/check-repo/fail/*.md; do expect 1 "${f%.md}.out" claude_md "$f"; done

# Each fixture is named after its mode.
for f in tests/validate-report/pass/*.md; do
  mode=$(basename "$f" .md)
  expect 0 - sh scripts/validate-report.sh "--$mode" "$f"
done
for f in tests/validate-report/fail/*.md; do
  mode=$(basename "$f" .md)
  expect 1 "${f%.md}.out" sh scripts/validate-report.sh "--$mode" "$f"
done

if [ "$failures" -gt 0 ]; then
  echo "$failures of $checks checks failed." >&2
  exit 1
fi
echo "All $checks checks passed."
