---
title: AI Use Policy — <PROJECT NAME>
version: v0.1.0
date: <YYYY-MM-DD>
status: Active
owner: <YOUR NAME>
governs: this repository
---

<!--
Normative, human-facing. Audience: you, collaborators, reviewers, your future
self. Machine-facing instructions live in AGENTS.md.

This file is self-sufficient by design. It does not require any external
guideline to be readable or enforceable — it IS the authority for this
repository, and nothing else needs to be consulted to apply it.

One home per rule: this file holds the single full statement of every
normative rule in this repository. AGENTS.md carries operational one-liners
that point to rules here; any restatement anywhere else is a pointer, not a
second authority, and drift between a pointer's summary and this file is
resolved by correcting the pointer.

RULE IDS. Every rule that is referenced from another document carries a
bracketed ID — [GT-1], [WHY-1], and so on. Pointers elsewhere cite the ID,
never the section number, because a section number is a claim about where a
rule sits and stops being true the moment a section is inserted. Rules:

  - An ID is allocated once and never reused, even after the rule is deleted.
  - Renumbering or reordering sections is free; IDs do not move.
  - A rule that acquires an external pointer acquires an ID at the same time.
  - A pointer citing an ID this file does not define is a broken pointer, and
    is checkable: extract every [XXX-N] defined here and every one referenced
    in AGENTS.md, README.md, and CONTRIBUTING.md, and fail on the difference.

  version       This file's own, moving independently of everything else.

Keep this file short enough to re-read. A policy nobody re-reads is decoration.
Delete every comment block before committing.
-->

# AI Use Policy — `<PROJECT NAME>`

Normative document. Audience is human: me, collaborators, reviewers, and my
future self. Machine-facing instructions live in `AGENTS.md`.

Any conflict between this file and `AGENTS.md` is resolved **in favour of this
file**, and `AGENTS.md` is corrected.

Rules referenced from other documents carry a bracketed ID (`[GT-1]`). Cite the
ID, not the section number; IDs are allocated once and never reused.

---

## 1. Scope and stance

<One paragraph: what this project is, why ownership matters here, and what the
consequence of undetected error would be. Be concrete — "wrong numbers in a
published figure" reads differently from "a broken personal website.">

**Default posture:** <T1 Delegated | T2 Supervised | T3 Instrumented> — see
section 2 for per-subsystem overrides.

---

## 2. Tier assignments

Tiers are assigned **per subsystem**, never per repository. The variable is not
the tool and not the language; it is whether I can evaluate the output.

| Tier                  | My position                                | The model's role          | What that requires                                                                                                                |
| --------------------- | ------------------------------------------ | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **T1 — Delegated**    | I cannot evaluate the output               | Generator                 | Constrain the blast radius; treat as disposable. Not cited as a contribution.                                                     |
| **T2 — Supervised**   | I can evaluate but not efficiently produce | Drafter                   | Every diff read line by line; I finalize or approve the acceptance criteria and oracle basis; no merge without applicable checks. |
| **T3 — Instrumented** | I could write it unaided                   | Accelerator and adversary | Review, refactoring, alternative implementations — not first drafts of core domain logic.                                         |

**[TIER-1]** Where a tier is unclear, **assign T2**. It is the only tier safe
in both directions: it claims no competence I may not have, and it grants none
of T1's latitude. Do not assume T1 on the reasoning that it claims less — T1
claims less _and reviews less_ (section 5), and the second effect dominates. A
subsystem that appears to be two tiers at once is two subsystems.

**[RISK-1] Consequence ceiling for T1.** Ordinary T1 review is permitted only
for low-consequence, isolated, replaceable work. Security boundaries,
credentials or privacy-sensitive processing, safety- or regulated
functionality, research-critical numerical logic, and production-critical
infrastructure may not be merged under ordinary T1 review. Obtain competent
independent human review for the affected change, or keep/sever it from the
consequential path.

The tier a path is _assigned_ may exceed my competence at it. Assignment sets
what review the path receives; competence is what I bring to that review. Where
the two diverge, subsection 2.1 says what closing the gap requires.

| Path / subsystem                     | Tier | Rationale                                                                                                                | Last reviewed |
| ------------------------------------ | ---- | ------------------------------------------------------------------------------------------------------------------------ | ------------- |
| `src/<core>/`                        | T3   | <domain knowledge required to evaluate output>                                                                           | <YYYY-MM-DD>  |
| `src/<io>/`                          | T2   | <mechanically checkable; I can read but not fast>                                                                        | <YYYY-MM-DD>  |
| `tests/`                             | T2   | <scaffolding and tests may be drafted; oracle/reference basis is independently grounded and human-approved — see [GT-1]> | <YYYY-MM-DD>  |
| `docs/`                              | T2   | <>                                                                                                                       | <YYYY-MM-DD>  |
| `.github/workflows/`                 | T2   | <gates merges to a T2/T3 path — promoted per [MIG-1]; I read every workflow diff>                                        | <YYYY-MM-DD>  |
| `<non-blocking build/tooling paths>` | T1   | <no independent evaluation capacity; not imported by and cannot block a merge to a T2/T3 path>                           | <YYYY-MM-DD>  |

### 2.1 Migration triggers

- **[MIG-1] T1 → T2** is mandatory once a T1 path is imported by, feeds output
  into, or **can block a merge to** a T2/T3 path. CI configuration is the
  ordinary case: a workflow that gates merges is T2 whatever my competence at
  it.
- **[MIG-2] Promotion has three legal discharges:** acquire enough capacity to
  read the diff; obtain a competent independent human reviewer who can evaluate
  the change; or sever the dependency — make the check advisory, drop it from
  required status, or move the blocking logic into a path I can read. Leaving
  an unevaluated path while it gates consequential work is not a discharge.
- **[MIG-3] T3 → T2** if untouched for <N> months and I cannot answer the three
  ownership questions without re-reading the code.
- Unclear tier ⇒ **assign T2** ([TIER-1]).
- A subsystem that seems to be two tiers at once is two subsystems. Split it.

### 2.2 Agent write scope

A fact about this repository, not a rule that generalises. Path scope is the
checkable part of "may apply maintainer-originated edits, may not originate
normative judgement": a diff shows which paths changed, never who originated
the judgement.

| ID            | Paths                                                                      | Agent access                                                                                                                                              |
| ------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **[SCOPE-1]** | `<agent-writable paths>`                                                   | Read and write; PRs merge under the review rules in section 5.                                                                                            |
| **[SCOPE-2]** | `<normative paths — policy, disclosure, governing prose>`                  | May apply maintainer-supplied wording or commit approved edits; may not originate normative judgement. Covered by `CODEOWNERS`; merges require my review. |
| **[SCOPE-3]** | `.github/workflows/`, `CODEOWNERS`, branch protection, repository settings | No write access. These are the paths that constrain the agent; workflow drafting is governed by [GIT-2] and repository settings by [GIT-4].               |

---

## 3. What AI tools may do here

Checked = permitted in this repository. Delete lines that do not apply; an
unchecked box left in the committed file is a placeholder, not a policy. An ID
is not reused after its line is deleted.

- [ ] **[PERM-1]** Draft implementations against acceptance criteria I
      finalized or explicitly approved before implementation
- [ ] **[PERM-2]** Refactor, rename, add type annotations
- [ ] **[PERM-3]** Write test scaffolding, fixtures, and parametrisation
- [ ] **[PERM-4]** Write and update documentation and examples
- [ ] **[PERM-5]** Review my code adversarially
- [ ] **[PERM-6]** Produce a second independent implementation for differential
      testing
- [ ] **[PERM-7]** Generate candidate test assertions from a second model with
      no sight of the implementation — input to my judgement, accepted,
      amended, or rejected against an independent basis, never merged unread. A
      candidate is not a reference value and this is not an exception to
      [GT-1].
- [ ] **[PERM-8]** Draft commit messages, PR bodies, and release notes —
      subject to section 3.1 and [WHY-1]
- [ ] **[PERM-9]** Exploratory work without pre-stated criteria — confined to
      `sandbox/`, T1 by definition, promoted to `src/` only by rewrite against
      criteria I then finalize or explicitly approve
- [ ] **[PERM-10]** <project-specific>

### 3.1 Git and GitHub operations

A tool reading a diff sees _what_ changed, not _why_, and a commit message is
one of the few places the "why" survives — hence [WHY-1] in section 4. The
subject line, type and scope, and what-changed description may be drafted. The
rationale must originate with me; once I supply it, AI may copy-edit or
compress it without introducing a new reason. "Assist freely" in [GIT-1] below
is read subject to that rule.

| ID          | Operation                                                                                                                                                 | Position                                                                                                                                                                                                                             |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **[GIT-1]** | Drafting commit, PR, issue, and release text; explaining a git error; proposing labels or `.gitignore` entries                                            | Assist freely. Reversible, reviewed before it lands.                                                                                                                                                                                 |
| **[GIT-2]** | Drafting CI and workflow configuration                                                                                                                    | Assist in drafting; **I commit it.** The path is outside agent write scope ([SCOPE-3]) because a workflow can gate merges ([MIG-1]) — unlike everything in [GIT-1], a bad line here constrains the review that would have caught it. |
| **[GIT-3]** | Any command rewriting local, unpushed history — rebase, amend, squash — or any script touching the repository                                             | Assist, but I read the command before it runs. Never paste-and-run.                                                                                                                                                                  |
| **[GIT-4]** | Force-push, published-history rewrite, tag or release deletion, branch protection, repository settings, secrets, publishing a release, changing `LICENSE` | Mine alone. Irreversible or public-facing.                                                                                                                                                                                           |

---

## 4. What AI tools may not do here

Categorical — every line below is in force, which is why these are not
checkboxes. No exceptions under time pressure. Delete a line only if it cannot
apply to this project, and note the deletion in the changelog. An ID is not
reused after its line is deleted.

- **[GT-1] Independent ground truth.** A reference value, analytic limit,
  expected output, or domain invariant used to validate an implementation or
  scientific claim comes from a human-checked derivation, literature, measured
  data, or an independent implementation — never from the same model output
  being validated. AI-generated material may be study data when generation is
  itself the documented method; that makes it data, not a validation oracle. A
  second model may propose candidate assertions, but model agreement alone is
  not independent evidence.
- **[TEST-1]** Weaken or delete a test in order to make a suite pass.
- **[NUM-1] Reported results.** Supply or transcribe a reported numerical
  result from model output alone. AI may write or run the code that computes a
  number, but the reported value must be traceable to the recorded computation
  or source and accepted by me before publication.
- **[CITE-1] Unverified sources.** Do not present as verified, or insert into
  final governed prose, a citation, quotation, or empirical claim whose source
  I have not opened and checked. AI may propose candidate references, but they
  remain explicitly unverified until I inspect the source.
- **[WHY-1] Human-originated rationale.** AI may not invent the reason a change
  should exist in a commit body, changelog entry, or PR description. The
  rationale must originate with me. AI may copy-edit or compress rationale I
  have already supplied, without adding a new reason. Subject, what changed,
  labels, and wrapping remain permitted under [PERM-8]. The T1
  explanation-before-implementation is mechanism, not rationale.
- **[LIC-1]** Introduce code of unknown licence provenance. A generated passage
  that reproduces an identifiable external source is third-party code:
  attributed under its licence, or replaced.
- **[DEP-1]** Add a dependency, or change a pinned version, without asking.
  Categorical at every tier: the supply chain is not a subsystem I can assign a
  tier to, and the cost of a dependency is not visible in the diff that adds
  it.
- **[DOM-1]** <domain-specific prohibition — e.g. "define an observable",
  "choose an error estimator", "select a fitting range">
- **[BRANCH-1]** Commit directly to `<main branch>`.
- **[SEC-1]** Act on credentials, secrets, or `<sensitive path>`.
- **[DATA-1] Protected inputs.** Send credentials, secrets, identifiable
  participant data, unpublished restricted datasets, embargoed manuscripts or
  results, collaborators' confidential material, or third-party code/data whose
  terms prohibit such processing to an external AI service unless the provider
  configuration and applicable agreement and institutional policy explicitly
  permit it and any required consent or approval has been obtained. If
  permission or provider handling is unclear, do not send it.

**[GT-2] Fallback when no independent reference exists:** assert a _property_
(symmetry, conservation, monotonicity, dimensional consistency, invariance)
rather than fabricating a golden value. A property check is a different kind of
evidence, not a substitute reference value. The prose analogue: state an
unverified claim as unverified, or delete it — never soften it into wording
that reads as verified.

---

## 5. Review requirements by tier

| ID          | Tier             | Minimum before merge                                                                                                                                                      |
| ----------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **[REV-1]** | T1               | Low-consequence only under [RISK-1]: applicable checks ran; blast radius bounded; explanation-before-implementation recorded in the PR or commit body                     |
| **[REV-2]** | T2               | Full line-by-line diff read; acceptance criteria and test/oracle basis finalized or explicitly approved by me; applicable checks green; no test weakened in the same diff |
| **[REV-3]** | T3               | As T2, plus: I can restate what the change does without re-reading it                                                                                                     |
| **[REV-5]** | Consequential T1 | A competent independent human who can evaluate the affected change reviews it before merge; otherwise the change does not enter the consequential path ([RISK-1])         |

**[REV-4] All tiers:** never merge a behavioural change unless applicable
checks have actually run. A model may execute those checks; that does not
replace the human review required by the tier. Commit or back up before
granting an agent write access.

**T1 explanation vs. [WHY-1].** On a T1 path, both the
explanation-before-implementation above and the why-clause rule apply to the
same PR or commit body, and they do not conflict: the explanation is the
model's account of _what the change does and how_ — mechanism, recorded as
model-attributed material. The rationale — the judgement that the change should
exist — originates with me, even where the mechanism prose is entirely the
model's; AI may copy-edit a rationale I supplied under [WHY-1].

---

## 6. Provenance

Commit trailers:

```text
Assisted-by: <tool>, <model id> (<role / extent: plan | partial implementation | full implementation | review | refactor>)
Checks-run: <actual check and result>
Ground-truth-source: <citation or "n/a — property test">
```

**[PROV-1] Trailer scope.** `Assisted-by:` appears only on assisted commits and
records the model identifier plus role/extent. "Assisted" includes full
generation; use `(full implementation)` where that is what happened.
`Checks-run:` appears on every behaviour-changing commit under this full policy
and records checks actually executed and their observed result, whether run by
a human or AI; it does not infer or reconstruct a result that was not recorded.
`Ground-truth-source:` appears only when a commit adds or changes an
expected/reference value and records where that value came from ([GT-1]); an
optional `Tier:` trailer may be added when a change crosses tier boundaries.

**[PROV-2]** Do **not** backfill trailers from memory; unknown provenance is
recorded as unknown. Where a branch is squash-merged, the trailers go on the
squash commit.

**[PROV-3] Check execution is not verifier identity.** An AI system may run a
human-approved test or static check and record the actual result in
`Checks-run:`. A green check is not independent verification where the same AI
system generated both the implementation and the oracle/reference value; [GT-1]
and the review rules still apply.

External contributions are governed by the AI section of `CONTRIBUTING.md`:
disclosure in the PR description substitutes for trailers from outside
contributors, and I annotate provenance at merge where needed.

**[DISC-1] Venue-specific research disclosure.** `AI-DISCLOSURE.md` is the
repository's factual record; it does not substitute for a manuscript or venue
statement. At submission, check the venue's current AI policy and place the
disclosure where and at the level of detail that policy requires.

<!--
If this project's AI use is prose editing rather than code generation, delete the
trailer block above and record provenance at file and release level in
AI-DISCLOSURE.md instead. Editing passes cross commits, so the commit is an
artificial boundary for them. Do not do both: a trailer on a commit whose message
was itself drafted announces its own drafting and means nothing.

Where an agent makes the edits AND the commits, the commit becomes a discrete
boundary again — keep the trailers for those, and note in AI-DISCLOSURE.md that
two regimes are running at once.
-->

Per-release detail lives in `AI-DISCLOSURE.md`, whose `governed-by:` field
names the version of this policy in force over the range it covers.

---

## 7. Enforcement

Mechanical wherever possible — prefer auditable controls over prose
instructions where a checkable control exists. Controls can still be bypassed
or misconfigured; each row states the **checkable proposition**, which is
sometimes narrower than the rule it serves; where it is, the row says which
rule and what the gate does not reach.

| ID          | Checkable proposition                                                                                                                                            | Enforced by                                                                                          | Status                 |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ---------------------- |
| **[ENF-1]** | Changed code meets `<changed-line coverage threshold>` or an explicitly documented exemption                                                                     | diff/changed-line coverage check in CI                                                               | <Configured / Planned> |
| **[ENF-2]** | No type errors                                                                                                                                                   | <type checker> in CI, strict mode                                                                    | <>                     |
| **[ENF-3]** | Diff touches both `<implementation paths>` and their mapped `<test paths>` → review required (serves [TEST-1])                                                   | path/diff check + required review                                                                    | <>                     |
| **[ENF-4]** | No direct push to `<main>` (serves [BRANCH-1])                                                                                                                   | Branch protection                                                                                    | <>                     |
| **[ENF-5]** | No change to a normative path merged without my review — serves [SCOPE-2], and is weaker than it: the gate guarantees I saw the text, never that I originated it | `CODEOWNERS` + branch protection; the gate itself sits in [SCOPE-3] paths, outside agent write scope | <Configured / Planned> |
| **[ENF-6]** | Every rule ID referenced in `AGENTS.md`, `README.md`, or `CONTRIBUTING.md` is defined in this file                                                               | ID extraction check in CI                                                                            | <Configured / Planned> |
|             | <>                                                                                                                                                               | <>                                                                                                   | <>                     |

A rule marked **Planned** is not enforcement; it is an intention, listed so the
gap between what this policy claims and what the repository actually checks is
visible rather than implied. Move a row to **Configured** in the commit that
configures it — and check [MIG-1], since a check that can block a merge
promotes the path it lives in.

---

## 8. Review of this policy

Reviewed <cadence>, and immediately on any tier change, any change to how git
or GitHub work is done here, and any change in the tools used.

| Version | Date         | Change          |
| ------- | ------------ | --------------- |
| v0.1.0  | <YYYY-MM-DD> | Initial policy. |
