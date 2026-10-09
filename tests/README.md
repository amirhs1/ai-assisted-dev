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

Each fixture's name starts with its mode: `<mode>.md` or `<mode>.<case>.md`.

- `pass/chat-short.md` — the short chat form.
- `pass/chat-full.md` — the full chat form, with plain, bold, and heading
  labels.
- `pass/pr-body.md` — a pull request body with code that quotes placeholders.
- `pass/pr-body.nested-fence.md` — a four-backtick block that holds a
  three-backtick line, a `~~~` line, and a fence indented four spaces.
- `fail/chat-short.md` — a placeholder, no answer, an empty `Open:`.
- `fail/chat-full.md` — bad, misplaced, and repeated verdicts; empty and
  out-of-order sections.
- `fail/pr-body.md` — a placeholder, a verdict, empty, out-of-order, and
  missing sections.
- `fail/pr-body.unclosed-fence.md` — a four-backtick block that shorter,
  `~~~~`, and indented fences do not close, so the sections after it are
  missing, and its trailer block is code.
- `fail/pr-body.empty-notes.md` — a trailer block that is the only content
  of "Notes for review".

## `commit-msg/` — `.githooks/commit-msg`

- `pass/ai-commit.txt` — `Why:` in the body; trailers, one wrapped with an
  indent.
- `pass/no-model.txt` — `not recorded` in place of a model id.
- `pass/no-trailers.txt` — a body and no trailer block.
- `pass/why-only.txt` — a human commit ending with a wrapped `Why:` line.
- `pass/subject-only.txt` — a subject only, which looks like a trailer.
- `pass/human-co-author.txt` — a person as `Co-authored-by:`, and
  `Signed-off-by:`.
- `pass/editor-comments.txt` — git comment lines, and a diff below the
  scissors line.
- `pass/skip-merge.txt`, `pass/skip-revert.txt` — skipped, though each holds
  an AI `Co-Authored-By:`.
- `fail/unknown-key.txt` — `Why:` and `Reviewed-by:` in the trailer block.
- `fail/wrapped-line.txt` — a wrapped trailer line without an indent.
- `fail/free-detail.txt` — extra text inside the `Assisted-by:` role.
- `fail/bad-role.txt` — a role not in the list.
- `fail/template-placeholders.txt` — the template's placeholders in
  `Assisted-by:`.
- `fail/ai-co-author.txt` — `Co-Authored-By:` naming Claude.
- `fail/outside-final-paragraph.txt` — a blank line inside the trailer block.
- `fail/fixup.txt`, `fail/squash.txt`, `fail/amend.txt` — checked like any
  message: each holds an AI `Co-Authored-By:`.

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

- `pass/repo.txt` — four valid skills, one user-invoked, and a user-invoked
  skill template; one skill holds a three-backtick block inside a
  four-backtick one.
- `pass/no-skills.txt` — no skills at all: nothing to check, so it passes.
- `fail/repo.txt` — one fault per skill, among them a
  `disable-model-invocation` that is neither true nor false, a placeholder
  after a line indented four spaces, which is not a fence, and a template
  whose name does not match its file.

## `check-adoption/` — `scripts/check-adoption.sh`

- `pass/repo.txt` — an adopted repository that passes; the self-check sets
  `core.hooksPath`. Its pull request template keeps a comment and a
  documented `<...>` format; its skill quotes a section across a line break;
  its `AGENTS.md` nests a fenced block, with a placeholder and a missing path
  inside.
- `pass/long-agents.out` — the same repository with 200 lines added to
  `AGENTS.md`, which the self-check writes out: a warning, and a pass.
- `pass/no-claude.txt` — no `CLAUDE.md` or `.claude/`: the Claude checks are
  skipped.
- `fail/repo.txt` — one of each fault, among them a "Skills" table that
  differs from `.agents/skills/`, a missing path, a missing section, a
  placeholder after a line indented four spaces, and a broken link in a
  `PULL_REQUEST_TEMPLATE.md`; `core.hooksPath` is not set.
- `fail/claude-dir-only.txt` — `.claude/` without `CLAUDE.md`.

## `check-names/` — `scripts/check-names.sh --labels`

Each manifest holds a `labels.tsv`, saved output of the script's
`gh label list` call; the self-check never calls `gh`.

- `pass/repo.txt` — names that agree, with an issue template under a listed
  pattern and a `dependabot.yml`; a line indented four spaces before the lists
  is not a fence.
- `pass/repo-commands.out` — the same with `--print-label-commands`: one
  `gh label edit` command.
- `fail/repo.txt` — one of each fault: labels, `.gitmessage`, a skill's
  labels, and the "Where these names are used" list.
- `fail/repo-commands.out` — the same with `--print-label-commands`: one
  `gh label create` command.
