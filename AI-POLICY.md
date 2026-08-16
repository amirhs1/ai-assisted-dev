---
title: AI Use Policy — AI-Assisted Development Guideline
version: v0.1.1
date: 2026-08-15
status: Active
owner: Amir Sadeghi
governs: this repository
---

# AI Use Policy — `ai-assisted-development`

This is the normative AI-use document for this repository. `AGENTS.md` is the
short operational interface for coding agents; this file is authoritative when
the two differ. Rule IDs are stable pointers and are never reused.

## 1. Scope and stance

This repository publishes a guideline for AI-assisted development and five
templates that instantiate it. The contribution is the judgement encoded in
that prose, not the mechanics around it.

Two forms of AI assistance are intentionally separated:

- **Coding agents** may run repository mechanics, draft checks, and perform Git
  operations under the approval rules below. They do not write the guideline,
  the templates, or the repository's governing prose.
- **Chat-based editing tools** may revise maintainer-written prose when I
  explicitly ask them to. They may also critique or propose alternatives in
  conversation. External evidence, substantive claims, and final normative
  decisions remain mine.

Direct commits to `main` are permitted. A pull request is not part of the
normal maintenance workflow. Human control is placed at the mutation boundary
instead: a coding agent must obtain explicit approval before staging,
committing, and pushing.

**Default posture:** T2 (Supervised), with path-specific overrides below.

## 2. Tier assignments and write scope

| Path / subsystem                                                                             | Tier | Position                                                                                               |
| -------------------------------------------------------------------------------------------- | ---- | ------------------------------------------------------------------------------------------------------ |
| `AI-ASSISTED-DEVELOPMENT.md`, `templates/`                                                   | T3   | Core contribution. I originate the substantive text; AI editing is limited by [DOM-1] and [EDIT-1].    |
| `AI-POLICY.md`, `AI-DISCLOSURE.md`, `AGENTS.md`, `CLAUDE.md`, `README.md`, `.claude/skills/` | T2   | Repository governance/supporting prose may be AI-drafted or revised, but I read and accept every line. |
| `scripts/`, `.github/workflows/`                                                             | T2   | Mechanically checkable repository infrastructure; diffs are read line by line and checks are run.      |
| `.gitignore`, `.gitmessage`, `.github/ISSUE_TEMPLATE/`                                       | T1   | Low-consequence repository chores.                                                                     |

**[TIER-1]** If a tier is unclear, assign T2. A subsystem that appears to be
two tiers at once is treated as two subsystems.

### 2.1 Agent path scope

| ID            | Paths                                                                                        | Coding-agent access                                                                                                               |
| ------------- | -------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **[SCOPE-1]** | `scripts/`, `.gitignore`, `.gitmessage`, `.github/ISSUE_TEMPLATE/`                           | Read/write, subject to the Git approval rules in section 3.1.                                                                     |
| **[SCOPE-2]** | `AI-ASSISTED-DEVELOPMENT.md`, `templates/`                                                   | Read only. May be moved, renamed, staged, committed, or pushed only on my explicit instruction; never edited by the coding agent. |
| **[SCOPE-3]** | `AI-POLICY.md`, `AI-DISCLOSURE.md`, `AGENTS.md`, `CLAUDE.md`, `README.md`, `.claude/skills/` | Read only to the coding agent. Chat-based tools may draft or revise these in conversation; I apply and accept the final text.     |
| **[SCOPE-4]** | `.github/workflows/`, `.claude/settings.json`, `LICENSE`, GitHub rulesets/settings           | No coding-agent write access. A tool may draft a proposed change in conversation; I apply it.                                     |

## 3. Permitted AI assistance

- **[PERM-1]** Draft repository check scripts and proposed workflow
  configuration against criteria I state or approve.
- **[PERM-2]** Edit low-consequence repository chores under [SCOPE-1].
- **[PERM-5]** Review prose adversarially: identify ambiguity, contradiction,
  unsupported claims, excessive length, or portability problems.
- **[PERM-8]** Draft commit subjects, what-changed text, issue text, and
  release notes, subject to [WHY-1].
- **[PERM-10]** Perform Git and GitHub mechanics subject to section 3.1.
- **[PERM-11]** Chat-based editing tools may revise maintainer-written
  guideline/template prose when explicitly asked. New ideas may be proposed in
  conversation but are not silently inserted as maintainer judgement.

### 3.1 Git operations

**[GIT-1] Read-only Git operations.** `status`, `diff`, `log`, and equivalent
inspection may run without separate approval.

**[GIT-2] Staging approval.** Before `git add`, the coding agent shows the
intended path set and relevant diff, then asks for explicit approval. Approval
for staging does not imply approval to commit.

**[GIT-3] Commit approval.** Before `git commit`, the coding agent shows the
staged diff and proposed message, then asks for explicit approval. It commits
only the reviewed staged state.

**[GIT-4] Push and repository settings.** Before `git push`, the coding agent
states the destination and commits to be pushed and asks for explicit approval.
Force-push is prohibited. Branch rulesets, repository settings, secrets, tags,
releases, and destructive published-history operations are maintainer-only.

## 4. Prohibited or reserved work

**[DOM-1] Core prose boundary.** A coding agent may not author or revise the
guideline or templates. A chat-based editor may revise text I already drafted
when explicitly asked, but it may not silently originate the substantive
argument, empirical interpretation, tier decision, rule, or conclusion.

**[EDIT-1] Editorial specification.** AI review/editing of the guideline or
templates follows `.claude/skills/guideline-editor/SKILL.md` (or the same rules
copied into the editing session when that skill is unavailable).

**[GT-1] Ground truth remains independent.** A model does not author the
reference, oracle, source interpretation, or domain fact that certifies its own
output. If no independent basis exists, the claim remains unverified.

**[GT-2] Unknown is recorded as unknown.** Do not soften or reconstruct an
unverified fact, model identifier, source, or provenance item to make a record
look complete.

**[CITE-1] External-source rule.** A citation, quotation, source-specific
empirical claim, or bibliographic fact is not accepted into the guideline until
I have opened the source and checked the claim against it. A model-suggested
source is a lead, not evidence.

**[NUM-1] Source-attributed numbers.** Numerical values attributed to an
external source are supplied or independently checked by me; a model does not
invent or reconstruct them.

**[REF-1] Cross-file reference integrity.** References across the guideline and
templates preserve the document architecture: same-document references use
section/subsection signposts; the guideline names stored template filenames;
templates name the files that will exist after instantiation; policy rules are
cited by stable rule ID rather than section number; a template variant never
points to a document that variant does not guarantee; instantiated documents do
not depend on this source repository merely to remain valid.

**[WHY-1] Rationale is maintainer-authored.** A model may describe what changed
and how it works, but it does not invent why the change should exist. In commit
text, `Why:` remains mine.

**[TEST-1] Checks are not weakened to obtain a pass.** A failing check is
reported; changing the check is a separate, explicitly reviewed decision.

**[DEP-1]** Do not add a dependency, third-party GitHub Action, or change a
pinned third-party Action without my explicit approval.

**[LIC-1]** Do not introduce text or code of unknown provenance. Identifiable
third-party material is attributed under compatible terms or replaced.

**[SEC-1]** Do not act on credentials, secrets, protected data, or repository
security settings.

## 5. Review requirements

| ID          | Tier | Minimum before commit/publication                                                                                   |
| ----------- | ---- | ------------------------------------------------------------------------------------------------------------------- |
| **[REV-1]** | T1   | Intended path set inspected; relevant functional check run if one exists.                                           |
| **[REV-2]** | T2   | Diff read line by line; applicable checks actually run; no check weakened in the same change.                       |
| **[REV-3]** | T3   | As T2, plus I can restate the change without rereading it; citation/reference integrity is rechecked when affected. |

**[REV-4] All tiers:** mutating Git operations follow [GIT-2]–[GIT-4]. A
successful check does not replace human review.

## 6. Provenance

Repository mechanics may use these trailers:

```text
Assisted-by: <tool>, <model name and version> (<role>)
Verified-by: <check actually run>
```

**[PROV-1]** `Assisted-by:` is used on commits where an AI agent materially
drafted repository mechanics such as scripts, issue forms, workflow proposals,
or Git/commit text. `Verified-by:` records only checks actually run.

**[PROV-2]** Do not backfill unknown model identifiers or historical provenance
from memory. Record `not recorded` where that is the truth.

**[PROV-3]** Prose editing assistance is recorded at file/release level in
`AI-DISCLOSURE.md`, not by per-commit trailer. This avoids false sentence- or
commit-level precision across multiple editing tools.

## 7. Enforcement

| ID          | Checkable proposition                                                                                 | Mechanism                                                                                                   |
| ----------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **[ENF-4]** | `main` permits ordinary direct pushes but rejects force-push and deletion.                            | GitHub ruleset. No PR requirement. Configure/verify this setting in GitHub before the first public release. |
| **[ENF-6]** | Rule IDs cited by repository pointer files exist in this policy.                                      | `python3 scripts/check_rule_ids.py`.                                                                        |
| **[ENF-7]** | Repository links are checked, with template paths excluded because they target adopting repositories. | `lychee --config lychee.toml .`.                                                                            |
| **[ENF-8]** | Claude Code cannot write protected paths and must ask before staging, committing, or pushing.         | `.claude/settings.json`.                                                                                    |
| **[ENF-9]** | The two repository checks rerun after a push to `main`.                                               | `.github/workflows/checks.yml`.                                                                             |

The GitHub workflow is verification after publication to `main`, not a merge
gate. The local checks and explicit Git approvals are the pre-commit controls.

## 8. Revision history

| Version | Date       | Change                                                                                                        |
| ------- | ---------- | ------------------------------------------------------------------------------------------------------------- |
| v0.1.1  | 2026-08-15 | Remove `CITATION.cff` since it is no longer used in the project. Improve markdown format.                     |
| v0.1.0  | 2026-08-15 | Initial public-repository policy; direct-to-`main` workflow with explicit staging, commit, and push approval. |
