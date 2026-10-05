#!/bin/sh

# This repository's self-check. It runs each tool on its passing and failing
# fixtures under tests/ and checks the exit status and, where a fixture has a
# .out file, the exact output. It also checks that CLAUDE.md imports
# AGENTS.md. ShellCheck runs separately.
# Usage: sh scripts/check-repo.sh

set -eu

repo_root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Fixture repositories must not read the developer's git configuration.
GIT_CONFIG_GLOBAL=/dev/null
GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL GIT_CONFIG_NOSYSTEM

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

# in_dir <directory> <command...>
in_dir() (
  cd "$1"
  shift
  "$@"
)

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

for f in tests/commit-msg/pass/*.txt; do expect 0 - sh .githooks/commit-msg "$f"; done
for f in tests/commit-msg/fail/*.txt; do
  expect 1 "${f%.txt}.out" sh .githooks/commit-msg "$f"
done

# provenance-report.sh runs in a repository built from a fixture history.
git init -q -b main "$tmp/provenance"
git -C "$tmp/provenance" fast-import --quiet < tests/provenance-report/history.fi
provenance="$repo_root/scripts/provenance-report.sh"
d=tests/provenance-report
expect 0 $d/pass/main.out in_dir "$tmp/provenance" sh "$provenance" main
expect 0 $d/pass/none.out in_dir "$tmp/provenance" sh "$provenance" main~3..main~2
expect 2 $d/fail/no-range.out in_dir "$tmp/provenance" sh "$provenance"
expect 2 $d/fail/bad-range.out in_dir "$tmp/provenance" sh "$provenance" main..nosuch

if [ "$failures" -gt 0 ]; then
  echo "$failures of $checks checks failed." >&2
  exit 1
fi
echo "All $checks checks passed."
