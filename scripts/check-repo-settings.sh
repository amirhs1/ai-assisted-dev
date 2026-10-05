#!/bin/sh

# Read-only check of a GitHub repository's merge settings. It reads them with
# gh api, changes nothing, and reports each difference from: squash merging
# off, rebase merging off, merge commits on, merge commit title from the pull
# request title, merge commit message from the pull request description.
# Usage: sh scripts/check-repo-settings.sh <owner/repo>
#        sh scripts/check-repo-settings.sh --file <saved output>
# --file reads saved output of the same gh api call, as the tests do.
# Exit status: 0 settings match, 1 a difference, 2 usage or read error.

set -eu

usage() {
  echo "Usage: sh scripts/check-repo-settings.sh <owner/repo> | --file <saved output>" >&2
  exit 2
}

filter='"allow_squash_merge=\(.allow_squash_merge)",
"allow_rebase_merge=\(.allow_rebase_merge)",
"allow_merge_commit=\(.allow_merge_commit)",
"merge_commit_title=\(.merge_commit_title)",
"merge_commit_message=\(.merge_commit_message)"'

case ${1-} in
  --file)
    [ "$#" -eq 2 ] && [ -f "$2" ] || usage
    target=$2
    settings=$(cat "$2")
    ;;
  -* | '') usage ;;
  */*)
    [ "$#" -eq 1 ] || usage
    target=$1
    settings=$(gh api "repos/$1" --jq "$filter") || {
      echo "Could not read the settings of $1 with gh api." >&2
      exit 2
    }
    ;;
  *) usage ;;
esac

differences=0
while read -r key want what; do
  got=$(printf '%s\n' "$settings" | sed -n "s/^$key=//p")
  if [ "$got" != "$want" ]; then
    echo "$target: $key is ${got:-missing}; expected $want ($what)" >&2
    differences=$((differences + 1))
  fi
done << EOF
allow_squash_merge false squash merging off
allow_rebase_merge false rebase merging off
allow_merge_commit true merge commits on
merge_commit_title PR_TITLE the pull request title
merge_commit_message PR_BODY the pull request description
EOF

[ "$differences" -eq 0 ] || exit 1
echo "Merge settings match: $target"
