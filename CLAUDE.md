@AGENTS.md

## Claude Code

- `.claude/settings.json` turns off Claude Code's own commit and pull request
  attribution lines; `AGENTS.md` "Provenance" governs the trailer.
- The same file asks before maintainer-only commands (merge, ready, release,
  repository edits, force-push, `gh api`). If a prompt appears for one, stop
  and hand the step to the maintainer.
