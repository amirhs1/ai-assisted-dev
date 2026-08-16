# AI-Assisted Development Guideline

A practical guideline for using generative AI in software and research work
while keeping human judgement, verification, and provenance explicit. The
repository also provides five reusable templates for adopting projects.

**Start here:** [`AI-ASSISTED-DEVELOPMENT.md`](AI-ASSISTED-DEVELOPMENT.md).

## Repository contents

| Path                                                                                   | Purpose                                                                                                        |
| -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| [`AI-ASSISTED-DEVELOPMENT.md`](AI-ASSISTED-DEVELOPMENT.md)                             | The guideline: principles, evidence, workflow, and open questions.                                             |
| [`templates/`](templates/)                                                             | Five reusable templates for policy, agent instructions, disclosure, README, and CONTRIBUTING AI sections.      |
| [`AI-POLICY.md`](AI-POLICY.md)                                                         | The AI-use rules that govern this repository itself.                                                           |
| [`AI-DISCLOSURE.md`](AI-DISCLOSURE.md)                                                 | The release-level record of how AI tools were used here.                                                       |
| [`AGENTS.md`](AGENTS.md)                                                               | Short operational instructions for coding agents working on repository mechanics.                              |
| [`CLAUDE.md`](CLAUDE.md)                                                               | Claude Code shim that imports `AGENTS.md`.                                                                     |
| [`.agents/skills/guideline-editor/SKILL.md`](.agents/skills/guideline-editor/SKILL.md) | Manual editorial skill for Markdown, external citations, and cross-file references in the guideline/templates. |
| [`scripts/check_rule_ids.py`](scripts/check_rule_ids.py)                               | Checks that rule IDs cited by repository pointer files exist in `AI-POLICY.md`.                                |
| [`.github/workflows/checks.yml`](.github/workflows/checks.yml)                         | Runs the rule-ID and link checks after pushes to `main`, and on manual dispatch.                               |
| [`.github/ISSUE_TEMPLATE/gap.yml`](.github/ISSUE_TEMPLATE/gap.yml)                     | One issue form for gaps, open questions, errors, and template-usability problems.                              |
| [`.gitmessage`](.gitmessage)                                                           | Preferred commit format, types, scopes, and provenance trailers.                                               |
| [`lychee.toml`](lychee.toml)                                                           | Link-check configuration; reusable templates are excluded because their links target adopting repositories.    |
| [`LICENSE`](LICENSE)                                                                   | Licence scopes for the guideline/supporting files, templates, and scripts.                                     |

## AI-assisted development

I author the substantive guideline and template content. Chat-based AI tools
may edit maintainer-written prose; coding agents handle repository mechanics
and cannot write the core prose. The exact rules and release-level disclosure
are in [`AI-POLICY.md`](AI-POLICY.md) and
[`AI-DISCLOSURE.md`](AI-DISCLOSURE.md).

## Status

This is a living document. Known gaps and open questions stay in the guideline;
actionable ones can be tracked with the repository's single issue form.

## Licence and citation

The guideline and repository supporting prose are CC BY 4.0, `templates/` are
CC0 1.0, and `scripts/` are MIT-licensed. See [`LICENSE`](LICENSE).
