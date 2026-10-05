# Tests

`sh scripts/check-repo.sh` runs every fixture here; ShellCheck runs separately.

- `pass/` holds inputs the tool must accept (exit 0); `fail/` holds inputs it
  must reject (exit 1).
- A `.out` file next to a fixture is the exact output the tool must print.
- A `repo.txt` manifest holds a whole fixture repository: each file starts at a
  `==> path <==` line, and the self-check writes it out to a temporary
  directory.

## `check-repo/` — the `CLAUDE.md` rule in `scripts/check-repo.sh`

- `pass/import-only.md` — `@AGENTS.md` alone.
- `pass/claude-section.md` — `@AGENTS.md`, then a Claude-only section.
- `fail/text-before-import.md` — a heading before the import.
- `fail/prose-after-import.md` — prose, not a `## ` section, after the import.

## `validate-report/` — `scripts/validate-report.sh`

Each fixture is named after its mode.

- `pass/chat-short.md` — the short chat form.
- `pass/chat-full.md` — the full chat form, with plain, bold, and heading
  labels.
- `pass/pr-body.md` — a pull request body with code that quotes placeholders.
- `fail/chat-short.md` — a placeholder, no answer, an empty `Open:`.
- `fail/chat-full.md` — bad, misplaced, and repeated verdicts; empty and
  out-of-order sections.
- `fail/pr-body.md` — a placeholder, a verdict, empty, out-of-order, and
  missing sections.

## `commit-msg/` — `.githooks/commit-msg`

- `pass/ai-commit.txt` — `Why:` in the body; trailers, one wrapped with an
  indent.
- `pass/no-model.txt` — `not recorded` in place of a model id.
- `pass/no-trailers.txt` — a body and no trailer block.
- `pass/subject-only.txt` — a subject only, which looks like a trailer.
- `pass/human-co-author.txt` — a person as `Co-authored-by:`, and
  `Signed-off-by:`.
- `pass/editor-comments.txt` — git comment lines, and a diff below the
  scissors line.
- `pass/skip-*.txt` — `Merge`, `Revert`, `fixup!`, `squash!`, `amend!`:
  skipped, though each holds an AI `Co-Authored-By:`.
- `fail/unknown-key.txt` — `Why:` and `Reviewed-by:` in the trailer block.
- `fail/wrapped-line.txt` — a wrapped trailer line without an indent.
- `fail/free-detail.txt` — extra text inside the `Assisted-by:` role.
- `fail/bad-role.txt` — a role not in the list.
- `fail/template-placeholders.txt` — the template's placeholders in
  `Assisted-by:`.
- `fail/ai-co-author.txt` — `Co-Authored-By:` naming Claude.
- `fail/outside-final-paragraph.txt` — a blank line inside the trailer block.

## `provenance-report/` — `scripts/provenance-report.sh`

- `history.fi` — a `git fast-import` history: a trailer outside the final
  paragraph, a merge that repeats a trailer, a pipe in a subject.
- `pass/main.out` — the report for the range `main`.
- `pass/none.out` — the report for a range with no provenance lines.
- `fail/no-range.out` — the usage error, with no range given.
- `fail/bad-range.out` — the error for a range that does not exist.

## `check-repo-settings/` — `scripts/check-repo-settings.sh --file`

Each input is saved output of the script's `gh api --jq` filter.

- `pass/match.txt` — all five settings as expected.
- `fail/all-differ.txt` — all five differ; one is `null`.
- `fail/message-missing.txt` — `merge_commit_message` absent.

## `check-skills/` — `scripts/check-skills.sh`

- `pass/repo.txt` — two valid skills and a skill template.
- `fail/repo.txt` — one fault per skill, and a template whose name does not
  match its file.

## `check-adoption/` — `scripts/check-adoption.sh`

- `pass/repo.txt` — an adopted repository that passes; the self-check sets
  `core.hooksPath`.
- `fail/repo.txt` — one of each fault; `core.hooksPath` is not set.
