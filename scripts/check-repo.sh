#!/bin/sh

# This repository's self-check. It runs each tool on its passing and failing
# fixtures under tests/ and checks the exit status and, where a fixture has a
# .out file, the exact output. It also checks that CLAUDE.md imports
# AGENTS.md. ShellCheck runs separately, and so does check-names.sh on this
# repository, since it reads the labels with gh.
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

# unpack <manifest> <directory>: writes out a fixture repository. A manifest
# holds each file as a "==> path <==" line followed by the file's lines;
# lines before the first header describe the fixture. Manifests keep fixture
# AGENTS.md, CLAUDE.md, and skill files out of this repository's tree, where
# an agent could load them as instructions.
unpack() {
  mkdir -p "$2"
  sed -n 's/^==> \(.*\) <==$/\1/p' "$1" | while IFS= read -r path; do
    mkdir -p "$2/$(dirname -- "$path")"
  done
  awk -v dir="$2" '
    /^==> .* <==$/ {
      if (file) close(file)
      file = dir "/" substr($0, 5, length($0) - 8)
      printf "" > file
      next
    }
    file { print > file }' "$1"
}

# CLAUDE.md starts with the line @AGENTS.md and holds only "## " sections
# after it, for Claude-only content.
claude_md() {
  awk 'NR == 1 { ok = ($0 == "@AGENTS.md"); next }
    /^[ \t]*$/ { next }
    !seen++ && !/^## / { ok = 0 }
    END { exit !(NR > 0 && ok) }' "$1" || {
    echo "$1: must start with the line @AGENTS.md and hold only ## sections after it" >&2
    return 1
  }
}

expect 0 - claude_md CLAUDE.md
for f in tests/check-repo/pass/*.md; do expect 0 - claude_md "$f"; done
for f in tests/check-repo/fail/*.md; do expect 1 "${f%.md}.out" claude_md "$f"; done

# Each fixture's name starts with its mode: <mode>.md or <mode>.<case>.md.
for f in tests/validate-report/pass/*.md; do
  mode=$(basename "$f" .md)
  expect 0 - sh scripts/validate-report.sh "--${mode%%.*}" "$f"
done
for f in tests/validate-report/fail/*.md; do
  mode=$(basename "$f" .md)
  expect 1 "${f%.md}.out" sh scripts/validate-report.sh "--${mode%%.*}" "$f"
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

# check-repo-settings.sh reads saved gh api output; it never calls gh here.
for f in tests/check-repo-settings/pass/*.txt; do
  expect 0 - sh scripts/check-repo-settings.sh --file "$f"
done
for f in tests/check-repo-settings/fail/*.txt; do
  expect 1 "${f%.txt}.out" sh scripts/check-repo-settings.sh --file "$f"
done

# check-skills.sh runs on this repository, then on fixture repositories.
expect 0 - sh scripts/check-skills.sh
for f in tests/check-skills/pass/*.txt; do
  unpack "$f" "$tmp/skills-pass-$(basename "$f" .txt)"
  expect 0 - sh scripts/check-skills.sh "$tmp/skills-pass-$(basename "$f" .txt)"
done
for f in tests/check-skills/fail/*.txt; do
  unpack "$f" "$tmp/skills-fail-$(basename "$f" .txt)"
  expect 1 "${f%.txt}.out" sh scripts/check-skills.sh "$tmp/skills-fail-$(basename "$f" .txt)"
done

# check-adoption.sh runs in fixture repositories whose files are tracked;
# only the passing ones set core.hooksPath.
adoption="$repo_root/scripts/check-adoption.sh"
for f in tests/check-adoption/pass/*.txt; do
  dir=$tmp/adoption-pass-$(basename "$f" .txt)
  unpack "$f" "$dir"
  git init -q -b main "$dir"
  git -C "$dir" add -A
  git -C "$dir" config core.hooksPath .githooks
  expect 0 - in_dir "$dir" sh "$adoption"
done
for f in tests/check-adoption/fail/*.txt; do
  dir=$tmp/adoption-fail-$(basename "$f" .txt)
  unpack "$f" "$dir"
  git init -q -b main "$dir"
  git -C "$dir" add -A
  expect 1 "${f%.txt}.out" in_dir "$dir" sh "$adoption"
done
# An AGENTS.md over 200 lines draws a warning, not a failure. The copy is
# padded to 201 lines, whatever the fixture holds.
dir=$tmp/adoption-long
unpack tests/check-adoption/pass/repo.txt "$dir"
lines=$(awk 'END { print NR }' "$dir/AGENTS.md")
awk -v n="$lines" 'BEGIN { for (i = n + 1; i <= 201; i++) print "- Rule " i "." }' >> "$dir/AGENTS.md"
git init -q -b main "$dir"
git -C "$dir" add -A
git -C "$dir" config core.hooksPath .githooks
expect 0 tests/check-adoption/pass/long-agents.out in_dir "$dir" sh "$adoption"

# check-names.sh runs on fixture repositories with saved labels; it never
# calls gh here.
for f in tests/check-names/pass/*.txt; do
  dir=$tmp/names-pass-$(basename "$f" .txt)
  unpack "$f" "$dir"
  expect 0 - sh scripts/check-names.sh --labels "$dir/labels.tsv" "$dir"
done
for f in tests/check-names/fail/*.txt; do
  dir=$tmp/names-fail-$(basename "$f" .txt)
  unpack "$f" "$dir"
  expect 1 "${f%.txt}.out" sh scripts/check-names.sh --labels "$dir/labels.tsv" "$dir"
done
# --print-label-commands adds the gh label commands to the same report.
expect 0 tests/check-names/pass/repo-commands.out sh scripts/check-names.sh \
  --print-label-commands --labels "$tmp/names-pass-repo/labels.tsv" "$tmp/names-pass-repo"
expect 1 tests/check-names/fail/repo-commands.out sh scripts/check-names.sh \
  --print-label-commands --labels "$tmp/names-fail-repo/labels.tsv" "$tmp/names-fail-repo"

if [ "$failures" -gt 0 ]; then
  echo "$failures of $checks checks failed." >&2
  exit 1
fi
echo "All $checks checks passed."
