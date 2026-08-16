---
title: AI Use Disclosure — AI-Assisted Development Guideline
version: v0.1.0
date: 2026-08-15
covers: v0.1.0 (initial public release)
prepared-by: Amir Sadeghi
accountable-for-content: Amir Sadeghi
governed-by: AI-POLICY.md v0.1.0
tools:
  [
    Claude Code — models not recorded,
    Claude — models not recorded,
    ChatGPT — models not recorded,
    Grammarly,
  ]
supersedes: n/a
---

# AI Use Disclosure — `ai-assisted-development`

This record describes AI assistance used in preparing the guideline, templates,
and repository supporting files for the initial public release. AI systems are
not credited as authors; Amir Sadeghi remains accountable for the published
content.

## 1. Summary

The substantive guideline and template content originated with the maintainer.
Chat-based AI tools were used to revise maintainer-written prose, test clarity
and structure, and provide adversarial review. The coding agent is restricted
from writing the guideline and templates.

Repository governance/supporting files (`AI-POLICY.md`, `AGENTS.md`,
`AI-DISCLOSURE.md`, `README.md`, the editorial skill, and repository
configuration) received substantial AI-assisted drafting and revision under
maintainer direction. Repository mechanics such as checks and workflow
configuration may also be agent-drafted. The maintainer reviews and accepts the
published state.

## 2. Tools used

| Tool        | Version / model | Period       | Roles                                                              |
| ----------- | --------------- | ------------ | ------------------------------------------------------------------ |
| Claude Code | not recorded    | not recorded | Git/GitHub operations; repository mechanics; check/workflow drafts |
| Claude      | not recorded    | not recorded | Editing maintainer-written prose; adversarial review               |
| ChatGPT     | not recorded    | not recorded | Editing maintainer-written prose; adversarial review               |
| Grammarly   | n/a             | not recorded | Copy-editing                                                       |

Unknown model identifiers and session dates are not reconstructed from memory.

## 3. Where assistance was used

| Component                                                                       | Extent                                                                  | Human control / verification                                                   |
| ------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| `AI-ASSISTED-DEVELOPMENT.md`                                                    | Editing of maintainer-written drafts; structural and adversarial review | Maintainer accepts every revision and owns source selection and interpretation |
| `templates/`                                                                    | Editing of maintainer-written drafts                                    | Maintainer accepts every revision and owns the normative decisions             |
| `AI-POLICY.md`, `AI-DISCLOSURE.md`, `AGENTS.md`, `README.md`, `.claude/skills/` | Substantial AI-assisted drafting/revision under maintainer direction    | Maintainer reviews line by line before publication                             |
| `scripts/`, `.github/workflows/`, issue/configuration files                     | Agent/chatbot drafting permitted                                        | Maintainer reviews diffs and runs or observes the repository checks            |
| Commit and release text                                                         | Agent may draft subject and what-changed text                           | Rationale and final acceptance remain maintainer-authored                      |

**Not delegated to AI:** selection and reading of external evidence; the
substantive argument of the guideline; the final tier model, rule decisions,
template semantics, and acceptance of what is published.

## 4. Ground truth and source handling

These are statements of the maintainer's intended release practice:

- [x] External references used as evidence are opened and checked by the
      maintainer before citation.
- [x] Source-specific empirical claims and attributed numerical values
      originate with, or are independently checked by, the maintainer.
- [x] Model-suggested citations are treated as unverified leads until the
      maintainer checks the source.
- [x] The substantive guideline and template judgements originate with the
      maintainer; AI assistance there is editorial/review assistance.
- [x] No generated passage known to reproduce an identifiable external source
      remains knowingly unattributed.

## 5. Known limitations

- Prose editing assistance is recorded at aggregate file/release level; it is
  not reconstructable sentence by sentence.
- Historical model identifiers and exact session dates were not consistently
  logged and are recorded as `not recorded` rather than inferred.
- Repository supporting documents in this release received more than
  copy-editing: they include AI-assisted drafting under maintainer direction.
- The project has one maintainer and no independent reviewer; the accuracy of
  this disclosure rests on that maintainer's record and review.
- The GitHub `main` ruleset is repository configuration rather than a tracked
  file, so its configured state must be checked in GitHub separately.

## 6. Provenance convention

Agent-authored repository mechanics may carry:

```text
Assisted-by: <tool>, <model name and version> (<role>)
Verified-by: <check actually run>
```

Prose assistance carries no per-commit trailer; this file is the release-level
record.

## 7. Revision history

| Version | Date       | Change                                           |
| ------- | ---------- | ------------------------------------------------ |
| v0.1.0  | 2026-08-15 | Initial disclosure for the first public release. |
