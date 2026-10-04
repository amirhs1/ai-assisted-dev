# AI-Assisted Development Templates

This repository holds Markdown templates, a Git commit-message template, and a
Claude Code settings template for projects that use AI in software development
or research. The companion _AI-Assisted Development Guideline_ will be
published separately on the author's Jekyll website and its public link will be
added here when available.

## Template files

| File                                                                                   | Use in an adopting project                                                         |
| -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| [`AGENTS-template.md`](templates/AGENTS-template.md)                                   | Adapt as `AGENTS.md` for coding agents.                                            |
| [`AI-POLICY-template.md`](templates/AI-POLICY-template.md)                             | Adapt as `AI-POLICY.md` for contributors.                                          |
| [`AI-DISCLOSURE-template.md`](templates/AI-DISCLOSURE-template.md)                     | Adapt as a disclosure for a specific research output.                              |
| [`README-ai-section-template.md`](templates/README-ai-section-template.md)             | Add an AI section to the project's `README.md`.                                    |
| [`CONTRIBUTING-ai-section-template.md`](templates/CONTRIBUTING-ai-section-template.md) | Add a section to `CONTRIBUTING.md`; its second block fits an existing PR template. |
| [`pull-request-template.md`](templates/pull-request-template.md)                       | Use as a complete `.github/pull_request_template.md` when needed.                  |
| [`chat-report-template.md`](templates/chat-report-template.md)                         | Give agents the short and full forms of their report in chat.                      |
| [`SKILL-write-commit-template.md`](templates/SKILL-write-commit-template.md)           | Copy to `.agents/skills/write-commit/SKILL.md`.                                    |
| [`SKILL-open-pull-request-template.md`](templates/SKILL-open-pull-request-template.md) | Copy to `.agents/skills/open-pull-request/SKILL.md`.                               |
| [`SKILL-open-issue-template.md`](templates/SKILL-open-issue-template.md)               | Copy to `.agents/skills/open-issue/SKILL.md`.                                      |
| [`SKILL-post-comment-template.md`](templates/SKILL-post-comment-template.md)           | Copy to `.agents/skills/post-comment/SKILL.md`.                                    |
| [`SKILL-report-back-template.md`](templates/SKILL-report-back-template.md)             | Copy to `.agents/skills/report-back/SKILL.md`.                                     |
| [`gitmessage-template.txt`](templates/gitmessage-template.txt)                         | Copy to `.gitmessage` and adapt the commit convention.                             |
| [`claude-settings-template.json`](templates/claude-settings-template.json)             | Copy to `.claude/settings.json` for Claude Code.                                   |

The two PR options serve different starting points: add the short AI block to
an existing PR template, or copy the complete PR template. Use one AI prompt in
the resulting PR form.

[`.gitmessage`](.gitmessage) is this repository's own commit-message example.
To use a copied `.gitmessage` for editor-based commits, run
`git config commit.template .gitmessage` in that project. Git does not apply it
to `git commit -m`; check the final message for completed provenance trailers.

## AI-assisted development

I use AI tools in this project. Each part has a tier, set by whether I can
evaluate AI output there. The table records the checks or human review applied
to each part:

- **Instrumented** — I could write it myself. AI is used for review,
  refactoring, and alternative implementations, not first drafts of core logic.
- **Supervised** — AI drafts; I read every line and set the acceptance criteria
  and test values.
- **Delegated** — AI generates; I can't fully evaluate it. It is covered by
  tests, kept isolated and low-risk, and not presented as my work.

| Part                                    | Tier         | Checks or human review                                                                                                                                                |
| --------------------------------------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Stored templates, `README.md`           | Instrumented | I design and write the first draft of each file; AI revises; I review every line and finalize wording.                                                                |
| Issues, pull requests, commit messages  | Instrumented | AI drafts at my request; I review each before it is posted or merged.                                                                                                 |
| `.gitmessage`, `.gitignore`, `.github/` | Instrumented | AI writes at my request; I review the diff in a pull request.                                                                                                         |
| `scripts/`, `.githooks/`, `tests/`      | Supervised   | AI drafts against acceptance criteria I set in the issues; I read every line, and ShellCheck and each script's passing and failing fixtures must pass before I merge. |

Where a tier is unclear, I treat the part as Supervised. Tiers last reviewed:
2026-10-04.

Instructions for AI agents: [`AGENTS.md`](AGENTS.md).

## Licence

Everything in this repository except the tools is licensed under
[Creative Commons Attribution 4.0 International](LICENSE) (CC BY 4.0), the
templates included. The tools in `scripts/`, `.githooks/`, and `tests/` are
licensed under the [MIT License](LICENSE-MIT). When redistributing an adapted
template, credit its source, link to the licence, and indicate that you changed
it. An adopting project's README or attribution notice can carry this
information without adding source notes to every instruction file. The
separately published article carries its own CC BY 4.0 notice on the website.

## Status

These are adaptable templates. Replace or remove every placeholder and check
each statement against the adopting project's actual practice before use.
